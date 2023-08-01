//     final verifiyLoginViaOtpModel = verifiyLoginViaOtpModelFromJson(jsonString);

import 'dart:convert';

VerifiyLoginViaOtpModel verifiyLoginViaOtpModelFromJson(String str) =>
    VerifiyLoginViaOtpModel.fromJson(json.decode(str));

String verifiyLoginViaOtpModelToJson(VerifiyLoginViaOtpModel data) =>
    json.encode(data.toJson());

class VerifiyLoginViaOtpModel {
  VerifiyLoginViaOtpModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory VerifiyLoginViaOtpModel.fromJson(Map<String, dynamic> json) =>
      VerifiyLoginViaOtpModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.accessToken,
  });

  String? accessToken;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}
