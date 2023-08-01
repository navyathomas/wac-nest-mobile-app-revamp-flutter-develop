import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_palette.dart';

class FontPalette {
  static const themeFont = "PlusJakarta";

  ///10
  static TextStyle get black10Bold => TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get black10Regular => TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle get black10Medium => TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w500, color: Colors.black);

  ///11
  static TextStyle get black11semiBold => TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get f950053_11semiBold => TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w600, color: HexColor('#950053'));
  static TextStyle get f8695A7_11Medium => TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w500, color: HexColor('#8695A7'));
  static TextStyle get f525B67_11semiBold => TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w600, color: HexColor('#525B67'));

  ///12
  static TextStyle get black12semiBold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get f8695A7_12semiBold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w600, color: HexColor('#8695A7'));
  static TextStyle get f8695A7_12medium => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#8695A7'));
  static TextStyle get f131A24_12SemiBold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w600, color: HexColor('#131A24'));
  static TextStyle get f00A22C_12SemiBold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w600, color: HexColor('#00A22C'));
  static TextStyle get black12Medium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      );
  static TextStyle get f131A24_12Bold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));
  static TextStyle get white_12Bold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get f131A24_12Medium => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#131A24'));
  static TextStyle get f565F6C_12Medium => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#565F6C'));
  static TextStyle get f565F6C_12Bold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w700, color: HexColor('#565F6C'));
  static TextStyle get f565F6C_12SemiBold => TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w600, color: HexColor('#565F6C'));

  ///13
  static TextStyle get black13Regular => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle get f131A24_13Medium => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#131A24'));
  static TextStyle get f565F6C_13Medium => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#565F6C'));
  static TextStyle get black13SemiBold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get white13SemiBold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle get f2995E5_13ExtraBold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w800, color: HexColor('#2995E5'));
  static TextStyle get f2995E5_13SemiBold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: HexColor('#2995E5'));
  static TextStyle get f131A24_13SemiBold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: HexColor('#131A24'));
  static TextStyle get f131A24_13Bold => TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));

  ///14
  static TextStyle get black14SemiBold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get black14MediumUnderLine => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      decoration: TextDecoration.underline);

  static TextStyle get black14Medium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      );
  static TextStyle get f131A24_14SemiBold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#131A24'));

  static TextStyle get black14Regular => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle get black14Bold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get white14Bold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get f131A24_14Bold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));
  static TextStyle get f131A24_14Medium => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#131A24'));
  static TextStyle get f565F6C_14Medium => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#565F6C'));
  static TextStyle get f565F6C_14Bold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: HexColor('#565F6C'));
  static TextStyle get f8695A7_14Bold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: HexColor('#8695A7'));
  static TextStyle get f2995E5_14SemiBold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#2995E5'));
  static TextStyle get f2995E5_14ExtraBold => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w800, color: HexColor('#2995E5'));

  ///15
  static TextStyle get black15SemiBold => TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get black15Medium => TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle get black15Bold => TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get f131A24_15Bold => TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));

  ///16
  static TextStyle get white16Bold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get black16Bold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get primary16Bold => TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: ColorPalette.primaryColor);
  static TextStyle get f09274D_16Bold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: HexColor('#09274D'));
  static TextStyle get black16SemiBold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle get f131A24_16SemiBold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: HexColor('#131A24'));
  static TextStyle get f131A24_16Bold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));
  static TextStyle get white16Medium => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, color: HexColor('#FFFFFF'));
  static TextStyle get black16Medium => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle get f565F6C16SemiBold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, color: HexColor('#565F6C'));
  static TextStyle get f565F6C16Bold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w700, color: HexColor('#565F6C'));
  static TextStyle get black16ExtraBold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.black);
  static TextStyle get f131A24_16Medium => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, color: HexColor('#131A24'));
  static TextStyle get f131A24_16ExtraBold => TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w800, color: HexColor('#131A24'));

  ///17
  static TextStyle get black17Bold => TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get white17Bold => TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get f131A24_17SemiBold => TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.w600, color: HexColor('#131A24'));

  ///18
  static TextStyle get white18Bold => TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get black18Bold => TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle get f131A24_18ExtraBold => TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w800, color: HexColor('#131A24'));

  ///19
  static TextStyle get f131A24_19ExtraBold => TextStyle(
      fontSize: 19.sp, fontWeight: FontWeight.w800, color: HexColor('#131A24'));

  ///20
  static TextStyle get black20SemiBold => TextStyle(
      fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black);

  ///22
  static TextStyle get black22SemiBold => TextStyle(
      fontSize: 22.sp, fontWeight: FontWeight.w600, color: Colors.black);

  ///26
  static TextStyle get black26Bold => TextStyle(
      fontSize: 26.sp, fontWeight: FontWeight.w700, color: Colors.black);

  ///27
  static TextStyle get white27Bold => TextStyle(
      fontSize: 27.sp, fontWeight: FontWeight.w700, color: Colors.white);

  ///28
  static TextStyle get black28Bold => TextStyle(
      fontSize: 28.sp, fontWeight: FontWeight.w700, color: Colors.black);

  ///30
  static TextStyle get black30Bold => TextStyle(
      fontSize: 30.sp, fontWeight: FontWeight.w700, color: Colors.black);

  static TextStyle color131A24_20Bold = TextStyle(
      fontSize: 30.sp, fontWeight: FontWeight.w700, color: HexColor('#131A24'));
}
