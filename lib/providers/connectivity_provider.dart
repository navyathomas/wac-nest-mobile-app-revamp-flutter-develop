import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider() {
    updateEnableRefresh();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      resultHandler(result);
    });
  }

  bool enableRefresh = false;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isConnected = true;

  ConnectivityResult get connectivity => _connectivityResult;
  bool get isConnected => _isConnected;

  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      enableRefresh = true;
      _isConnected = false;
    } else if (result == ConnectivityResult.mobile) {
      _isConnected = true;
    } else if (result == ConnectivityResult.wifi) {
      _isConnected = true;
    }
    notifyListeners();
  }

  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    resultHandler(connectivityResult);
  }

  void updateEnableRefresh() {
    enableRefresh = false;
    notifyListeners();
  }
}
