import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/providers/notification_provider.dart';
import 'package:nest_matrimony/views/account/settings/settings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'common/route_generator.dart';
import 'models/route_arguments.dart';

class NotificationServices {
  static oneSignalInitialization(BuildContext context) async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("46d5f5a2-a9e7-4f02-bd1c-1f983830c1f1");
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    // debugPrint('player id ${status?.userId}');
// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.

      debugPrint('Notification opened');
      debugPrint(
          'notification data ${result.notification.additionalData!['notify_type']}');
      debugPrint('notification data ${result.notification.additionalData}');

      context.read<NotificationProvider>().onNotificationSelected(
          context,
          result.notification.additionalData!['notify_type'],
          result.notification.additionalData!['from_id'],
          notificationId:
              result.notification.additionalData!['notification_id']);
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
    // String externalUserId = '123456789';
    // OneSignal.shared.setExternalUserId(externalUserId).then((results) {
    //   debugPrint('external user id ${results.toString()}');
    // }).catchError((error) {
    //   debugPrint('error in external user id ${error.toString()}');
    // });
  }
}
