import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class WhatsAppVerifiedTile extends StatelessWidget {
  final bool isVerified;
  final bool enableButton;
  const WhatsAppVerifiedTile(
      {Key? key, this.isVerified = false, this.enableButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 12.r,
          width: 12.r,
          child: !isVerified
              ? null
              : SvgPicture.asset(
                  Assets.iconsCheckMarkCircle,
                  color: HexColor('#2995E5'),
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
        ),
        3.horizontalSpace,
        Flexible(
          child: Text(
            isVerified ? context.loc.verified : context.loc.verify,
            style: FontPalette.black14SemiBold.copyWith(
                color:
                    enableButton ? HexColor('#2995E5') : HexColor("#8695A7")),
          ).avoidOverFlow(),
        ),
        12.horizontalSpace,
      ],
    );
  }
}
