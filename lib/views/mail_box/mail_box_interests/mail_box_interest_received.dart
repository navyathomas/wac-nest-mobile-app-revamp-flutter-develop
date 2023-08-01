import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
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

class MailBoxInterestReceived extends StatefulWidget {
  MailBoxInterestReceived({Key? key}) : super(key: key);

  @override
  State<MailBoxInterestReceived> createState() =>
      _MailBoxInterestReceivedState();
}

class _MailBoxInterestReceivedState extends State<MailBoxInterestReceived> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MailBoxProvider>(
      builder: (context, value, child) {
        return StackLoader(
          inAsyncCall: value.loaderState == LoaderState.loading ? true : false,
          child: switchView(value.loaderState, value, context),
        );
      },
    );
  }
}

Widget switchView(
    LoaderState loaderState, MailBoxProvider provider, BuildContext context) {
  Widget child = const SizedBox.shrink();
  switch (loaderState) {
    case LoaderState.loaded:
      child = provider.mailBoxInterestReceivedDataList.isEmpty
          ? CommonErrorView(
              error: Errors.noDatFound,
              isTryAgainVisible: false,
              onTap: () => CommonFunctions.afterInit(() {
                context.read<MailBoxProvider>().getInterestList(context,
                    enableLoader: true,
                    page: 1,
                    length: 20,
                    interestTypes: InterestTypes.received);
              }),
            )
          : mainView(
              context, provider, provider.mailBoxInterestReceivedDataList);
      break;
    case LoaderState.error:
      child = CommonErrorView(
        error: Errors.serverError,
        onTap: () => context.read<MailBoxProvider>().getInterestList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            interestTypes: InterestTypes.received),
      );
      break;
    case LoaderState.networkErr:
      child = CommonErrorView(
        error: Errors.networkError,
        onTap: () => context.read<MailBoxProvider>().getInterestList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            interestTypes: InterestTypes.received),
      );
      break;
    case LoaderState.noData:
      child = CommonErrorView(
        error: Errors.noDatFound,
        isTryAgainVisible: false,
        onTap: () => context.read<MailBoxProvider>().getInterestList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            interestTypes: InterestTypes.received),
      );
      break;
    case LoaderState.loading:
      child = provider.interestUserDataList.isEmpty
          ? const SizedBox.shrink()
          : mainView(
              context, provider, provider.mailBoxInterestReceivedDataList);
      break;
  }
  return child;
}

mainView(BuildContext context, MailBoxProvider value,
    List<InterestUserData> interestUserDataList) {
  print(interestUserDataList.length);
  return Container(
    color: ColorPalette.pageBgColor,
    child: NotificationListener<ScrollNotification>(
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
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(13.w),
              child: Text(
                context.loc.members(value.interestReceivedTotalRecords),
                style: FontPalette.f131A24_16ExtraBold,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              debugPrint('index $index');
              return Padding(
                padding: EdgeInsets.only(bottom: 9.h),
                child: MailBoxProfileCard(
                  onTap: () {
                    UserDetails? userDetails =
                        interestUserDataList[index].userDetails;
                    Navigator.pushNamed(
                        context, RouteGenerator.routePartnerSingleProfileDetail,
                        arguments: RouteArguments(
                            navFrom: NavFrom.navFromInterests,
                            profileId: interestUserDataList[index].id ?? -1,
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
                    padding: EdgeInsets.only(top: 9.h, bottom: 3.h),
                    child: Row(
                      children: [
                        _DeclineBtn(
                          interestId: interestUserDataList[index].id ?? 0,
                          provider: value,
                        ).flexWrap,
                        9.horizontalSpace,
                        _AcceptBtn(
                          interestId: interestUserDataList[index].id ?? 0,
                          provider: value,
                        ).flexWrap
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
    ),
  );
}

class _DeclineBtn extends StatelessWidget {
  _DeclineBtn({Key? key, required this.interestId, required this.provider})
      : super(key: key);
  int interestId;
  MailBoxProvider provider;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CommonFunctions.afterInit(() {
          provider.acceptOrDeclineInterest(
              context, interestId, InterestAction.decline, onSuccess: () {
            provider.mailBoxInterestDeclinedByMeDataList.clear();
            provider.getInterestList(context,
                enableLoader: true, interestTypes: InterestTypes.received);
          });
        });
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
            Icon(
              Icons.close,
              color: HexColor('#565F6C'),
              size: 20.r,
            ),
            3.horizontalSpace,
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                context.loc.decline,
                style: FontPalette.f565F6C_14Bold,
              ).avoidOverFlow(),
            ).flexWrap,
          ],
        ),
      ),
    ).applyRipple();
  }
}

class _AcceptBtn extends StatelessWidget {
  _AcceptBtn({Key? key, required this.interestId, required this.provider})
      : super(key: key);
  int interestId;
  MailBoxProvider provider;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CommonFunctions.afterInit(() {
          provider.acceptOrDeclineInterest(
              context, interestId, InterestAction.accept, onSuccess: () {
            provider.mailBoxInterestAcceptedByMeDataList.clear();
            provider.getInterestList(context,
                enableLoader: true, interestTypes: InterestTypes.received);
          });
        });
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.done,
              color: Colors.white,
              size: 20.r,
            ),
            3.horizontalSpace,
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                context.loc.accept,
                style: FontPalette.white14Bold,
              ).avoidOverFlow(),
            ).flexWrap
          ],
        ),
      ),
    ).applyRipple(btnColor: HexColor('#14BF84'));
  }
}
