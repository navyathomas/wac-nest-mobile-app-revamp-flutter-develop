import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class PartnerCategoryTile extends StatelessWidget {
  final String title;
  final String icon;
  const PartnerCategoryTile({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.5.h),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 24.r,
            width: 24.r,
            fit: BoxFit.contain,
          ),
          7.horizontalSpace,
          Expanded(
              child: Text(
            title,
            style: FontPalette.f131A24_16Bold,
          ))
        ],
      ),
    );
  }
}
