import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio.dart';

class BrideGroomTile extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final bool disableBtn;
  final VoidCallback? onTap;
  const BrideGroomTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.isSelected,
      this.disableBtn = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disableBtn ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor('#F1F3F3'),
            ),
            color: isSelected ? HexColor('#FFDEF4') : Colors.white,
            borderRadius: BorderRadius.circular(9.r)),
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 32.h,
                  width: 22.w,
                  color: isSelected
                      ? HexColor('#C60089')
                      : disableBtn
                          ? Colors.grey.shade300
                          : null,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.08),
                  child: Text(
                    title,
                    style: disableBtn && !isSelected
                        ? FontPalette.f131A24_16SemiBold
                            .copyWith(color: Colors.grey.shade300)
                        : FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow(),
                )),
                CustomRadio(
                  isSelected: isSelected,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
