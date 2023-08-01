import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';

import '../models/profile_data_model.dart';
import '../models/profile_search_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';

class SimilarProfilesProvider extends ChangeNotifier with BaseProviderClass {
  int pageCount = 1;
  int totalPageLength = 0;
  bool paginationLoader = false;
  List<UserData>? userDataList;

  Future<ProfileDataModel?> getSimilarProfiles(int profileId,
      {bool enableLoader = true}) async {
    ProfileDataModel? model;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getSimilarProfiles(pageCount, profileId);
    if (res.isValue) {
      model = res.asValue!.value;
      paginationLoader = false;
      updateSimilarProfileModel(model);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
    } else {
      paginationLoader = false;
      updateSimilarProfileModel(null);
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      }
    }
    return model;
  }

  Future<ProfileDataModel?> onLoadMore(
    int profileId,
  ) async {
    ProfileDataModel? model;
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount += 1;
      notifyListeners();
      model = await getSimilarProfiles(profileId, enableLoader: false);
    }

    return model;
  }

  void updateSimilarProfileModel(ProfileDataModel? model) {
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
    userDataList = null;
    loaderState = LoaderState.loading;
    notifyListeners();
    super.pageInit();
  }

  void initPageCount() {
    pageCount = 1;
    totalPageLength = 0;
    paginationLoader = false;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
