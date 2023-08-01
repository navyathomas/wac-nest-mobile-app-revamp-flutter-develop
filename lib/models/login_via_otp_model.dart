// To parse this JSON data, do
//
//     final loginViaOtpModel = loginViaOtpModelFromJson(jsonString);

import 'dart:convert';

LoginViaOtpModel loginViaOtpModelFromJson(String str) =>
    LoginViaOtpModel.fromJson(json.decode(str));

String loginViaOtpModelToJson(LoginViaOtpModel data) =>
    json.encode(data.toJson());

class LoginViaOtpModel {
  LoginViaOtpModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  dynamic? data;

  factory LoginViaOtpModel.fromJson(Map<String, dynamic> json) =>
      LoginViaOtpModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data,
      };
}
