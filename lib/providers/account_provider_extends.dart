import 'dart:developer';

import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/blocked_users_model.dart' as blocked;
import 'package:nest_matrimony/models/horoscope_images_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:flutter/material.dart';

import '../services/http_requests.dart';

class AccountProviderExtends extends ChangeNotifier with BaseProviderClass {
  List<blocked.Datum> blockedUsersList = [];

  // BLOCKED USERS LIST
  getBlockedUsers({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    debugPrint('loader state $loaderState');
    var res = await serviceConfig.getBlockedUsers();
    if (res.isValue) {
      blocked.BlockedUsersModel model = res.asValue!.value;
      blockedUsersList = model.data ?? [];
      log("SUCCESS : ${model.message}");

      updateLoaderState(LoaderState.loaded);
      if (onSuccess != null) onSuccess();
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  init() {
    blockedUsersList = [];
    notifyListeners();
  }

  // edit horoscope section
HoroscopeImagesModel ? horoImage;
List<Datum>? horoscopeList;
  getHoroscope({Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.getHoroscopeimages();
    if (res.isValue) {
      horoImage = res.asValue!.value;
      log("SUCCESS : ${horoImage?.message}");
      horoscopeList=horoImage?.data??[];
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    // return seeAllPlans;
    notifyListeners();
  }

  // edit horoscope section close

}
