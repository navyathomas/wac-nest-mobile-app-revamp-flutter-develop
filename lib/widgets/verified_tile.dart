import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class VerifiedTile extends StatelessWidget {
  final String? title;
  const VerifiedTile({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 11.r,
          width: 11.r,
          child: title != null
              ? null
              : SvgPicture.asset(
                  Assets.iconsVerified,
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
        ),
        4.horizontalSpace,
        Flexible(
          child: Text(
            title ?? context.loc.verified,
            style:
                FontPalette.black10Medium.copyWith(color: HexColor('#C60089')),
          ).avoidOverFlow(),
        )
      ],
    );
  }
}
