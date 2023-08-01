import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/auth_screens/registration/register_number/country_picker_container.dart';
import 'package:nest_matrimony/widgets/common_floating_btn.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../../models/authentication/login_arguments.dart';
import '../../../services/helpers.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/common_alert_view.dart';

class LoginViaOTP extends StatefulWidget {
  final LoginArguments? loginArguments;
  const LoginViaOTP({Key? key, this.loginArguments}) : super(key: key);

  @override
  State<LoginViaOTP> createState() => _LoginViaOTPState();
}

class _LoginViaOTPState extends State<LoginViaOTP> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> enablebtn = ValueNotifier<bool>(false);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  Color get btnGreyColor => const Color(0xFFC1C9D2);
  late final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: enablebtn,
            builder: (_, bool value, Widget? child) {
              return Consumer<AuthProvider>(
                builder: (_, provider, child) {
                  return CommonFloatingBtn(
                    enableBtn: enableButton,
                    enableLoader: provider.btnLoader,
                    onPressed: onProceed,
                  );
                },
              );
            }),
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0, leading: ReusableWidgets.roundedBackButton(context)),
        body: SingleChildScrollView(
          child: Container(
            width: context.sw(),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                37.verticalSpace,
                Text(
                  context.loc.loginViaOTP,
                  style: FontPalette.black30Bold,
                ),
                26.verticalSpace,
                Consumer<AuthProvider>(builder: ((context, value, child) {
                  return otpTextField(
                      labelText: context.loc.registeredMobile,
                      error: value.errorMsg != "" ? true : false,
                      errorMsg: value.errorMsg);
                }))
              ],
            ),
          ),
        ));
  }

  Widget otpTextField(
      {String? labelText, bool error = false, String? errorMsg}) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Consumer<AuthProvider>(builder: ((_, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 26.w,
                  ),
                  height: 60.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                          width: 1.sp,
                          color: error &&
                                  provider.errorType ==
                                      Constants.mobileErrorType
                              ? Colors.red
                              : value && focusNode.hasFocus
                                  ? Colors.black
                                  : dimBlackColor)),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
                    ],
                    controller: _controller,
                    maxLength: provider.maxLength,
                    onChanged: ((value) {
                      enableButton;
                      provider.updateMobileNo(mobile: value);
                    }),
                    keyboardType: TextInputType.number,
                    style: FontPalette.black16SemiBold,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          context.read<AppDataProvider>().resetCountryList();
                          ReusableWidgets.customBottomSheet(
                              context: context,
                              child: CountryPickerContainer(
                                onChange: (val) {
                                  provider.updateCountryData(val);
                                  _controller.clear();
                                },
                              ));
                        },
                        onLongPress: () {
                          //TODO
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32.88.w,
                              height: 22.87.h,
                              child: provider.countryData?.countryFlag != null
                                  ? SvgPicture.network(
                                      provider.countryData!.countryFlag!,
                                      alignment: Alignment.center,
                                      width: 32.88.w,
                                      height: 22.87.h,
                                    )
                                  : SvgPicture.asset(
                                      Assets.iconsFlag,
                                      alignment: Alignment.center,
                                      width: 32.88.w,
                                      height: 22.87.h,
                                    ),
                            ),
                            4.12.horizontalSpace,
                            Text(
                              provider.countryData?.dialCode != null
                                  ? "+${provider.countryData!.dialCode}"
                                  : "+91",
                              style: FontPalette.black16SemiBold,
                            ),
                            4.12.horizontalSpace,
                            SizedBox(
                              width: 5.84.w,
                              height: 9.61.h,
                              child: SvgPicture.asset(
                                Assets.iconsDownArrow,
                                alignment: Alignment.center,
                                width: 5.84.w,
                                height: 9.61.h,
                              ),
                            ),
                            14.25.horizontalSpace,
                          ],
                        ),
                      ),
                      border: InputBorder.none,
                      labelText: labelText,
                      labelStyle: value && focusNode.hasFocus
                          ? FontPalette.f8695A7_12semiBold
                          : FontPalette.f8695A7_12semiBold
                              .copyWith(fontSize: 16.sp, color: darkGreyColor),
                    ),
                  ),
                ),
                if (provider.countryData != null &&
                    provider.countryData?.id != 1)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: CommonTextField(
                      labelText: 'Enter Email Address',
                      controller: provider.emailController,
                      errorBorder: error &&
                          provider.errorType == Constants.emailErrorType,
                      onChanged: (val) => provider
                        ..validateEmailAddress(val)
                        ..updateEmailId(val),
                    ),
                  ),
                error
                    ? Padding(
                        padding: EdgeInsets.all(3.r),
                        child: Text(
                          errorMsg ?? "",
                          style: FontPalette.black10Medium
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : const SizedBox()
              ],
            );
          }));
        });
  }

  @override
  void initState() {
    focusListen();
    _controller =
        TextEditingController(text: widget.loginArguments?.mobileNumber ?? "");
    context.read<AuthProvider>().emailController =
        TextEditingController(text: widget.loginArguments?.email ?? "");
    CommonFunctions.afterInit(() {
      context.read<AuthProvider>()
        ..initAuthProvider()
        ..updateCountryData(widget.loginArguments?.countryData)
        ..updateMobileNo(mobile: widget.loginArguments?.mobileNumber ?? '')
        ..updateEmailId(widget.loginArguments?.email ?? '')
        ..validateEmailAddress(widget.loginArguments?.email ?? '');
    });
    super.initState();
  }

  void focusListen() {
    focusNode.addListener(() {
      if (focusNode.hasFocus == true) {
        isBorder.value = true;
      } else {
        isBorder.value = false;
      }
    });
  }

  bool get enableButton {
    int minLength = context.read<AuthProvider>().minLength;
    if (context.read<AuthProvider>().countryData == null ||
        context.read<AuthProvider>().countryData?.id == 1) {
      return _controller.text == "" || _controller.text.length < minLength
          ? enablebtn.value = false
          : enablebtn.value = true;
    } else {
      return _controller.text == "" ||
              _controller.text.length < minLength ||
              !context.read<AuthProvider>().isEmailValid
          ? enablebtn.value = false
          : enablebtn.value = true;
    }
  }

  void onProceed() {
    final provider = context.read<AuthProvider>();
    FocusScope.of(context).unfocus();

    provider.postLoginViaOTP(context, onSuccess: (res) {
      if (res != null) {
        if (res) {
          Navigator.pushNamed(context, RouteGenerator.routeAuthOtpScreen,
                  arguments: RouteArguments(navFrom: NavFrom.navFromLogin))
              .then((value) {
            provider.clearErrorMsg();
          });
        } else {
          context
              .read<RegistrationProvider>()
              .updateCountryData(provider.countryData);
          Helpers.successToast(context.loc.notARegisteredUser);
          Navigator.pushNamed(context, RouteGenerator.routeRegistrationScreen,
              arguments: LoginArguments(
                  mobileNumber: provider.mobileNo,
                  countryData: provider.countryData,
                  email: provider.email));
          /* CommonAlertDialog.showDialogPopUp(
              barrierDismissible: false,
              context,
              CommonAlertView(
                height: 216.h + ((40 * Helpers.validateScale(context, 0.0)).h),
                buttonText: context.loc.register,
                heading: context.loc.oopss,
                contents: context.loc.looksLikeUrNotARegisteredUser,
                onTap: () async {
                  context.rootPop;
                  Navigator.pushReplacementNamed(
                      context, RouteGenerator.routeRegistrationScreen);
                },
              ));*/
        }
      }
    });
  }
}
