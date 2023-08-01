import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../generated/assets.dart';
import '../../../../models/profile_view_model.dart';
import '../../../../providers/partner_detail_provider.dart';
import '../../../../utils/font_palette.dart';
import '../../../partner_profile_detail/widgets/map_view_tile.dart';
import '../../../partner_profile_detail/widgets/partner_category_tile.dart';

class PreviewContactAddress extends StatelessWidget {
  const PreviewContactAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              UserFamilyInfo? userFamilyInfo =
                  value?.data?.basicDetails?.userFamilyInfo;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PartnerCategoryTile(
                    title: context.loc.contactAddress,
                    icon: Assets.iconsTelephone,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      29.verticalSpace,
                      if (value?.data?.basicDetails?.userFamilyInfo
                              ?.houseAddress !=
                          null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: _IconTile(
                            icon: Assets.iconsLinearLocation,
                            titles: [
                              value?.data?.basicDetails?.userFamilyInfo
                                      ?.houseAddress ??
                                  ''
                            ],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: _IconTile(
                          icon: Assets.iconsOutlineMobileGrey,
                          titles: [
                            if (value?.data?.basicDetails?.phoneNo != null)
                              value!.data!.basicDetails!.phoneNo!,
                            value?.data?.basicDetails?.mobile ?? ''
                          ],
                        ),
                      ),
                      if ((value?.data?.basicDetails?.whatsappNo ?? '')
                          .isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 22.h,
                          ),
                          child: _IconTile(
                            icon: Assets.iconsWhatsappGrey,
                            titles: [
                              value!.data!.basicDetails!.whatsappNo!,
                            ],
                          ),
                        ),
                      if (userFamilyInfo?.latitude != 0.0 &&
                          userFamilyInfo?.longitude != 0.0)
                        MapViewTile(
                          latitude: userFamilyInfo?.latitude ?? 0.0,
                          longitude: userFamilyInfo?.longitude ?? 0.0,
                          address:
                              "${(userFamilyInfo?.userLocation?.locationName ?? '').isNotEmpty ? '${userFamilyInfo?.userLocation?.locationName}, ' : ''}${(userFamilyInfo?.userDistrict?.districtName ?? '').isNotEmpty ? '${userFamilyInfo?.userDistrict?.districtName}, ' : ''}${userFamilyInfo?.userState?.stateName ?? ''}",
                        )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  final String icon;
  final List<String> titles;

  const _IconTile({Key? key, required this.icon, required this.titles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 20.r,
          width: 20.r,
        ),
        9.horizontalSpace,
        Expanded(
          child: Wrap(
            runSpacing: 7.h,
            spacing: 7.w,
            children: List.generate(
              titles.length,
              (index) => Text(
                titles[index],
                style: FontPalette.f131A24_14Medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
