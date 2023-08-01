import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../common/route_generator.dart';
import '../../models/profile_detail_default_model.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../error_views/common_error_view.dart';
import '../search_result/profile_short_info_tile.dart';
import '../search_result/search_result_list_tile.dart';

class MatchesAll extends StatefulWidget {
  final TabController? tabController;
  const MatchesAll({Key? key, this.tabController}) : super(key: key);

  @override
  State<MatchesAll> createState() => _MatchesAllState();
}

class _MatchesAllState extends State<MatchesAll>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: tabController,
      children: List.generate(
        2,
        (index) => MatchTileList(),
      ),
    );
  }

  @override
  void initState() {
    tabController = widget.tabController;
    super.initState();
  }
}

class MatchTileList extends StatelessWidget {
  const MatchTileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, value, child) {
        return StackLoader(
            inAsyncCall: value.loaderState.isLoading,
            child: value.loaderState.isLoading
                ? const SizedBox.shrink()
                : switchView(value.loaderState, value, context));
      },
    );
  }

  Widget switchView(
      LoaderState loaderState, MatchesProvider provider, BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = provider.userDataList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                isTryAgainVisible: false,
                onTap: () => CommonFunctions.afterInit(() {
                  getMatchesList(provider, context);
                }),
              )
            : _mainView(context, provider);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError,
            onTap: () => getMatchesList(provider, context));
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => getMatchesList(provider, context),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => getMatchesList(provider, context),
        );
        break;
      case LoaderState.loading:
        child = provider.userDataList.isEmpty
            ? const SizedBox.shrink()
            : _mainView(context, provider);
        break;
    }
    return child;
  }

  _mainView(BuildContext context, MatchesProvider value) {
    return Container(
      color: ColorPalette.pageBgColor,
      height: double.maxFinite,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              // loadMore(value, context);
            } else {
              loadMore(value, context);
            }
          }
          return true;
        },
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(13.w),
                child: Text(
                  context.loc.members(value.recordsFiltered),
                  style: FontPalette.f131A24_16ExtraBold,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ProfileInfoListTile(
                onTap: () {
                  NavRoutes.navToProductDetails(context: context, arguments: ProfileDetailArguments(
                      index: index,
                      userData: value.userDataList[index],
                      navToProfile: NavToProfile.navFromMatches),);
                },
                matchPer: double.parse(
                    (value.userDataList[index].scorePercentage ?? 0)
                        .toStringAsFixed(0)),
                isMale: value.userDataList[index].isMale,
                imagePath: (value.userDataList[index].userImage ?? [])
                        .isNotEmpty
                    ? value.userDataList[index].userImage![0].imageFile ?? ''
                    : '',
                child: ProfileShortInfoTile(
                  id: value.userDataList[index].registerId ?? '',
                  name: value.userDataList[index].name ?? '',
                  isVerified:
                      value.userDataList[index].profileVerificationStatus == "1"
                          ? true
                          : false,
                  isPremium: value.userDataList[index].premiumAccount ?? false,
                  basicDetails: value.userDataList[index].basicDetails ?? '',
                  address: value.userDataList[index].address ?? '',
                ),
              );
            }, childCount: value.userDataList.length)),
            ReusableWidgets.sliverPaginationLoader(value.paginationLoader)
          ],
        ),
      ),
    );
  }

  getMatchesList(MatchesProvider provider, BuildContext context) {
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

  loadMore(MatchesProvider provider, BuildContext context) {
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
