import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class CommonTextField extends StatefulWidget {
  final bool isPasswordField;
  final String labelText;
  final TextInputType? keyboardType;
  final bool isAddress;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool errorBorder;
  final String? errorMsg;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEditable;
  var validator;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final double? scrollPadding;
  final bool copyPasteNeeded;
  // final bool labelAlign;

  CommonTextField({
    Key? key,
    this.isPasswordField = false,
    required this.labelText,
    this.keyboardType,
    this.isAddress = false,
    this.controller,
    this.onEditingComplete,
    this.textInputAction,
    this.onChanged,
    this.errorBorder = false,
    this.errorMsg,
    this.inputFormatters,
    this.textCapitalization,
    this.validator,
    this.isEditable = true,
    this.onSubmitted,
    this.onTap,
    this.scrollPadding,
    this.copyPasteNeeded = true,
    // this.labelAlign = false,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  final TextEditingController _controller = TextEditingController(text: "");
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> obscured = ValueNotifier<bool>(true);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: widget.isAddress ? 110.h : 60.h,
                // padding:widget.isAddress? EdgeInsets.only(top:!obscured.value?0: 2.h):null,
                decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                        width: 1.sp,
                        color: widget.errorBorder
                            ? Colors.red
                            : value && focusNode.hasFocus
                                ? Colors.black
                                : dimBlackColor)),
                child: ValueListenableBuilder<bool>(
                    valueListenable: obscured,
                    builder: (BuildContext context, bool obscuredValue,
                        Widget? child) {
                      return TextFormField(
                        scrollPadding:
                            EdgeInsets.all(widget.scrollPadding ?? 20.h),
                        onTap: widget.onTap,
                        onFieldSubmitted: widget.onSubmitted,
                        enabled: widget.isEditable,
                        validator: widget.validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textCapitalization: widget.textCapitalization ??
                            TextCapitalization.none,
                        inputFormatters: widget.inputFormatters,
                        onChanged: widget.onChanged,
                        controller: widget.controller ?? _controller,
                        style: FontPalette.black16SemiBold,
                        obscureText: obscuredValue,
                        focusNode: focusNode,
                        onEditingComplete: widget.onEditingComplete,
                        textInputAction: widget.textInputAction,
                        keyboardType: widget.keyboardType,
                        maxLines: widget.isAddress ? 5 : 1,
                        enableInteractiveSelection: widget.copyPasteNeeded,
                        decoration: InputDecoration(
                          suffixIcon: widget.isPasswordField
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: IconButton(
                                      iconSize: 20.h,
                                      onPressed: () =>
                                          obscured.value = !obscured.value,
                                      icon: !obscuredValue
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
                              : null,
                          contentPadding: EdgeInsets.only(
                              left: 15.w,
                              top: 9.h,
                              bottom: 17.h,
                              right:
                                  15.w), //   bottom: 9.h change to bottom: 17.h
                          border: InputBorder.none,
                          label: widget.isAddress
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: isBorder.value ? 4.h : 4.h,
                                      bottom: 20.h),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30.h),
                                    // padding:  EdgeInsets.only(bottom: 40.h,),
                                    child: Text(widget.labelText),
                                  ),
                                )
                              : Text(widget.labelText),
                          // labelText: widget.labelText,
                          labelStyle: value && focusNode.hasFocus
                              ? FontPalette.f8695A7_12semiBold
                              : FontPalette.f8695A7_12semiBold.copyWith(
                                  fontSize: 16.sp, color: darkGreyColor),
                        ),
                      );
                    }),
              ),
              widget.errorBorder
                  ? Padding(
                      padding: EdgeInsets.all(3.r),
                      child: Text(
                        widget.errorMsg ?? "",
                        style: FontPalette.black10Medium
                            .copyWith(color: Colors.red),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        });
  }

  @override
  void initState() {
    obscured.value = widget.isPasswordField;
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
