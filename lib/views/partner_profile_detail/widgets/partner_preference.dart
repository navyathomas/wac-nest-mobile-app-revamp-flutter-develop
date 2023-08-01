import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../widgets/circular_percentage_indicator.dart';
import '../../account/profile/preview_profile/preview_verified_taq.dart';
import 'partner_category_tile.dart';
import 'partner_key_value_tile.dart';

class PartnerPreference extends StatelessWidget {
  final bool enableMatchScore;
  final bool enableIcon;
  final EdgeInsets? padding;
  const PartnerPreference(
      {Key? key,
      this.enableMatchScore = true,
      this.enableIcon = true,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetExtension.verticalDivider(
          height: 3.h,
        ),
        if (AppConfig.isAuthorized && enableMatchScore) const _MatchScoreCard(),
        Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              UserPartnerPreference? userPartnerPreference =
                  value?.data?.userPartnerPreference;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (AppConfig.isAuthorized && !enableMatchScore)
                    PreviewVerifiedTag(
                      isVerified: (value?.data?.basicDetails
                                  ?.profileVerificationStatus ??
                              '') ==
                          '1',
                    ),
                  PartnerCategoryTile(
                    title: context.loc.partnerPreference,
                    icon: Assets.iconsHeartTick,
                  ),
                  15.verticalSpace,
                  Text(
                    context.loc.basicDetails,
                    style: FontPalette.f8695A7_14Bold,
                  ),
                  17.verticalSpace,
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.fromAge?.age),
                    leading: context.loc.partnersAgeFrom,
                    trailing: '${userPartnerPreference?.fromAge?.age ?? '---'}',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.toAge?.age),
                    leading: context.loc.partnersAgeTo,
                    trailing: '${userPartnerPreference?.toAge?.age ?? '---'}',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.fromHeight?.height),
                    leading: context.loc.partnersHeightFrom,
                    trailing:
                        userPartnerPreference?.fromHeight?.height ?? '---',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.toHeight?.height),
                    leading: context.loc.partnersHeightTo,
                    trailing: userPartnerPreference?.toHeight?.height ?? '---',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.bodyTypesUnserialize),
                    leading: context.loc.bodyType,
                    trailing:
                        userPartnerPreference?.bodyTypesUnserialize?.join(", "),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.maritalStatusUnserialize),
                    leading: context.loc.maritalStatus,
                    trailing: userPartnerPreference?.maritalStatusUnserialize
                        ?.join(", "),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class _MatchScoreCard extends StatelessWidget {
  const _MatchScoreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 7.w),
      padding: EdgeInsets.symmetric(vertical: 21.h, horizontal: 23.w),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.r),
          gradient: LinearGradient(
              colors: [HexColor('#950053'), HexColor('#FF906F')])),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.sw(size: 0.03)),
            child: Text(
              context.loc.seeHowWellUrProfileMatches,
              textAlign: TextAlign.center,
              style: FontPalette.white16Bold,
            ),
          ),
          17.verticalSpace,
          SizedBox(
            height: 65.h,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Selector<AppDataProvider, BasicDetailModel?>(
                  selector: (context, provider) => provider.basicDetailModel,
                  builder: (context, value, child) {
                    return ClipOval(
                      child: ProfileImageView(
                        image: value?.basicDetail?.profileImage?.imageFile
                                ?.thumbImagePath(context) ??
                            '',
                        isMale: value?.basicDetail?.isMale,
                        height: 65.r,
                        width: 65.r,
                        boxFit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.r),
                        gradient: const LinearGradient(
                            colors: [Colors.white54, Colors.white])),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Transform.translate(
                              offset: Offset(-10.w, 0),
                              child: Selector<PartnerDetailProvider,
                                  List<ProfileDetailDefaultModel>>(
                                selector: (context, provider) =>
                                    provider.defaultProfiles,
                                builder: (context, value, child) {
                                  ProfileDetailDefaultModel? model =
                                      value.isEmpty
                                          ? null
                                          : value[value.length - 1];
                                  return ClipOval(
                                    child: ProfileImageView(
                                      image: CommonFunctions.getImage(
                                              model?.userImage)
                                          .thumbImagePath(context),
                                      isMale: model?.isMale,
                                      height: 65.r,
                                      width: 65.r,
                                      boxFit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                                child: Center(
                              child: Text(
                                context.loc.matchScore,
                                style: FontPalette.f131A24_17SemiBold,
                              ).addEllipsis(maxLine: 2),
                            )),
                            Container(
                              height: 65.r,
                              width: 65.r,
                              padding: EdgeInsets.all(8.r),
                              child: Selector<PartnerDetailProvider,
                                  PartnerDetailModel?>(
                                selector: (context, provider) =>
                                    provider.partnerDetailModel,
                                builder: (context, partnerModel, child) {
                                  return CircularPercentageIndicator(
                                    percentage:
                                        (partnerModel?.data?.matchPercentage ??
                                            0.0),
                                    enableAnimation: false,
                                    onChange: (value) => FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            ' ${(partnerModel?.data?.matchPercentage ?? 0.0).ceil()}',
                                            style: FontPalette.f131A24_13Bold,
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
                        ),
                        Positioned(
                          top: 0,
                          left: 27.5.w,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: SvgPicture.asset(
                                  Assets.iconsHeartRounded,
                                  height: 45.r,
                                  width: 45.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
