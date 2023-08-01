import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../models/mail_box_response_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';

class InterestRecievedProvider extends ChangeNotifier with BaseProviderClass {
  int pageCount = 1;
  int totalPageLength = 0;
  bool paginationLoader = false;
  int recordTotals = 0;
  List<InterestUserData>? userDataList;

  Future<InterestResponseModel?> getInterestReceivedData(
      {bool enableLoader = true}) async {
    InterestResponseModel? model;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getInterestReceivedData(pageCount);
    if (res.isValue) {
      model = res.asValue!.value;
      paginationLoader = false;
      updateInterestReceivedModel(model);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
    } else {
      paginationLoader = false;
      updateInterestReceivedModel(null);
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
      model = await getInterestReceivedData(enableLoader: false);
    }
    return model;
  }

  void updateInterestReceivedModel(InterestResponseModel? model) {
    if (pageCount == 1) {
      userDataList = model?.datas?.original?.datas ?? [];
      notifyListeners();
    } else {
      List<InterestUserData> tempUserDataList = [...?userDataList];
      userDataList = [
        ...tempUserDataList,
        ...model?.datas?.original?.datas ?? []
      ];
    }
    recordTotals = model?.datas?.original?.recordsTotal ?? 0;

    totalPageLength =
        ((model?.datas?.original?.recordsTotal ?? 10) / 10).ceil();
    notifyListeners();
  }

  @override
  void pageInit() {
    pageCount = 1;
    totalPageLength = 0;
    recordTotals = 0;
    paginationLoader = false;
    loaderState = LoaderState.loaded;
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
