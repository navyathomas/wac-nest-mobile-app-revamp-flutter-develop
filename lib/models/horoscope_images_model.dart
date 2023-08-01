import 'dart:convert';

HoroscopeImagesModel horoscopeImagesModelFromJson(String str) =>
    HoroscopeImagesModel.fromJson(json.decode(str));

String horoscopeImagesModelToJson(HoroscopeImagesModel data) =>
    json.encode(data.toJson());

class HoroscopeImagesModel {
  HoroscopeImagesModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  List<Datum>? data;

  factory HoroscopeImagesModel.fromJson(Map<String, dynamic> json) =>
      HoroscopeImagesModel(
        status: json["status"] ?? null,
        statusCode: json["status_code"] ?? null,
        message: json["message"] ?? null,
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? null,
        "status_code": statusCode ?? null,
        "message": message ?? null,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.usersId,
    this.userImageTypeId,
    this.userImagePath,
    this.isDeleted,
    this.isPriority,
    this.createdAt,
    this.updatedAt,
    this.isFeatured,
  });

  int? id;
  int? usersId;
  int? userImageTypeId;
  String? userImagePath;
  int? isDeleted;
  int? isPriority;
  String? createdAt;
  String? updatedAt;
  bool? isFeatured;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? null,
        usersId: json["users_id"] ?? null,
        userImageTypeId: json["user_image_type_id"] ?? null,
        userImagePath:
            json["user_image_path"] ?? null,
        isDeleted: json["is_deleted"] ?? null,
        isPriority: json["is_priority"] ?? null,
        createdAt: json["created_at"] ?? null,
        updatedAt: json["updated_at"] ?? null,
        isFeatured: json["is_featured"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "users_id": usersId ?? null,
        "user_image_type_id": userImageTypeId ?? null,
        "user_image_path": userImagePath ?? null,
        "is_deleted": isDeleted ?? null,
        "is_priority": isPriority ?? null,
        "created_at": createdAt ?? null,
        "updated_at": updatedAt ?? null,
        "is_featured": isFeatured ?? null,
      };
}
