import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_palette.dart';

class ColorPalette {
  static ThemeData get themeData => ThemeData(
      primarySwatch: ColorPalette.materialPrimary,
      fontFamily: FontPalette.themeFont,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: ColorPalette.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r)))),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark)),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black));

  static Color get primaryColor => const Color(0xFF950053);
  static Color get secondaryColor => const Color(0xFF950053);
  static Color get pageBgColor => const Color(0xFFF2F4F5);
  static Color get shimmerColor => const Color(0xFFEFF1F4);

  static const MaterialColor materialPrimary = MaterialColor(
    0xFF950053,
    <int, Color>{
      50: Color(0xFF950053),
      100: Color(0xFF950053),
      200: Color(0xFF950053),
      300: Color(0xFF950053),
      400: Color(0xFF950053),
      500: Color(0xFF950053),
      600: Color(0xFF950053),
      700: Color(0xFF950053),
      800: Color(0xFF950053),
      900: Color(0xFF950053),
    },
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
