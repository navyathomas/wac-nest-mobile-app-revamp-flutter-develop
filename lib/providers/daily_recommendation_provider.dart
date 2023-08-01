import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';

import '../models/profile_data_model.dart';
import '../models/profile_search_model.dart';
import '../services/http_requests.dart';

class DailyRecommendationProvider extends ChangeNotifier
    with BaseProviderClass {
  int pageCount = 1;
  int totalPageLength = 0;
  bool paginationLoader = false;
  int recordTotals = 0;
  List<UserData>? userDataList;

  Future<ProfileDataModel?> getDailyRecommendation(
      {bool enableLoader = true}) async {
    ProfileDataModel? model;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getDailyRecommendation(pageCount);
    if (res.isValue) {
      model = res.asValue!.value;
      paginationLoader = false;
      recordTotals = model?.profileData?.original?.recordsTotal ?? 0;
      updateRecommendationModel(model);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
    } else {
      paginationLoader = false;
      recordTotals = 0;
      updateRecommendationModel(null);
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
      model = await getDailyRecommendation(enableLoader: false);
    }

    return model;
  }

  void updateRecommendationModel(ProfileDataModel? model) {
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
    totalPageLength =
        ((model?.profileData?.original?.recordsTotal ?? 10) / 10).ceil();
    notifyListeners();
  }

  @override
  void pageInit() {
    pageCount = 1;
    totalPageLength = 0;
    paginationLoader = false;
    recordTotals = 0;
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
