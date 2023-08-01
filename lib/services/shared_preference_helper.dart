import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class SharedPreferenceHelper {
  static Future<void> appOpenedOnce(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("appOpened", value);
  }

  static Future<bool> getAppOpenedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool("appOpened") ?? false;
    log("APP OPENED ONCE : $value");
    return value;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    AppConfig.accessToken = token;
    log("SAVED TOKEN : $token");
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);

    AppConfig.accessToken = token;
    return token;
  }

  static Future<void> savePaymentStatus(bool paymentStatus) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("paymentStatus", paymentStatus);
  }

  static Future<bool> getPaymentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool paymentStatus = prefs.getBool("paymentStatus") ?? true;
    return paymentStatus;
  }

  static Future<void> saveUpgradePlanStatus(bool paymentStatus) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("upgradePlanStatus", paymentStatus);
  }

  static Future<bool> getUpgradePlanStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool paymentStatus = prefs.getBool("upgradePlanStatus") ?? true;
    return paymentStatus;
  }

  static Future<void> clearData() async {
    AppConfig.accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  static Future<void> clearWholeData() async {
    AppConfig.accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> isDataCleared(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("dataClear", value);
  }

  static Future<bool> isDataClearedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool("dataClear") ?? false;
    log("APP DATA CLEAR STATUS : $value");
    return value;
  }
}
