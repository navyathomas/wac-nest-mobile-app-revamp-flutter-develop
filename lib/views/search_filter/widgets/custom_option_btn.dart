import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../../utils/color_palette.dart';

class CustomOptionBtn extends StatelessWidget {
  const CustomOptionBtn(
      {Key? key,
      required this.title,
      this.selectedValue = '',
      this.marginTop,
      this.onTap})
      : super(key: key);

  final String title;
  final String selectedValue;
  final double? marginTop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          key: key,
          margin: EdgeInsets.only(top: marginTop ?? 15.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor('#F1F3F3'),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(9.r)),
          child: Row(
            children: [
              Expanded(
                child: selectedValue.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: FontPalette.f131A24_16SemiBold,
                        ).avoidOverFlow(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: FontPalette.black12semiBold
                                .copyWith(color: HexColor('#8695A7')),
                          ).avoidOverFlow(),
                          6.verticalSpace,
                          Text(
                            selectedValue,
                            style: onTap == null
                                ? FontPalette.f131A24_16SemiBold
                                    .copyWith(color: HexColor("#8695A7"))
                                : FontPalette.f131A24_16SemiBold,
                          ).avoidOverFlow()
                        ],
                      ),
              ),
              SvgPicture.asset(Assets.iconsChevronRight)
            ],
          ),
        ),
      ),
    ).removeSplash();
  }
}
