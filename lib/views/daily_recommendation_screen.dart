import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/providers/daily_recommendation_provider.dart';
import 'package:nest_matrimony/widgets/common_app_bar.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../common/common_functions.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../models/profile_detail_default_model.dart';
import '../models/profile_search_model.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';
import '../widgets/count_down_timer.dart';
import 'search_result/profile_short_info_tile.dart';
import 'search_result/search_result_list_tile.dart';

class DailyRecommendationScreen extends StatefulWidget {
  const DailyRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<DailyRecommendationScreen> createState() =>
      _DailyRecommendationScreenState();
}

class _DailyRecommendationScreenState extends State<DailyRecommendationScreen> {
  late final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.pageBgColor,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: context.loc.dailyRecommendations,
      ),
      body: Consumer<DailyRecommendationProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.5.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: HexColor('#DBE2EA'))),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 2,
                          offset: const Offset(0, 1))
                    ]),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.iconsAlarmClockPrimary,
                      height: 16.r,
                      width: 16.r,
                    ),
                    5.horizontalSpace,
                    CountDownTimer(
                      textStyle: FontPalette.f131A24_13Medium,
                    ),
                    7.horizontalSpace,
                    Expanded(
                      child: Text(
                        context.loc.timeLeftToViewProfiles,
                        style: FontPalette.f131A24_13Medium.copyWith(
                            color: HexColor('#131A24').withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16.h, left: 16.w, right: 16.w, bottom: 13.h),
                      child: Text(
                        context.loc.profile(provider.recordTotals),
                        style: FontPalette.f131A24_16ExtraBold,
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    childCount: provider.userDataList?.length ?? 0,
                    (context, index) {
                      UserData? userData = provider.userDataList?[index];
                      return ProfileInfoListTile(
                        onTap: () {
                          NavRoutes.navToProductDetails(
                              context: context,
                              arguments: ProfileDetailArguments(
                                  index: index,
                                  userData: userData,
                                  navToProfile: NavToProfile.navFromDailyRec));
                        },
                        imagePath:
                            CommonFunctions.getImage(userData?.userImage ?? []),
                        isMale: userData?.isMale,
                        child: ProfileShortInfoTile(
                          index: index,
                          name: userData?.name,
                          id: userData?.registerId,
                          isPremium: userData?.premiumAccount ?? false,
                          isVerified:
                              (userData?.profileVerificationStatus ?? '-1') ==
                                  '1',
                          basicDetails: userData?.basicDetails,
                          address: (userData?.userDistricts?.districtName ?? '')
                                  .isEmpty
                              ? userData?.userState?.stateName ?? ''
                              : "${userData?.userDistricts?.districtName ?? ''}, ${userData?.userState?.stateName ?? ''}",
                        ),
                      );
                    },
                  )),
                  SliverToBoxAdapter(
                      child: ReusableWidgets.paginationLoader(
                          isAsync: provider.paginationLoader)),
                  SliverPadding(padding: EdgeInsets.only(bottom: 16.h))
                ],
              )),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (scrollController.offset >=
        (scrollController.position.maxScrollExtent * 0.5)) {
      context.read<DailyRecommendationProvider>().onLoadMore();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
