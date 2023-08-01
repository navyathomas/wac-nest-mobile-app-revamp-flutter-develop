import 'dart:convert';

MakePrimaryModel makePrimaryModelFromJson(String str) =>
    MakePrimaryModel.fromJson(json.decode(str));

String makePrimaryModelToJson(MakePrimaryModel data) =>
    json.encode(data.toJson());

class MakePrimaryModel {
  MakePrimaryModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory MakePrimaryModel.fromJson(Map<String, dynamic> json) =>
      MakePrimaryModel(
        status: json["status"] == null ? null : json["status"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": data == null ? null : data?.toJson(),
      };
}

class Data {
  Data({
    this.status,
    this.msg,
  });

  bool? status;
  String? msg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
      };
}
