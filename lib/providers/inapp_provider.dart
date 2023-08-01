import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../consumable_store.dart';
import 'package:async/src/result/result.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';

import '../models/inapp_ep_verification_model.dart';
import '../services/helpers.dart';
import '../views/alert_views/payment_failed_alert.dart';
import '../views/alert_views/success_alert.dart';
import '../widgets/common_alert_view.dart';

final bool kAutoConsume = Platform.isIOS || true;

class InappProvider extends ChangeNotifier with BaseProviderClass {
  String kConsumableId = 'Premium_Delight_7500';
  String kUpgradeId = 'Premium_Delight_7500';

  List<String> _kProductIds = <String>[];
//
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  List<String> notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool iisAvailable = false;
  bool purchasePending = false;
  bool purchaseCompleted = true;
  bool loading = true;
  String? queryProductError;
  String? productPrice;
  updateKeys({String? kConsumable, String? kUpgrade}) {
    kConsumableId = kConsumable ?? '';
    kUpgradeId = kConsumable ?? '';
    debugPrint('k consumable id $kConsumableId');
    notifyListeners();
  }

  updateProductPrice(String price) {
    productPrice = price;
    debugPrint(productPrice);
    notifyListeners();
  }

  void inappListner(BuildContext context,
      {required bool isFromUpgrade, required String planid}) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        inAppPurchase.purchaseStream;
    debugPrint(purchaseUpdated.toString());
    subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
      debugPrint("subscriptions list $subscription");
      subscription.onData((data) {
        for (var element in data) {
          debugPrint(element.productID);
          debugPrint(element.transactionDate);
          debugPrint(element.verificationData.serverVerificationData);
          debugPrint('${element.status}');
          inAppPurchase.completePurchase(data[0]);
          if (element.status == PurchaseStatus.canceled) {
            dontShowPendingUI();
            purchseCompleted();
          } else if (element.status == PurchaseStatus.pending) {
            showPendingUI();
            // Helpers.successToast("one plan is pending please wait .....");
            log("one order is pending please wait .....");
          } else if (element.status == PurchaseStatus.purchased) {
            if (isFromUpgrade) {
              upgradeInAppVerification(
                onSuccess: () {
                  Future.microtask(() => CommonAlertDialog.showDialogPopUp(
                      barrierDismissible: false,
                      context,
                      SuccessAlert(
                          description: context.loc.paymentSuccessfullyCompleted,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteGenerator.routeMainScreen,
                                (route) => false);
                          })));
                  Helpers.successToast("plan upgraded");
                },
                orderAmount: productPrice,
                planID: planid,
                token: element.verificationData.serverVerificationData,
              );
            } else {
              easyPayInAppVerification(
                onSuccess: () {
                  Future.microtask(() => CommonAlertDialog.showDialogPopUp(
                      barrierDismissible: false,
                      context,
                      SuccessAlert(
                          description: context.loc.paymentSuccessfullyCompleted,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteGenerator.routeAuthScreen,
                                (route) => false);
                            Helpers.successToast("payment success");
                          })));
                },
                orderAmount: productPrice,
                paymentID: context.read<PaymentProvider>().paymentId.toString(),
                token: element.verificationData.serverVerificationData,
              );
            }

            log("purchased completed");
            purchseCompleted();
          } else if (element.status == PurchaseStatus.error) {
            Future.microtask(() => CommonAlertDialog.showDialogPopUp(
                context,
                barrierDismissible: false,
                PaymentFailedAlert(
                  showTryAgain: false,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                )));
            debugPrint("error");
          }
        }
      });
    }, onDone: () {
      debugPrint("on done");
      subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
      log(error.toString());
    });
    notifyListeners();
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      isEasyPayInAppLoading = false;
      iisAvailable = isAvailable;
      products = <ProductDetails>[];
      purchases = <PurchaseDetails>[];
      notFoundIds = <String>[];
      _consumables = <String>[];
      purchasePending = false;
      purchaseCompleted = true;
      loading = false;
      debugPrint('loading in in app $loading');
      notifyListeners();
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      queryProductError = productDetailResponse.error!.message;
      iisAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      purchasePending = false;
      purchaseCompleted = true;
      loading = false;
      notifyListeners();
      debugPrint('loading in in app ios $loading');
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      queryProductError = null;
      iisAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      purchasePending = false;
      purchaseCompleted = true;
      loading = false;
      debugPrint('loading in in app product details $loading');
      notifyListeners();
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    iisAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    notFoundIds = productDetailResponse.notFoundIDs;
    _consumables = consumables;
    purchasePending = false;
    purchaseCompleted = true;
    loading = false;
    kProductLoadingUpdate(false);
    debugPrint('loading in in app consumables $loading');
    notifyListeners();
  }

