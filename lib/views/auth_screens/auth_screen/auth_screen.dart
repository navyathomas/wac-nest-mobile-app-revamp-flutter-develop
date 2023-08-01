import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/views/auth_screens/auth_screen/search_easy_pay_tile.dart';
import 'package:nest_matrimony/views/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

import '../../../services/app_config.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    if (AppConfig.isAuthorized) return const MainScreen();
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Image.asset(
                  Assets.imagesAuthBg,
                  width: double.maxFinite,
                  height: _customHeight(constraints.maxHeight),
                  fit: BoxFit.cover,
                );
              }),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: SearchEasyPayTile()),
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
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    context.read<AuthProvider>().getPaymentStatus(context);
    super.initState();
  }

  double _customHeight(double height) {
    if (height > 900) {
      return height * 0.8;
    } else if (height > 750) {
      return height * 0.7;
    } else if (height > 650) {
      return height * 0.67;
    } else {
      return height * 0.65;
    }
  }
}
