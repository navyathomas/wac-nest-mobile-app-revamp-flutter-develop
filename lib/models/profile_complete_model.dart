import 'dart:convert';

ProfileCompleteModel profileCompleteModelFromJson(String str) =>
    ProfileCompleteModel.fromJson(json.decode(str));

String profileCompleteModelToJson(ProfileCompleteModel data) =>
    json.encode(data.toJson());

class ProfileCompleteModel {
  ProfileCompleteModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory ProfileCompleteModel.fromJson(Map<String, dynamic> json) =>
      ProfileCompleteModel(
        status: json["status"] ?? null,
        statusCode: json["status_code"] ?? null,
        message: json["message"] ?? null,
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status ?? null,
        "status_code": statusCode ?? null,
        "message": message ?? null,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.percentage,
    this.name,
    this.nestId,
    this.userImage,
    this.userPackage,
  });

  int? percentage;
  String? name;
  String? nestId;
  UserImage? userImage;
  UserPackage? userPackage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        percentage: json["percentage"] ?? null,
        name: json["name"] ?? null,
        nestId: json["nest_id"] ?? null,
        userImage: json["user_image"] == null
            ? null
            : UserImage.fromJson(json["user_image"]),
        userPackage: json["user_package"] == null
            ? null
            : UserPackage.fromJson(json["user_package"]),
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage ?? null,
        "name": name ?? null,
        "nest_id": nestId ?? null,
        "user_image": userImage == null ? null : userImage!.toJson(),
        "user_package": userPackage == null ? null : userPackage!.toJson(),
      };
}

class UserImage {
  UserImage({
    this.id,
    this.usersId,
    this.imageFile,
    this.imageApprove,
    this.isPreference,
  });

  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;
  int? isPreference;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        id: json["id"] ?? null,
        usersId: json["users_id"] ?? null,
        imageFile: json["image_file"] ?? null,
        imageApprove: json["image_approve"] ?? null,
        isPreference: json["is_preference"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "users_id": usersId ?? null,
        "image_file": imageFile ?? null,
        "image_approve": imageApprove ?? null,
        "is_preference": isPreference ?? null,
      };
}

class UserPackage {
  UserPackage({
    this.id,
    this.subscriptionTitle,
    this.subscriptionPrice,
    this.validityMonth,
    this.premiumPackage,
    this.subscriptionType,
  });

  int? id;
  String? subscriptionTitle;
  int? subscriptionPrice;
  int? validityMonth;
  bool? premiumPackage;
  dynamic subscriptionType;

  factory UserPackage.fromJson(Map<String, dynamic> json) => UserPackage(
        id: json["id"] ?? null,
        subscriptionTitle: json["subscription_title"] ?? null,
        subscriptionPrice: json["subscription_price"] ?? null,
        validityMonth: json["validity_month"] ?? null,
        premiumPackage: json["premium_package"] ?? null,
        subscriptionType: json["subscription_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "subscription_title": subscriptionTitle ?? null,
        "subscription_price": subscriptionPrice ?? null,
        "validity_month": validityMonth ?? null,
        "premium_package": premiumPackage ?? null,
        "subscription_type": subscriptionType,
      };
}
