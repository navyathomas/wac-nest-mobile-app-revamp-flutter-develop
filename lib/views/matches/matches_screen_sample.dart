import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/views/matches/widgets/all_matches_screen.dart';
import 'package:nest_matrimony/views/matches/widgets/child_tab_widget.dart';
import 'package:nest_matrimony/views/matches/widgets/nearby_matches_screen.dart';
import 'package:nest_matrimony/views/matches/widgets/new_profiles_screen.dart';
import 'package:nest_matrimony/views/matches/widgets/parent_tab_widget.dart';
import 'package:nest_matrimony/views/matches/widgets/premium_profiles_screen.dart';
import 'package:nest_matrimony/views/matches/widgets/top_matches_screen.dart';
import 'package:nest_matrimony/views/top_matches_screen.dart';
import 'package:nest_matrimony/widgets/sticky_tab_bar_delegate.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../generated/assets.dart';
import '../../models/button_style_model.dart';
import '../../models/custom_tab_model.dart';
import '../../models/profile_detail_default_model.dart';
import '../../providers/matches_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_result/profile_short_info_tile.dart';
import '../search_result/search_result_list_tile.dart';
import 'matches_filter.dart';

class MatchesScreenSample extends StatefulWidget {
  const MatchesScreenSample({Key? key}) : super(key: key);

  @override
  State<MatchesScreenSample> createState() => _MatchesScreenSampleState();
}

class _MatchesScreenSampleState extends State<MatchesScreenSample>
    with TickerProviderStateMixin {
  bool isExpand = false;
  TabController? tabController;
  List<TabController>? subTabControllerList;
  @override
  void initState() {
    MatchesProvider matchesProvider = context.read<MatchesProvider>();
    CommonFunctions.afterInit(() {
      matchesProvider.clearValues();
      matchesProvider.pageInit();
      context.read<AppDataProvider>().getHeightListData(context);
      matchesProvider.getMatchesList(
          params: {'page': 1, 'length': 20},
          context: context,
          matchesTypes: MatchesTypes.allMatchesNotViewed,
          enableLoader: true);
    });
    if (matchesProvider.scrollController.hasClients) {
      matchesProvider.scrollController.addListener(() {
        if (matchesProvider.scrollController.offset >=
            (matchesProvider.scrollController.position.maxScrollExtent *
                0.75)) {
          if (!context.isNull) {
            matchesProvider.loadMoreSwitch(context);
          }
        }
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (tabController == null) {
      List<CustomTabModel> customModelList =
          context.read<MatchesProvider>().matchesMenuList(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MatchesProvider>(
        builder: (context, matchesProvider, child) {
          return NestedScrollView(
              physics: const ScrollPhysics(parent: PageScrollPhysics()),
              controller: matchesProvider.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                isExpand = innerBoxIsScrolled;
                return [
                  ParentTabWidget(
                    customModelList: context
                        .read<MatchesProvider>()
                        .matchesMenuList(context),
                    matchesProvider: matchesProvider,
                    subTabControllerList: subTabControllerList,
                  ),
                  ChildTabWidget(
                    matchesProvider: matchesProvider,
                    tabController: tabController,
                    subTabControllerList: subTabControllerList,
                  )
                ];
              },
              body: PageView(
                controller: matchesProvider.pageViewController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  AllMatchesScreen(),
                  TopMatchesTabScreen(),
                  NewProfilesMatchesScreen(),
                  PremiumMatchesScreen(),
                  NearByMatchesScreen()
                ],
              ));
        },
      ),
    );
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
