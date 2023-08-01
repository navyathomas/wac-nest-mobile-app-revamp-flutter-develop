import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/validation_helper.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/timer_counter.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen(
      {Key? key,
      required this.onTap,
      required this.onComplete,
      this.onChange,
      this.padding,
      this.fieldPadding,
      this.onResendTap,
      required this.mobileNumber,
      this.errorMsg,
      this.enableLoader = false,
      this.enableError = false,
      this.pinCodeController,
      this.email})
      : super(key: key);

  final Function(BuildContext context) onTap;
  final Function(BuildContext, String) onComplete;
  final ValueChanged<String>? onChange;
  final VoidCallback? onResendTap;
  final EdgeInsets? padding;
  final EdgeInsets? fieldPadding;
  final String mobileNumber;
  final bool enableError;
  final String? errorMsg;
  final bool enableLoader;
  final TextEditingController? pinCodeController;
  final String? email;
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Color borderColor = HexColor('#000000');

  final controller = TextEditingController();

  final focusNode = FocusNode();

  PinTheme focusedPinTheme(double width) => PinTheme(
        width: width,
        textStyle: FontPalette.black22SemiBold,
        height: width,
        decoration: const BoxDecoration(),
      );

  PinTheme errorPinTheme(double width) => PinTheme(
        width: width,
        textStyle: FontPalette.black22SemiBold,
        height: width,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1.5.h, color: HexColor('FF0000')))),
      );

  PinTheme defaultPinTheme(double width) => PinTheme(
        width: width,
        textStyle: FontPalette.black22SemiBold,
        height: width,
        decoration: const BoxDecoration(),
      );

  Widget cursor(double width) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: width,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: borderColor,
              // borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      );

  Widget preFilledWidget(double width) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: width,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: HexColor('#E4E7E8'),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      );

  PinTheme submittedPinTheme(double width) => PinTheme(
        width: width,
        height: width,
        textStyle: FontPalette.black22SemiBold,
        decoration: BoxDecoration(
            // color: Colors.red,
            border: Border(
                bottom: BorderSide(width: 1.5.h, color: HexColor('#E4E7E8')))),
      );

  Widget _errorWidget(BuildContext context) {
    return WidgetExtension.crossSwitch(
        first: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Selector<AuthProvider, String>(
            selector: (context, provider) => provider.errorMsg,
            builder: (context, value, child) {
              return Text(
                widget.errorMsg ?? value,
                style: FontPalette.black14Regular
                    .copyWith(color: HexColor('#FF0000')),
              );
            },
          ),
        ),
        value: widget.enableError);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    widget.padding ?? EdgeInsets.symmetric(horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      36.verticalSpace,
                      Text(
                        context.loc.otpTitle,
                        style: FontPalette.black30Bold,
                      ),
                      14.verticalSpace,
                      Text.rich(TextSpan(
                          text: context.loc.sendTo,
                          style: FontPalette.black14Medium
                              .copyWith(color: HexColor('#8695A7')),
                          children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: 5.w,
                            )),
                            TextSpan(
                                text: (widget.email ?? '').isEmpty
                                    ? widget.mobileNumber
                                    : widget.email,
                                style: FontPalette.black14Medium),
                            WidgetSpan(
                                child: SizedBox(
                              width: 5.w,
                            )),
                            TextSpan(
                                text: context.loc.change,
                                style: FontPalette.black14SemiBold
                                    .copyWith(color: HexColor('#2995E5')),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (!widget.enableLoader) {
                                      widget.onTap(context);
                                    }
                                  })
                          ])),
                      10.verticalSpace,
                      Padding(
                        padding: widget.fieldPadding ?? EdgeInsets.zero,
                        child: Selector<AuthProvider, String>(
                            selector: (context, provider) => provider.errorMsg,
                            builder: (context, value, child) {
                              return LayoutBuilder(
                                  builder: (context, constraints) {
                                return Center(
                                  child: Pinput(
                                    autofocus: true,
                                    length: 4,
                                    //
                                    androidSmsAutofillMethod:
                                        AndroidSmsAutofillMethod
                                            .smsRetrieverApi,
                                    listenForMultipleSmsOnAndroid: true,
                                    // onClipboardFound: (value) {
                                    //   debugPrint('onClipboardFound: $value');
                                    // },
                                    //
                                    pinAnimationType: PinAnimationType.fade,
                                    controller: controller,
                                    focusNode: focusNode,
                                    inputFormatters:
                                        ValidationHelper.inputFormatter(
                                                InputFormats.phoneNumber) ??
                                            [],
                                    onCompleted: (value) =>
                                        widget.onComplete(context, value),
                                    onChanged: (val) {
                                      if (widget.onChange != null) {
                                        widget.onChange!(val);
                                      }
                                    },
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    errorPinTheme: errorPinTheme(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    defaultPinTheme: defaultPinTheme(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    showCursor: true,
                                    cursor: cursor(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    preFilledWidget: preFilledWidget(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    submittedPinTheme: submittedPinTheme(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    focusedPinTheme: focusedPinTheme(
                                        ((constraints.maxWidth - 70.w) / 4).w),
                                    forceErrorState:
                                        (widget.errorMsg ?? value).isNotEmpty,
                                  ),
                                );

                                //ajnas bro
                                // Pinput(
                                //   defaultPinTheme: defaultPinTheme,
                                //   // focusedPinTheme: focusedPinTheme,
                                //   // submittedPinTheme: submittedPinTheme,
                                //   validator: (s) {
                                //     return s == '2222' ? null : 'Pin is incorrect';
                                //   },
                                //   pinputAutovalidateMode:
                                //       PinputAutovalidateMode.onSubmit,
                                //   showCursor: true,
                                //   onCompleted: (pin) => print(pin),
                                // );

                                // Pinput(
                                //   defaultPinTheme: defaultPinTheme,
                                //   focusedPinTheme: focusedPinTheme,
                                //   submittedPinTheme: submittedPinTheme,
                                //   validator: (s) {
                                //     return s == '2222' ? null : 'Pin is incorrect';
                                //   },
                                //   pinputAutovalidateMode:
                                //       PinputAutovalidateMode.onSubmit,
                                //   showCursor: true,
                                //   onCompleted: (pin) => print(pin),
                                // );

                                // PinCodeTextField(
                                //   appContext: context,
                                //   controller: pinCodeController,
                                //   pastedTextStyle: TextStyle(
                                //     color: Colors.green.shade600,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                //   length: 4,
                                //   animationType: AnimationType.fade,
                                //   inputFormatters: ValidationHelper.inputFormatter(
                                //           InputFormats.phoneNumber) ??
                                //       [],
                                //   pinTheme: PinTheme(
                                //       shape: PinCodeFieldShape.underline,
                                //       fieldWidth:
                                //           ((constraints.maxWidth - 70.w) / 4).w,
                                //       activeColor: enableError
                                //           ? HexColor('#FF0000')
                                //           : HexColor('#E4E7E8'),
                                //       selectedColor: Colors.black,
                                //       inactiveColor: HexColor('#E4E7E8'),
                                //       disabledColor: HexColor('#E4E7E8'),
                                //       borderWidth: 1.5.h,
                                //       errorBorderColor: HexColor('#FF0000')),
                                //   cursorColor: Colors.black,
                                //   animationDuration:
                                //       const Duration(milliseconds: 300),
                                //   keyboardType: TextInputType.number,
                                //   onCompleted: (value) => onComplete(context, value),
                                //   onChanged: (value) {
                                //     if (onChange != null) {
                                //       onChange!(value);
                                //     } else {
                                //       onChange!(value);
                                //     }
                                //   },
                                //   beforeTextPaste: (text) {
                                //     debugPrint("Allowing to paste $text");
                                //     return true;
                                //   },
                                // );
                              });
                            }),
                      ),
                      5.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: _errorWidget(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.enableLoader ? 0 : 1.0,
              child: Countdown(
                seconds: 30,
                onTap: () {
                  controller.clear();
                  if (widget.onResendTap != null) widget.onResendTap!();
                },
              ),
            ),
            SizedBox(
              height: context.sh(size: 0.05),
            )
          ],
        ),
        if (widget.enableLoader)
          Positioned(
              bottom: context.sh(size: 0.05),
              child: const CircularProgressIndicator())
      ],
    );
  }
}
