import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/contact_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../common/route_generator.dart';
import '../../../models/mail_box_response_model.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../models/route_arguments.dart';
import '../../../providers/mail_box_provider.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../error_views/common_error_view.dart';
import '../../search_result/profile_short_info_tile.dart';
import '../../search_result/search_result_list_tile.dart';
import '../mail_box_profile_card.dart';

class MailBoxInterestAccepted extends StatefulWidget {
  const MailBoxInterestAccepted({Key? key}) : super(key: key);

  @override
  State<MailBoxInterestAccepted> createState() =>
      _MailBoxInterestAcceptedState();
}

class _MailBoxInterestAcceptedState extends State<MailBoxInterestAccepted>
    with TickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: context.read<MailBoxProvider>().childTabControllerIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MailBoxProvider>(
      builder: (context, value, child) {
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
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200))),
                  child: Container(
                    padding: EdgeInsets.all(3.r),
                    height: 35.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                    decoration: BoxDecoration(
                        color: HexColor('#E9EDEF'),
                        borderRadius: BorderRadius.circular(9.r)),
                    child: TabBar(
                      controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      onTap: (index) {
                        if (context.read<MailBoxProvider>().loaderState ==
                            LoaderState.loading) {
                          return;
                        }
                        context.read<MailBoxProvider>().clearPageLoader();
                        value.updateAcceptedTabIndex(index);
                        value.getChildTabValues(context, true);
                      },
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
                        Tab(text: context.loc.interestsAccepted),
                        Tab(text: context.loc.acceptedByMe)
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  color: ColorPalette.pageBgColor,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _InterestAcceptView(),
                      _InterestAcceptView(),
                    ],
                  ),
                ))
              ],
            ));
      },
    );
  }
}

class _InterestAcceptView extends StatelessWidget {
  _InterestAcceptView({Key? key}) : super(key: key);

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
                    value.acceptedTabIndex == 0
                        ? value.mailBoxInterestAcceptedDataList
                        : value.mailBoxInterestAcceptedByMeDataList));
      },
    );
  }

  switchView(LoaderState loaderState, MailBoxProvider provider,
      BuildContext context, List<InterestUserData> interestUserDetailsList) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = interestUserDetailsList.isEmpty
            ? CommonErrorView(
                error: Errors.noAccepts,
                onTap: () => CommonFunctions.afterInit(() {
                  context.read<MailBoxProvider>().getInterestList(context,
                      enableLoader: true,
                      page: 1,
                      length: 20,
                      interestTypes: InterestTypes.accepted);
                }),
              )
            : mainView(context, provider, interestUserDetailsList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.accepted),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.accepted),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.accepted),
        );
        break;

      case LoaderState.loading:
        // TODO: Handle this case.
        break;
    }
    return child;
  }

  mainView(BuildContext context, MailBoxProvider value,
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
                value.acceptedTabIndex == 0
                    ? context.loc
                        .membersAccepted(value.interestAcceptedTotalRecords)
                    : context.loc.profilesInterest(
                        value.interestAcceptedByMeTotalRecords),
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
                    padding: EdgeInsets.only(top: 10.h, bottom: 2.h),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              context.loc.accepted,
                              style: FontPalette.f00A22C_12SemiBold,
                            ).flexWrap,
                            7.horizontalSpace,
                            Text(
                              value.acceptedTabIndex == 0
                                  ? interestUserDataList[index]
                                          .interestApprovedDate ??
                                      ''
                                  : interestUserDataList[index]
                                          .interestAcceptedDate ??
                                      '',
                              style: FontPalette.f8695A7_11Medium,
                            ).flexWrap
                          ],
                        )),
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

class ContactBtn extends StatelessWidget {
  ContactBtn({Key? key, this.phoneNumber}) : super(key: key);
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ContactProvider>().makePhoneCall(phoneNumber: phoneNumber);
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
            border: Border.all(color: HexColor('#DBE2EA')),
            borderRadius: BorderRadius.circular(9.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.iconsLinearCall,
              height: 21.r,
              width: 21.r,
            ),
            6.horizontalSpace,
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                context.loc.contact,
                style: FontPalette.f2995E5_14SemiBold,
              ).avoidOverFlow(),
            ).flexWrap,
          ],
        ),
      ),
    ).applyRipple();
  }
}
