import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_palette.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key, this.backgroundColor}) : super(key: key);
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: backgroundColor ?? Colors.transparent,
          statusBarBrightness:
              Platform.isIOS ? Brightness.light : Brightness.dark),
      child: Container(
        color: backgroundColor ?? Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}

class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountAppBar({Key? key, this.backgroundColor}) : super(key: key);
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: backgroundColor ?? Colors.transparent,
          statusBarBrightness:
              Platform.isIOS ? Brightness.light : Brightness.dark),
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
        stops: const [
          0.5,
          0.9,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.topRight,
        colors: [
          HexColor('#FFF0E3'),
          HexColor('#F8D5FF'),
        ],
      ))),
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
