
import 'dart:convert';

BlockedUsersModel blockedUsersModelFromJson(String str) =>
    BlockedUsersModel.fromJson(json.decode(str));

String blockedUsersModelToJson(BlockedUsersModel data) =>
    json.encode(data.toJson());

class BlockedUsersModel {
  BlockedUsersModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  List<Datum>? data;

  factory BlockedUsersModel.fromJson(Map<String, dynamic> json) =>
      BlockedUsersModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.blockProfileId,
    this.profileImage,
    this.getUser,
  });

  int? id;
  int? blockProfileId;
  String? profileImage;
  GetUser? getUser;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        blockProfileId:
            json["block_profile_id"],
        profileImage:
            json["profile_image"],
        getUser: json["get_user"] == null
            ? null
            : GetUser.fromJson(json["get_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "block_profile_id": blockProfileId,
        "profile_image": profileImage,
        "get_user": getUser == null ? null : getUser?.toJson(),
      };
}

class GetUser {
  GetUser({
    this.id,
    this.name,
    this.premiumAccount,
    this.isMale,
    this.isHindu,
    this.scorePercentage,
    this.userPackage,
    this.userReligion,
  });

  int? id;
  String? name;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  int? scorePercentage;
  dynamic userPackage;
  dynamic userReligion;

  factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
        id: json["id"],
        name: json["name"],
        premiumAccount:
            json["premium_account"],
        isMale: json["is_male"],
        isHindu: json["is_hindu"],
        scorePercentage:
            json["score_percentage"],
        userPackage: json["user_package"],
        userReligion: json["user_religion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "premium_account": premiumAccount,
        "is_male": isMale,
        "is_hindu": isHindu,
        "score_percentage": scorePercentage,
        "user_package": userPackage,
        "user_religion": userReligion,
      };
}
