import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/providers/similar_profiles_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/profile_image_view.dart';

class PartnerSimilarProfiles extends StatelessWidget {
  final Function? onReturn;
  const PartnerSimilarProfiles({Key? key, this.onReturn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Selector<SimilarProfilesProvider,
          Tuple2<List<UserData>?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.userDataList, provider.loaderState),
        builder: (context, value, child) {
          return (value.item2.isLoading
                  ? const _SimilarProfileShimmer()
                  : (value.item1 ?? []).isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetExtension.verticalDivider(
                                height: 4.h,
                                margin: EdgeInsets.only(bottom: 20.h)),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.w, right: 8.w, bottom: 15.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.loc.similarProfiles,
                                      style: FontPalette.f131A24_16Bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final model =
                                          context.read<PartnerDetailProvider>();
                                      Navigator.pushNamed(
                                              context,
                                              RouteGenerator
                                                  .routeSimilarProfiles,
                                              arguments: model
                                                      .partnerDetailModel
                                                      ?.data
                                                      ?.basicDetails
                                                      ?.id ??
                                                  -1)
                                          .then((value) {
                                        if (onReturn != null) onReturn!(true);
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          context.loc.seeAll,
                                          style:
                                              FontPalette.f2995E5_13ExtraBold,
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
                            ),
                            SizedBox(
                              height: 153.h,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    UserData? userData = value.item1?[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                                context,
                                                RouteGenerator
                                                    .routePartnerSimilarProfileDetail,
                                                arguments:
                                                    SimilarProfileDetailArguments(
                                                        index: index,
                                                        usersData: value.item1,
                                                        navToProfile: NavToProfile
                                                            .navFromSimilarProfiles))
                                            .then((value) {
                                          if (onReturn != null) onReturn!(true);
                                        });
                                      },
                                      child: Container(
                                        width: 93.w,
                                        margin: EdgeInsets.only(
                                            left: index == 0 ? 16.w : 0,
                                            right: index == 7 ? 16.0 : 0),
                                        height: double.maxFinite,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.r),
                                              child: CommonFunctions.getImage(
                                                          userData?.userImage ??
                                                              []) ==
                                                      null
                                                  ? ProfileImagePlaceHolder(
                                                      isMale: userData?.isMale,
                                                    )
                                                  : ProfileImageView(
                                                      image: CommonFunctions
                                                              .getImage(userData
                                                                      ?.userImage ??
                                                                  [])
                                                          .thumbImagePath(
                                                              context),
                                                      height: double.maxFinite,
                                                      isMale: userData?.isMale,
                                                    ),
                                            )),
                                            6.verticalSpace,
                                            Text(
                                              userData?.name ?? '',
                                              style: FontPalette
                                                  .f131A24_14SemiBold,
                                            ).avoidOverFlow(),
                                            3.verticalSpace,
                                            Text(
                                              '${userData?.age == null ? '' : '${userData?.age} yrs, '}${userData?.userDistricts?.districtName ?? ''}',
                                              style: FontPalette.black12Medium
                                                  .copyWith(
                                                      color:
                                                          HexColor('#565F6C')),
                                            ).avoidOverFlow()
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) => SizedBox(
                                        width: 11.w,
                                      ),
                                  itemCount: (value.item1?.length ?? 0) > 8
                                      ? 8
                                      : value.item1?.length ?? 0),
                            ),
                            5.verticalSpace,
                          ],
                        ))
              .animatedSwitch();
        },
      ),
    );
  }
}

class _SimilarProfileShimmer extends StatelessWidget {
  const _SimilarProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetExtension.verticalDivider(
            height: 4.h, margin: EdgeInsets.only(bottom: 20.h)),
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 8.w, bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  color: Colors.white,
                  height: 20.h,
                  width: context.sw(size: 0.4),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.white,
                    height: 16.h,
                    width: 40.w,
                  ),
                  10.horizontalSpace,
                  Container(
                    color: Colors.white,
                    height: 32.r,
                    width: 32.r,
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 153.h,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 93.w,
                  margin: EdgeInsets.only(
                      left: index == 0 ? 16.w : 0,
                      right: index == 4 ? 16.0 : 0),
                  height: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            color: Colors.white),
                      )),
                      6.verticalSpace,
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 25.w),
                        height: 18.h,
                      ),
                      3.verticalSpace,
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 10.w),
                        height: 15.h,
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                    width: 11.w,
                  ),
              itemCount: 5),
        ),
        23.verticalSpace,
      ],
    ).addShimmer;
  }
}
