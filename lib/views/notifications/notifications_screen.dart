import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/notifications/notification_tile.dart.dart';
import 'package:nest_matrimony/widgets/common_app_bar.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';
import '../../providers/mail_box_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../error_views/common_error_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    CommonFunctions.afterInit(
        () => context.read<NotificationProvider>().getNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        pageTitle: context.loc.notifications,
        buildContext: context,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, value, child) {
          return StackLoader(
              inAsyncCall: value.loaderState == LoaderState.loading,
              child: _switchView(value.loaderState, value, context));
        },
      ),
    );
  }

  Widget _switchView(LoaderState loaderState, NotificationProvider provider,
      BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = _mainView(provider);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError,
            onTap: () => provider.getNotifications());
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => provider.getNotifications(),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          isTryAgainVisible: false,
          onTap: () => provider.getNotifications(),
        );
        break;
      case LoaderState.loading:
        child = provider.notificationList.isEmpty
            ? const SizedBox.shrink()
            : _mainView(provider);
        break;
    }
    return child;
  }

  _mainView(NotificationProvider value) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          value.notificationListToday.isNotEmpty
              ? greyTitleText()
              : const SizedBox.shrink(),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.notificationListToday.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                notificationData: value.notificationListToday[index],
                isRedDot: value.notificationListToday[index].isViewed == 0
                    ? true
                    : false,
                onTap: () => value.onNotificationSelected(
                    context,
                    value.notificationListToday[index].notificationType ?? '',
                    value.notificationListToday[index].userFromId ?? 0,
                    notificationId: value.notificationListToday[index].id,
                    isFromNotificationScreen: true),
              );
            },
          ),
          value.notificationListYesterday.isNotEmpty
              ? greyTitleText(title: context.loc.yesterday)
              : const SizedBox.shrink(),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.notificationListYesterday.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                notificationData: value.notificationListYesterday[index],
                isRedDot: value.notificationListYesterday[index].isViewed == 0
                    ? true
                    : false,
                onTap: () => value.onNotificationSelected(
                    context,
                    value.notificationListYesterday[index].notificationType ??
                        '',
                    value.notificationListYesterday[index].userFromId ?? 0,
                    notificationId: value.notificationListYesterday[index].id,
                    isFromNotificationScreen: true),
              );
            },
          ),
          value.notificationListThisWeek.isNotEmpty
              ? greyTitleText(title: context.loc.thisWeek)
              : const SizedBox.shrink(),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.notificationListThisWeek.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                notificationData: value.notificationListThisWeek[index],
                isRedDot: value.notificationListThisWeek[index].isViewed == 0
                    ? true
                    : false,
                onTap: () => value.onNotificationSelected(
                    context,
                    value.notificationListThisWeek[index].notificationType ??
                        '',
                    value.notificationListThisWeek[index].userFromId ?? 0,
                    notificationId: value.notificationListThisWeek[index].id,
                    isFromNotificationScreen: true),
              );
            },
          ),
          value.notificationListOlder.isNotEmpty
              ? greyTitleText(title: context.loc.older)
              : const SizedBox.shrink(),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: value.notificationListOlder.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                notificationData: value.notificationListOlder[index],
                isRedDot: value.notificationListOlder[index].isViewed == 0
                    ? true
                    : false,
                onTap: () => value.onNotificationSelected(
                    context,
                    value.notificationListOlder[index].notificationType ?? '',
                    value.notificationListOlder[index].userFromId ?? 0,
                    notificationId: value.notificationListOlder[index].id,
                    isFromNotificationScreen: true),
              );
            },
          )
        ],
      ),
    );
  }

  Widget greyTitleText({String? title}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 12.h, bottom: 7.h),
      child: Text(
        title ?? context.loc.today,
        style: FontPalette.black13SemiBold
            .copyWith(color: HexColor("#8695A7"), fontSize: 12.sp),
      ),
    );
  }
}
