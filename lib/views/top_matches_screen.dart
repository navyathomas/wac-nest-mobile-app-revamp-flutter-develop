import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/providers/top_matches_provider.dart';
import 'package:nest_matrimony/views/search_result/search_result_list_tile.dart';
import 'package:provider/provider.dart';

import '../common/common_functions.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../models/profile_detail_default_model.dart';
import '../models/profile_search_model.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/reusable_widgets.dart';
import 'search_result/profile_short_info_tile.dart';

class TopMatchesScreen extends StatefulWidget {
  const TopMatchesScreen({Key? key}) : super(key: key);

  @override
  State<TopMatchesScreen> createState() => _TopMatchesScreenState();
}

class _TopMatchesScreenState extends State<TopMatchesScreen> {
  late final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.pageBgColor,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: context.loc.topMatches,
      ),
      body: Consumer<TopMatchesProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 16.h, left: 16.w, right: 16.w, bottom: 13.h),
                  child: Text(
                    context.loc.profile(provider.recordTotals),
                    style: FontPalette.f131A24_16ExtraBold,
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: provider.userDataList?.length ?? 0,
                (context, index) {
                  UserData? userData = provider.userDataList?[index];
                  return ProfileInfoListTile(
                    onTap: () => NavRoutes.navToProductDetails(
                      context: context,
                      arguments: ProfileDetailArguments(
                          index: index,
                          userData: userData,
                          navToProfile: NavToProfile.navFromTopMatches),
                    ),
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
              SliverToBoxAdapter(
                  child: ReusableWidgets.paginationLoader(
                      isAsync: provider.paginationLoader)),
              SliverPadding(padding: EdgeInsets.only(bottom: 16.h))
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (scrollController.offset >=
        (scrollController.position.maxScrollExtent * 0.5)) {
      context.read<TopMatchesProvider>().onLoadMore();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