//------------------ MAIN FUNCTIONS ---------------------

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();

    _consumables = consumables;
    debugPrint(_consumables.toString());
    notifyListeners();
  }

  void showPendingUI() {
    purchasePending = true;
    notifyListeners();
  }

  void dontShowPendingUI() {
    purchasePending = false;
    notifyListeners();
  }

  void purchseCompleted() {
    purchaseCompleted = true;
    notifyListeners();
  }

  void purchaseProgress() {
    purchaseCompleted = false;
    notifyListeners();
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      debugPrint(consumables.toString());

      purchasePending = false;
      _consumables = consumables;
      notifyListeners();
    } else {
      purchases.add(purchaseDetails);
      purchasePending = false;
      notifyListeners();
    }
  }

  void handleError(IAPError error) {
    purchasePending = false;
    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        dontShowPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition = inAppPurchase
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      // if (mounted) {
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
      // }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

//------------------MAIN CLOSE --------------------------

// invoke function
  void invokePurchase() {
    late PurchaseParam purchaseParam;
    late ProductDetails productDetail;
    products.map((e) => productDetail = e);

    if (Platform.isAndroid) {
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetail,
      );
    }

    if (productDetail.id == kConsumableId) {
      inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: kAutoConsume);
    } else {
      inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

//--------------------------------------
//--------------------------------------API verification
  bool isEasyPayInAppLoading = false;
  void easyPayInAppLoader(bool val) {
    isEasyPayInAppLoading = val;
    notifyListeners();
  }

  Future<void> easyPayInAppVerification(
      {String? token,
      String? orderAmount,
      String? paymentID,
      Function? onSuccess}) async {
    easyPayInAppLoader(true);

    debugPrint("token new$token");
    debugPrint("order amount$orderAmount");
    debugPrint("payment id$paymentID");

    Result res = await serviceConfig.verifyInAppEasyPayment(
        token: token, orderAmount: orderAmount, paymentId: paymentID);
    debugPrint("entered into easy pay app integration");
    debugPrint('resource $res');
    if (res.isValue) {
      InAppEasyPayVerificationModel inAppVerificationModel = res.asValue?.value;
      debugPrint(inAppVerificationModel.message);
      easyPayInAppLoader(false);
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint("easy-pay inApp failed");
      easyPayInAppLoader(false);
      Helpers.successToast("An Error Occurred !");
    }
  }

  bool isUpgradeInAppLoading = false;
  void upgradeInAppLoader(bool val) {
    isUpgradeInAppLoading = val;
    notifyListeners();
  }

  Future<void> upgradeInAppVerification(
      {String? token,
      String? orderAmount,
      String? planID,
      Function? onSuccess}) async {
    upgradeInAppLoader(true);

    debugPrint("token new$token");
    debugPrint("order amount $orderAmount");
    debugPrint("planID id$planID");

    Result res = await serviceConfig.verifyInAppUpgradePayment(
        token: token, orderAmount: orderAmount, planId: planID);
    debugPrint("entered into upgrade pay app integration");
    debugPrint('resource $res');
    if (res.isValue) {
      InAppEasyPayVerificationModel inAppVerificationModel = res.asValue?.value;
      debugPrint(inAppVerificationModel.message);
      easyPayInAppLoader(false);
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint("upgrade-pay inApp failed");
      easyPayInAppLoader(false);
      Helpers.successToast("An Error Occurred !");
    }
  }

//--------------------------------------API verification close
  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    subscription.cancel();
    super.dispose();
    super.dispose();
  }

  bool kProductLoading=false;
   kProductLoadingUpdate(bool val){
    kProductLoading=val;
    notifyListeners();
  }
  void updateKProductIds() {
    _kProductIds = [
      kConsumableId,
      kUpgradeId,
    ];
    kProductLoadingUpdate(true);
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    // TODO: implement updateLoaderState
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    debugPrint(storefront.identifier);
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
