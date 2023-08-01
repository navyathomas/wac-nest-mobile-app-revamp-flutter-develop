import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/models/custom_tab_model.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/custom_tab_indicator.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../../widgets/sticky_tab_bar_delegate.dart';
import '../matches_filter.dart';

class ChildTabWidget extends StatelessWidget {
  ChildTabWidget(
      {Key? key,
      required this.matchesProvider,
      required this.tabController,
      required this.subTabControllerList})
      : super(key: key);
  final MatchesProvider matchesProvider;
  TabController? tabController;
  List<TabController>? subTabControllerList;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyTabBarDelegate(
          minHeight: 51.h,
          maxHeight: 51.h,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1.h)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<MatchesProvider>(
                  builder: (context, matchesProvider, child) {
                    return Expanded(
                      child: IgnorePointer(
                        ignoring:
                            matchesProvider.loaderState == LoaderState.loading,
                        child: TabBar(
                          controller: subTabControllerList![
                              matchesProvider.selectedIndex],
                          labelColor: matchesProvider
                              .tabSelectedColors[matchesProvider.selectedIndex],
                          unselectedLabelColor: HexColor('#565F6C'),
                          labelStyle: FontPalette.f131A24_12Medium,
                          unselectedLabelStyle: FontPalette.f131A24_12Medium,
                          indicatorSize: TabBarIndicatorSize.label,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          indicator: CustomTabIndicator(
                            indicatorHeight: 2.0,
                            color: matchesProvider.tabSelectedColors[
                                matchesProvider.selectedIndex],
                          ),
                          onTap: (val) async {
                            matchesProvider.clearPageLoader();
                            matchesProvider.updateSelectedChildIndex(val);

                            //matchesProvider.clearFilterValues();
                            // matchesProvider.resetSliderValues();
                            matchesProvider.userDataList.clear();
                            await _getMatchesList(context, matchesProvider);
                            matchesProvider.scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastLinearToSlowEaseIn);
                          },
                          labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
                          isScrollable: true,
                          tabs: <Widget>[
                            ...List.generate(
                                matchesProvider
                                    .matchesMenuList(
                                        context)[matchesProvider.selectedIndex]
                                    .tabBarTitles
                                    .length,
                                (index) => Tab(
                                      text: matchesProvider
                                          .matchesMenuList(context)[
                                              matchesProvider.selectedIndex]
                                          .tabBarTitles[index],
                                    ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    ReusableWidgets.customBottomSheet(
                        context: context, child: const MatchesFilter());
                    //ReusableWidgets.customBottomSheet(context: context, child: FilterMatches());
                  },
                  child: Container(
                      height: 37.w,
                      width: 37.w,
                      margin: EdgeInsets.all(5.r),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.iconsFilter,
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }

  Future<void> _getMatchesList(
      BuildContext context, MatchesProvider provider) async {
    switch (provider.selectedIndex) {
      case 0:
        if (provider.selectedChildIndex == 0) {
          if (provider.allMatchesNotViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.allMatchesNotViewed);
          } else {
            provider.updateUserList(provider.allMatchesNotViewedUserDataList);
          }
        } else if (provider.selectedChildIndex == 1) {
          if (provider.allMatchesViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.allMatchesViewed);
          } else {
            provider.updateUserList(provider.allMatchesViewedUserDataList);
          }
        }
        break;
      case 1:
        if (provider.selectedChildIndex == 0) {
          if (provider.topMatchesNotViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.topMatchesNotViewed);
          } else {
            provider.updateUserList(provider.topMatchesNotViewedUserDataList);
          }
        } else if (provider.selectedChildIndex == 1) {
          if (provider.topMatchesViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.topMatchesViewed);
          } else {
            provider.updateUserList(provider.topMatchesViewedUserDataList);
          }
        }
        break;
      case 2:
        if (provider.selectedChildIndex == 0) {
          if (provider.newProfileMatchesNotViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.newProfileNotViewed);
          } else {
            provider.updateUserList(
                provider.newProfileMatchesNotViewedUserDataList);
          }
        } else if (provider.selectedChildIndex == 1) {
          if (provider.newProfileMatchesViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.newProfileViewed);
          } else {
            provider
                .updateUserList(provider.newProfileMatchesViewedUserDataList);
          }
        }
        break;
      case 3:
        if (provider.selectedChildIndex == 0) {
          if (provider.premiumProfilesMatchesNotViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.premiumProfilesNotViewed);
          } else {
            provider.updateUserList(
                provider.premiumProfilesMatchesNotViewedUserDataList);
          }
        } else if (provider.selectedChildIndex == 1) {
          if (provider.premiumProfilesMatchesViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.premiumProfilesViewed);
          } else {
            provider.updateUserList(
                provider.premiumProfilesMatchesViewedUserDataList);
          }
        }
        break;
      case 4:
        if (provider.selectedChildIndex == 0) {
          if (provider.nearByMatchesNotViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.nearByMatchesNotViewed);
          } else {
            provider
                .updateUserList(provider.nearByMatchesNotViewedUserDataList);
          }
        } else if (provider.selectedChildIndex == 1) {
          if (provider.nearByMatchesViewedUserDataList.isEmpty) {
            await provider.advancedSearchRequest(
                context: context,
                enableLoader: true,
                matchesTypes: MatchesTypes.nearByMatchesViewed);
          } else {
            provider.updateUserList(provider.nearByMatchesViewedUserDataList);
          }
        }
        break;
    }
  }
}
