import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../common/route_generator.dart';
import '../../models/mail_box_response_model.dart';
import '../../models/profile_detail_default_model.dart';
import '../../utils/font_palette.dart';
import '../../widgets/reusable_widgets.dart';
import '../error_views/common_error_view.dart';
import '../search_result/profile_short_info_tile.dart';
import '../search_result/search_result_list_tile.dart';

class MailBoxShortList extends StatefulWidget {
  TabController? tabController;
  MailBoxShortList({Key? key, this.tabController}) : super(key: key);

  @override
  State<MailBoxShortList> createState() => _MailBoxShortListState();
}

class _MailBoxShortListState extends State<MailBoxShortList>
    with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: context.read<MailBoxProvider>().childTabControllerIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget.tabController,
        children: List.generate(2, (index) => ViewedShortList(index: index)));
  }
}

class ViewedShortList extends StatelessWidget {
  int index;
  ViewedShortList({Key? key, required this.index}) : super(key: key);

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
                          ? value.mailBoxInterestShortListViewedDataList
                          : value.mailBoxInterestShortListViewedByMeDataList)),
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
                  context.read<MailBoxProvider>().getShortList(context,
                      enableLoader: true,
                      page: 1,
                      length: 20,
                      shortListedBy: index == 0
                          ? ShortListedBy.shortListedByOthers
                          : ShortListedBy.shortListedByMe);
                }),
              )
            : _mainView(context, provider, interestUserDataList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => context.read<MailBoxProvider>().getShortList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              shortListedBy: index == 0
                  ? ShortListedBy.shortListedByOthers
                  : ShortListedBy.shortListedByMe),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => context.read<MailBoxProvider>().getShortList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              shortListedBy: index == 0
                  ? ShortListedBy.shortListedByOthers
                  : ShortListedBy.shortListedByMe),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          isTryAgainVisible: false,
          onTap: () => context.read<MailBoxProvider>().getShortList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              shortListedBy: index == 0
                  ? ShortListedBy.shortListedByOthers
                  : ShortListedBy.shortListedByMe),
        );
        break;

      case LoaderState.loading:
        // TODO: Handle this case.
        break;
    }
    return child;
  }

  _mainView(BuildContext context, MailBoxProvider mailBoxProvider,
      List<InterestUserData> interestUserDataList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
          } else {
            mailBoxProvider.loadChildTabValues(context, false);
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
                mailBoxProvider.selectedChildIndex == 0
                    ? context.loc.membersShortListed(
                        mailBoxProvider.interestShortlistViewedTotalRecords)
                    : context.loc.profilesShortListed(mailBoxProvider
                        .interestShortlistViewedByMeTotalRecords),
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
                            navFrom: NavFrom.navFromShortList,
                            anyValue: ProfileDetailDefaultModel(
                                id: userDetails?.id,
                                userName: userDetails?.name,
                                isMale: userDetails?.isMale,
                                userImage: userDetails?.userImage,
                                nestId: userDetails?.registerId,
                                age: userDetails?.age)))
                    .then((value) => context.read<MailBoxProvider>()
                      ..clearPageLoader()
                      ..getShortList(context,
                          enableLoader: true,
                          page: 1,
                          length: 20,
                          shortListedBy: mailBoxProvider.selectedChildIndex == 0
                              ? ShortListedBy.shortListedByOthers
                              : ShortListedBy.shortListedByMe));
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
                viewedDate: interestUserDataList[index].shortListDate ?? '',
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
          ReusableWidgets.sliverPaginationLoader(
              mailBoxProvider.paginationLoader)
        ],
      ),
    );
  }
}
