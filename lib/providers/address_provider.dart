import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/contact_address_model.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';

import '../models/contact_address_count_model.dart';
import '../models/response_model.dart';
import '../services/app_config.dart';

class AddressProvider extends ChangeNotifier with BaseProviderClass {
  ContactAddressModel? contactAddressModel;
  ContactAddressCountModel? contactAddressCountModel;

  Future<void> getProfileAddressData(int profileId,
      {Function? onSuccess, Function(String)? onCountZero}) async {
    updateBtnLoader(true);
    Result res = await serviceConfig.getProfileAddress(profileId);
    if (res.isValue) {
      ContactAddressModel model = res.asValue!.value;
      updateContactAddressModel(model);
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess(true);
    } else {
      updateBtnLoader(false);
      if (res.asError!.error is ContactAddressModel) {
        ContactAddressModel responseModel =
            res.asError!.error as ContactAddressModel;
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
        if (responseModel.messageModel?.count != null &&
            responseModel.messageModel!.count! < 1) {
          if (onCountZero != null)
            onCountZero(responseModel.messageModel?.msg ?? "");
        } else {
          if (onSuccess != null) onSuccess(false);
        }
      } else {
        if (onSuccess != null) onSuccess(false);
        updateBtnLoader(false);
      }
    }
  }

  Future<void> getContactAddressModel() async {
    if (AppConfig.isAuthorized) {
      ContactAddressCountModel? countModel;
      Result res = await serviceConfig.contactAddressCount();
      if (res.isValue) {
        ContactAddressCountModel? model = res.asValue?.value;
        updateBtnLoader(false);
        countModel = model;
      } else {
        countModel = null;
      }
      contactAddressCountModel = countModel;
      notifyListeners();
    }
  }

  void updateContactAddressModel(ContactAddressModel model) {
    contactAddressModel = model;
    notifyListeners();
  }

  Future<void> requestContactCount(int profileId,
      {int? limit, Function? onSuccess}) async {
    updateBtnLoader(true);
    Result res =
        await serviceConfig.requestContactCount(profileId, limit: limit);
    if (res.isValue) {
      ResponseModel responseModel = res.asValue!.value;
      updateBtnLoader(false);
      if (responseModel.message != null) {
        responseModel.message!.showToast();
      }
      if (onSuccess != null) onSuccess(true);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        if (responseModel.message != null) {
          responseModel.message!.showToast();
        }
        updateBtnLoader(false);
      } else {
        updateBtnLoader(false);
      }
    }
  }

  @override
  void pageInit() {
    btnLoader = false;
    loaderState = LoaderState.loaded;
    super.pageInit();
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
    super.updateBtnLoader(val);
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
