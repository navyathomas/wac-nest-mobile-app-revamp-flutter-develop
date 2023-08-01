import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';
import 'package:nest_matrimony/widgets/premium_tile.dart';
import 'package:nest_matrimony/widgets/verified_tile.dart';

import '../../models/mail_box_response_model.dart';

class MailBoxProfileCard extends StatelessWidget {
  const MailBoxProfileCard(
      {Key? key, this.bottomTile, this.interestReceivedUserData, this.onTap})
      : super(key: key);
  final Widget? bottomTile;
  final InterestUserData? interestReceivedUserData;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: HexColor('#DBE2EA'))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(9.r),
                //     child: imagePath == null
                //         ? ProfileImagePlaceHolder(
                //       isMale: isMale,
                //       width: 130.w,
                //     )
                //         : ProfileImageView(
                //       image: (imagePath ?? '').thumbImagePath(context),
                //       isMale: isMale,
                //       width: 130.w,
                //       height: double.maxFinite,
                //       boxFit: BoxFit.cover,
                //     )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(11.r),
                  child: CommonImageView(
                    alignment: Alignment.topCenter,
                    image:
                        (interestReceivedUserData?.userDetails?.userImage ?? [])
                                .isNotEmpty
                            ? (interestReceivedUserData?.userDetails!
                                        .userImage![0].imageFile ??
                                    '')
                                .thumbImagePath(context)
                            : '',
                    height: 93.h,
                    width: 79.w,
                    boxFit: BoxFit.cover,
                    errorView: SvgPicture.asset(
                      interestReceivedUserData?.userDetails?.isMale == true
                          ? Assets.iconsMalePlaceHolder
                          : Assets.iconsFemalePlaceHolder,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Row(
                        children: [
                          VerifiedTile(),
                          14.horizontalSpace,
                          interestReceivedUserData
                                      ?.userDetails?.premiumAccount ==
                                  true
                              ? const PremiumTile()
                              : const SizedBox()
                        ],
                      ),
                      5.verticalSpace,
                      Text(
                        interestReceivedUserData?.userDetails?.name ?? '',
                        style: FontPalette.f131A24_15Bold,
                      ).avoidOverFlow(),
                      5.verticalSpace,
                      Text(
                        interestReceivedUserData?.userDetails?.basicDetails ??
                            '',
                        style: FontPalette.f131A24_12Medium,
                        strutStyle: StrutStyle(height: 1.2.h),
                      ).avoidOverFlow(maxLine: 3)
                    ],
                  ),
                )
              ],
            ),
            bottomTile ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
