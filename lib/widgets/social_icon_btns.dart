import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class SocialIconButtons extends StatelessWidget {
  const SocialIconButtons(
      {Key? key,
      this.title,
      this.spaceBetween,
      this.onTap,
      this.leadingIcon,
      this.iconSize,
      this.secondaryTitle})
      : super(key: key);

  final String? leadingIcon;
  final String? title;
  final String? secondaryTitle;
  final double? spaceBetween;
  final VoidCallback? onTap;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85.h,
        width: 315.w,
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.sp, color: HexColor("#C1C9D2"))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 59.h,
              width: 59.w,
              child: Center(
                child: SvgPicture.asset(
                  leadingIcon ?? Assets.iconsInstagram,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            13.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "Instagram",
                  style: FontPalette.black15SemiBold
                      .copyWith(color: HexColor("#565F6C")),
                ),
                if (secondaryTitle != null) ...[
                  3.verticalSpace,
                  Text(
                    secondaryTitle!,
                    style: FontPalette.black15SemiBold
                        .copyWith(color: HexColor("#2995E5"), fontSize: 11.sp),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
