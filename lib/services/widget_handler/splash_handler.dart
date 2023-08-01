import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';
import '../../one_signal_messaging_services.dart';
import '../../providers/app_data_provider.dart';
import '../shared_preference_helper.dart';

class SplashHandler {
  static SplashHandler? _instance;

  static SplashHandler get instance {
    _instance ??= SplashHandler();
    return _instance!;
  }

  void isAppOpenedOnce(BuildContext context, bool mounted,
      {required Function onNavSuccess}) async {
    if (mounted) await context.read<AppDataProvider>().getAppBaseVersion();

    ///Todo: Navigate to error if api failed
    if (mounted) await context.read<AppDataProvider>().getCountryData();
    if (mounted) {
      await context.read<AppDataProvider>().getHeightListData(context);
    }

    if (mounted) await context.read<AppDataProvider>().getAgeData(context);
    if (mounted) await context.read<AppDataProvider>().getReligionList();
    if (mounted) await context.read<AppDataProvider>().getMaritalStatusData();
    if (mounted && AppConfig.isAuthorized) {
      final model = await context
          .read<AppDataProvider>()
          .getBasicDetails(context: context);
      if (model != null && mounted) {
        await context.read<AppDataProvider>().getEduCatListData().then(
            (value) => context.read<AppDataProvider>().getOccupationList().then(
                (value) => context.read<AppDataProvider>().getBaseUrls()));
      }
    } else {
      await context.read<AppDataProvider>().getEduCatListData().then((value) =>
          context
              .read<AppDataProvider>()
              .getOccupationList()
              .then((value) => context.read<AppDataProvider>().getBaseUrls()));
    }
    CommonFunctions.afterInit(() {
      NotificationServices.oneSignalInitialization(context);
    });
    onNavSuccess();
    /*  bool isAppOpened = await SharedPreferenceHelper.getAppOpenedStatus();
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.routeMainScreen, (route) => false,
        arguments: RouteArguments(tabIndex: 0));
    */ /*if (!mounted) return;
    isAppOpened
        ? SharedPreferenceHelper.getToken().then((value) => value.isNotEmpty
            ? Navigator.pushNamedAndRemoveUntil(
                context, RouteGenerator.routeMainScreen, (route) => false,
                arguments: RouteArguments(tabIndex: 0))
            : Navigator.pushNamedAndRemoveUntil(
                context, RouteGenerator.routeAuthScreen, (route) => false))
        : onBoarding(context);*/
  }

  void navigateToNext(BuildContext context) {
    SharedPreferenceHelper.getAppOpenedStatus().then((isAppOpened) {
      isAppOpened
          ? SharedPreferenceHelper.getToken().then((value) => value.isNotEmpty
              ? Navigator.pushNamedAndRemoveUntil(
                  context, RouteGenerator.routeMainScreen, (route) => false,
                  arguments: RouteArguments(tabIndex: 0))
              : Navigator.pushNamedAndRemoveUntil(
                  context, RouteGenerator.routeAuthScreen, (route) => false))
          : Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.routeOnBoarding, (route) => false);
    });
  }
}
