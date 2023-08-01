import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../../../generated/assets.dart';
import '../../../partner_profile_detail/widgets/partner_category_tile.dart';

class PreviewVerifiedTag extends StatelessWidget {
  final bool isVerified;
  const PreviewVerifiedTag({Key? key, this.isVerified = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PartnerCategoryTile(
          title: context.loc.profileVerification,
          icon: Assets.iconsVerifiedSheild,
        ),
        15.verticalSpace,
        Container(
          decoration: BoxDecoration(
              color: HexColor('#F2F4F5'),
              borderRadius: BorderRadius.circular(15.r)),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.iconsVerifyPhone,
                width: 27.w,
                height: 33.h,
              ),
              16.horizontalSpace,
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isVerified
                        ? context.loc.mobileNumberVerified
                        : context.loc.mobileNumberNotVerified,
                    style: FontPalette.f131A24_14SemiBold,
                  ),
                  6.verticalSpace,
                  Text(
                    isVerified
                        ? context.loc.contactDetailVerified
                        : context.loc.contactDetailNotVerified,
                    style: FontPalette.f8695A7_12medium,
                  )
                ],
              ))
            ],
          ),
        ),
        33.verticalSpace
      ],
    );
  }
}
