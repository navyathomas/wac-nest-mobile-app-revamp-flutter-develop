import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/discover_more_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/home_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:provider/provider.dart';

import '../../../../utils/color_palette.dart';
import '../../../providers/search_filter_provider.dart';

class HomeDiscoverMatches extends StatelessWidget {
  const HomeDiscoverMatches({Key? key}) : super(key: key);

  static List<String> icons = [
    Assets.iconsStarTile,
    Assets.iconsEducationTile,
    Assets.iconsProfessionTile,
    Assets.iconsLocationTile,
  ];

  static List<String> listTitles(BuildContext context, {bool? isHindu}) => [
        (isHindu ?? false) == true ? context.loc.star : context.loc.religion,
        context.loc.education,
        context.loc.profession,
        context.loc.city,
      ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<HomeProvider, Tuple2<DiscoverMoreModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.discoverMoreModel, provider.loaderState),
        builder: (context, value, child) {
          double width = context.sw(size: 0.28);

          if (value.item2.isLoading) {
            return const _DiscoverMoreShimmer();
          }
          return value.item1?.data == null
              ? const SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(top: 19.h),
                  padding: EdgeInsets.only(top: 36.h, bottom: 24.h),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [HexColor('#F8D5FF'), HexColor('#FFF0E3')],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.1, 0.4],
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            context.loc.discoverMatches,
                            style: FontPalette.f131A24_19ExtraBold,
                          )),
                      29.verticalSpace,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Selector<AppDataProvider, BasicDetailModel?>(
                          selector: (context, provider) =>
                              provider.basicDetailModel,
                          builder: (context, basicDetails, child) {
                            return Row(
                              children: [
                                _iconTextTile(
                                    index: 0,
                                    width: width,
                                    title: listTitles(context,
                                        isHindu: basicDetails
                                            ?.basicDetail?.isHindu)[0],
                                    subTitle:
                                        value.item1?.data?.religion?.matches !=
                                                null
                                            ? context.loc.matchesCount(value
                                                .item1!
                                                .data!
                                                .religion!
                                                .matches!)
                                            : '',
                                    onTap: () {
                                      context
                                          .read<SearchFilterProvider>()
                                          .updateDiscoverMatchParams(context,
                                              religion: value
                                                  .item1?.data?.religion?.id);
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator.routeSearchResult);
                                    }),
                                _iconTextTile(
                                    index: 1,
                                    width: width,
                                    title: listTitles(context)[1],
                                    subTitle:
                                        value.item1?.data?.education?.matches !=
                                                null
                                            ? context.loc.matchesCount(value
                                                .item1!
                                                .data!
                                                .education!
                                                .matches!)
                                            : '',
                                    onTap: () {
                                      context
                                          .read<SearchFilterProvider>()
                                          .updateDiscoverMatchParams(context,
                                              education: value
                                                  .item1?.data?.education?.id);
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator.routeSearchResult);
                                    }),
                                _iconTextTile(
                                    index: 2,
                                    width: width,
                                    title: listTitles(context)[2],
                                    subTitle: value.item1?.data?.proffesion
                                                ?.matches !=
                                            null
                                        ? context.loc.matchesCount(value
                                            .item1!.data!.proffesion!.matches!)
                                        : '',
                                    onTap: () {
                                      context
                                          .read<SearchFilterProvider>()
                                          .updateDiscoverMatchParams(context,
                                              profession: value
                                                  .item1?.data?.proffesion?.id);
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator.routeSearchResult);
                                    }),
                                _iconTextTile(
                                    index: 3,
                                    width: width,
                                    title: listTitles(context)[3],
                                    subTitle: value
                                                .item1?.data?.city?.matches !=
                                            null
                                        ? context.loc.matchesCount(
                                            value.item1!.data!.city!.matches!)
                                        : '',
                                    onTap: () {
                                      context
                                          .read<SearchFilterProvider>()
                                          .updateDiscoverMatchParams(context,
                                              city:
                                                  value.item1?.data?.city?.id);
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator.routeSearchResult);
                                    }),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _iconTextTile(
      {required int index,
      required double width,
      String? title,
      String? subTitle,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        margin: EdgeInsets.only(
            left: index == 0 ? 8.w : 0, right: index == 3 ? 8.w : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              icons[index],
              height: width * 0.5,
              width: width * 0.5,
            ),
            13.verticalSpace,
            Text(
              title ?? '',
              style: FontPalette.f131A24_16SemiBold,
            ).avoidOverFlow(),
            2.verticalSpace,
            Text(
              subTitle ?? '',
              style: FontPalette.f565F6C_12Medium,
            ).avoidOverFlow()
          ],
        ),
      ),
    );
  }
}

class _DiscoverMoreShimmer extends StatelessWidget {
  const _DiscoverMoreShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = context.sw(size: 0.28);
    return Container(
      margin: EdgeInsets.only(top: 19.h),
      padding: EdgeInsets.only(top: 36.h, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            width: context.sw(size: 0.4),
            color: Colors.white,
            height: 24.h,
          ),
          29.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  4,
                  (int indexVal) => Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        margin: EdgeInsets.only(
                            left: indexVal == 0 ? 8.w : 0,
                            right: indexVal == 3 ? 8.w : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: width * 0.5,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r))),
                            13.verticalSpace,
                            Container(
                              color: Colors.white,
                              height: 20.h,
                              margin: EdgeInsets.only(right: 5.w),
                              width: double.maxFinite,
                            ),
                            2.verticalSpace,
                            Container(
                              height: 15.h,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )),
            ),
          ),
        ],
      ).addShimmer,
    );
  }
}
