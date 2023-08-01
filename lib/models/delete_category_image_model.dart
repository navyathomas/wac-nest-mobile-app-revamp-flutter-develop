import 'dart:convert';

DeleteCategoryModel deleteCategoryModelFromJson(String str) =>
    DeleteCategoryModel.fromJson(json.decode(str));

String deleteCategoryModelToJson(DeleteCategoryModel data) =>
    json.encode(data.toJson());

class DeleteCategoryModel {
  DeleteCategoryModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  int? data;

  factory DeleteCategoryModel.fromJson(Map<String, dynamic> json) =>
      DeleteCategoryModel(
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
