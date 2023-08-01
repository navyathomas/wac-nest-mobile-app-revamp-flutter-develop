import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../../../generated/assets.dart';

class HomeHeaderTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  const HomeHeaderTile({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 4.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: FontPalette.f131A24_18ExtraBold,
            ).avoidOverFlow(),
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(5, 0),
                  child: Text(
                    context.loc.seeAll,
                    style: FontPalette.f2995E5_13ExtraBold,
                  ),
                ).flexWrap,
                SvgPicture.asset(
                  Assets.iconsChevronRightBlue,
                  height: 32.r,
                  width: 32.r,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
