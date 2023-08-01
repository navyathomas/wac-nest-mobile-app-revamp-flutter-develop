import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/search_result_filter.dart';
import 'package:nest_matrimony/widgets/common_app_bar.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/profile_detail_default_model.dart';
import '../../models/route_arguments.dart';
import '../../providers/search_filter_provider.dart';
import '../../services/helpers.dart';
import '../../widgets/customRadioTile.dart';
import '../../widgets/profile_image_view.dart';
import 'profile_short_info_tile.dart';
import 'search_result_list_tile.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key, this.isFromSearchId = true})
      : super(key: key);
  final bool isFromSearchId;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late ScrollController controller;
  List<String> sortOptions = [];

  Widget _searchCountTile({int count = 0}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 9.h),
        child: Text(
          context.loc.searchResultsCount(count),
          style: FontPalette.black14SemiBold,
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = ScrollController()
      ..addListener(() {
        if (controller.offset >= (controller.position.maxScrollExtent * 0.5)) {
          context
              .read<SearchFilterProvider>()
              .loadMore(context, fromSearchById: widget.isFromSearchId);
        }
      });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (sortOptions.isEmpty) {
      sortOptions = [
        context.loc.recentlyCreated,
        context.loc.profileRelevancy,
        context.loc.boostedProfiles
      ];
    }
    super.didChangeDependencies();
  }

  Widget switchView(LoaderState loaderState, SearchFilterProvider provider) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = provider.userDataList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                onTap: getData,
              )
            : mainView(provider);
        break;
      case LoaderState.loading:
        child = provider.userDataList.isNotEmpty
            ? mainView(provider)
            : const SizedBox.shrink();
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: getData,
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: getData,
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: getData,
        );
        break;
    }
    return child;
  }

  Widget mainView(SearchFilterProvider value) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        CustomScrollView(
          controller: controller,
          slivers: [
            _searchCountTile(count: value.recordsFiltered),
            value.enableGridView
                ? _SearchGridView(
                    userdataList: value.userDataList,
                    navToProfile: widget.isFromSearchId
                        ? NavToProfile.navFromSearchById
                        : NavToProfile.navFromSearch,
                  )
                : _SearchListView(
                    userdataList: value.userDataList,
                    navToProfile: widget.isFromSearchId
                        ? NavToProfile.navFromSearchById
                        : NavToProfile.navFromSearch,
                  ),
            SliverToBoxAdapter(
              child: value.paginationLoader
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 80.h)),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: _FilterSortTile(
                options: sortOptions,
                onTap: () {
                  CommonFunctions.scrollToTop(controller);
                  getData();
                  context.rootPop;
                },
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.pageBgColor,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: context.loc.searchResults,
        actionList: [
          Selector<SearchFilterProvider, bool>(
            selector: (context, provider) => provider.enableGridView,
            builder: (context, value, child) {
              return IconButton(
                  onPressed: () {
                    context.read<SearchFilterProvider>().updateEnableGridView();
                  },
                  icon: (value
                          ? SvgPicture.asset(Assets.iconsGridView)
                          : SvgPicture.asset(Assets.iconsListView))
                      .animatedSwitch());
            },
          )
        ],
      ),
      body: Consumer<SearchFilterProvider>(
        builder: (context, value, child) {
          return StackLoader(
              inAsyncCall: value.loaderState.isLoading,
              child: switchView(value.loaderState, value));
        },
      ),
    );
  }

  void getData() {
    widget.isFromSearchId
        ? context.read<SearchFilterProvider>().searchById(context)
        : context
            .read<SearchFilterProvider>()
            .advancedSearchRequest(context: context);
  }
}

class _FilterSortTile extends StatelessWidget {
  final List<String>? options;
  final VoidCallback? onTap;
  const _FilterSortTile({
    Key? key,
    this.options,
    this.onTap,
  }) : super(key: key);

