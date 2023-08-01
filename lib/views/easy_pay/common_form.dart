import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/common/validation_helper.dart';
import 'package:nest_matrimony/models/paymentRegistrationBodyModel.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/easy_pay/ep_home.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/common_mobile_textfield.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../providers/inapp_provider.dart';

class CommonForm extends StatefulWidget {
  final EPnav? epayNav;
  final String? appbarTitle;
  const CommonForm({Key? key, this.epayNav, this.appbarTitle})
      : super(key: key);

  @override
  State<CommonForm> createState() => _CommonFormState();
}

class _CommonFormState extends State<CommonForm> {
  late ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.appbarTitle ?? '',
          style: FontPalette.white16Bold.copyWith(color: Colors.black),
        ),
        elevation: 0.5,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Consumer<PaymentProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///
                Expanded(
                  child: SingleChildScrollView(
                    // reverse: true,
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        21.5.verticalSpace,
                        CommonTextField(
                          isEditable:
                              provider.loaderState == LoaderState.loading
                                  ? false
                                  : true,
                          controller: provider.controllerFullName,
                          inputFormatters: ValidationHelper.inputFormatter(
                              InputFormats.name),
                          labelText: context.loc.fullName,
                          keyboardType: TextInputType.name,
                          errorMsg: provider.nameErrorMessage,
                          errorBorder: provider.nameBorder,
                          onChanged: ((p0) {
                            setState(() {});
                            String? error =
                                ValidationHelper.validateName(context, p0);
                            if (error != null) {
                              provider.nameErrorMessage = error;
                              provider.nameBorder = true;
                            } else {
                              provider.nameErrorMessage = '';
                              provider.nameBorder = false;
                            }
                          }),
                        ),
                        12.verticalSpace,
                        CommonMobileTextField(
                          isEditable:
                              provider.loaderState == LoaderState.loading
                                  ? false
                                  : true,
                          labelText: context.loc.mobileNumber,
                          controller: provider.controllerMob,
                          errorMsg: provider.mobileErrorMessage,
                          errorBorder: provider.mobileBorder,
                          onChanged: (p0) {
                            setState(() {});
                            if (p0.length <
                                context.read<AuthProvider>().minLength) {
                              provider.mobileErrorMessage =
                                  context.loc.invalidMobile;
                              provider.mobileBorder = true;
                            } else {
                              provider.mobileErrorMessage = '';
                              provider.mobileBorder = false;
                            }
                          },
                        ),
                        12.verticalSpace,
                        CommonTextField(
                          isEditable:
                              provider.loaderState == LoaderState.loading
                                  ? false
                                  : true,
                          controller: provider.controllerEmail,
                          labelText: context.loc.emailIdOptional,
                          keyboardType: TextInputType.emailAddress,
                          errorMsg: provider.emailErrorMessage,
                          errorBorder: provider.emailBorder,
                          onChanged: ((p0) {
                            if (p0.isNotEmpty) {
                              String? error =
                                  ValidationHelper.validateEmail(context, p0);
                              if (error != null) {
                                provider.emailErrorMessage = error;
                                provider.emailBorder = true;
                              } else {
                                provider.emailErrorMessage = '';
                                provider.emailBorder = false;
                              }
                            } else {
                              provider.emailErrorMessage = '';
                              provider.emailBorder = false;
                            }

                            setState(() {});
                          }),
                        ),
                        widget.epayNav == EPnav.other
                            ? Column(
                                children: [
                                  12.verticalSpace,
                                  CommonTextField(
                                    isEditable: provider.loaderState ==
                                            LoaderState.loading
                                        ? false
                                        : true,
                                    controller:
                                        provider.controllerPurposeDetail,
                                    labelText: context.loc.purposeDetails,
                                    keyboardType: TextInputType.emailAddress,
                                    errorMsg: provider.purposeErrorMessage,
                                    errorBorder: provider.purposeBorder,
                                    onChanged: ((p0) {
                                      setState(() {});
                                      String? error =
                                          ValidationHelper.validateName(
                                              context, p0);
                                      if (error != null) {
                                        provider.purposeErrorMessage =
                                            'Please enter a valid purpose';
                                        provider.purposeBorder = true;
                                      } else {
                                        provider.purposeErrorMessage = '';
                                        provider.purposeBorder = false;
                                      }
                                    }),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        12.verticalSpace,
                        CommonTextField(
                          scrollPadding: 80.h,
                          onTap: () {},
                          isEditable:
                              provider.loaderState == LoaderState.loading
                                  ? false
                                  : true,
                          controller: provider.controllerAddress,
                          isAddress: true,
                          labelText: context.loc.address,
                          keyboardType: TextInputType.emailAddress,
                          errorMsg: provider.addressErrorMessage,
                          errorBorder: provider.addressBorder,
                          onChanged: ((p0) {
                            setState(() {});
                            String? error =
                                ValidationHelper.validateAddress(context, p0);
                            if (error != null) {
                              provider.addressErrorMessage = error;
                              provider.addressBorder = true;
                            } else {
                              provider.addressErrorMessage = '';
                              provider.addressBorder = false;
                            }
                            debugPrint('error $error');
                          }),
                        ),
                        10.verticalSpace,
                      ],
                    ),
                  ),
                ),

                ///
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: CommonButton(
                      fontStyle: FontPalette.white13SemiBold,
                      title: "Continue",
                      isLoading: provider.loaderState == LoaderState.loaded
                          ? false
                          : true,
                      onPressed:
                          // provider.controllerFullName.text.length >= 3 &&
                          //         provider.nameBorder == false &&
                          //         provider.controllerMob.text != "" &&
                          //         provider.mobileBorder == false &&
                          //         provider.addressBorder == false &&
                          //         provider.emailBorder == false &&
                          //         provider.controllerAddress.text.isNotEmpty
                          //     ?
                          () {
                        if (provider.controllerMob.text.isEmpty) {
                          Helpers.successToast('Mobile number is required');
                        } else if (provider.controllerAddress.text.isEmpty) {
                          Helpers.successToast('Address field is required');
                        } else if (provider.controllerEmail.text.isEmpty ||
                            (provider.emailErrorMessage).isNotEmpty) {
                          Helpers.successToast('Email ID field is required');
                        } 

                        else {
                          context.read<InappProvider>().updateKeys(kConsumable:"Premium_Delight_7500");
                          PaymentRegistrationBodyModel
                              paymentRegistrationBodyModel =
                              PaymentRegistrationBodyModel(
                            clientName: provider.controllerFullName.text,
                            clientAddress: provider.controllerAddress.text,
                            clientEmail: provider.controllerEmail.text,
                            clientMobile: provider.controllerMob.text.isNotEmpty
                                ? int.parse(provider.controllerMob.text)
                                : int.parse('0'),
                            countryCode: context.read<AuthProvider>().countryId,
                            paymentPurpose: provider.paymentPurpose ?? '',
                            purposeDetails:
                                provider.controllerPurposeDetail.text,
                          );
                          provider.paymentRegistration(
                              context, paymentRegistrationBodyModel,
                              onSuccess: () {
                            FocusScope.of(context).unfocus();
                            provider.getSubscriptionList(context).then(
                                (value) => Navigator.pushNamed(context,
                                        RouteGenerator.routePaymentInit,
                                        arguments: RouteArguments(
                                            isUpgradePlan: false,
                                            planAmount: 0,
                                            planId: 0))
                                    .then((value) =>
                                        provider.subscriptionDataList.clear()));
                          });
                        }
                      }
                      //   : null,
                      ),
                ),
                // Padding(
                //     padding: EdgeInsets.only(
                //         bottom: MediaQuery.of(context).viewInsets.bottom))
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    CommonFunctions.afterInit(() {
      context.read<PaymentProvider>().clearValues();
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }
}
