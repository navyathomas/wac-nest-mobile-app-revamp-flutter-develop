import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool obscured = true;

  obscureChange() {
    obscured = !obscured;
    notifyListeners();
  }
}
