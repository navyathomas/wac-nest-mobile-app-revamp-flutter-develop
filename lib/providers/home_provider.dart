import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:nest_matrimony/models/discover_more_model.dart';

import '../common/constants.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';

class HomeProvider extends ChangeNotifier with BaseProviderClass {
  DiscoverMoreModel? discoverMoreModel;

  Future<void> getDiscoverMoreData() async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getDiscoverMoreData();
    if (res.isValue) {
      discoverMoreModel = res.asValue!.value;
      updateDiscoverMoreModel(discoverMoreModel);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateDiscoverMoreModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  @override
  void pageInit() {
    discoverMoreModel = null;
    loaderState = LoaderState.loaded;
    notifyListeners();
    super.pageInit();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateDiscoverMoreModel(model) {
    discoverMoreModel = model;
    notifyListeners();
  }
}
