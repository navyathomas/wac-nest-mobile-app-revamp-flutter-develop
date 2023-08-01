import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../../../common/route_generator.dart';
import 'home_header_tile.dart';

class HomeWidgets {
  static HomeWidgets? _instance;
  static HomeWidgets get instance {
    _instance ??= HomeWidgets();
    return _instance!;
  }

  List<Widget> homeNewJoin(BuildContext context) {
    return [
      SliverPadding(padding: EdgeInsets.only(top: 8.h)),
      SliverToBoxAdapter(
        child: HomeHeaderTile(
          title: context.loc.newJoin,
        ),
      ),
      SliverPadding(padding: EdgeInsets.only(top: 7.h)),
      SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 13.h),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routePartnerProfileDetail),
                        child: Row(
                          children: [
                            16.horizontalSpace,
                            ClipRRect(
                                borderRadius: BorderRadius.circular(7.r),
                                child: Image.asset(Assets.tempModel,
                                    height: constraints.maxWidth * 0.23,
                                    width: constraints.maxWidth * 0.2)),
                            18.horizontalSpace,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anagha',
                                  style: FontPalette.f131A24_16SemiBold,
                                ).avoidOverFlow(),
                                6.verticalSpace,
                                Text(
                                  '24 yrs, 5’4, BSc Chemistry Pathanamthitta.',
                                  style: FontPalette.f565F6C_13Medium,
                                  strutStyle: StrutStyle(height: 1.4.h),
                                ).addEllipsis(maxLine: 2)
                              ],
                            )),
                            context.sw(size: 0.2).horizontalSpace
                          ],
                        ),
                      );
                    }),
                  ),
              childCount: 3))
    ];
  }
}

List<Widget> homeNewJoinShimmer(BuildContext context) {
  return [
    SliverPadding(padding: EdgeInsets.only(top: 8.h)),
    SliverToBoxAdapter(
      child: HomeHeaderTile(
        title: context.loc.newJoin,
      ),
    ),
    SliverPadding(padding: EdgeInsets.only(top: 7.h)),
    SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 13.h),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Row(
                      children: [
                        16.horizontalSpace,
                        ClipRRect(
                            borderRadius: BorderRadius.circular(7.r),
                            child: Image.asset(Assets.tempModel,
                                height: constraints.maxWidth * 0.23,
                                width: constraints.maxWidth * 0.2)),
                        18.horizontalSpace,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anagha',
                              style: FontPalette.f131A24_16SemiBold,
                            ).avoidOverFlow(),
                            6.verticalSpace,
                            Text(
                              '24 yrs, 5’4, BSc Chemistry Pathanamthitta.',
                              style: FontPalette.f565F6C_13Medium,
                              strutStyle: StrutStyle(height: 1.4.h),
                            ).addEllipsis(maxLine: 2)
                          ],
                        )),
                        context.sw(size: 0.2).horizontalSpace
                      ],
                    );
                  }),
                ),
            childCount: 3))
  ];
}

class _ImageCardTile extends StatelessWidget {
  const _ImageCardTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(7.r),
            child: Image.asset(Assets.tempModel))
      ],
    );
  }
}
