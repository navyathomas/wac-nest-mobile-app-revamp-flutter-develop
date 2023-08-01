import 'dart:convert';
import 'dart:io';

import 'package:async/src/result/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/hive_models/paymentDetails.dart';
import 'package:nest_matrimony/models/cashfree_sent_order.dart';
import 'package:nest_matrimony/models/createCashfreeModel.dart';
import 'package:nest_matrimony/models/offer_check_response_model.dart';
import 'package:nest_matrimony/models/paymentOrderResponseModel.dart';
import 'package:nest_matrimony/models/paymentRegistrationBodyModel.dart';
import 'package:nest_matrimony/models/payment_registration_response_model.dart';
import 'package:nest_matrimony/models/payment_save_response_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/inapp_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/hive_services.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/views/alert_views/payment_failed_alert.dart';
import 'package:nest_matrimony/views/alert_views/success_alert.dart';
import 'package:nest_matrimony/widgets/common_alert_view.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../common/route_generator.dart';
import '../models/basic_detail_model.dart';
import '../models/response_model.dart';
import '../models/subscriptions_response_model.dart';
import '../models/upgrade_plan_details.dart';

// cashFree
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class PaymentProvider extends ChangeNotifier with BaseProviderClass {
  //payment method select
  bool isRayzorpay = true;
  bool isCashFree = false;
  //payment method select close

  initPaymentMethod() {
    isRayzorpay = true;
    isCashFree = false;
    notifyListeners();
  }

  enableCashFree() {
    isRayzorpay = false;
    isCashFree = true;
    notifyListeners();
  }

  enableRazorPay() {
    isRayzorpay = true;
    isCashFree = false;
    notifyListeners();
  }

  int selectedIndex = -1;
  String? selectedPackage;

  bool couponLoading = false;
  bool couponApplied = false;

  String couponButtonName = 'Apply';
  bool nameBorder = false;
  bool mobileBorder = false;
  bool emailBorder = false;
  bool addressBorder = false;
  bool purposeBorder = false;
  String nameErrorMessage = '';
  String mobileErrorMessage = '';
  String emailErrorMessage = '';
  String addressErrorMessage = '';
  String purposeErrorMessage = '';
  List<SubscriptionData> subscriptionDataList = [];
  String? paymentPurpose;
  bool errorBorder = false;
  String errorMessage = '';
  int? planId;
  int? payment;
  int? offerCode;
  SubscriptionData? subscriptionData;
  int? offerAmount;
  int amount = 0;
  int totalAmount = 0;
  int? paymentId;
  String? razorpayId;
  String? signature;
  String? razorpayStatus;
  String? razorpayOrderId;
  String? userName;
  String? phoneNumber;
  String? email;
  String? orderId;
  bool? paymentStatus;
  bool? upgradePlanStatus;
  String subscriptionPayment = '0';
  var paymentDetailsHive;
  var upgradePlanDetailsHive;
  String? productId;
  BasicDetailModel? userBasicDetails;
  bool isFromUpgradePlan = false;
  final TextEditingController controllerPayment =
      TextEditingController(text: "");
  final TextEditingController controllerCoupon =
      TextEditingController(text: "");
  final TextEditingController controllerMob = TextEditingController(text: "");
  final TextEditingController controllerFullName =
      TextEditingController(text: "");
  final TextEditingController controllerEmail = TextEditingController(text: "");
  final TextEditingController controllerAddress =
      TextEditingController(text: "");
  final TextEditingController controllerPurposeDetail =
      TextEditingController(text: "");
  init(BuildContext context, int planIdValue) {
    selectedPackage;
    couponLoading = false;
    couponApplied = false;
    couponButtonName = context.loc.apply;
    updatePackage(value: 0, context: context);
    getPaymentStatus();
    getUpgradePlanStatus();
    getPaymentDetails();
    getUpgradePlanDetails();
    getUserBasicDetails(context);
    updatePlanId(planIdValue);
    notifyListeners();
  }

  clearValues() {
    controllerPayment.text = '';
    controllerEmail.text = '';
    controllerMob.text = '';
    controllerCoupon.text = '';
    controllerAddress.text = '';
    controllerFullName.text = '';
    nameBorder = false;
    mobileBorder = false;
    emailBorder = false;
    addressBorder = false;
    purposeBorder = false;
    nameErrorMessage = '';
    mobileErrorMessage = '';
    emailErrorMessage = '';
    addressErrorMessage = '';
    purposeErrorMessage = '';
    isRayzorpay = true;
    isCashFree = false;
    notifyListeners();
  }

  coupenCheck({bool? coupenApply}) {
    couponApplied = coupenApply ?? false;
    notifyListeners();
  }

  couponLoad({bool? status}) async {
    couponLoading = status ?? false;
    notifyListeners();
  }

  updatePlanId(int planIdValue) {
    planId = planIdValue;
    notifyListeners();
  }

  updatePackage({int? value, String? package, required BuildContext context}) {
    removeAppliedCoupon(context);
    selectedIndex = value ?? -1;
    selectedPackage = package;
    if (subscriptionDataList.isNotEmpty) {
      subscriptionData = subscriptionDataList[value ?? 0];
      updateTotalAmount(subscriptionData?.subscriptionPrice ?? 0);
      context
          .read<InappProvider>()
          .updateKeys(kConsumable: subscriptionData?.iosInappTitle);
    }
    controllerPayment.text = subscriptionDataList.isNotEmpty
        ? Platform.isIOS
            ? subscriptionDataList[value ?? 0].iosInAppAmount.toString()
            : subscriptionDataList[value ?? 0].subscriptionPrice.toString()
        : subscriptionPayment;
    for (var element in subscriptionDataList) {}
    notifyListeners();
  }

  updateSubscriptionPayment(String paymentAmount) {
    subscriptionPayment = paymentAmount;
    notifyListeners();
  }

  reInitializeIndex() {
    selectedIndex = -1;
    notifyListeners();
  }

  paymentRegistration(BuildContext context,
      PaymentRegistrationBodyModel paymentRegistrationBodyModel,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    Result res =
        await serviceConfig.paymentRegistration(paymentRegistrationBodyModel);
    if (res.isValue) {
      PaymentRegistrationResponseModel paymentRegistrationResponseModel =
          res.asValue?.value;
      paymentId = paymentRegistrationResponseModel.data?.id;
      updateLoaderState(LoaderState.loaded);
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.errors?.clientName ?? '');
      }
      updateLoaderState(LoaderState.loaded);
    }
    notifyListeners();
  }

  Future<void> getSubscriptionList(BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getSubscriptions();
    print('ressponse in getsub $res');
    if (res.isValue) {
      SubscriptionsResponseModel subscriptionsResponseModel =
          res.asValue?.value;
      if ((subscriptionsResponseModel.data ?? []).isNotEmpty) {
        for (int i = 0; i < subscriptionsResponseModel.data!.length; i++) {
          if (subscriptionsResponseModel.data![i].subscriptionPrice! > 0) {
            subscriptionDataList.add(subscriptionsResponseModel.data![i]);
          }
        }
      }

      updateLoaderState(LoaderState.loaded);
      if (onSuccess != null) onSuccess();
    } else {
      updateLoaderState(LoaderState.loaded);
      Helpers.successToast(context.loc.anErrorOccurred);
    }
  }

  offerCheck(BuildContext context,
      {int? planIdValue, String? offerId, bool isUpgradePlan = false}) async {
    couponLoad(status: true);
    planId = planIdValue;
    Result res = await serviceConfig.offerCheck(
        isUpgradePlan ? planIdValue ?? 0 : subscriptionData?.id ?? 0,
        offerId ?? '');
    if (res.isValue) {
      OfferCheckResponseModel offerCheckResponseModel = res.asValue?.value;
      if (offerCheckResponseModel.data!.status!) {
        errorBorder = false;
        errorMessage = '';
        couponApplied = true;
        couponButtonName = context.loc.remove;
        offerAmount = offerCheckResponseModel.data?.offerAmount ?? 0;
        amount = offerCheckResponseModel.data?.amount ?? 0;
        totalAmount = offerCheckResponseModel.data?.totalAmount ?? 0;
        offerCode = offerCheckResponseModel.data?.id ?? 0;
        couponLoad(status: false);
      } else {
        errorBorder = true;
        errorMessage = offerCheckResponseModel.data?.msg ?? '';
        couponLoad(status: false);
      }
    } else {
      couponLoad(status: false);
      errorBorder = true;
      errorMessage = (res.asError?.error as ResponseModel).errors?.offerCode ??
          context.loc.selectedCouponIsInvalid;
      // Helpers.successToast(offerCheckResponseModel.message ?? '');
    }
    notifyListeners();
  }

  savePayment(BuildContext context, PaymentDetails paymentDetails,
      {bool isFromPayment = true}) async {
    updateLoaderState(LoaderState.loading);
    Result? res;
    if (paymentStatus == true) {
      res = await serviceConfig.savePayment(paymentDetails);
    } else {
      res = await serviceConfig.savePayment(paymentDetailsHive);
    }
    if (res.isValue) {
      PaymentSaveResponseModel paymentSaveResponseModel = res.asValue?.value;
      if (paymentSaveResponseModel.status == true) {
        await HiveServices.deletePaymentDetails();
        SharedPreferenceHelper.savePaymentStatus(true);
        updateLoaderState(LoaderState.loaded);
        if (isFromPayment) {
          Future.microtask(() => CommonAlertDialog.showDialogPopUp(
              barrierDismissible: false,
              context,
              SuccessAlert(
                  description: context.loc.paymentSuccessfullyCompleted,
                  onTap: () {
                    clearValues();
                    Navigator.pushNamedAndRemoveUntil(context,
                        RouteGenerator.routeAuthScreen, (route) => false);
                  })));
        }
      } else {
        SharedPreferenceHelper.savePaymentStatus(false);
        await HiveServices.addPaymentDetails(
            paymentDetails, HiveServices.paymentDetails);
        updateLoaderState(LoaderState.loaded);
        if (isFromPayment) {
          Future.microtask(() => CommonAlertDialog.showDialogPopUp(
              context,
              barrierDismissible: false,
              PaymentFailedAlert(
                onCancel: () {
                  onFailureCallback(context);
                },
                onTap: () {
                  getPaymentStatus().then((value) {
                    updateLoaderState(LoaderState.loaded);
                    onFailureCallback(context);
                    savePayment(context, paymentDetailsHive);
                  });
                },
              )));
        }
      }
    } else {
      SharedPreferenceHelper.savePaymentStatus(false);
      getPaymentStatus();
      await HiveServices.addPaymentDetails(
          paymentDetails, HiveServices.paymentDetails);
      updateLoaderState(LoaderState.loaded);
      if (isFromPayment) {
        Future.microtask(() => CommonAlertDialog.showDialogPopUp(
            context,
            barrierDismissible: false,
            PaymentFailedAlert(
              onCancel: () {
                onFailureCallback(context);
              },
              onTap: () {
                getPaymentStatus().then((value) {
                  updateLoaderState(LoaderState.loaded);
                  onFailureCallback(context).then(
                      (value) => savePayment(context, paymentDetailsHive));
                });
              },
            )));
      }
    }
    notifyListeners();
  }

  savePaymentPlan(BuildContext context, UpgradePlanDetails upgradePlanDetails,
      {bool isFromPayment = true}) async {
    updateLoaderState(LoaderState.loading);
    Result? res;
    if (upgradePlanStatus == true) {
      res = await serviceConfig.saveUpgradePlanPayment(upgradePlanDetails);
    } else {
      res = await serviceConfig.saveUpgradePlanPayment(upgradePlanDetailsHive);
    }
    if (res.isValue) {
      PaymentSaveResponseModel paymentSaveResponseModel = res.asValue?.value;
      if (paymentSaveResponseModel.status == true) {
        await HiveServices.deleteUpgradePlanDetails();
        SharedPreferenceHelper.saveUpgradePlanStatus(true);
        updateLoaderState(LoaderState.loaded);
        if (isFromPayment) {
          Future.microtask(() => CommonAlertDialog.showDialogPopUp(
              barrierDismissible: false,
              context,
              SuccessAlert(
                  description: context.loc.paymentSuccessfullyCompleted,
                  onTap: () {
                    clearValues();
                    Navigator.pushNamedAndRemoveUntil(context,
                        RouteGenerator.routeMainScreen, (route) => false,
                        arguments: RouteArguments(tabIndex: 4));
                  })));
        }
      } else {
        SharedPreferenceHelper.saveUpgradePlanStatus(false);
        HiveServices.addUpgradePlanDetails(
            val: jsonEncode(upgradePlanDetails),
            key: HiveServices.upgradePlanDetails);
        updateLoaderState(LoaderState.loaded);
        if (isFromPayment) {
          Future.microtask(() => CommonAlertDialog.showDialogPopUp(
              context,
              barrierDismissible: false,
              PaymentFailedAlert(
                onCancel: () {
                  onFailureCallback(context);
                },
                onTap: () {
                  getUpgradePlanStatus().then((value) {
                    updateLoaderState(LoaderState.loaded);
                    onFailureCallback(context);
                    savePaymentPlan(context, upgradePlanDetailsHive);
                  });
                },
              )));
        }
      }
    } else {
      SharedPreferenceHelper.saveUpgradePlanStatus(false);
      getUpgradePlanStatus();
      await HiveServices.addUpgradePlanDetails(
          val: jsonEncode(upgradePlanDetails),
          key: HiveServices.upgradePlanDetails);
      updateLoaderState(LoaderState.loaded);
      if (isFromPayment) {
        Future.microtask(() => CommonAlertDialog.showDialogPopUp(
            context,
            barrierDismissible: false,
            PaymentFailedAlert(
              onCancel: () {
                onFailureCallback(context);
              },
              onTap: () {
                getUpgradePlanDetails().then((value) {
                  updateLoaderState(LoaderState.loaded);
                  onFailureCallback(context).then((value) =>
                      savePaymentPlan(context, upgradePlanDetailsHive));
                });
              },
            )));
      }
    }
    notifyListeners();
  }

  Future<void> getPaymentDetails() async {
    paymentDetailsHive = await HiveServices.getPaymentDetails();
    HiveServices.closePaymentDetailsBox();
    notifyListeners();
  }

  getUserBasicDetails(BuildContext context) async {
    userBasicDetails = context.read<AppDataProvider>().basicDetailModel;
    notifyListeners();
  }

  Future<void> getUpgradePlanDetails() async {
    final localRes = await HiveServices.getUpgradePlanDetails();
    if (localRes != null) {
      upgradePlanDetailsHive =
          UpgradePlanDetails.fromJson(jsonDecode(localRes));
    }
    HiveServices.closePaymentDetailsBox();
    notifyListeners();
  }

  Future<void> getPaymentStatus() async {
    paymentStatus = await SharedPreferenceHelper.getPaymentStatus();
    notifyListeners();
  }

  Future<void> getUpgradePlanStatus() async {
    upgradePlanStatus = await SharedPreferenceHelper.getUpgradePlanStatus();
    notifyListeners();
  }

  Future<void> onFailureCallback(BuildContext context) async {
    Navigator.pop(context);
    getPaymentStatus();
    getPaymentDetails();
    getUpgradePlanStatus();
    getUpgradePlanDetails();
  }

  removeAppliedCoupon(BuildContext context) {
    couponApplied = false;
    couponButtonName = context.loc.apply;
    controllerCoupon.text = '';
    errorBorder = false;
    subscriptionData = null;
    notifyListeners();
  }

  updateTotalAmount(int amountTotal) {
    totalAmount = amountTotal;
    notifyListeners();
  }

  createOrderId(BuildContext context, bool isUpgradePlan) async {
    updateLoaderState(LoaderState.loading);
    String username = AppConfig.razorPayKeyId;
    String password = AppConfig.razorPayKeySecret;
    isFromUpgradePlan = isUpgradePlan;
    context = context;
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint(' basic auth $basicAuth');
    Map parameter = {
      'amount': couponApplied
          ? (totalAmount) * 100
          : int.parse(controllerPayment.text) * 100,
      'currency': 'INR',
    };

    var res = await serviceConfig.getOrderIdForPayment(basicAuth, parameter);
    if (res.isValue) {
      PaymentOrderResponseModel paymentOrderResponseModel = res.asValue?.value;
      debugPrint('order id ${paymentOrderResponseModel.id}');
      orderId = paymentOrderResponseModel.id;
      updateLoaderState(LoaderState.loaded);
      Future.microtask(
          () => proceedPayment(paymentOrderResponseModel.id ?? '', context));
    } else {
      debugPrint('error occurred while fetching order id');
      updateLoaderState(LoaderState.loaded);
    }
    notifyListeners();
  }

  proceedPayment(String orderId, BuildContext context) {
    Razorpay razorpay = Razorpay();

    var options = {
      'key': AppConfig.razorPayKeyId,
      'name': 'Nest Matrimony.',
      "order_id": orderId,
      'description': paymentPurpose,
      'retry': {'enabled': true, 'max_count': 5},
      'send_sms_hash': true,
      'prefill': {
        'contact': isFromUpgradePlan
            ? userBasicDetails?.basicDetail?.mobile
            : controllerMob.text,
        'email': isFromUpgradePlan
            ? userBasicDetails?.basicDetail?.email
            : controllerEmail.text
      },
      'external': {
        'wallets': ['paytm', 'paypal']
      }
    };
    razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) =>
            handlePaymentErrorResponse(response, context));
    razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) =>
            handlePaymentSuccessResponse(response, context));
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(
      PaymentFailureResponse response, BuildContext context) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // debugPrint('payment error ${response.error}');
    // Helpers.successToast('Payment error ${response.error}');
    Future.microtask(() => CommonAlertDialog.showDialogPopUp(
        barrierDismissible: false,
        context,
        PaymentFailedAlert(onCancel: () {
          Navigator.pop(context);
        }, onTap: () {
          Navigator.pop(context);
          proceedPayment(orderId ?? '', context);
        })));
  }

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response, BuildContext context) {
    debugPrint('payment id after payment success ${response.paymentId}');
    debugPrint('order id after payment success ${response.orderId}');
    razorpayId = response.paymentId;
    razorpayStatus = 'complete';
    razorpayOrderId = response.orderId;
    signature = response.signature;
    if (isFromUpgradePlan) {
      final upgradePlanDetails = UpgradePlanDetails()
        ..paymentPurpose = 'Upgrade Plan'
        ..clientAddress = userBasicDetails?.basicDetail?.address ?? ''
        ..clientEmail = userBasicDetails?.basicDetail?.email ?? ''
        ..clientName = userBasicDetails?.basicDetail?.name ?? ''
        ..userId = userBasicDetails?.basicDetail?.id
        ..planId = planId
        ..offerCode = offerCode
        ..razorpayStatus = razorpayStatus
        ..razorpaySignature = signature
        ..razorpayPaymentId = razorpayId
        ..razorpayOrderId = razorpayOrderId
        ..paymentAmount =
            couponApplied ? totalAmount : int.parse(controllerPayment.text)
        ..offerAmount = offerAmount
        ..totalAmount = totalAmount;
      savePaymentPlan(context, upgradePlanDetails);
    } else {
      final paymentDetails = PaymentDetails()
        ..razorpayOrderId = razorpayOrderId
        ..paymentId = paymentId
        ..offerCode = offerCode
        ..offerAmount = offerAmount
        ..planId = subscriptionData?.subscriptionTypesId
        ..razorpayStatus = razorpayStatus
        ..razorpayPaymentId = razorpayId
        ..razorpaySignature = signature
        ..totalAmount = totalAmount;
      savePayment(context, paymentDetails);
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Helpers.successToast('External wallet added');
  }

//CASH FREE SECTION
  var cfPaymentGatewayService = CFPaymentGatewayService();
  bool cashFreeLoader = false;
  bool cashFreeVerified = false;

  String cashfreesessionID = "";
  String cashfreeOrderID = "";

  initCashFreePayment() {
    cashFreeVerified = false;
    cashFreeLoader = false;
    notifyListeners();
  }

  cashFreePayVerified(bool val) {
    cashFreeVerified = val;
    notifyListeners();
  }

  cashFreeLoaderUpdate(bool value) {
    cashFreeLoader = value;
    notifyListeners();
  }

  Future<void> cashFreeSessionIDGeneration(
      {String? orderAmount, String? paymentID, Function? onSuccess}) async {
    cashFreeLoaderUpdate(true);

    debugPrint("cashfree order amount$orderAmount");
    debugPrint("cashfree payment id$paymentID");

    Result res = await serviceConfig.createCashFreePayment(
        orderAmount: orderAmount, paymentId: paymentID);
    if (res.isValue) {
      CreateCashFreeModel cashFreeSessionModel = res.asValue?.value;
      debugPrint(cashFreeSessionModel.message);
      cashFreeLoaderUpdate(false);
      cashfreesessionID =
          cashFreeSessionModel.data?.responseJson?.paymentSessionId ?? "";
      cashfreeOrderID = cashFreeSessionModel.data?.responseJson?.orderId ?? "";
      debugPrint("Cashfree session :$cashfreesessionID");
      debugPrint("Cashfree orderID :$cashfreeOrderID");
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint("cash free failed");
      cashFreeLoaderUpdate(false);
      Helpers.successToast("An Error Occurred !");
    }
  }

  Future<void> cashFreeUpgradeSessionIDGeneration(
      {String? orderAmount, String? planID, Function? onSuccess}) async {
    cashFreeLoaderUpdate(true);

    debugPrint("cashfree order amount$orderAmount");
    debugPrint("cashfree payment plan id$planID");

    Result res = await serviceConfig.createCashFreeupgradePayment(
        orderAmount: orderAmount, planId: planID);

    if (res.isValue) {
      CreateCashFreeModel cashFreeSessionModel = res.asValue?.value;
      debugPrint(cashFreeSessionModel.message);
      cashFreeLoaderUpdate(false);
      cashfreesessionID =
          cashFreeSessionModel.data?.responseJson?.paymentSessionId ?? "";
      cashfreeOrderID = cashFreeSessionModel.data?.responseJson?.orderId ?? "";
      debugPrint("Cashfree session :$cashfreesessionID");
      debugPrint("Cashfree orderID :$cashfreeOrderID");
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint("cash free failed");
      cashFreeLoaderUpdate(false);
      Helpers.successToast("An Error Occurred !");
    }
  }

  Future<void> cashfreeSentOrderID({String? orID, Function? onSuccess}) async {
    cashFreeLoaderUpdate(true);

    debugPrint("cashfree orderID for sent $orID");

    Result res = await serviceConfig.cashFreeVerifyOrderID(orderID: orID);
    if (res.isValue) {
      SentOrderCashFreeModel cashFreeSessionModel = res.asValue?.value;
      cashFreeLoaderUpdate(false);
      if (cashFreeSessionModel.statusCode == 200) {
        if (onSuccess != null) onSuccess();
      } else {
        Helpers.successToast("An Error Occurred On verification !");
      }
    } else {
      debugPrint("cash free orderid sent failed");
      cashFreeLoaderUpdate(false);
      Helpers.successToast("An Error Occurred !");
    }
  }

  void verifyPayment(BuildContext context, String? orderId,
      {Function? onSuccess}) {
    debugPrint("Verify Payment orderid: $orderId");
    cashFreePayVerified(true);
    cashFreeSuccessRoute(context, onSuccess: onSuccess);
  }

  cashFreeSuccessRoute(BuildContext context, {Function? onSuccess}) {
    // if ((cashfreeOrderID).isNotEmpty) {
    if (cashFreeVerified) {
      CommonFunctions.afterInit(() {
        if (onSuccess != null) onSuccess();
      });
    }
    // }
  }

  onError(CFErrorResponse errorResponse, String orderId,
      {Function? onFailure}) {
    debugPrint(errorResponse.getMessage());
    debugPrint("Error while making payment");
    if (onFailure != null) onFailure();
  }

  CFEnvironment environment = CFEnvironment.SANDBOX;

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(cashfreeOrderID)
          .setPaymentSessionId(cashfreesessionID)
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<void> pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#950053")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      debugPrint(e.message);
    }
  }

//CASH FREE SECTION CLOSE

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}

enum TextFieldTypes { name, address, mobile, purpose, email }
