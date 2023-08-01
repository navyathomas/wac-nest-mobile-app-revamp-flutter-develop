import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/button_style_model.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/matches/matches_filter.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../common/extensions.dart';
import '../../models/custom_tab_model.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/search_filter_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_tab_indicator.dart';
import '../../utils/font_palette.dart';
import '../../widgets/sticky_tab_bar_delegate.dart';
import '../search_result/search_result_filter/search_result_filter.dart';
import 'filter_matches.dart';
import 'matches_all.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  List<TabController>? subTabControllerList;
  late ScrollController controller;
  late MatchesProvider matchesProvider;
  @override
  Widget build(BuildContext context) {
    final model = context.read<MatchesProvider>();
    return DefaultTabController(
      length: 5,
      child: Selector<MatchesProvider, bool>(
        selector: (p0, p1) => p1.paginationLoader,
        builder: (context, data, child) {
          return NestedScrollView(
            controller: controller,
            physics: const ScrollPhysics(parent: PageScrollPhysics()),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[expandedAppBar(), childTabBar()];
            },
            body: SafeArea(
              child: Stack(children: [
                TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                      model.matchesMenuList(context).length,
                      (index) => model
                          .matchesMenuList(context,
                              tabController:
                                  subTabControllerList![index])[index]
                          .tabBarChild),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    matchesProvider = context.read<MatchesProvider>();
    CommonFunctions.afterInit(() {
      matchesProvider.pageInit();
      context.read<AppDataProvider>().getHeightListData(context);
      matchesProvider.getMatchesList(
          params: {'page': 1, 'length': 20},
          context: context,
          matchesTypes: MatchesTypes.allMatchesNotViewed,
          enableLoader: true);
    });
    controller = ScrollController()
      ..addListener(() {
        if (controller.position.atEdge) {
          bool isTop = controller.position.pixels == 0;
          if (isTop) {
          } else {}
        }
        if (controller.offset >= (controller.position.maxScrollExtent * 0.5)) {
          loadMore(matchesProvider);
        }
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (tabController == null) {
      List<CustomTabModel> customModelList =
          matchesProvider.matchesMenuList(context);
      tabController =
          TabController(length: customModelList.length, vsync: this);
      subTabControllerList = List.generate(
          customModelList.length,
          (index) => TabController(
              length: customModelList[index].tabBarTitles.length, vsync: this));
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (tabController != null) tabController!.dispose();
    if (subTabControllerList != null) {
      for (var ctrl in subTabControllerList!) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  Widget scrolledAppBar(bool isExpanded, List<CustomTabModel> customModelList) {
    return isExpanded
        ? const SizedBox.shrink()
        : Selector<MatchesProvider, int>(
            selector: (context, provider) => provider.selectedIndex,
            builder: (context, value, child) {
              return Theme(
                data: ThemeData().copyWith(
                    splashColor: Colors.white, highlightColor: Colors.white),
                child: TabBar(
                  controller: tabController,
                  labelColor: Colors.black,
                  isScrollable: true,
                  indicatorWeight: 0,
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.transparent,
                  ),
                  onTap: (val) {
                    matchesProvider.updateSelectedIndex(val);
                    matchesProvider.updateSelectedChildIndex(0);
                    matchesProvider.clearPageLoader();
                    subTabControllerList![val].animateTo(0);
                    controller.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastLinearToSlowEaseIn);
                    context.read<MatchesProvider>().clearFilterValues();
                    context.read<MatchesProvider>().resetSliderValues();
                    context.read<MatchesProvider>().userDataList.clear();
                    getMatchesList(matchesProvider);
                  },
                  labelStyle: FontPalette.f131A24_13SemiBold,
                  unselectedLabelColor: Colors.black,
                  tabs: List.generate(
                      customModelList.length,
                      (index) => Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 18.w : 0,
                                right: index == 4 ? 18.w : 8.w),
                            child: Container(
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
                                matchesProvider
                                    .matchesMenuTitleList(context)[index],
                                textAlign: TextAlign.center,
                                style: index == value
                                    ? FontPalette.f131A24_12Medium
                                        .copyWith(color: Colors.white)
                                    : FontPalette.f131A24_12Medium
                                        .copyWith(color: HexColor('#565F6C')),
                              ).avoidOverFlow(maxLine: 2),
                            ),
                          )),
                ),
              );
            },
          );
  }

  Widget expandedAppBar() {
    return SliverAppBar(
      titleSpacing: 0,
      pinned: true,
      snap: false,
      floating: true,
      elevation: 0,
      expandedHeight: context.sw(size: 0.3),
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        bool isExpanded = constraints.maxHeight >
            (kToolbarHeight + MediaQuery.of(context).viewPadding.top);
        final double width = (constraints.maxWidth - 68.w) * 0.28;

        return Selector<MatchesProvider, int>(
          selector: (context, provider) => provider.selectedIndex,
          builder: (context, value, child) {
            final model = context.read<MatchesProvider>();
            return FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.zero,
              title: scrolledAppBar(isExpanded, model.matchesMenuList(context)),
              background: Container(
                height: width * 1.2,
                margin: EdgeInsets.only(top: 9.h, bottom: 4.h),
                child: Theme(
                  data: ThemeData().copyWith(
                      splashColor: Colors.white, highlightColor: Colors.white),
                  child: TabBar(
                    controller: tabController,
                    labelColor: Colors.black,
                    isScrollable: true,
                    indicatorWeight: 0,
                    labelPadding: EdgeInsets.zero,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.transparent,
                    ),
                    onTap: (val) {
                      model.updateSelectedIndex(val);
                      model.updateSelectedChildIndex(0);
                      matchesProvider.clearPageLoader();
                      subTabControllerList![val].animateTo(0);
                      controller.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn);
                      context.read<MatchesProvider>().clearFilterValues();
                      context.read<MatchesProvider>().resetSliderValues();
                      context.read<MatchesProvider>().userDataList.clear();
                      getMatchesList(model);
                    },
                    labelStyle: FontPalette.f131A24_13SemiBold,
                    unselectedLabelColor: Colors.black,
                    tabs: List.generate(
                        model.matchesMenuList(context).length,
                        (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 18.w : 0,
                                  right: index == 4 ? 18.w : 8.w),
                              child: _TabTile(
                                width: width,
                                index: index,
                                isSelected: index == value,
                              ),
                            )),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget childTabBar() {
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
              children: [
                Expanded(
                  child: Selector<MatchesProvider, int>(
                    selector: (context, provider) => provider.selectedIndex,
                    builder: (context, selectedIndex, child) {
                      final model = context.read<MatchesProvider>();
                      return TabBar(
                        controller: subTabControllerList![selectedIndex],
                        labelColor: model.tabSelectedColors[selectedIndex],
                        unselectedLabelColor: HexColor('#565F6C'),
                        labelStyle: FontPalette.f131A24_12Medium,
                        unselectedLabelStyle: FontPalette.f131A24_12Medium,
                        indicatorSize: TabBarIndicatorSize.label,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        indicator: CustomTabIndicator(
                          indicatorHeight: 2.0,
                          color: model.tabSelectedColors[selectedIndex],
                        ),
                        onTap: (val) {
                          matchesProvider.clearPageLoader();
                          model.updateSelectedChildIndex(val);
                          controller.animateTo(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastLinearToSlowEaseIn);
                          context.read<MatchesProvider>().clearFilterValues();
                          context.read<MatchesProvider>().resetSliderValues();
                          context.read<MatchesProvider>().userDataList.clear();
                          getMatchesList(model);
                        },
                        labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
                        isScrollable: true,
                        tabs: <Widget>[
                          ...List.generate(
                              model
                                  .matchesMenuList(context)[selectedIndex]
                                  .tabBarTitles
                                  .length,
                              (index) => Tab(
                                    text: model
                                        .matchesMenuList(context)[selectedIndex]
                                        .tabBarTitles[index],
                                  ))
                        ],
                      );
                    },
                  ),
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

  void moveToNextTab(int index) {
    context.read<MatchesProvider>().updateSelectedIndex(index);
    tabController!.animateTo(index);
  }

  getMatchesList(MatchesProvider provider) {
    switch (provider.selectedIndex) {
      case 0:
        provider.advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: provider.selectedChildIndex == 0
                ? MatchesTypes.allMatchesNotViewed
                : MatchesTypes.allMatchesViewed);
        break;
      case 1:
        provider.advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: provider.selectedChildIndex == 0
                ? MatchesTypes.topMatchesNotViewed
                : MatchesTypes.topMatchesViewed);
        break;
      case 2:
        provider.advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: provider.selectedChildIndex == 0
                ? MatchesTypes.newProfileNotViewed
                : MatchesTypes.newProfileViewed);
        break;
      case 3:
        provider.advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: provider.selectedChildIndex == 0
                ? MatchesTypes.premiumProfilesNotViewed
                : MatchesTypes.premiumProfilesViewed);
        break;
      case 4:
        provider.advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: provider.selectedChildIndex == 0
                ? MatchesTypes.nearByMatchesNotViewed
                : MatchesTypes.nearByMatchesViewed);
        break;
    }
  }

  loadMore(MatchesProvider provider) {
    switch (provider.selectedIndex) {
      case 0:
        provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.allMatchesNotViewed
                : MatchesTypes.allMatchesViewed);
        break;
      case 1:
        provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.topMatchesNotViewed
                : MatchesTypes.topMatchesViewed);
        break;
      case 2:
        provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.newProfileNotViewed
                : MatchesTypes.newProfileViewed);
        break;
      case 3:
        provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.premiumProfilesNotViewed
                : MatchesTypes.premiumProfilesViewed);
        break;
      case 4:
        provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.nearByMatchesNotViewed
                : MatchesTypes.nearByMatchesViewed);
        break;
    }
  }
}

class _TabTile extends StatelessWidget {
  final double width;
  final int index;
  final bool isSelected;

  const _TabTile(
      {Key? key,
      required this.width,
      required this.index,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyleModel buttonStyleModel = context
        .read<MatchesProvider>()
        .matchesMenuList(context)[index]
        .buttonStyleModel;
    return Container(
      height: double.maxFinite,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: HexColor('#F5F5F5'),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: buttonStyleModel.gradiantColor)
              : null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: width * 0.4,
            width: width * 0.4,
            child: SvgPicture.asset(
              buttonStyleModel.icon,
              fit: BoxFit.contain,
              color: isSelected ? Colors.white : HexColor('#565F6C'),
            ),
          ),
          7.verticalSpace,
          Text(buttonStyleModel.title,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? FontPalette.f131A24_12Medium
                          .copyWith(color: Colors.white)
                      : FontPalette.f131A24_12Medium
                          .copyWith(color: HexColor('#565F6C')))
              .avoidOverFlow(maxLine: 2)
        ],
      ),
    );
  }
}
