import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/models/profile_data_model.dart';

import '../common/constants.dart';
import '../models/profile_search_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';

class NewJoinProvider extends ChangeNotifier with BaseProviderClass {
  int pageCount = 1;
  int totalPageLength = 0;
  bool paginationLoader = false;
  int recordTotals = 0;
  List<UserData>? userDataList;

  Future<ProfileDataModel?> getNewProfileData(
      {bool enableLoader = true}) async {
    ProfileDataModel? model;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getNewProfileData(pageCount);
    if (res.isValue) {
      model = res.asValue!.value;
      paginationLoader = false;
      updateNewJoinModel(model);
      if (enableLoader) updateLoaderState(LoaderState.error);
    } else {
      paginationLoader = false;
      recordTotals = 0;
      updateNewJoinModel(null);
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      }
    }
    return model;
  }

  Future<ProfileDataModel?> onLoadMore() async {
    ProfileDataModel? model;
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount += 1;
      notifyListeners();
      model = await getNewProfileData(enableLoader: false);
    }
    return model;
  }

  void updateNewJoinModel(ProfileDataModel? model) {
    if (pageCount == 1) {
      userDataList = model?.profileData?.original?.data ?? [];
      notifyListeners();
    } else {
      List<UserData> tempUserDataList = [...?userDataList];
      userDataList = [
        ...tempUserDataList,
        ...model?.profileData?.original?.data ?? []
      ];
    }
    recordTotals = model?.profileData?.original?.recordsTotal ?? 0;
    totalPageLength =
        ((model?.profileData?.original?.recordsTotal ?? 10) / 10).ceil();
    notifyListeners();
  }

  @override
  void pageInit() {
    pageCount = 1;
    totalPageLength = 0;
    paginationLoader = false;
    loaderState = LoaderState.loaded;
    notifyListeners();
    super.pageInit();
  }

  void updateRecordTotals(int val) {
    recordTotals = val;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
