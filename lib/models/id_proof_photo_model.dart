import 'dart:convert';

OtherPhotosModel iDproofPhotosModelFromJson(String str) => OtherPhotosModel.fromJson(json.decode(str));

String iDproofPhotosModelToJson(OtherPhotosModel data) => json.encode(data.toJson());

class OtherPhotosModel {
    OtherPhotosModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool? status;
    int? statusCode;
    String ?message;
    List<Datum> ? data;

    factory OtherPhotosModel.fromJson(Map<String, dynamic> json) => OtherPhotosModel(
        status: json["status"] == null ? null : json["status"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
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

    int ?id;
    int ?usersId;
    int? userImageTypeId;
    String ?userImagePath;
    int ?isDeleted;
    int? isPriority;
    String ?createdAt;
    String ?updatedAt;
    bool ?isFeatured;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        usersId: json["users_id"] == null ? null : json["users_id"],
        userImageTypeId: json["user_image_type_id"] == null ? null : json["user_image_type_id"],
        userImagePath: json["user_image_path"] == null ? null : json["user_image_path"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        isPriority: json["is_priority"] == null ? null : json["is_priority"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        isFeatured: json["is_featured"] == null ? null : json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "users_id": usersId == null ? null : usersId,
        "user_image_type_id": userImageTypeId == null ? null : userImageTypeId,
        "user_image_path": userImagePath == null ? null : userImagePath,
        "is_deleted": isDeleted == null ? null : isDeleted,
        "is_priority": isPriority == null ? null : isPriority,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "is_featured": isFeatured == null ? null : isFeatured,
    };
}
