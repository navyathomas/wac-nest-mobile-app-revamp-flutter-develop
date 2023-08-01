import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nest_matrimony/hive_models/paymentDetails.dart';
import 'package:nest_matrimony/services/flavour_config.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'common/multi_provider_list.dart';
import 'common/route_generator.dart';
import 'utils/color_palette.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  Hive.registerAdapter(PaymentDetailsAdapter());
  // FlavourConstants.setEnvironment(Environment.dev);
  FlutterError.onError = (errorDetails) {
    debugPrint('error details ${errorDetails.stack}');
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  runZonedGuarded(() async {
    runApp(
        /*    DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ));*/
        const MyApp());
  }, (error, stackTrace) {
    debugPrint('error $stackTrace');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    debugPrint('crashlytics error $error}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: OverlaySupport.global(
        toastTheme:
            ToastThemeData(textColor: Colors.white, background: Colors.black),
        child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Nest Matrimony',
                // useInheritedMediaQuery: true,
                // locale: DevicePreview.locale(context),
                // builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                // locale: const Locale('en'),
                // initialRoute: RouteGenerator.routeInitial,
                theme: ColorPalette.themeData,
                onGenerateRoute: RouteGenerator.instance.generateRoute,
              );
            }),
      ),
    );
  }
}
