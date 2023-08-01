import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/notification_reponse_model.dart';
import 'package:nest_matrimony/providers/services_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:provider/provider.dart';
import 'package:async/src/result/result.dart';

import '../common/common_functions.dart';
import '../common/route_generator.dart';
import '../models/route_arguments.dart';
import '../services/http_requests.dart';
import 'mail_box_provider.dart';

class NotificationProvider extends ChangeNotifier with BaseProviderClass {
  List<NotificationListData> notificationList = [];
  List<NotificationUserData> notificationListToday = [];
  List<NotificationUserData> notificationListYesterday = [];
  List<NotificationUserData> notificationListOlder = [];
  List<NotificationUserData> notificationListThisWeek = [];

  getNotifications() async {
    notificationList = [];
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getNotifications();
    if (res.isValue) {
      NotificationResponseModel notificationResponseModel = res.asValue?.value;
      updateNotificationList(notificationResponseModel);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
    notifyListeners();
  }

  updateNotificationList(NotificationResponseModel notificationResponseModel) {
    notificationListToday = [];
    notificationListYesterday = [];
    notificationListThisWeek = [];
    notificationListOlder = [];
    notificationList = notificationResponseModel.data ?? [];
    if ((notificationResponseModel.data ?? []).isNotEmpty) {
      notificationListToday = notificationResponseModel.data![0].list ?? [];
      notificationListYesterday = notificationResponseModel.data![1].list ?? [];
      notificationListThisWeek = notificationResponseModel.data![2].list ?? [];
      notificationListOlder = notificationResponseModel.data![3].list ?? [];
    }
    if (notificationListToday.isEmpty &&
        notificationListYesterday.isEmpty &&
        notificationListThisWeek.isEmpty &&
        notificationListOlder.isEmpty) {
      updateLoaderState(LoaderState.noData);
    } else {
      updateLoaderState(LoaderState.loaded);
    }

    notifyListeners();
  }

  convertDate(var dates) {
    var date = Jiffy(dates).format('dd');
    var month = Jiffy(dates).format('MM');
    var year = Jiffy(dates).format('yyyy');
    var week = Jiffy().format('EEEE');
    Map<String, String> dateCalender = {
      'date': date,
      'month': month,
      'year': year,
      'week': week
    };
    return dateCalender;
  }

  viewNotification(int notificationId, Function onSuccess) async {
    Map<String, dynamic> params = {'notification_id': notificationId};
    Result res = await serviceConfig.viewNotification(params);
    if (res.isValue) {
      debugPrint('notification view success');
      onSuccess();
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  onNotificationSelected(
      BuildContext context, String notificationType, int userFromId,
      {int? notificationId, bool isFromNotificationScreen = false}) {
    MailBoxProvider mailBoxProvider = context.read<MailBoxProvider>();
    ServicesProvider servicesProvider = context.read<ServicesProvider>();
    switch (notificationType) {
      case 'VIEW_PROFILE':
        viewNotification(notificationId ?? 0, () {
          Navigator.pushNamed(
                  context, RouteGenerator.routePartnerSingleProfileDetail,
                  arguments: RouteArguments(profileId: userFromId))
              .then((value) => getNotifications());
        });

        break;
      case 'VIEW_CONTACT':
        viewNotification(notificationId ?? 0, () {
          Navigator.pushNamed(
                  context, RouteGenerator.routePartnerSingleProfileDetail,
                  arguments: RouteArguments(profileId: userFromId))
              .then((value) => getNotifications());
        });

        break;
      case 'SHORT-LIST':
        viewNotification(notificationId ?? 0, () {
          mailBoxProvider.updateTabControllerIndex(3);
          mailBoxProvider.updateSubTabControllerIndex(0);
          mailBoxProvider.updateSelectedIndex(3);
          mailBoxProvider.updateSelectedChildIndex(0);
          mailBoxProvider.updateChildTabControllerIndex(0);
          mailBoxProvider.updatePageIndexValue(3);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.routeMainScreen, (route) => false,
              arguments:
                  RouteArguments(tabIndex: 2, isFromNotificationScreen: true));
        });

        break;
      case 'SEND_INTEREST':
        viewNotification(notificationId ?? 0, () {
          mailBoxProvider.updateTabControllerIndex(0);
          mailBoxProvider.updateSubTabControllerIndex(0);
          mailBoxProvider.updateSelectedIndex(0);
          mailBoxProvider.updateSelectedChildIndex(2);
          mailBoxProvider.updateChildTabControllerIndex(1);
          mailBoxProvider.updatePageIndexValue(0);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.routeMainScreen, (route) => false,
              arguments:
                  RouteArguments(tabIndex: 2, isFromNotificationScreen: true));
        });
        break;
      case 'ADMIN_TYPE':
        servicesProvider.updateTabIndex(1);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments:
                RouteArguments(tabIndex: 3, isFromNotificationScreen: true));
        break;
      case 'CUSTOMER_TYPE':
        servicesProvider.updateTabIndex(0);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments:
                RouteArguments(tabIndex: 3, isFromNotificationScreen: true));
        break;
    }
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
