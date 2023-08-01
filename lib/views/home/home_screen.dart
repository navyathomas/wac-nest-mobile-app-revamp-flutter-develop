import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/services/widget_handler/home_page_handler.dart';
import 'package:nest_matrimony/widgets/network_connectivity.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../providers/user_viewed_profie_provider.dart';
import '../../widgets/sticky_tab_bar_delegate.dart';
import 'widgets/home_banner.dart';
import 'widgets/home_daily_recommendations.dart';
import 'widgets/home_discover_matches.dart';
import 'widgets/home_interest_recommendations.dart';
import 'widgets/home_new_join.dart';
import 'widgets/home_premium_members.dart';
import 'widgets/home_profile_stat_tile.dart';
import 'widgets/home_recently_viewed.dart';
import 'widgets/home_top_categories.dart';
import 'widgets/home_top_container.dart';
import 'widgets/home_top_matches.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Image banner1;
  late Image banner2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NetworkConnectivity(
      onTap: () => HomePageHandler.instance.fetchHomeApis(context),
      child: Stack(
        children: [
          Container(
            height: 200.h,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                Assets.imagesHomeStatusBg,
              ),
              fit: BoxFit.cover,
            )),
          ),
          NestedScrollView(
            // Setting floatHeaderSlivers to true is required in order to float
            // the outer slivers over the inner scrollable.
            floatHeaderSlivers: true,
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  titleSpacing: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: const HomeTopContainer(),
                  floating: true,
                  expandedHeight: 68.h,
                ),
              ];
            },
            body: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.r),
                    topRight: Radius.circular(22.r)),
                child: Container(
                  color: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        elevation: 1,
                        titleSpacing: 0,
                        shadowColor: Colors.black38,
                        backgroundColor: Colors.white,
                        flexibleSpace: const HomeTopCategories(),
                        floating: true,
                        pinned: true,
                        collapsedHeight: 86.h,
                        expandedHeight: 86.h,
                      ),
                      /*SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyTabBarDelegate(
                          minHeight: 112.h,
                          maxHeight: 112.h,
                          child: const HomeTopCategories(),
                        ),
                      ),*/
                      const HomeDailyRecommendations(),
                      const HomeTopMatches(),
                      const HomeProfileStatTile(),
                      const HomePremiumMembers(),
                      const HomeNewJoin(),
                      const HomeDiscoverMatches(),
                      const HomeInterestRecommendations(),
                      HomeUpgradePlanBanner(
                        image: banner1,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.routePlanSeeAll);
                        },
                      ),
                      const HomeRecentlyViewed(),
                      HomeSuccessStoriesBanner(
                        image: banner2,
                        onTap: () {
                          Navigator.pushNamed(context,
                              RouteGenerator.routeSuccessStoriesScreen);
                        },
                      ),
                      SliverPadding(padding: EdgeInsets.only(top: 20.h)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void initState() {
    banner1 = Image.asset(Assets.imagesUpgradeNow, fit: BoxFit.cover);
    banner2 = Image.asset(Assets.imagesSuccessStories, fit: BoxFit.cover);
    CommonFunctions.afterInit(() {
      context.read<UserViewedProfileProvider>()
        ..pageInit()
        ..getNewProfileViewedData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(banner1.image, context);
    precacheImage(banner2.image, context);
    super.didChangeDependencies();
  }
}
