import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nest_matrimony/common/extensions.dart';

enum InputFormats { phoneNumber, name }

class ValidationHelper {
  static String? validateMobile(
      BuildContext context, String val, int? maxLength) {
    String value = val.trim();
    String pattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value) ||
        (maxLength != null && value.length != maxLength)) {
      return context.loc.invalidMobile;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String val) {
    String value = val.trim();
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value)) {
      return null;
    } else {
      return context.loc.invalidEmail;
    }
  }

  static String? validateDate(BuildContext context, String val) {
    String value = val.trim();

    if (value.isNotEmpty) {
      return null;
    } else {
      return "Please enter a date";
    }
  }

  static String? validateName(BuildContext context, String val) {
    String value = val.trim();
    if (value.isEmpty || value == '') {
      return context.loc.invalidName;
    } else if (value.trim().length < 3) {
      return context.loc.invalidName;
    }
    return null;
  }

  static String? validateAddress(BuildContext context, String val) {
    String value = val.trim();
    if (value.isEmpty || value == '') {
      return context.loc.inValidAddress;
    } else if (value.isEmpty) {
      return context.loc.inValidAddress;
    }
    return null;
  }

  static String? validateLastName(BuildContext context, String val) {
    String value = val.trim();
    return (value.isEmpty) ? context.loc.invalidLName : null;
  }

  static String? validateText(BuildContext context, String value) {
    return (value.trim().isEmpty) ? "Field can't be empty" : null;
  }

  static List<TextInputFormatter>? inputFormatter(InputFormats inputFormats) {
    List<TextInputFormatter>? val;
    switch (inputFormats) {
      case InputFormats.phoneNumber:
        val = [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ];
        break;
      case InputFormats.name:
        val = [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))];
        break;
    }
    return val;
  }
}
