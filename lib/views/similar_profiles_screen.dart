import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/similar_profiles_provider.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/search_result/profile_short_info_tile.dart';
import 'package:nest_matrimony/views/search_result/search_result_list_tile.dart';
import 'package:nest_matrimony/widgets/network_connectivity.dart';
import 'package:provider/provider.dart';

import '../common/common_functions.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../models/profile_detail_default_model.dart';
import '../models/profile_search_model.dart';
import '../utils/color_palette.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/reusable_widgets.dart';
import '../widgets/shimmers/product_list_shimmer.dart';

class SimilarProfilesScreen extends StatefulWidget {
  final int profileId;
  const SimilarProfilesScreen({Key? key, required this.profileId})
      : super(key: key);

  @override
  State<SimilarProfilesScreen> createState() => _SimilarProfilesScreenState();
}

class _SimilarProfilesScreenState extends State<SimilarProfilesScreen> {
  late final ScrollController scrollController;

  Widget _mainView(List<UserData>? userDataList, {bool isLoading = false}) {
    return RefreshIndicator(
      onRefresh: () => _fetchData(clearData: false),
      child: NetworkConnectivity(
        inAsyncCall: isLoading,
        onTap: () => _fetchData(clearData:  false),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: 16.h),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: userDataList?.length ?? 0,
                (cxt, index) {
                  UserData? userData = userDataList?[index];
                  return ProfileInfoListTile(
                    onTap: () => Navigator.pushNamed(
                            context, RouteGenerator
                        .routePartnerSimilarProfileDetail,
                        arguments:
                        SimilarProfileDetailArguments(
                            index: index,
                            usersData: userDataList,
                            navToProfile: NavToProfile
                                .navFromSimilarProfiles))
                        .then((value) {
                      if(mounted) {
                        context.read<SimilarProfilesProvider>()
                        ..pageInit()
                        ..getSimilarProfiles(widget.profileId);
                      }
                    }),
                    imagePath:
                        CommonFunctions.getImage(userData?.userImage ?? []),
                    isMale: userData?.isMale,
                    child: ProfileShortInfoTile(
                      index: index,
                      name: userData?.name,
                      id: userData?.registerId,
                      isPremium: userData?.premiumAccount ?? false,
                      isVerified:
                          (userData?.profileVerificationStatus ?? '-1') == '1',
                      basicDetails: userData?.basicDetails,
                      address: (userData?.userDistricts?.districtName ?? '')
                              .isEmpty
                          ? userData?.userState?.stateName ?? ''
                          : "${userData?.userDistricts?.districtName ?? ''}, ${userData?.userState?.stateName ?? ''}",
                    ),
                  );
                },
              )),
            ),
            SliverToBoxAdapter(
                child: Selector<SimilarProfilesProvider, bool>(
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
        pageTitle: context.loc.similarProfiles,
      ),
      body: Selector<SimilarProfilesProvider,
          Tuple2<List<UserData>?, LoaderState>>(
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
    CommonFunctions.afterInit(() {});
    super.initState();
  }

  void scrollListener() {
    if (scrollController.offset >=
        (scrollController.position.maxScrollExtent * 0.5)) {
      context.read<SimilarProfilesProvider>().onLoadMore(widget.profileId);
    }
  }

  Future<void> _fetchData({bool clearData = true}) async {
    clearData
        ? context.read<SimilarProfilesProvider>().pageInit()
        : context.read<SimilarProfilesProvider>().initPageCount();
    context
        .read<SimilarProfilesProvider>()
        .getSimilarProfiles(widget.profileId);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
