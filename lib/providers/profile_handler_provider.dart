import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../models/profile_detail_default_model.dart';

class ProfileHandlerProvider extends ChangeNotifier with BaseProviderClass {
  int selectedInterestId = 1;

  Future<void> sendInterestRequest(BuildContext context,
      {required int profileId,
      int sendInterestId = 1,
      Function? onSuccess}) async {
    ReusableWidgets.customCircularLoader(context);
    Result res =
        await serviceConfig.sendInterestRequest(profileId, sendInterestId);
    if (res.isValue) {
      ResponseModel? responseModel = res.asValue?.value;
      updateBtnLoader(false);
      if (responseModel?.message != null) {
        Helpers.successToast(responseModel!.message!);
      }
      context.rootPop;
      if (onSuccess != null) onSuccess(responseModel?.status ?? false);
    } else {
      if (res.asError?.error != null && res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
        if (onSuccess != null) onSuccess(false);
        context.rootPop;
      } else {
        if (onSuccess != null) onSuccess(false);
        context.rootPop;
      }
    }
  }

  Future<void> shortListProfileRequest(BuildContext context, int profileId,
      {Function? onSuccess}) async {
    ReusableWidgets.customCircularLoader(context);
    Result res = await serviceConfig.shortListProfileRequest(profileId);
    if (res.isValue) {
      ResponseModel? responseModel = res.asValue?.value;
      updateBtnLoader(false);
      if (responseModel?.message != null) {
        Helpers.successToast(responseModel!.message!);
      }
      context.rootPop;
      if (onSuccess != null) onSuccess(responseModel?.status ?? false);
    } else {
      if (res.asError?.error != null && res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
        if (onSuccess != null) onSuccess(false);
        context.rootPop;
      } else {
        if (onSuccess != null) onSuccess(false);
        context.rootPop;
      }
    }
  }

  Future<void> removerFromShortList(BuildContext context,
      {Function? onSuccess}) async {
    ReusableWidgets.customCircularLoader(context);
    List<ProfileDetailDefaultModel> defaultProfiles =
        context.read<PartnerDetailProvider>().defaultProfiles;
    int id = defaultProfiles.isEmpty
        ? -1
        : defaultProfiles[defaultProfiles.length - 1].id ?? -1;
    Result res = await serviceConfig.removerFromShortList(id);
    if (res.isValue) {
      ResponseModel? responseModel = res.asValue?.value;
      updateBtnLoader(false);
      if (responseModel?.message != null) {
        Helpers.successToast(responseModel!.message!);
      }
      context.rootPop;
      if (onSuccess != null) onSuccess(responseModel?.status ?? false);
    } else {
      if (res.asError?.error != null && res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        updateBtnLoader(false);
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
      } else {
        updateBtnLoader(false);
        context.rootPop;
      }
    }
  }

  Future<void> reportProfileRequest(
      BuildContext context, int profileId, String response,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    Result res = await serviceConfig.reportProfile(profileId, response);
    if (res.isValue) {
      ResponseModel? responseModel = res.asValue?.value;
      updateBtnLoader(false);
      if (responseModel?.message != null) {
        Helpers.successToast(responseModel!.message!);
      }
      onSuccess == null ? context.rootPop : onSuccess();
    } else {
      if (res.asError?.error != null && res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        updateBtnLoader(false);
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
      } else {
        updateBtnLoader(false);
        context.rootPop;
      }
    }
  }

  Future<void> blockProfileRequest(BuildContext context, int userId,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    Result res = await serviceConfig.blockProfile(userId);
    if (res.isValue) {
      ResponseModel? responseModel = res.asValue?.value;
      updateBtnLoader(false);
      if (responseModel?.message != null) {
        Helpers.successToast(responseModel!.message!);
      }
      onSuccess == null ? context.rootPop : onSuccess();
    } else {
      if (res.asError?.error != null && res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        updateBtnLoader(false);
        if (responseModel.message != null) {
          Helpers.successToast(responseModel.message!);
        }
      } else {
        updateBtnLoader(false);
        context.rootPop;
      }
    }
  }

  void updatedSelectedInterestId(int id) {
    selectedInterestId = id;
    notifyListeners();
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
