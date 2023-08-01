import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/circular_percentage_indicator.dart';

class PartnerDetailAddressCard extends StatelessWidget {
  const PartnerDetailAddressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerDetailProvider,
        Tuple2<PartnerDetailModel?, LoaderState>>(
      selector: (context, provider) =>
          Tuple2(provider.partnerDetailModel, provider.loaderState),
      builder: (context, value, child) {
        return value.item2.isLoading || value.item1 == null
            ? const _CardAddressTileShimmer()
            : Expanded(
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  6.horizontalSpace,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.iconsLocationGrey,
                              width: 11.w,
                              height: 15.h,
                            ),
                            7.horizontalSpace,
                            Text(
                              value.item1?.data?.basicDetails?.userFamilyInfo
                                      ?.userDistrict?.districtName ??
                                  'Unknown',
                              style: FontPalette.f131A24_17SemiBold,
                            ).flexWrap,
                          ],
                        ),
                        2.verticalSpace,
                        Padding(
                          padding: EdgeInsets.only(left: 18.w),
                          child: Row(
                            children: [
                              Text(
                                value.item1?.data?.basicDetails?.userFamilyInfo
                                        ?.userState?.stateName ??
                                    '',
                                style: FontPalette.white13SemiBold
                                    .copyWith(color: HexColor('#858C95')),
                              ).flexWrap
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  6.horizontalSpace,
                  if (AppConfig.isAuthorized)
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: 16.w, right: 8.w, top: 7.h, bottom: 7.h),
                        decoration: BoxDecoration(
                            color: ColorPalette.pageBgColor,
                            borderRadius: BorderRadius.circular(19.r)),
                        child: Row(
                          children: [
                            Text(
                              context.loc.match,
                              style: FontPalette.black15SemiBold
                                  .copyWith(color: HexColor('#565F6C')),
                            ),
                            11.horizontalSpace,
                            SizedBox(
                              height: 41.h,
                              width: 41.w,
                              child: Selector<PartnerDetailProvider,
                                  PartnerDetailModel?>(
                                selector: (context, provider) =>
                                    provider.partnerDetailModel,
                                builder: (context, partnerModel, child) {
                                  return CircularPercentageIndicator(
                                    percentage:
                                        (partnerModel?.data?.matchPercentage ??
                                            0.0),
                                    onChange: (value) => FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            ' ${(partnerModel?.data?.matchPercentage ?? 0.0).ceil()}',
                                            style: FontPalette.f131A24_12Bold,
                                          ),
                                          Text(
                                            "%",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700,
                                              color: HexColor('#131A24'),
                                              fontFeatures: const [
                                                FontFeature.enable('sups'),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ))
                ],
              ));
      },
    );
  }
}

class _CardAddressTileShimmer extends StatelessWidget {
  const _CardAddressTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          6.horizontalSpace,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 11.w,
                      height: 15.h,
                      color: Colors.white,
                    ),
                    7.horizontalSpace,
                    Container(
                      color: Colors.white,
                      height: 22.h,
                      width: context.sw(size: 0.3),
                    ),
                  ],
                ),
                2.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 17.h,
                        width: context.sw(size: 0.2),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          6.horizontalSpace,
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 16.w, right: 8.w, top: 7.h, bottom: 7.h),
              decoration: BoxDecoration(
                  color: ColorPalette.pageBgColor,
                  borderRadius: BorderRadius.circular(19.r)),
              child: Row(
                children: [
                  SizedBox(
                    width: 40.w,
                  ),
                  11.horizontalSpace,
                  SizedBox(
                    height: 41.h,
                    width: 41.w,
                  )
                ],
              ))
        ],
      ).addShimmer,
    );
  }
}
