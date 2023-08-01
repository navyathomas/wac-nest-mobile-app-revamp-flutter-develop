import 'dart:ui';

class ButtonStyleModel {
  String? selectedIcon;
  String icon;
  String title;
  List<Color> gradiantColor;

  ButtonStyleModel(
      {required this.title,
      required this.gradiantColor,
      required this.icon,
      this.selectedIcon});
}
