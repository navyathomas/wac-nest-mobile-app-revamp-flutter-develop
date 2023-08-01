import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class CommonMessageTextField extends StatefulWidget {
  final String labelText;
  final TextInputType? keyboardType;

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool isMessageField;

  const CommonMessageTextField({
    Key? key,
    required this.labelText,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.isMessageField = false,
  }) : super(key: key);

  @override
  State<CommonMessageTextField> createState() => _CommonMessageTextFieldState();
}

class _CommonMessageTextFieldState extends State<CommonMessageTextField> {
  final TextEditingController _controller = TextEditingController(text: "");
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> obscured = ValueNotifier<bool>(true);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: BorderSide(
          color: dimBlackColor,
          width: 1.0.r,
        ));
    final outlinedFocusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: BorderSide(
          color: Colors.black,
          width: 1.0.r,
        ));
    return SizedBox(
        height: widget.isMessageField ? 143.h : 60.h,
        child: TextFormField(
          maxLength: widget.isMessageField ? 600 : null,
          onChanged: widget.onChanged,
          controller: widget.controller ?? _controller,
          style: FontPalette.black16SemiBold,
          focusNode: focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.isMessageField ? 10 : 1,
          decoration: InputDecoration(
              focusedBorder: outlinedFocusedBorder,
              contentPadding:
                  EdgeInsets.only(left: 15.w, top: 9.h, bottom: 9.w, right: 15),
              border: outlinedBorder,
              enabledBorder: outlinedBorder,
              disabledBorder: outlinedBorder,
              hintText: widget.labelText,
              hintStyle: FontPalette.black16SemiBold
                  .copyWith(color: HexColor("#565F6C")),
              labelStyle: FontPalette.f8695A7_12semiBold),
        ));
  }
}
