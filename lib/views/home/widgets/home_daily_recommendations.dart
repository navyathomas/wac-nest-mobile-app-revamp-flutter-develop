import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/profile_detail_default_model.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/count_down_timer.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

import '../../../providers/daily_recommendation_provider.dart';

class HomeDailyRecommendations extends StatelessWidget {
  const HomeDailyRecommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Selector<DailyRecommendationProvider,
            Tuple2<List<UserData>?, LoaderState>>(
      selector: (context, provider) =>
          Tuple2(provider.userDataList, provider.loaderState),
      builder: (context, value, child) {
        return value.item2.isLoading
            ? const _DailyRecShimmer()
            : (value.item1 ?? []).isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    margin: EdgeInsets.symmetric(horizontal: 7.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13.r),
                        gradient: LinearGradient(colors: [
                          HexColor('#FFF0E3'),
                          HexColor('#F8D5FF')
                        ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          9.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.loc.dailyRecommendations,
                                  style: FontPalette.f131A24_18ExtraBold,
                                ),
                                6.verticalSpace,
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.iconsClockPink,
                                      height: 12.r,
                                      width: 12.r,
                                    ),
                                    5.horizontalSpace,
                                    CountDownTimer(
                                      textStyle: FontPalette.f131A24_12Medium,
                                    ),
                                    7.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        context.loc.timeLeftToViewProfiles,
                                        style: FontPalette.f131A24_12Medium
                                            .copyWith(
                                                color: HexColor('#131A24')
                                                    .withOpacity(0.7)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  RouteGenerator.routeDailyRecommendations);
                            },
                            child: Container(
                              height: 32.r,
                              width: 32.r,
                              margin: EdgeInsets.all(13.r),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 10.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: SvgPicture.asset(
                                Assets.iconsChevronRight,
                                height: double.maxFinite,
                                width: double.maxFinite,
                              ),
                            ),
                          )
                        ]),
                        12.verticalSpace,
                        _ProfileListView(
                          originalData: value.item1 ?? [],
                        ),
                        7.verticalSpace
                      ],
                    ),
                  );
      },
    ));
  }
}

class _ProfileListView extends StatelessWidget {
  final List<UserData> originalData;
  const _ProfileListView({Key? key, required this.originalData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      child: LayoutBuilder(builder: (context, constraints) {
        double width = (constraints.maxWidth / 4).w - 27.w;
        double height = width + (width * 0.85);
        return SizedBox(
          height: height,
          child: GridView.builder(
              itemCount: originalData.length > 4 ? 4 : originalData.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 9.w,
                  mainAxisExtent: height),
              itemBuilder: (context, index) {
                UserData? data = originalData[index];
                return GestureDetector(
                  onTap: () {
                    NavRoutes.navToProductDetails(
                        context: context,
                        arguments: ProfileDetailArguments(
                            index: index,
                            userData: data,
                            navToProfile: NavToProfile.navFromDailyRec));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.r),
                                border: Border.all(
                                    color:
                                        HexColor('#950053').withOpacity(0.07),
                                    width: 1.3.r)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7.r),
                              child: CommonFunctions.getImage(
                                          data.userImage ?? []) ==
                                      null
                                  ? ProfileImagePlaceHolder(
                                      isMale: data.isMale,
                                    )
                                  : ProfileImageView(
                                      image: CommonFunctions.getImage(
                                              data.userImage ?? [])
                                          .thumbImagePath(context),
                                      isMale: data.isMale,
                                      boxFit: BoxFit.cover,
                                    ),
                            )),
                      ),
                      6.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          data.name ?? '',
                          style: FontPalette.f131A24_13SemiBold,
                          textAlign: TextAlign.center,
                        ).avoidOverFlow(),
                      )
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}

class _DailyRecShimmer extends StatelessWidget {
  const _DailyRecShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            9.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    height: 23.h,
                    width: context.sw(size: 0.5),
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 16.h,
                        width: 16.h,
                      ),
                      5.horizontalSpace,
                      Container(
                        color: Colors.white,
                        height: 16.h,
                        width: context.sw(size: 0.15),
                      ),
                      7.horizontalSpace,
                      Container(
                        color: Colors.white,
                        height: 16.h,
                        width: context.sw(size: 0.35),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 32.r,
              width: 32.r,
              margin: EdgeInsets.all(13.r),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            )
          ]),
          12.verticalSpace,
          const _GridShimmer(),
          7.verticalSpace
        ],
      ).addShimmer,
    );
  }
}

class _GridShimmer extends StatelessWidget {
  const _GridShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = ((context.sw() - 32.w) / 4).w - 27.w;
    double height = width + (width * 0.85);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      child: SizedBox(
        height: height,
        child: GridView.builder(
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 9.w,
                mainAxisExtent: height),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.r),
                          color: Colors.white),
                    ),
                  ),
                  6.verticalSpace,
                  Container(
                    color: Colors.red,
                    height: 17.h,
                    width: double.maxFinite,
                  )
                ],
              ).addShimmer;
            }),
      ),
    );
  }
}
