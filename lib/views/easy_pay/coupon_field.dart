import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

class CouponField extends StatefulWidget {
  final String labelText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController controller;
  final String? buttonName;
  bool errorBorder;
  String? errorMsg;
  final bool isEditable;
  bool isEmpty;
  CouponField(
      {Key? key,
      required this.labelText,
      this.onChanged,
      required this.controller,
      this.onTap,
      this.buttonName,
      this.errorBorder = false,
      this.errorMsg,
      this.isEditable = true,
      this.isEmpty = false})
      : super(key: key);

  @override
  State<CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends State<CouponField> {
  final FocusNode focusNode = FocusNode();
  final Color dimBlackColor = const Color(0xFFE4E7E8);
  final Color darkGreyColor = const Color(0xFF565F6C);
  final Color btnGreyColor = const Color(0xFFC1C9D2);
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(
                    width: 1.sp,
                    color: widget.errorBorder
                        ? Colors.red
                        : focusNode.hasFocus
                            ? Colors.black
                            : dimBlackColor)),
            child: TextFormField(
              enabled: widget.isEditable,
              enableInteractiveSelection: false,
              readOnly: provider.couponApplied ? true : false,
              controller: widget.controller,
              onChanged: widget.onChanged,
              keyboardType: TextInputType.text,
              style: FontPalette.black14SemiBold.copyWith(),
              focusNode: provider.couponApplied ? FocusNode() : focusNode,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                suffixIcon: provider.couponLoading
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                            height: 5.h,
                            width: 5.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                            )),
                      )
                    : InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: widget.onTap,
                        onLongPress: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 13.h, bottom: 13.h, right: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.buttonName != "Apply"
                                  ? Text(
                                      widget.buttonName ?? '',
                                      style: FontPalette.f131A24_16SemiBold
                                          .copyWith(
                                              fontSize: 13,
                                              color: Colors.black),
                                    )
                                  : Text(
                                      widget.buttonName ?? '',
                                      style: FontPalette.f131A24_16SemiBold
                                          .copyWith(
                                              fontSize: 16,
                                              color: !widget.isEmpty
                                                  ? ColorPalette.primaryColor
                                                  : ColorPalette.primaryColor
                                                      .withOpacity(.5)),
                                    ),
                            ],
                          ),
                        ),
                      ),
                border: InputBorder.none,
                hintText: "ENTER CODE",
                hintStyle: FontPalette.black14SemiBold
                    .copyWith(fontSize: 14.sp, color: HexColor("#565F6C")),
              ),
            ),
          ),
          widget.errorBorder
              ? Padding(
                  padding: EdgeInsets.all(3.r),
                  child: Text(
                    widget.errorMsg ?? "",
                    style:
                        FontPalette.black10Medium.copyWith(color: Colors.red),
                  ),
                )
              : const SizedBox()
        ],
      );
    });
  }
}
