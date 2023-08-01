import 'package:hive/hive.dart';

class HiveServices {
  static const String generalAppBox = 'general_app_box';
  static const String appVersion = 'app_version';
  static const String countryDataList = 'country_data_list';
  static const String agesDataList = 'ages_data_list';
  static const String religionListData = 'religion_list_data';
  static const String recentSearchBox = 'recent_search_box';
  static const String baseURLs = 'base_url_box';
  static const String maritalStatusData = 'marital_status_data';
  static const String heightListData = 'height_list_data';
  static const String eduCatListData = 'edu_cat_list_data';
  static const String jobListData = 'job_list_data';
  static const String basicDetails = 'basic_details_data';
  static const String paymentDetailsBox = 'payment_details_box';
  static const String paymentDetails = 'payment_details';
  static const String upgradePlanDetailsBox = 'upgrade_plan_details_box';
  static const String upgradePlanDetails = 'upgrade_plan_details';
  static const String bodyTypeList = 'body_type_list_data';
  static const String complexionList = 'complexion';
  static const String childJobCategoryList = 'child-job-categories';
  static const String jobParentListData='job_parent_list_data';
  static Future<void> saveAppVersion(
      {required String val, required String key}) async {
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      box.put(key, val);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      box.put(key, val);
      box.close();
    }
  }

  static Future<String> getAppVersion() async {
    String res = '';
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<String> box = Hive.box(generalAppBox);
      res = box.get(appVersion) ?? '';
      box.close();
    } else {
      Box<String> box = await Hive.openBox<String>(generalAppBox);
      res = box.get(appVersion) ?? '';
      box.close();
    }
    return res;
  }

  static Future<void> saveDataToLocal(
      {required val, required String key}) async {
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      box.put(key, val);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      box.put(key, val);
    }
  }

  static Future<void> removeDataFromLocal(key) async {
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      box.delete(key);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      box.delete(key);
      box.close();
    }
  }

// SAVE BASE URLS TO LOCAL
  static Future<void> saveBaseURLsLocal(
      {required val, required String key}) async {
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      box.put(key, val);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      box.put(key, val);
    }
  }
// SAVE BASE URLS TO LOCAL CLOSE

// GET BASE URLS TO LOCAL
  static Future<dynamic> getBaseURLsLocal(String key) async {
    dynamic res;
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      res = box.get(key);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      res = box.get(key);
    }
    return res;
  }
