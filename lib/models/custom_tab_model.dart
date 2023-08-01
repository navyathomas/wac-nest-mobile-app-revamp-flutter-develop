import 'package:flutter/material.dart';

import 'button_style_model.dart';

class CustomTabModel {
  ButtonStyleModel buttonStyleModel;
  List<String> tabBarTitles;
  List<Widget> tabBarViews;
  Widget tabBarChild;

    CustomTabModel(
      {required this.buttonStyleModel,
      required this.tabBarTitles,
      required this.tabBarViews,
      required this.tabBarChild});
}
