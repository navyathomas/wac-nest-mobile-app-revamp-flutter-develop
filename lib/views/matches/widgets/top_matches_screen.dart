import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/profile_detail_default_model.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_result/profile_short_info_tile.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../error_views/common_error_view.dart';
import '../../search_result/search_result_list_tile.dart';

class TopMatchesTabScreen extends StatefulWidget {
  const TopMatchesTabScreen({Key? key}) : super(key: key);

  @override
  State<TopMatchesTabScreen> createState() => _TopMatchesTabScreenState();
}

class _TopMatchesTabScreenState extends State<TopMatchesTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, matchesProvider, child) {
        return StackLoader(
            inAsyncCall: matchesProvider.loaderState == LoaderState.loading,
            child: _switchView(
                matchesProvider.loaderState,
                matchesProvider,
                context,
                matchesProvider.selectedChildIndex == 0
                    ? matchesProvider.topMatchesNotViewedUserDataList
                    : matchesProvider.topMatchesViewedUserDataList));
      },
    );
  }

  Widget _switchView(LoaderState loaderState, MatchesProvider provider,
      BuildContext context, List<UserData> userDataList) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = userDataList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                isTryAgainVisible: false,
                onTap: () => CommonFunctions.afterInit(() {
                  provider.getMatchesSwitch(context);
                }),
              )
            : _mainView(provider, userDataList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError,
            onTap: () => provider.getMatchesSwitch(context));
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => provider.getMatchesSwitch(context),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => provider.getMatchesSwitch(context),
        );
        break;
      case LoaderState.loading:
        child = userDataList.isEmpty
            ? const SizedBox.shrink()
            : _mainView(provider, userDataList);
        break;
    }
    return child;
  }

  _mainView(MatchesProvider provider, List<UserData> userDataList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
            // loadMore(value, context);
          } else {
            if (!context.isNull) {
              provider.loadMoreSwitch(context);
            }
          }
        }
        return true;
      },
      child: Container(
        color: ColorPalette.pageBgColor,
        height: double.maxFinite,
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(13.w),
                child: Text(
                  context.loc.members(provider.selectedChildIndex == 0
                      ? provider.topMatchesNotViewedRecords
                      : provider.topMatchesViewedRecords),
                  style: FontPalette.f131A24_16ExtraBold,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ProfileInfoListTile(
                onTap: () {
                  NavRoutes.navToProductDetails(
                      context: context,
                      arguments: ProfileDetailArguments(
                          index: index,
                          userData: userDataList[index],
                          navToProfile: NavToProfile.navFromMatches));
                },
                matchPer: double.parse(
                    (userDataList[index].scorePercentage ?? 0)
                        .toStringAsFixed(0)),
                isMale: userDataList[index].isMale,
                imagePath: (userDataList[index].userImage ?? []).isNotEmpty
                    ? userDataList[index].userImage![0].imageFile ?? ''
                    : '',
                child: ProfileShortInfoTile(
                  id: userDataList[index].registerId ?? '',
                  name: userDataList[index].name ?? '',
                  isVerified:
                      userDataList[index].profileVerificationStatus == "1"
                          ? true
                          : false,
                  isPremium: userDataList[index].premiumAccount ?? false,
                  basicDetails: userDataList[index].basicDetails ?? '',
                  address: userDataList[index].address ?? '',
                ),
              );
            }, childCount: userDataList.length)),
            ReusableWidgets.sliverPaginationLoader(provider.paginationLoader)
          ],
        ),
      ),
    );
  }
}
