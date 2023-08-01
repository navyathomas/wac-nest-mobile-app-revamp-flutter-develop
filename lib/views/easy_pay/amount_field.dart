import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class AmountField extends StatefulWidget {
  final String labelText;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final void Function()? onTap;
  final bool isEditable;
  final bool isCopyPasteNeeded;
  const AmountField(
      {Key? key,
      required this.labelText,
      this.onChanged,
      this.onTap,
      this.isEditable = true,
        this.isCopyPasteNeeded=true,
      required this.controller})
      : super(key: key);

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final Color dimBlackColor = const Color(0xFFE4E7E8);
  final Color darkGreyColor = const Color(0xFF565F6C);
  final Color btnGreyColor = const Color(0xFFC1C9D2);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
              padding: EdgeInsets.only(
                left: 26.w,
              ),
              height: 60.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  border: Border.all(
                      width: 1.sp,
                      color: value && focusNode.hasFocus
                          ? Colors.black
                          : dimBlackColor)),
              child: TextFormField(
                enableInteractiveSelection: widget.isCopyPasteNeeded,
                enabled: widget.isEditable,
                onTap: widget.onTap,
                controller: widget.controller,
                onChanged: widget.onChanged,
                keyboardType: TextInputType.number,
                style: FontPalette.black10Bold.copyWith(fontSize: 37.sp),
                focusNode: focusNode,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  prefixIcon: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {},
                    onLongPress: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 17.66.h,
                            width: 14.15.w,
                            child: SvgPicture.asset(Assets.iconsRupee)),
                        Text(
                          "INR",
                          style: FontPalette.black10Bold.copyWith(
                              fontSize: 13, color: HexColor('#565F6C')),
                        ),
                      ],
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "0",
                  hintStyle: FontPalette.black10Bold
                      .copyWith(fontSize: 37.sp, color: HexColor("#D9DCE0")),
                ),
              ));
        });
  }

  @override
  void initState() {
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
