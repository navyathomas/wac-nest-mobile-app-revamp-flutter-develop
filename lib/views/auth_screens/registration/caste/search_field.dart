import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';

class CustomSearchField extends StatelessWidget {
  final Color borderColor;
  final bool enableClose;
  final TextEditingController? controller;
  final Widget? trailingBtn;
  const CustomSearchField(
      {Key? key,
      this.borderColor = Colors.black,
      this.controller,
      this.trailingBtn,
      this.enableClose = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outLineBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
        borderSide: BorderSide(color: borderColor));
    return SizedBox(
      height: 39.h,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: outLineBorder,
            enabledBorder: outLineBorder,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            hintText: context.loc.searchURCaste,
            hintStyle:
                FontPalette.black16Medium.copyWith(color: HexColor('#565F6C')),
            border: outLineBorder,
            suffixIconConstraints:
                BoxConstraints(maxWidth: 31.5.r, minWidth: 31.5.r),
            suffixIcon: trailingBtn ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (enableClose
                        ? SvgPicture.asset(
                            Assets.iconsCloseGrey,
                            height: 16.5.r,
                            width: 16.5.r,
                          )
                        : SvgPicture.asset(
                            Assets.iconsSearchBlack,
                            height: 16.5.r,
                            width: 16.5.r,
                          ).animatedSwitch()),
                    15.verticalSpace
                  ],
                )),
      ),
    );
  }
}
