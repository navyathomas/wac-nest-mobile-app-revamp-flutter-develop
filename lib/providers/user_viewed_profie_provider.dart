import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../models/mail_box_response_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';

class UserViewedProfileProvider extends ChangeNotifier with BaseProviderClass {
  int pageCount = 1;
  int totalPageLength = 0;
  int recordTotals = 0;
  bool paginationLoader = false;
  List<InterestUserData>? interestUserDataList;

  Future<InterestResponseModel?> getNewProfileViewedData(
      {bool enableLoader = true}) async {
    InterestResponseModel? model;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getProfileViewedList(
        pageCount, 10, ViewedBy.viewedByMe);
    if (res.isValue) {
      model = res.asValue!.value;
      paginationLoader = false;
      updateNewProfileViewedModel(model);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
    } else {
      paginationLoader = false;
      updateNewProfileViewedModel(null);
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      }
    }
    return model;
  }

  Future<InterestResponseModel?> onLoadMore() async {
    InterestResponseModel? model;
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount += 1;
      notifyListeners();
      model = await getNewProfileViewedData(enableLoader: false);
    }
    return model;
  }

  void updateNewProfileViewedModel(
      InterestResponseModel? interestResponseModel) {
    if (pageCount == 1) {
      interestUserDataList =
          interestResponseModel?.datas?.original?.datas ?? [];
    } else {
      List<InterestUserData> tempUserDataList = [...?interestUserDataList];
      interestUserDataList = [
        ...tempUserDataList,
        ...interestResponseModel?.datas?.original?.datas ?? []
      ];
    }
    recordTotals = interestResponseModel?.datas?.original?.recordsTotal ?? 0;
    totalPageLength =
        ((interestResponseModel?.datas?.original?.recordsTotal ?? 10) / 10)
            .ceil();
    notifyListeners();
  }

  @override
  void pageInit() {
    pageCount = 1;
    totalPageLength = 0;
    recordTotals = 0;
    paginationLoader = false;
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