// GET BASE URLS TO LOCAL CLOSE

  static Future<dynamic> getDataFromLocal(String key) async {
    dynamic res;
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      res = box.get(key);

    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      res = box.get(key);

    }
    return res;
  }

  static Future<void> addRecentlySearchedKeys(val) async {
    if (Hive.isBoxOpen(recentSearchBox)) {
      Box<dynamic> box = Hive.box(recentSearchBox);
      box.add(val);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(recentSearchBox);
      box.add(val);
    }
  }

  static Future<List<dynamic>> getRecentlySearchedKeys() async {
    dynamic res;
    dynamic reversedList;
    if (Hive.isBoxOpen(recentSearchBox)) {
      Box<dynamic> box = Hive.box(recentSearchBox);
      res = box.values.toList();
      reversedList = res.reversed.toList();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(recentSearchBox);
      res = box.values.toList();
      reversedList = res.reversed.toList();
    }
    return reversedList;
  }

  static Future<void> addPaymentDetails(val, String key) async {
    if (Hive.isBoxOpen(paymentDetailsBox)) {
      Box<dynamic> box = Hive.box(paymentDetailsBox);
      box.put(key, val);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(paymentDetailsBox);
      box.put(key, val);
    }
  }

  static Future<dynamic> getPaymentDetails() async {
    dynamic res;
    if (Hive.isBoxOpen(paymentDetailsBox)) {
      Box<dynamic> box = Hive.box(paymentDetailsBox);
      res = box.get(HiveServices.paymentDetails);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(paymentDetailsBox);
      res = box.get(HiveServices.paymentDetails);
    }
    return res;
  }

  static Future<void> deletePaymentDetails() async {
    List res;
    if (Hive.isBoxOpen(paymentDetailsBox)) {
      Box<dynamic> box = Hive.box(paymentDetailsBox);
      res = box.values.toList();
      if (res.isNotEmpty) {
        box.delete(paymentDetails);
      }
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(paymentDetailsBox);
      res = box.values.toList();
      if (res.isNotEmpty) {
        box.delete(paymentDetails);
      }
    }
  }

  static Future<void> closePaymentDetailsBox() async {
    if (Hive.isBoxOpen(paymentDetails)) {
      Box<dynamic> box = Hive.box(paymentDetails);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(paymentDetails);
      box.close();
    }
  }
  // static Future<void> saveDataToLocal(
  //     {required val, required String key}) async {
  //   if (Hive.isBoxOpen(generalAppBox)) {
  //     Box<dynamic> box = Hive.box(generalAppBox);
  //     box.put(key, val);
  //   } else {
  //     Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
  //     box.put(key, val);
  //   }
  // }

  static Future<void> addUpgradePlanDetails(
      {required val, required String key}) async {
    if (Hive.isBoxOpen(upgradePlanDetailsBox)) {
      Box<dynamic> box = Hive.box(upgradePlanDetailsBox);
      box.put(key, val);
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(upgradePlanDetailsBox);
      box.put(key, val);
    }
  }
  // static Future<dynamic> getDataFromLocal(String key) async {
  //   dynamic res;
  //   if (Hive.isBoxOpen(generalAppBox)) {
  //     Box<dynamic> box = Hive.box(generalAppBox);
  //     res = box.get(key);
  //   } else {
  //     Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
  //     res = box.get(key);
  //   }
  //   return res;
  // }

  static Future<dynamic> getUpgradePlanDetails() async {
    dynamic res;
    if (Hive.isBoxOpen(upgradePlanDetailsBox)) {
      Box<dynamic> box = Hive.box(upgradePlanDetailsBox);
      print(box.keys);
      print(box.values);
      res = box.get(HiveServices.upgradePlanDetails);

    } else {
      Box<dynamic> box = await Hive.openBox(upgradePlanDetailsBox);
      res = box.get(HiveServices.upgradePlanDetails);
    }
    return res;
  }

  static Future<void> deleteUpgradePlanDetails() async {
    List res;
    if (Hive.isBoxOpen(upgradePlanDetailsBox)) {
      Box<dynamic> box = Hive.box(upgradePlanDetailsBox);
      res = box.values.toList();
      if (res.isNotEmpty) {
        box.delete(upgradePlanDetailsBox);
      }
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(upgradePlanDetailsBox);
      res = box.values.toList();
      if (res.isNotEmpty) {
        box.delete(upgradePlanDetailsBox);
      }
    }
  }

  static Future<void> closeUpgradePlanDetails() async {
    if (Hive.isBoxOpen(upgradePlanDetailsBox)) {
      Box<dynamic> box = Hive.box(upgradePlanDetailsBox);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(upgradePlanDetailsBox);
      box.close();
    }
  }

  static Future<void> closeHiveBox() async {
    if (Hive.isBoxOpen(generalAppBox)) {
      Box<dynamic> box = Hive.box(generalAppBox);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(generalAppBox);
      box.close();
    }
  }

  static Future<void> closeRecentlySearchedBox() async {
    if (Hive.isBoxOpen(recentSearchBox)) {
      Box<dynamic> box = Hive.box(recentSearchBox);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(recentSearchBox);
      box.close();
    }
  }

  static Future<void> deleteItemFromRecentlySearchedList(String value) async {
    dynamic res;
    if (Hive.isBoxOpen(recentSearchBox)) {
      Box<dynamic> box = Hive.box(recentSearchBox);
      res = box.values.toList();
      for (int i = 0; i < res.length; i++) {
        if (res[i] == value) {
          box.deleteAt(i);
        }
      }
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(recentSearchBox);
      res = box.values.toList();
      for (int i = 0; i < res.length; i++) {
        if (res[i] == value) {
          box.deleteAt(i);
        }
      }
    }
  }
}
