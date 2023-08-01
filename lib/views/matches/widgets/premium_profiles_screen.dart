import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/profile_detail_default_model.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/search_result/profile_short_info_tile.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../search_result/search_result_list_tile.dart';

class PremiumMatchesScreen extends StatefulWidget {
  const PremiumMatchesScreen({Key? key}) : super(key: key);

  @override
  State<PremiumMatchesScreen> createState() => _PremiumMatchesScreenState();
}

class _PremiumMatchesScreenState extends State<PremiumMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, matchesProvider, _) {
        return StackLoader(
            inAsyncCall: matchesProvider.loaderState == LoaderState.loading,
            child: _switchView(
                matchesProvider.loaderState,
                matchesProvider,
                context,
                matchesProvider.selectedChildIndex == 0
                    ? matchesProvider
                        .premiumProfilesMatchesNotViewedUserDataList
                    : matchesProvider
                        .premiumProfilesMatchesViewedUserDataList));
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

  _mainView(MatchesProvider provider, List<UserData> usrDataList) {
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
                      ? provider.premiumProfilesNotViewedRecords
                      : provider.premiumProfilesViewedRecords),
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
                        userData: usrDataList[index],
                        navToProfile: NavToProfile.navFromMatches),
                  );
                },
                matchPer: double.parse((usrDataList[index].scorePercentage ?? 0)
                    .toStringAsFixed(0)),
                isMale: usrDataList[index].isMale,
                imagePath: (usrDataList[index].userImage ?? []).isNotEmpty
                    ? usrDataList[index].userImage![0].imageFile ?? ''
                    : '',
                child: ProfileShortInfoTile(
                  id: usrDataList[index].registerId ?? '',
                  name: usrDataList[index].name ?? '',
                  isVerified:
                      usrDataList[index].profileVerificationStatus == "1"
                          ? true
                          : false,
                  isPremium: usrDataList[index].premiumAccount ?? false,
                  basicDetails: usrDataList[index].basicDetails ?? '',
                  address: usrDataList[index].address ?? '',
                ),
              );
            }, childCount: usrDataList.length)),
            ReusableWidgets.sliverPaginationLoader(provider.paginationLoader)
          ],
        ),
      ),
    );
  }
}
