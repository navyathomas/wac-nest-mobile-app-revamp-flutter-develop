import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../../common/extensions.dart';
import '../../../common/route_generator.dart';
import '../../../models/mail_box_response_model.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../models/route_arguments.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../error_views/common_error_view.dart';
import '../../search_result/profile_short_info_tile.dart';
import '../../search_result/search_result_list_tile.dart';
import '../mail_box_profile_card.dart';

class MailBoxInterestDeclined extends StatelessWidget {
  const MailBoxInterestDeclined({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            WidgetExtension.horizontalDivider(
                color: HexColor('#DBE2EA'),
                height: 1.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Container(
                padding: EdgeInsets.all(3.r),
                height: 35.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                decoration: BoxDecoration(
                    color: HexColor('#E9EDEF'),
                    borderRadius: BorderRadius.circular(9.r)),
                child: TabBar(
                  onTap: (value) {
                    context.read<MailBoxProvider>().clearPageLoader();
                    context
                        .read<MailBoxProvider>()
                        .updateDeclinedTabIndex(value);
                    context
                        .read<MailBoxProvider>()
                        .getChildTabValues(context, true);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  labelColor: Colors.black,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(0, 2))
                      ]),
                  labelStyle: FontPalette.f131A24_12Medium
                      .copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: context.loc.interestDeclined),
                    Tab(text: context.loc.interestDeclinedByMe)
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              color: ColorPalette.pageBgColor,
              child: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [_InterestAcceptView(), _InterestAcceptView()],
              ),
            ))
          ],
        ));
  }
}

class _InterestAcceptView extends StatelessWidget {
  const _InterestAcceptView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MailBoxProvider>(
      builder: (context, value, child) {
        return StackLoader(
            inAsyncCall: value.loaderState.isLoading,
            child: value.loaderState.isLoading
                ? const SizedBox.shrink()
                : switchView(
                    value.loaderState,
                    value,
                    context,
                    value.declinedTabIndex == 0
                        ? value.mailBoxInterestDeclinedDataList
                        : value.mailBoxInterestDeclinedByMeDataList));
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
                error: Errors.declinesError,
                onTap: () => CommonFunctions.afterInit(() {
                  context.read<MailBoxProvider>().getInterestList(context,
                      enableLoader: true,
                      page: 1,
                      length: 20,
                      interestTypes: InterestTypes.declined);
                }),
              )
            : _mainView(context, provider, interestUserDataList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.declined),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.declined),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.declined),
        );
        break;

      case LoaderState.loading:
        // TODO: Handle this case.
        break;
    }
    return child;
  }

  _mainView(BuildContext context, MailBoxProvider value,
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
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(13.w),
              child: Text(
                value.declinedTabIndex == 0
                    ? context.loc
                        .membersDeclined(value.interestDeclinedTotalRecords)
                    : context.loc.profilesInterest(
                        value.interestDeclinedByMeTotalRecords),
                style: FontPalette.f131A24_16ExtraBold,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 9.h),
                child: MailBoxProfileCard(
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
                  interestReceivedUserData: interestUserDataList[index],
                  bottomTile: Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 15.h),
                    child: Row(
                      children: [
                        Text(
                          context.loc.declined,
                          style: FontPalette.f131A24_12SemiBold,
                        ).flexWrap,
                        7.horizontalSpace,
                        Text(
                          value.declinedTabIndex == 0
                              ? interestUserDataList[index]
                                      .interestRejectedDate ??
                                  ''
                              : interestUserDataList[index]
                                      .interestDeclinedDate ??
                                  '',
                          style: FontPalette.f8695A7_11Medium,
                        ).flexWrap,
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: interestUserDataList.length)),
          ),
          ReusableWidgets.sliverPaginationLoader(value.paginationLoader)
        ],
      ),
    );
  }
}
