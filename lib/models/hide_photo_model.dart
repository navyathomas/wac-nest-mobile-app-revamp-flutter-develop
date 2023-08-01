// To parse this JSON data, do
//
//     final hidePhotoModel = hidePhotoModelFromJson(jsonString);

import 'dart:convert';

HidePhotoModel hidePhotoModelFromJson(String str) =>
    HidePhotoModel.fromJson(json.decode(str));

String hidePhotoModelToJson(HidePhotoModel data) => json.encode(data.toJson());

class HidePhotoModel {
  HidePhotoModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  bool? data;

  factory HidePhotoModel.fromJson(Map<String, dynamic> json) => HidePhotoModel(
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
