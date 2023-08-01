import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/profile_detail_default_model.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../widgets/reusable_widgets.dart';
import '../error_views/common_error_view.dart';
import '../search_result/profile_short_info_tile.dart';
import '../search_result/search_result_list_tile.dart';

class MailBoxAddress extends StatelessWidget {
  final TabController? tabController;
  const MailBoxAddress({Key? key, this.tabController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: List.generate(2, (index) => _AddressTileList(index: index)));
  }
}

class _AddressTileList extends StatelessWidget {
  _AddressTileList({Key? key, required this.index}) : super(key: key);
  int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<MailBoxProvider>(
      builder: (context, value, child) {
        return StackLoader(
          inAsyncCall: value.loaderState.isLoading,
          child: Container(
              color: ColorPalette.pageBgColor,
              height: double.maxFinite,
              child: value.loaderState.isLoading
                  ? const SizedBox.shrink()
                  : switchView(
                      value.loaderState,
                      value,
                      context,
                      value.selectedChildIndex == 0
                          ? value.mailBoxInterestAddressViewedDataList
                          : value.mailBoxInterestAddressViewedByMeDataList)),
        );
      },
    );
  }

  switchView(LoaderState loaderState, MailBoxProvider provider,
      BuildContext context, List<InterestUserData> interestUserDataList) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = interestUserDataList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                isTryAgainVisible: false,
                onTap: () => CommonFunctions.afterInit(() {
                  context.read<MailBoxProvider>().getAddressViewedList(context,
                      enableLoader: true,
                      page: 1,
                      length: 10,
                      addressViewedBy: index == 0
                          ? ViewedBy.viewedByOthers
                          : ViewedBy.viewedByMe);
                }),
              )
            : _mainView(context, provider, index, interestUserDataList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => context.read<MailBoxProvider>().getAddressViewedList(
              context,
              enableLoader: true,
              page: 1,
              length: 10,
              addressViewedBy:
                  index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => context.read<MailBoxProvider>().getAddressViewedList(
              context,
              enableLoader: true,
              page: 1,
              length: 10,
              addressViewedBy:
                  index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          isTryAgainVisible: false,
          onTap: () => context.read<MailBoxProvider>().getAddressViewedList(
              context,
              enableLoader: true,
              page: 1,
              length: 10,
              addressViewedBy:
                  index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe),
        );
        break;

      case LoaderState.loading:
        // TODO: Handle this case.
        break;
    }
    return child;
  }

  _mainView(BuildContext context, MailBoxProvider value, int index,
      List<InterestUserData> interestUserDataList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
          } else {
            value.loadChildTabValues(context, false);
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
                value.selectedChildIndex == 0
                    ? context.loc
                        .members(value.interestAddressViewedTotalRecords)
                    : context.loc.profilesInterest(
                        value.interestAddressViewedByMeTotalRecords),
                style: FontPalette.f131A24_16ExtraBold,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return ProfileInfoListTile(
              height: 174.h,
              onTap: () {
                UserDetails? userDetails =
                    interestUserDataList[index].userDetails;
                Navigator.pushNamed(
                    context, RouteGenerator.routePartnerSingleProfileDetail,
                    arguments: RouteArguments(
                        anyValue: ProfileDetailDefaultModel(
                            id: userDetails?.id,
                            userName: userDetails?.name,
                            isMale: userDetails?.isMale,
                            userImage: userDetails?.userImage,
                            nestId: userDetails?.registerId,
                            age: userDetails?.age)));
              },
              imagePath:
                  (interestUserDataList[index].userDetails?.userImage ?? [])
                          .isNotEmpty
                      ? interestUserDataList[index]
                              .userDetails
                              ?.userImage![0]
                              .imageFile ??
                          ''
                      : '',
              isMale: interestUserDataList[index].userDetails?.isMale == true,
              child: ProfileShortInfoTile(
                index: index,
                viewedDate: interestUserDataList[index].viewedDate ?? '',
                address: interestUserDataList[index].userDetails?.address ?? '',
                id: interestUserDataList[index].userDetails?.registerId ?? '',
                basicDetails:
                    interestUserDataList[index].userDetails?.basicDetails ?? '',
                isPremium:
                    interestUserDataList[index].userDetails?.premiumAccount ??
                        false,
                isVerified: interestUserDataList[index]
                            .userDetails
                            ?.profileVerificationStatus ==
                        '1'
                    ? true
                    : false,
                name: interestUserDataList[index].userDetails?.name ?? '',
                userData: interestUserDataList,
              ),
            );
          }, childCount: interestUserDataList.length)),
          ReusableWidgets.sliverPaginationLoader(value.paginationLoader)
        ],
      ),
    );
  }
}
