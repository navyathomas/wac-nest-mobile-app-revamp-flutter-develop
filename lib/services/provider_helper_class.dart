import 'package:nest_matrimony/services/service_config.dart';

import '../common/constants.dart';

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoaderState loaderState = LoaderState.loaded;
  int apiCallCount = 0;
  void pageInit() {}
  void pageDispose() {}
  void updateApiCallCount() {}
  void updateLoadState(LoaderState state);
}
