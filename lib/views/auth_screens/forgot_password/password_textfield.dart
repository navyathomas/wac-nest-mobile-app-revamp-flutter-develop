import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/forgot_password_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

class PasswordTextField extends StatefulWidget {
  final bool isPasswordField;
  final bool showSuffix;
  final String labelText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final VoidCallback? onObscureTap;
  const PasswordTextField(
      {Key? key,
      this.isPasswordField = false,
      required this.labelText,
      this.showSuffix = false,
      required this.controller,
      this.onChanged,
      this.obscureText,
      this.onObscureTap})
      : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool show = false;
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> obscured = ValueNotifier<bool>(true);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  @override
  Widget build(BuildContext context) {
    // obscured.value=widget.obscureText;
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            height: 60.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(
                    width: 1.sp,
                    color: value && focusNode.hasFocus
                        ? Colors.black
                        : dimBlackColor)),
            child: Consumer<AuthProvider>(
              builder: (_, providerValue, __) {
                return TextFormField(
                  onChanged: widget.onChanged,
                  controller: widget.controller,
                  style: FontPalette.black16SemiBold,
                  obscureText: widget.obscureText ?? providerValue.obscured,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    suffixIcon: widget.showSuffix
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: IconButton(
                                iconSize: 20.h,
                                onPressed: widget.onObscureTap ??
                                    () => providerValue.obscureChange(),
                                icon: !(widget.obscureText ??
                                        providerValue.obscured)
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 14.02.h,
                                        child: SvgPicture.asset(
                                          Assets.iconsEye,
                                          alignment: Alignment.center,
                                          width: 20.w,
                                          height: 14.02.h,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 20.w,
                                        height: 18.h,
                                        child: SvgPicture.asset(
                                          Assets.iconsEyeSlash,
                                          alignment: Alignment.center,
                                          width: 20.w,
                                          height: 18.h,
                                        ),
                                      )),
                          )
                        : const SizedBox(),
                    contentPadding: EdgeInsets.only(
                        left: 15.w, top: 9.h, bottom: 9.w, right: 15),
                    border: InputBorder.none,
                    labelText: widget.labelText,
                    labelStyle: value && focusNode.hasFocus
                        ? FontPalette.f8695A7_12semiBold
                        : FontPalette.f8695A7_12semiBold
                            .copyWith(fontSize: 16.sp, color: darkGreyColor),
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  void initState() {
    show = context.read<ForgotPasswordProvider>().obscured;
    focusListen();
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
}
