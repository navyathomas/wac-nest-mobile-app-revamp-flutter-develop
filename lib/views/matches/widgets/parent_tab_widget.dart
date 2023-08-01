import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/button_style_model.dart';
import '../../../models/custom_tab_model.dart';
import '../../../providers/matches_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class ParentTabWidget extends StatelessWidget {
  const ParentTabWidget(
      {Key? key,
      required this.customModelList,
      required this.matchesProvider,
      required this.subTabControllerList})
      : super(key: key);
  final List<CustomTabModel> customModelList;
  final MatchesProvider matchesProvider;
  final List<TabController>? subTabControllerList;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      pinned: true,
      snap: false,
      floating: true,
      elevation: 0,
      toolbarHeight: 35.h,
      expandedHeight: context.sw(size: 0.3),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          bool isExpanded = constraints.maxHeight >
              (kToolbarHeight + MediaQuery.of(context).viewPadding.top);
          final double width = (constraints.maxWidth - 68.w) * 0.28;

          return FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.zero,
              background: Container(
                //height: width,
                margin: EdgeInsets.only(top: 9.h, bottom: 4.h),
                child: Theme(
                  data: ThemeData().copyWith(
                      splashColor: Colors.white, highlightColor: Colors.white),
                  child: ListView.builder(
                    itemCount: customModelList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return _TabTile(
                        width: width,
                        index: index,
                        matchesProvider: matchesProvider,
                        subTabControllerList: subTabControllerList,
                      );
                    },
                  ),
                ),
              ),
              title: (isExpanded
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      itemCount: customModelList.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Selector<MatchesProvider, int>(
                          selector: (context, matchesProvider) =>
                              matchesProvider.selectedIndex,
                          builder: (context, value, child) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10.w : 0,
                                  right: index == 4 ? 18.w : 8.w),
                              child: InkWell(
                                onTap: () {
                                  matchesProvider.updateSelectedIndex(index);
                                  matchesProvider.pageViewController
                                      .animateToPage(index,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.linearToEaseOut);
                                  matchesProvider.scrollController.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.fastLinearToSlowEaseIn);
                                  subTabControllerList![index].animateTo(0);
                                  matchesProvider.updateSelectedChildIndex(0);
                                  matchesProvider.clearPageLoader();
                                  // matchesProvider.clearFilterValues();
                                  //matchesProvider.resetSliderValues();
                                  matchesProvider.userDataList.clear();
                                  _getMatchesList(context, matchesProvider);
                                },
                                child: Container(
                                  height: 30.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: HexColor('#F5F5F5'),
                                      gradient: index == value
                                          ? LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: customModelList[index]
                                                  .buttonStyleModel
                                                  .gradiantColor)
                                          : null),
                                  child: Text(
                                    context
                                        .read<MatchesProvider>()
                                        .matchesMenuTitleList(context)[index],
                                    textAlign: TextAlign.center,
                                    style: index == value
                                        ? FontPalette.f131A24_12Medium
                                            .copyWith(color: Colors.white)
                                        : FontPalette.f131A24_12Medium.copyWith(
                                            color: HexColor('#565F6C')),
                                  ).avoidOverFlow(maxLine: 2),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )));
        },
      ),
    );
  }

  _getMatchesList(BuildContext context, MatchesProvider provider) {
    switch (provider.selectedIndex) {
      case 0:
        if (provider.allMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.allMatchesNotViewed
                  : MatchesTypes.allMatchesViewed);
        }
        break;
      case 1:
        if (provider.topMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.topMatchesNotViewed
                  : MatchesTypes.topMatchesViewed);
        }
        break;
      case 2:
        if (provider.newProfileMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.newProfileNotViewed
                  : MatchesTypes.newProfileViewed);
        }
        break;
      case 3:
        if (provider.premiumProfilesMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.premiumProfilesNotViewed
                  : MatchesTypes.premiumProfilesViewed);
        }
        break;
      case 4:
        if (provider.nearByMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.nearByMatchesNotViewed
                  : MatchesTypes.nearByMatchesViewed);
        }
        break;
    }
  }
}

class _TabTile extends StatelessWidget {
  final double width;
  final int index;
  final MatchesProvider matchesProvider;
  final List<TabController>? subTabControllerList;
  const _TabTile(
      {Key? key,
      required this.width,
      required this.index,
      required this.matchesProvider,
      required this.subTabControllerList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyleModel buttonStyleModel = context
        .read<MatchesProvider>()
        .matchesMenuList(context)[index]
        .buttonStyleModel;
    return Padding(
      padding: EdgeInsets.only(
          left: index == 0 ? 10.w : 0, right: index == 4 ? 18.w : 8.w),
      child: Selector<MatchesProvider, int>(
        selector: (context, matchesProvider) => matchesProvider.selectedIndex,
        builder: (context, value, child) {
          return InkWell(
            onTap: () {
              matchesProvider.updateSelectedIndex(index);
              matchesProvider.pageViewController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linearToEaseOut);
              matchesProvider.scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastLinearToSlowEaseIn);
              subTabControllerList![index].animateTo(0);
              matchesProvider.updateSelectedChildIndex(0);
              matchesProvider.clearPageLoader();
              //matchesProvider.clearFilterValues();
              //matchesProvider.resetSliderValues();
              matchesProvider.userDataList.clear();
              _getMatchesList(context, matchesProvider);
            },
            child: Container(
              height: double.maxFinite,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: HexColor('#F5F5F5'),
                  gradient: index == value
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: buttonStyleModel.gradiantColor)
                      : null),
              child: LayoutBuilder(
                  builder: (context, contraints) {
                    print(contraints.maxWidth);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: width * 0.4,
                        width: width * 0.4,
                        child: SvgPicture.asset(
                          buttonStyleModel.icon,
                          fit: BoxFit.contain,
                          color:
                              index == value ? Colors.white : HexColor('#565F6C'),
                        ),
                      ),
                      7.verticalSpace,
                      Text(buttonStyleModel.title,
                              textAlign: TextAlign.center,
                              style: index == value
                                  ? FontPalette.f131A24_12Medium
                                      .copyWith(color: Colors.white)
                                  : FontPalette.f131A24_12Medium
                                      .copyWith(color: HexColor('#565F6C')))
                          .avoidOverFlow(maxLine: 2)
                    ],
                  );
                }
              ),
            ),
          );
        },
      ),
    );
  }

  _getMatchesList(BuildContext context, MatchesProvider provider) {
    switch (provider.selectedIndex) {
      case 0:
        if (provider.allMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.allMatchesNotViewed
                  : MatchesTypes.allMatchesViewed);
        }
        break;
      case 1:
        if (provider.topMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.topMatchesNotViewed
                  : MatchesTypes.topMatchesViewed);
        }
        break;
      case 2:
        if (provider.newProfileMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.newProfileNotViewed
                  : MatchesTypes.newProfileViewed);
        }
        break;
      case 3:
        if (provider.premiumProfilesMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.premiumProfilesNotViewed
                  : MatchesTypes.premiumProfilesViewed);
        }
        break;
      case 4:
        if (provider.nearByMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: provider.selectedChildIndex == 0
                  ? MatchesTypes.nearByMatchesNotViewed
                  : MatchesTypes.nearByMatchesViewed);
        }
        break;
    }
  }
}
