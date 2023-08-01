import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/alert_views/payment_failed_alert.dart';
import 'package:nest_matrimony/views/alert_views/success_alert.dart';
import 'package:nest_matrimony/views/easy_pay/amount_field.dart';
import 'package:nest_matrimony/views/easy_pay/coupon_field.dart';
import 'package:nest_matrimony/widgets/common_alert_view.dart';
import 'package:nest_matrimony/widgets/common_app_bar.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/transparent_stack.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../providers/inapp_provider.dart';
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

class PaymentInit extends StatefulWidget {
  PaymentInit(
      {Key? key,
      this.isUpgradePlan = false,
      this.planAmount,
      this.planId,
      this.productID})
      : super(key: key);
  bool isUpgradePlan;
  int? planAmount;
  int? planId;
  String? productID;
  @override
  State<PaymentInit> createState() => _PaymentInitState();
}

class _PaymentInitState extends State<PaymentInit> {
  var cfPaymentGatewayService = CFPaymentGatewayService();
  final Color dimBlackColor = const Color(0xFFE4E7E8);
  final _formKey = GlobalKey<FormState>();
  bool isIos = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: context.loc.payment,
        ),
        body: Consumer<PaymentProvider>(builder: (context, pro, _) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TransparentStack(
                      inAsyncCall: (pro.paymentStatus == true ||
                                  pro.paymentStatus == null) &&
                              (pro.upgradePlanStatus == true ||
                                  pro.upgradePlanStatus == null)
                          ? false
                          : true,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            31.verticalSpace,
                            Text(
                              widget.isUpgradePlan
                                  ? context.loc.planAmount
                                  : context.loc.enterAmount,
                              style: FontPalette.black15SemiBold
                                  .copyWith(color: HexColor("#8695A7")),
                            ),
                            25.verticalSpace,
                            AmountField(
                              isCopyPasteNeeded: false,
                              isEditable: isIos
                                  ? false
                                  : pro.loaderState == LoaderState.loading ||
                                          widget.isUpgradePlan
                                      ? false
                                      : true,
                              labelText: "0",
                              controller: pro.controllerPayment,
                              onTap: () => pro.reInitializeIndex(),
                              onChanged: (p0) {
                                setState(() {});
                                pro.updateTotalAmount(int.parse(p0.trim()));
                                pro.removeAppliedCoupon(context);
                              },
                            ),
                            19.verticalSpace,
                            widget.isUpgradePlan
                                ? const SizedBox.shrink()
                                : _packageList(pro),
                            34.verticalSpace,
                            if (!isIos)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.loc.haveAOfferCode,
                                      style: FontPalette.black15Bold.copyWith(
                                          color: HexColor('#131A24'))),
                                  11.verticalSpace,
                                  CouponField(
                                      isEditable:
                                          pro.loaderState == LoaderState.loading
                                              ? false
                                              : true,
                                      controller: pro.controllerCoupon,
                                      errorBorder: pro.errorBorder,
                                      errorMsg: pro.errorMessage,
                                      labelText: '',
                                      buttonName: pro.couponButtonName,
                                      isEmpty:
                                          pro.controllerCoupon.text.isEmpty,
                                      onChanged: (p0) {
                                        setState(() {});
                                        if (p0.isEmpty) {
                                          pro.removeAppliedCoupon(context);
                                        }
                                      },
                                      onTap: () {
                                        if (pro.controllerCoupon.text
                                                .isNotEmpty &&
                                            pro.controllerCoupon.text != '') {
                                          FocusScope.of(context).unfocus();
                                          if (pro.couponButtonName ==
                                              context.loc.apply) {
                                            pro.offerCheck(context,
                                                offerId: pro
                                                    .controllerCoupon.text
                                                    .trim(),
                                                planIdValue: widget.planId,
                                                isUpgradePlan:
                                                    widget.isUpgradePlan);
                                          } else {
                                            pro.removeAppliedCoupon(context);
                                          }
                                        }
                                      }),
                                  30.verticalSpace,
                                ],
                              ),

                            amountDetails(provider: pro),
                            //TODO
                            17.verticalSpace,
                            if (!isIos)
                              Row(
                                children: [
                                  Flexible(
                                      child: rayzorPayButton(provider: pro)),
                                  13.horizontalSpace,
                                  Flexible(
                                      child: cashFreeButton(provider: pro)),
                                ],
                              )
                            //TODO
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: isIos
                          ? _buildInAppButton()
                          : Column(
                              children: [
                                if (pro.isRayzorpay)
                                  CommonButton(
                                    fontStyle: FontPalette.white13SemiBold,
                                    isLoading:
                                        pro.loaderState == LoaderState.loaded
                                            ? false
                                            : true,
                                    title: pro.paymentStatus == true
                                        ? "${context.loc.pay} ₹${pro.couponApplied ? Helpers.convertToDouble(pro.totalAmount).toStringAsFixed(2) : Helpers.convertToDouble(pro.controllerPayment.text.trim()).toStringAsFixed(2)}"
                                        : context.loc.retry,
                                    onPressed:
                                        pro.controllerPayment.text.trim() != '0'
                                            ? () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                debugPrint("In App purchase ");

                                                if (widget.isUpgradePlan) {
                                                  pro.upgradePlanStatus == true
                                                      ? pro.createOrderId(
                                                          context,
                                                          widget.isUpgradePlan)
                                                      : pro.savePaymentPlan(
                                                          context,
                                                          pro.upgradePlanDetailsHive);
                                                } else {
                                                  pro.paymentStatus == true
                                                      ? pro.createOrderId(
                                                          context,
                                                          widget.isUpgradePlan)
                                                      : pro.savePayment(context,
                                                          pro.paymentDetailsHive);
                                                }
                                              }
                                            : null,
                                  ),
                                if (pro.isCashFree)
                                  CommonButton(
                                    fontStyle: FontPalette.white13SemiBold,
                                    isLoading: pro.cashFreeLoader,
                                    title:
                                        "${context.loc.pay} ₹${pro.couponApplied ? Helpers.convertToDouble(pro.totalAmount).toStringAsFixed(2) : Helpers.convertToDouble(pro.controllerPayment.text.trim()).toStringAsFixed(2)}",
                                    onPressed: () {
                                      debugPrint("Cash Free");

                                      if (widget.isUpgradePlan) {
                                        pro
                                            .cashFreeUpgradeSessionIDGeneration(
                                                orderAmount:
                                                    pro.controllerPayment.text,
                                                planID:
                                                    widget.planId.toString())
                                            .then((value) => pro.pay());
                                      } else {
                                        pro.cashFreeSessionIDGeneration(
                                            paymentID: pro.paymentId.toString(),
                                            orderAmount:
                                                pro.controllerPayment.text,
                                            onSuccess: () {
                                              pro.pay();
                                            });
                                      }
                                    },
                                  )
                              ],
                            ))
                ],
              ),
            ),
          );
        }));
  }

  Widget amountDetails({PaymentProvider? provider}) {
    return Container(
      width: context.sw(),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: dimBlackColor,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: EdgeInsets.only(top: 24.h, bottom: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 19.w,
            ),
            child: Text(
              context.loc.amountDetails,
              style:
                  FontPalette.black15Bold.copyWith(color: HexColor('#131A24')),
            ),
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.loc.subtotal, style: FontPalette.black16Medium),
                Text(
                    provider!.couponApplied
                        ? Helpers.convertToDouble(provider.amount)
                            .toStringAsFixed(2)
                        : Helpers.convertToDouble(
                                provider.controllerPayment.text)
                            .toStringAsFixed(2),
                    style: FontPalette.black16Medium),
              ],
            ),
          ),
          provider.couponApplied
              ? Column(
                  children: [
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.loc.offerCode,
                              style: FontPalette.black16Medium),
                          Text("-${provider.offerAmount}",
                              style: FontPalette.black16Medium
                                  .copyWith(color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          19.verticalSpace,
          Container(
            height: 1,
            width: context.sw(),
            color: dimBlackColor,
          ),
          16.5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.loc.total,
                    style: FontPalette.black10Bold.copyWith(fontSize: 16.sp)),
                Text(
                    provider.couponApplied
                        ? Helpers.convertToDouble(provider.totalAmount)
                            .toStringAsFixed(2)
                        : Helpers.convertToDouble(
                                provider.controllerPayment.text)
                            .toStringAsFixed(2),
                    style: FontPalette.black10Bold.copyWith(fontSize: 16.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cashFreeButton({PaymentProvider? provider}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => provider?.enableCashFree(),
      child: Container(
        height: 68.h,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: HexColor("#DBE2EA"))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.iconsCashfreeLogo),
            10.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRadio(
                    isSelected: provider?.isCashFree ?? false,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rayzorPayButton({PaymentProvider? provider}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => provider?.enableRazorPay(),
      child: Container(
        height: 68.h,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: HexColor("#DBE2EA"))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.iconsRayzorPayIcon),
            10.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRadio(
                    isSelected: provider?.isRayzorpay ?? false,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //inApp purchase
  Widget _buildInAppButton() {
    InappProvider inappProvider = context.read<InappProvider>();
    return Consumer<InappProvider>(
      builder: (context, value, _) {
        if (value.loading ||
            value.isEasyPayInAppLoading ||
            value.isUpgradeInAppLoading) {
          return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CommonButton(
                isLoading: true,
              ));
        }

        if (!value.iisAvailable) {
          return const SizedBox.shrink();
        }
        const ListTile productHeader =
            ListTile(title: Text('Products for Sale'));
        final List<Widget> productList = <Widget>[];
        //
        if (value.notFoundIds.isNotEmpty) {
          productList.add(ListTile(
              title: Text('[${value.notFoundIds.join(", ")}] not found',
                  style: TextStyle(color: ThemeData.light().colorScheme.error)),
              subtitle:
                  const Text('This app needs special configuration to run.')));
        }

        final Map<String, PurchaseDetails> purchases =
            Map<String, PurchaseDetails>.fromEntries(
                value.purchases.map((PurchaseDetails purchase) {
          if (purchase.pendingCompletePurchase) {
            value.inAppPurchase.completePurchase(purchase);
          }
          return MapEntry<String, PurchaseDetails>(
              purchase.productID, purchase);
        }));
        productList.addAll(value.products.map(
          (ProductDetails productDetails) {
            final PurchaseDetails? previousPurchase =
                purchases[productDetails.id];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonButton(
                        onPressed: () {
                          value.updateProductPrice(productDetails.price);
                          // value.productPrice =productDetails.price;
                          if (value.purchasePending == true) {
                            Helpers.successToast("Purchase Under Pending");
                            debugPrint("purchase under pending");
                          } else {
                            late PurchaseParam purchaseParam;

                            if (Platform.isAndroid) {
                            } else {
                              purchaseParam = PurchaseParam(
                                productDetails: productDetails,
                              );
                            }
                            if (productDetails.id == value.kConsumableId) {
                              try {
                                log("purchase started");
                                value.purchaseProgress();
                                value.inAppPurchase
                                    .buyConsumable(
                                        purchaseParam: purchaseParam,
                                        autoConsume: kAutoConsume)
                                    .then((values) {
                                  value.purchasePending = false;
                                }).onError((error, stackTrace) {
                                  print("error payment closed");
                                  return;
                                });
                              } on Exception catch (e) {
                                debugPrint("error $e");
                              }
                            } else {
                              try {
                                value.purchaseProgress();
                                log("purchase started");
                                value.inAppPurchase
                                    .buyNonConsumable(
                                        purchaseParam: purchaseParam)
                                    .onError((error, stackTrace) {
                                  print("error payment closed");
                                  return true;
                                }).then((values) {
                                  value.purchasePending = false;
                                });
                              } on Exception catch (e) {
                                debugPrint("error $e");
                              }
                            }
                          }
                        },
                        isLoading: !value.purchaseCompleted ||
                            value.loading ||
                            value.kProductLoading,
                        title: "Pay ${productDetails.price}",
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
        return Column(
            children: <Widget>[const SizedBox.shrink(), const Divider()] +
                productList);
      },
    );
  }

  //inApp close
  Widget _packageList(PaymentProvider provider) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ListView.separated(
        itemCount: provider.subscriptionDataList.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return tile(index,
              packageAmt: Platform.isIOS
                  ? provider.subscriptionDataList[index].iosInAppAmount
                      .toString()
                  : provider.subscriptionDataList[index].subscriptionPrice
                      .toString());
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10.w,
          );
        },
      ),
    );
  }

  Widget tile(
    int index, {
    String? packageAmt,
  }) {
    return Consumer<PaymentProvider>(
        builder: (BuildContext context, provider, _) {
      return InkWell(
        onTap: () {
          provider.updatePackage(value: index, context: context);
          initInApp();
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: provider.selectedIndex == index
                  ? HexColor('#FFDEF4')
                  : HexColor('#F2F2F2'),
              border: Border.all(
                width: 1,
                color: provider.selectedIndex == index
                    ? HexColor('#FFDEF4')
                    : HexColor('#F2F2F2'),
              ),
              borderRadius: BorderRadius.circular(9)),
          height: 44.h,
          width: 108.h,
          child: Text(packageAmt ?? '', style: FontPalette.black16Medium),
        ),
      );
    });
  }

  void initFirstInAppProduct() {
    if (isIos) {
      if (context.read<PaymentProvider>().subscriptionDataList.isNotEmpty) {
        context.read<InappProvider>().updateKeys(
            kConsumable: context
                .read<PaymentProvider>()
                .subscriptionDataList[0]
                .iosInappTitle);
      }
    }
  }

  void initInApp() {
    var inAppPro = context.read<InappProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PaymentProvider>().initPaymentMethod();
      inAppPro.kProductLoadingUpdate(true);
      if (Platform.isIOS) {
        isIos = true;
        inAppPro.updateKProductIds();
        inAppPro.inappListner(context,
            isFromUpgrade: widget.isUpgradePlan, planid: "${widget.planId}");
      }
      // context.read<PaymentProvider>().init(context, widget.planId ?? 0);
    });
  }

  @override
  void initState() {
    init();
    initInApp();
    super.initState();
  }

  @override
  void dispose() {
    CommonFunctions.afterInit(() {
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            context
                .read<InappProvider>()
                .inAppPurchase
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        iosPlatformAddition.setDelegate(null);
      }
      if (!context.read<InappProvider>().subscription.isNull) { // if inApp purchase is not working remove the if condition and place subscription cancel line out side of the condition
        context.read<InappProvider>().subscription.cancel();
      }
    });

    super.dispose();
  }

  init() {
    CommonFunctions.afterInit(() {
      context.read<PaymentProvider>().init(context, widget.planId ?? 0);
      var initProvider = context.read<PaymentProvider>();
      initProvider.init(context, widget.planId ?? 0);
      initProvider.initCashFreePayment();
      initProvider.cfPaymentGatewayService.setCallback(
          (value) => initProvider.verifyPayment(context, value, onSuccess: () {
                initProvider.cashfreeSentOrderID(
                    orID: initProvider.cashfreeOrderID,
                    onSuccess: () {
                      CommonAlertDialog.showDialogPopUp(
                          barrierDismissible: false,
                          context,
                          SuccessAlert(
                              description:
                                  context.loc.paymentSuccessfullyCompleted,
                              onTap: () {
                                if (widget.isUpgradePlan) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteGenerator.routeMainScreen,
                                      (route) => false);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteGenerator.routeAuthScreen,
                                      (route) => false);
                                }

                                Helpers.successToast("payment success");
                              }));
                      initProvider.cashFreePayVerified(false);
                    });
              }),
          ((error, orderId) => initProvider.onError(error, orderId,
              onFailure: () => CommonAlertDialog.showDialogPopUp(
                  context,
                  barrierDismissible: false,
                  PaymentFailedAlert(
                    showTryAgain: false,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )))));
    });
  }
}
