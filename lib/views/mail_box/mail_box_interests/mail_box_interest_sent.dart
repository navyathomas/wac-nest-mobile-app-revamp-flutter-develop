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

class MailBoxInterestSend extends StatefulWidget {
  const MailBoxInterestSend({Key? key}) : super(key: key);

  @override
  State<MailBoxInterestSend> createState() => _MailBoxInterestSendState();
}

class _MailBoxInterestSendState extends State<MailBoxInterestSend> {
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

  Widget switchView(
      LoaderState loaderState, MailBoxProvider provider, BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = provider.mailBoxInterestSentDataList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                isTryAgainVisible: false,
                onTap: () => CommonFunctions.afterInit(() {
                  context.read<MailBoxProvider>().getInterestList(context,
                      enableLoader: true,
                      page: 1,
                      length: 20,
                      interestTypes: InterestTypes.sent);
                }),
              )
            : mainView(context, provider, provider.mailBoxInterestSentDataList);
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.sent),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.sent),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          isTryAgainVisible: false,
          onTap: () => context.read<MailBoxProvider>().getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.sent),
        );
        break;
      case LoaderState.loading:
        child = const SizedBox.shrink();
        break;
    }
    return child;
  }

  mainView(BuildContext context, MailBoxProvider value,
      List<InterestUserData> interestUserDataList) {
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
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(13.w),
                child: Text(
                  context.loc.profilesInterest(value.interestSentTotalRecords),
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
                      Navigator.pushNamed(context,
                          RouteGenerator.routePartnerSingleProfileDetail,
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
                            context.loc.interestSent,
                            style: FontPalette.f131A24_12SemiBold,
                          ).flexWrap,
                          7.horizontalSpace,
                          Text(
                            interestUserDataList[index].interestSentDate ?? '',
                            style: FontPalette.f8695A7_11Medium,
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
}
