import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/constants.dart';

class Helpers {
  static void successToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<bool> isInternetAvailable({bool enableToast = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        if (enableToast) Constants.noInternet.showToast();
        return false;
      }
    } on SocketException catch (_) {
      if (enableToast) Constants.noInternet.showToast();
      return false;
    }
  }

  static Future<bool> isLocationServiceEnabled() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static double validateScale(BuildContext context, [double defaultVal = 1.0]) {
    double value = MediaQuery.of(context).textScaleFactor;
    if (value <= 1.0) {
      defaultVal = defaultVal;
    } else if (value >= 1.3) {
      defaultVal = value - 0.2;
    } else if (value >= 1.1) {
      defaultVal = value - 0.1;
    }
    return defaultVal;
  }

  static double convertToDouble(var value) {
    double val = 0.0;
    if (value == null) return val;
    switch (value.runtimeType) {
      case int:
        val = value.toDouble();
        break;
      case String:
        val = double.tryParse(value) ?? val;
        break;

      default:
        val = value;
    }
    return val;
  }

  static int convertToInt(var value, {int defaultVal = 0}) {
    int val = defaultVal;
    if (value == null) return val;
    switch (value.runtimeType) {
      case double:
        return value.toInt();

      case String:
        return int.tryParse(value) ?? val;

      default:
        return value;
    }
  }

  static capitaliseFirstLetter(String? input) {
    String val = '';
    if (input != null && input != "") {
      val = input[0].toUpperCase() + input.substring(1);
    }
    return val;
  }

  static String decodeBase64(String? val) {
    String uid = '';
    if (val != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      uid = stringToBase64.decode(val);
    }
    return uid;
  }

  static String encodeBase64(String? value) {
    String val = '';
    if (value != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      val = stringToBase64.encode(value);
    }
    return val;
  }

  static String removeBracket(List<String>? input) {
    if (input != null && input.isNotEmpty) {
      return input.toString().replaceAll('[', '').replaceAll(']', '');
    }
    return '';
  }

  static String convertCmToInch(int valInCm) {
    double length = valInCm / 2.54;
    int feet = (length / 12).floor();
    double inch = length - (12 * feet);
    return "$feet'${inch.floor()}";
  }

  static Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
    String version = packageInfo.version;
// String buildNumber = packageInfo.buildNumber;
    return version;
  }

  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packName = packageInfo.packageName;
    return packName;
  }

  static Future<String> getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;
    return buildNumber;
  }

  static Future<void> launchApp(String urls) async {
    final Uri url = Uri.parse(urls);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('$e');
    }
  }
}
