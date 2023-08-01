import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class PremiumTile extends StatelessWidget {
  const PremiumTile({Key? key, this.packageType}) : super(key: key);
  final String? packageType;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 9.8.w,
            width: 12.w,
            child: packageType != null
                ? null
                : SvgPicture.asset(
                    Assets.iconsPremium,
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
          ),
          4.horizontalSpace,
          Flexible(
            child: Text(
              packageType ?? context.loc.premium,
              style: FontPalette.black10Medium
                  .copyWith(color: HexColor('#E09B00')),
            ).avoidOverFlow(),
          )
        ],
      ),
    );
  }
}
