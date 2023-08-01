import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/providers/new_join_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:nest_matrimony/widgets/shimmers/home_header_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../models/profile_search_model.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';
import 'home_header_tile.dart';

class HomeNewJoin extends StatelessWidget {
  const HomeNewJoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<NewJoinProvider, Tuple2<List<UserData>?, LoaderState>>(
          selector: (context, provider) =>
              Tuple2(provider.userDataList, provider.loaderState),
          builder: (context, value, child) {
            return value.item2.isLoading
                ? const _NewJoinShimmer()
                : (value.item1 ?? []).isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          8.verticalSpace,
                          HomeHeaderTile(
                            title: context.loc.newJoin,
                            onTap: () => Navigator.pushNamed(
                                context, RouteGenerator.routeNewJoins),
                          ),
                          7.verticalSpace,
                          ListView.separated(
                            padding: EdgeInsets.only(bottom: 13.h),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (value.item1?.length ?? 0) > 3
                                ? 3
                                : (value.item1?.length ?? 0),
                            itemBuilder: (context, index) {
                              UserData? userData = value.item1?[index];
                              return LayoutBuilder(
                                  builder: (context, constraints) {
                                return InkWell(
                                  onTap: () => NavRoutes.navToProductDetails(
                                    context: context,
                                    arguments: ProfileDetailArguments(
                                        index: index,
                                        userData: userData,
                                        navToProfile:
                                            NavToProfile.navFromNewJoin),
                                  ),
                                  child: Row(
                                    children: [
                                      16.horizontalSpace,
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7.r),
                                          child: CommonFunctions.getImage(
                                                      userData?.userImage ??
                                                          []) ==
                                                  null
                                              ? ProfileImagePlaceHolder(
                                                  isMale: userData?.isMale,
                                                  height: constraints.maxWidth *
                                                      0.23,
                                                  width:
                                                      constraints.maxWidth *
                                                          0.2)
                                              : ProfileImageView(
                                                  image: CommonFunctions.getImage(
                                                          userData?.userImage ??
                                                              [])
                                                      .thumbImagePath(context),
                                                  isMale: userData?.isMale,
                                                  height: constraints.maxWidth *
                                                      0.23,
                                                  width: constraints.maxWidth *
                                                      0.2)),
                                      18.horizontalSpace,
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData?.name ?? '',
                                            style:
                                                FontPalette.f131A24_16SemiBold,
                                          ).avoidOverFlow(),
                                          6.verticalSpace,
                                          Text(
                                            '${userData?.age != null ? '${userData?.age} yrs,' : ''}${userData?.userHeightList?.heightValue != null ? '${Helpers.convertCmToInch(userData!.userHeightList!.heightValue!)}, ' : ''}${userData?.userEducationSubcategory?.eduCategoryTitle != null ? '${userData?.userEducationSubcategory?.eduCategoryTitle}, ' : ''}\n${userData?.userDistricts?.districtName ?? ''}',
                                            style: FontPalette.f565F6C_13Medium,
                                            strutStyle:
                                                StrutStyle(height: 1.4.h),
                                          ).avoidOverFlow(maxLine: 2)
                                        ],
                                      )),
                                      context.sw(size: 0.2).horizontalSpace
                                    ],
                                  ),
                                );
                              });
                            },
                            separatorBuilder: (_, __) => 13.verticalSpace,
                          )
                        ],
                      );
          }),
    );
  }
}

class _NewJoinShimmer extends StatelessWidget {
  const _NewJoinShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.verticalSpace,
        const HomeHeaderShimmer(),
        7.verticalSpace,
        ListView.separated(
          padding: EdgeInsets.only(bottom: 13.h),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Row(
              children: [
                16.horizontalSpace,
                Container(
                  height: context.sw(size: 0.23),
                  width: context.sw(size: 0.2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.r)),
                ),
                18.horizontalSpace,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(right: 50.w),
                      height: 20.h,
                    ),
                    6.verticalSpace,
                    Container(
                      color: Colors.white,
                      height: 15.h,
                    ),
                    4.verticalSpace,
                    Container(
                      color: Colors.white,
                      height: 15.h,
                    ),
                  ],
                )),
                context.sw(size: 0.2).horizontalSpace
              ],
            );
          },
          separatorBuilder: (_, __) => 13.verticalSpace,
        )
      ],
    ).addShimmer;
  }
}
