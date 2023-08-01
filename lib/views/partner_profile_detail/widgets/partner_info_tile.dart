import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../utils/font_palette.dart';

class PartnerInfo extends StatelessWidget {
  const PartnerInfo({Key? key}) : super(key: key);

  Widget _infoTypeTile({required String icon, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      decoration: BoxDecoration(
          color: ColorPalette.pageBgColor,
          borderRadius: BorderRadius.circular(19.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 19.r,
            width: 19.r,
            fit: BoxFit.contain,
          ),
          6.horizontalSpace,
          Text(
            title,
            style: FontPalette.f131A24_15Bold,
          ).flexWrap
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              BasicDetails? basicDetails = value?.data?.basicDetails;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.partnersInfo(basicDetails?.name ?? 'Partner'),
                    style: FontPalette.f131A24_16Bold,
                  ),
                  18.verticalSpace,
                  Wrap(
                    spacing: 7.w,
                    runSpacing: 12.h,
                    children: [
                      if (basicDetails?.userReligion?.religionName != null)
                        _infoTypeTile(
                            icon: Assets.iconsReligionGrey,
                            title: basicDetails!.userReligion!.religionName!),
                      if (basicDetails?.userCaste?.casteName != null)
                        _infoTypeTile(
                            icon: Assets.iconsCasteGrey,
                            title: basicDetails!.userCaste!.casteName!),
                      if (basicDetails
                          ?.userHeight?.height !=
                          null)
                      _infoTypeTile(
                          icon: Assets.iconsScale, title: basicDetails!.userHeight!.height!),
                      if (basicDetails
                              ?.userEducationSubcategory?.eduCategoryTitle !=
                          null)
                        _infoTypeTile(
                            icon: Assets.iconsBookStore,
                            title: basicDetails!
                                .userEducationSubcategory!.eduCategoryTitle!),
                      if (basicDetails?.userJobSubCategory?.subcategoryName !=
                          null)
                        _infoTypeTile(
                            icon: Assets.iconsSuitcase,
                            title: basicDetails!
                                .userJobSubCategory!.subcategoryName!),
                      if (basicDetails
                              ?.userReligiousInfo?.userStars?.starName !=
                          null)
                        _infoTypeTile(
                            icon: Assets.iconsStarGrey,
                            title: basicDetails!
                                .userReligiousInfo!.userStars!.starName!)
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 24.h, bottom: 17.h))
      ],
    );
  }
}
