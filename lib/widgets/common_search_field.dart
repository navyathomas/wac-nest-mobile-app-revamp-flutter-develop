import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class CommonSearchField extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? valueChange;
  final TextEditingController? textEditingController;
  CommonSearchField({
    Key? key,
    this.hintText,
    this.valueChange,
    this.textEditingController,
  }) : super(key: key);

  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: ColorPalette.pageBgColor, width: 0),
    borderRadius: BorderRadius.circular(25.r),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.h,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 17.w),
      child: TextField(
        onChanged: valueChange,
        controller: textEditingController,
        decoration: InputDecoration(
            fillColor: ColorPalette.pageBgColor,
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                16.6.horizontalSpace,
                SvgPicture.asset(
                  Assets.iconsSearchGrey,
                  height: 16.5.w,
                  width: 16.5.w,
                )
              ],
            ),
            suffixIcon: ((textEditingController?.text ?? '').isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (textEditingController != null) {
                                textEditingController!.clear();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: SvgPicture.asset(
                                Assets.iconsCloseRoundedGrey,
                                height: 20.r,
                                width: 20.r,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink())
                .animatedSwitch(),
            border: _border,
            filled: true,
            focusedBorder: _border,
            enabledBorder: _border,
            errorBorder: _border,
            disabledBorder: _border,
            contentPadding: EdgeInsets.symmetric(vertical: 5.h),
            hintText: hintText,
            hintStyle: FontPalette.black16SemiBold
                .copyWith(color: HexColor('#565F6C'))),
      ),
    );
  }
}
