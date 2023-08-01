import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/build_version_model.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/firebase_analytics_services.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/services/widget_handler/splash_handler.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../services/flavour_config.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  Data? data;
  String? buildVersion;
  String? buildVersionForClear = "45";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            width: context.sw(),
            height: context.sh(),
            child: Stack(
              children: [
                Image.asset(
                  Assets.imagesSplashBg,
                  width: context.sw(),
                  height: context.sh(),
                  fit: BoxFit.fill,
                ),
                Center(
                    child: SvgPicture.asset(
                  Assets.imagesLogo,
                  alignment: Alignment.center,
                  width: 128.86.w,
                  height: 149.23.h,
                )),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    elevation: 0,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.light,
                    ),
                  ),
                ),
              ],
            )));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    final flavour = FlavourConstants.findFlavour;
    AppConfig.baseUrl = flavour.getBaseUrl();
    FirebaseAnalyticsService.instance.openApp();
    init();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Navigator.pop(context);
      init();
    }
  }

  init() {
    CommonFunctions.afterInit(() {
      context
          .read<AuthProvider>()
          .getBuildVersion()
          .then((value) => versionCheck().then((value) => initialFetch()));
    });
  }

  Future versionCheck() async {
    buildVersion = await Helpers.getBuildVersion();
    CommonFunctions.afterInit(() {
      data = context.read<AuthProvider>().buildversionData?.data;

    });

    bool isClear = await SharedPreferenceHelper.isDataClearedStatus();

    if (!isClear) {
      if (buildVersion == buildVersionForClear) {
        clearAllData();
      }
    }
  }

  void clearAllData() async {
    await SharedPreferenceHelper.clearWholeData();
    await SharedPreferenceHelper.isDataCleared(true);
  }

  bool checkForceUpdate({int? buildCode}) {
    bool update = false;
    int? code = int.parse(buildVersion ?? '0');
    print('code $code');
    print('ios version ${data?.minIosVersion}');
    if (Platform.isIOS) {
      if (code < (data?.minIosVersion ?? code)) {
        // force update
        update = true;
        Navigator.popUntil(context, (route) {
          if (route.settings.name != RouteGenerator.routeForcePopupDialog) {
            _showMyDialog(
              onUpdate: () {
                Navigator.pop(context);
                Helpers.launchApp(Constants.applestoreURL + Constants.appID);
              },
            );
          }
          return true;
        });
      } else if (code < (data?.latestIosVersion ?? code)) {
        // normal update
        update = true;
        Navigator.popUntil(context, (route) {
          if (route.settings.name != RouteGenerator.routeForcePopupDialog) {
            _showMyDialog(
                onUpdate: () async {
                  Navigator.pop(context);
                  Helpers.launchApp(Constants.applestoreURL + Constants.appID);
                },
                dialog: context.loc.updateMsgIOS,
                title: context.loc.newVersion,
                normalUpdate: true);
          }
          return true;
        });
      }
    } else {
      if (code < (data?.minAndroidVersion ?? code)) {
        //
        // force update
        update = true;
        Navigator.popUntil(context, (route) {
          if (route.settings.name != RouteGenerator.routeForcePopupDialog) {
            _showMyDialog(
              onUpdate: () async {
                Navigator.pop(context);
                String packageName = await Helpers.getPackageName();
                Helpers.launchApp('${Constants.playstoreURL}$packageName');
              },
            );
          }
          return true;
        });
      } else if (code < (data?.latestAndroidVersion ?? code)) {
        // normal update
        update = true;
        Navigator.popUntil(context, (route) {
          if (route.settings.name != RouteGenerator.routeForcePopupDialog) {
            _showMyDialog(
                onUpdate: () async {
                  Navigator.pop(context);
                  String packageName = await Helpers.getPackageName();
                  Helpers.launchApp('${Constants.playstoreURL}$packageName');
                },
                dialog: context.loc.updateMsgAndroid,
                title: context.loc.newVersion,
                normalUpdate: true);
          }
          return true;
        });
      }
    }
    return update;
  }

  Future<void> _showMyDialog(
      {String? title,
      bool normalUpdate = false,
      String? dialog,
      VoidCallback? onUpdate}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      routeSettings:
          const RouteSettings(name: RouteGenerator.routeForcePopupDialog),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.r))),
          title: Text(title ?? context.loc.updateRequired),
          content: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    dialog ?? context.loc.normalUpdateMsg,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onUpdate ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(
                context.loc.update,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (normalUpdate)
              TextButton(
                child: Text(context.loc.cancel),
                onPressed: () {
                  SplashHandler.instance.isAppOpenedOnce(context, mounted,
                      onNavSuccess: () {
                    if (mounted) SplashHandler.instance.navigateToNext(context);
                  });
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> initialFetch() async {
    final flavour = FlavourConstants.findFlavour;
    AppConfig.baseUrl = flavour.getBaseUrl();
    final network = await Helpers.isInternetAvailable(enableToast: false);
    if (network) {
      if (mounted) {
        bool isUpdate = checkForceUpdate();

        if (!isUpdate) {
          SplashHandler.instance.isAppOpenedOnce(context, mounted,
              onNavSuccess: () {
            if (mounted) SplashHandler.instance.navigateToNext(context);
          });
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_off,
                      color: ColorPalette.primaryColor,
                      size: 16,
                    ),
                    5.horizontalSpace,
                    Text(Constants.noInternet,
                        style: FontPalette.white14Bold
                            .copyWith(color: ColorPalette.primaryColor))
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  onPressed: () async {
                    final network =
                        await Helpers.isInternetAvailable(enableToast: false);
                    if (network && mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (mounted) {
                        SplashHandler.instance.isAppOpenedOnce(context, mounted,
                            onNavSuccess: () {
                          if (mounted) {
                            SplashHandler.instance.navigateToNext(context);
                          }
                        });
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: ColorPalette.materialPrimary,
                  ))
            ],
          ),
          duration: const Duration(days: 1),
          backgroundColor: Colors.white,
        ));
      }
    }
  }

  onBoarding() async {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.routeOnBoarding, (route) => false);
  }
}
