import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/providers/interest_received_provider.dart';
import 'package:nest_matrimony/views/search_result/profile_short_info_tile.dart';
import 'package:nest_matrimony/views/search_result/search_result_list_tile.dart';
import 'package:provider/provider.dart';

import '../common/common_functions.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../models/profile_detail_default_model.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';
import '../utils/tuple.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/network_connectivity.dart';
import '../widgets/reusable_widgets.dart';
import '../widgets/shimmers/product_list_shimmer.dart';
import 'error_views/common_error_view.dart';

class InterestRecommendationScreen extends StatefulWidget {
  const InterestRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<InterestRecommendationScreen> createState() =>
      _InterestRecommendationScreenState();
}

class _InterestRecommendationScreenState
    extends State<InterestRecommendationScreen> {
  late final ScrollController scrollController;

  Widget _mainView(List<InterestUserData>? userDataList,
      {bool isLoading = false}) {
    return RefreshIndicator(
      onRefresh: () => _fetchData(clearData: false),
      child: NetworkConnectivity(
        inAsyncCall: isLoading,
        onTap: () => _fetchData(clearData: false),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 16.h, left: 16.w, right: 16.w, bottom: 13.h),
                child: Selector<InterestRecievedProvider, int>(
                  selector: (context, provider) => provider.recordTotals,
                  builder: (context, value, child) {
                    return Text(
                      context.loc.profile(value),
                      style: FontPalette.f131A24_16ExtraBold,
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 16.h),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: userDataList?.length ?? 0,
                (context, index) {
                  InterestUserData? userData = userDataList?[index];
                  return ProfileInfoListTile(
                    onTap: () => NavRoutes.navToProductDetails(
                      context: context,
                      arguments: ProfileDetailArguments(
                          index: index,
                          navToProfile:
                              NavToProfile.navFromInterestRecommendations),
                    ),
                    imagePath: CommonFunctions.getImage(
                        userData?.userDetails?.userImage ?? []),
                    isMale: userData?.userDetails?.isMale,
                    child: ProfileShortInfoTile(
                      index: index,
                      name: userData?.userDetails?.name,
                      id: userData?.userDetails?.registerId,
                      isPremium: userData?.userDetails?.premiumAccount ?? false,
                      isVerified:
                          (userData?.userDetails?.profileVerificationStatus ??
                                  '-1') ==
                              '1',
                      basicDetails: userData?.userDetails?.basicDetails,
                      address: (userData?.userDetails?.userDistricts
                                      ?.districtName ??
                                  '')
                              .isEmpty
                          ? userData?.userDetails?.userState?.stateName ?? ''
                          : "${userData?.userDetails?.userDistricts?.districtName ?? ''}, ${userData?.userDetails?.userState?.stateName ?? ''}",
                    ),
                  );
                },
              )),
            ),
            SliverToBoxAdapter(
                child: Selector<InterestRecievedProvider, bool>(
              selector: (context, provider) => provider.paginationLoader,
              builder: (context, value, child) {
                return ReusableWidgets.paginationLoader(isAsync: value);
              },
            )),
            SliverPadding(padding: EdgeInsets.only(bottom: 16.h))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.pageBgColor,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: context.loc.interestRecommendations,
      ),
      body: Selector<InterestRecievedProvider,
          Tuple2<List<InterestUserData>?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.userDataList, provider.loaderState),
        builder: (context, value, child) {
          switch (value.item2) {
            case LoaderState.loaded:
              return value.item1 == null
                  ? const SizedBox.shrink()
                  : _mainView(value.item1, isLoading: value.item2.isLoading);
            case LoaderState.loading:
              return value.item1 == null
                  ? const ProductListingShimmer()
                  : _mainView(value.item1, isLoading: value.item2.isLoading);
            case LoaderState.error:
              return CommonErrorView(
                error: Errors.serverError,
                onTap: () {
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name != null
                        ? route.settings.name == RouteGenerator.routeMainScreen
                        : true;
                  });
                },
              );
            case LoaderState.networkErr:
              return CommonErrorView(
                error: Errors.networkError,
                onTap: () {
                  _fetchData();
                },
              );
            case LoaderState.noData:
              return CommonErrorView(
                error: Errors.noDatFound,
                onTap: () {
                  _fetchData();
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    CommonFunctions.afterInit(() {
      _fetchData();
    });
    super.initState();
  }

  void scrollListener() {
    if (scrollController.offset >=
        (scrollController.position.maxScrollExtent * 0.5)) {
      context.read<InterestRecievedProvider>().onLoadMore();
    }
  }

  Future<void> _fetchData({bool clearData = true}) async {
    clearData
        ? context.read<InterestRecievedProvider>().pageInit()
        : context.read<InterestRecievedProvider>().initPageCount();
    context.read<InterestRecievedProvider>().getInterestReceivedData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