  void _sortOnTap(BuildContext context) {
    ReusableWidgets.singleSelectBottomSheet(
        title: context.loc.sortBy,
        context: context,
        child: ListView.builder(
            itemCount: options?.length ?? 0,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
            itemBuilder: (context, index) {
              return Selector<SearchFilterProvider, int>(
                selector: (context, provider) => provider.selectedSortId,
                builder: (context, value, child) {
                  return CustomRadioTile(
                    title: options?[index] ?? '',
                    isSelected: (index + 1) == value,
                    onTap: () {
                      context
                          .read<SearchFilterProvider>()
                          .updateSelectedSortId(index + 1);
                      if (onTap != null) onTap!();
                    },
                  );
                },
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: HexColor('#00000045')),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.r)]),
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _sortOnTap(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.iconsSort,
                      width: 20.w,
                      height: 13.5.h,
                    ),
                    7.horizontalSpace,
                    Text(
                      context.loc.sortBy,
                      style: FontPalette.black13SemiBold
                          .copyWith(color: HexColor('#131A24')),
                    ).flexWrap
                  ],
                ),
              ),
            ).removeSplash(),
          ),
          WidgetExtension.verticalDivider(
              height: 33.h, color: HexColor('#C1C9D2'), width: 1.w),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<SearchFilterProvider>().assignValuesTempToFilter();
                ReusableWidgets.customBottomSheet(
                    context: context, child: const SearchResultFilter());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.iconsFilter,
                      width: 17.5.w,
                      height: 11.5.h,
                    ),
                    7.horizontalSpace,
                    Text(
                      context.loc.filters,
                      style: FontPalette.black13SemiBold
                          .copyWith(color: HexColor('#131A24')),
                    ).flexWrap
                  ],
                ),
              ),
            ).removeSplash(),
          ),
        ],
      ),
    );
  }
}

class _SearchListView extends StatelessWidget {
  const _SearchListView(
      {Key? key, required this.userdataList, required this.navToProfile})
      : super(key: key);
  final List<UserData> userdataList;
  final NavToProfile navToProfile;
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: userdataList.length,
      (context, index) {
        UserData? userData = userdataList[index];
        return ProfileInfoListTile(
          onTap: () => NavRoutes.navToProductDetails(
            context: context,
            arguments: ProfileDetailArguments(
                index: index, userData: userData, navToProfile: navToProfile),
          ),
          imagePath: CommonFunctions.getImage(userData.userImage ?? []),
          isMale: userData.isMale,
          child: ProfileShortInfoTile(
            index: index,
            name: userData.name,
            id: userData.registerId,
            isPremium: userData.premiumAccount ?? false,
            isVerified: (userData.profileVerificationStatus ?? '-1') == '1',
            basicDetails: userData.basicDetails,
            address: (userData.userDistricts?.districtName ?? '').isEmpty
                ? userData.userState?.stateName ?? ''
                : "${userData.userDistricts?.districtName ?? ''}, ${userData.userState?.stateName ?? ''}",
          ),
        );
      },
    ));
  }
}

class _SearchGridView extends StatelessWidget {
  const _SearchGridView(
      {Key? key, required this.userdataList, required this.navToProfile})
      : super(key: key);
  final List<UserData> userdataList;
  final NavToProfile navToProfile;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            UserData? userData = userdataList[index];
            return GestureDetector(
              onTap: () => AppConfig.isAuthorized
                  ? NavRoutes.navToProductDetails(
                      context: context,
                      arguments: ProfileDetailArguments(
                          index: index,
                          userData: userData,
                          navToProfile: navToProfile),
                    )
                  : Navigator.pushNamed(
                      context, RouteGenerator.routePartnerSingleProfileDetail,
                      arguments: RouteArguments(
                          navFrom: NavFrom.navFromSearch,
                          anyValue: ProfileDetailDefaultModel(
                              id: userData.id,
                              userName: userData.name,
                              isMale: userData.isMale,
                              userImage: userData.userImage,
                              nestId: userData.registerId,
                              age: userData.age))),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor('#DBE2EA')),
                    borderRadius: BorderRadius.circular(9.r)),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.r),
                        child: CommonFunctions.getImage(
                                    userData.userImage ?? []) ==
                                null
                            ? ProfileImagePlaceHolder(
                                isMale: userData.isMale,
                                height: 199.h,
                                width: double.maxFinite,
                              )
                            : ProfileImageView(
                                image: CommonFunctions.getImage(
                                        userData.userImage ?? [])
                                    .thumbImagePath(context),
                                isMale: userData.isMale,
                                height: 199.h,
                                width: double.maxFinite,
                                boxFit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 11.h, horizontal: 9.w),
                      child: ProfileShortInfoTile(
                        index: index,
                        name: userData.name,
                        id: userData.registerId,
                        isPremium: userData.premiumAccount ?? false,
                        isVerified:
                            (userData.profileVerificationStatus ?? '-1') == '1',
                        basicDetails: userData.basicDetails,
                        address: (userData.userDistricts?.districtName ?? '')
                                .isEmpty
                            ? userData.userState?.stateName ?? ''
                            : "${userData.userDistricts?.districtName ?? ''}, ${userData.userState?.stateName ?? ''}",
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
          childCount: context.read<SearchFilterProvider>().userDataList.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 9.h,
          crossAxisSpacing: 9.w,
          mainAxisExtent: 360.h + (30 * Helpers.validateScale(context, 0.0)).h,
        ),
      ),
    );
  }
}
