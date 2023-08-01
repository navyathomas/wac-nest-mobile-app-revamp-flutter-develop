// To parse this JSON data, do
//
//     final higherPlansModel = higherPlansModelFromJson(jsonString);

import 'dart:convert';

HigherPlansModel higherPlansModelFromJson(String str) =>
    HigherPlansModel.fromJson(json.decode(str));

String higherPlansModelToJson(HigherPlansModel data) =>
    json.encode(data.toJson());

class HigherPlansModel {
  HigherPlansModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  List<Datum>? data;

  factory HigherPlansModel.fromJson(Map<String, dynamic> json) =>
      HigherPlansModel(
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
  Datum(
      {this.id,
      this.subscriptionTitle,
      this.subscriptionTypesId,
      this.subscriptionPrice,
      this.validityMonth,
      this.extraFeatures,
      this.premiumPackage,
      this.subscriptionType,
      this.validity,
      this.iosAppTitle,this.iosInAppAmount});

  int? id;
  String? subscriptionTitle;
  int? subscriptionTypesId;
  int? subscriptionPrice;
  int? validityMonth;
  String? validity;
  String? extraFeatures;
  bool? premiumPackage;
  SubscriptionType? subscriptionType;
  String? iosAppTitle;
  int ? iosInAppAmount;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        subscriptionTitle: json["subscription_title"] == null
            ? null
            : json["subscription_title"],
        subscriptionTypesId: json["subscription_types_id"] == null
            ? null
            : json["subscription_types_id"],
        subscriptionPrice: json["subscription_price"] == null
            ? null
            : json["subscription_price"],

        iosAppTitle: json["ios_inapp_title"] ?? null,
        iosInAppAmount: json["ios_inapp_amount"]??null,
        validityMonth: json["validity_month"],
        validity: json["validity"],
        extraFeatures: json["extra_features"],
        premiumPackage: json["premium_package"],
        subscriptionType: json["subscription_type"] == null
            ? null
            : SubscriptionType.fromJson(json["subscription_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "subscription_title":
            subscriptionTitle == null ? null : subscriptionTitle,
        "subscription_types_id":
            subscriptionTypesId == null ? null : subscriptionTypesId,
        "subscription_price":
            subscriptionPrice == null ? null : subscriptionPrice,
        "validity_month": validityMonth == null ? null : validityMonth,
        "extra_features": extraFeatures == null ? null : extraFeatures,
        "premium_package": premiumPackage == null ? null : premiumPackage,
        "subscription_type":
            subscriptionType == null ? null : subscriptionType?.toJson(),
      };
}

class SubscriptionType {
  SubscriptionType({
    this.id,
    this.subscriptionType,
  });

  int? id;
  String? subscriptionType;

  factory SubscriptionType.fromJson(Map<String, dynamic> json) =>
      SubscriptionType(
        id: json["id"] == null ? null : json["id"],
        subscriptionType: json["subscription_type"] == null
            ? null
            : json["subscription_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "subscription_type": subscriptionType == null ? null : subscriptionType,
      };
}

// import 'dart:convert';

// HigherPlansModel higherPlansModelFromJson(String str) =>
//     HigherPlansModel.fromJson(json.decode(str));

// String higherPlansModelToJson(HigherPlansModel data) =>
//     json.encode(data.toJson());

// class HigherPlansModel {
//   HigherPlansModel({
//     this.status,
//     this.statusCode,
//     this.message,
//     this.data,
//   });

//   bool? status;
//   int? statusCode;
//   String? message;
//   List<Datum>? data;

//   factory HigherPlansModel.fromJson(Map<String, dynamic> json) =>
//       HigherPlansModel(
//         status: json["status"] ?? null,
//         statusCode: json["status_code"] ?? null,
//         message: json["message"] ?? null,
//         data: json["data"] == null
//             ? null
//             : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status ?? null,
//         "status_code": statusCode ?? null,
//         "message": message ?? null,
//         "data": data == null
//             ? null
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   Datum({
//     this.id,
//     this.subscriptionTitle,
//     this.subscriptionPrice,
//     this.validityMonth,
//     this.extraFeatures,
//     this.premiumPackage,
//   });

//   int? id;
//   String? subscriptionTitle;
//   int? subscriptionPrice;
//   int? validityMonth;
//   String? extraFeatures;
//   bool? premiumPackage;

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"] ?? null,
//         subscriptionTitle: json["subscription_title"] ?? null,
//         subscriptionPrice: json["subscription_price"] ?? null,
//         validityMonth:
//             json["validity_month"] ?? null,
//         extraFeatures:
//             json["extra_features"] ?? null,
//         premiumPackage:
//             json["premium_package"] ?? null,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id ?? null,
//         "subscription_title":
//             subscriptionTitle ?? null,
//         "subscription_price":
//             subscriptionPrice ?? null,
//         "validity_month": validityMonth ?? null,
//         "extra_features": extraFeatures ?? null,
//         "premium_package": premiumPackage ?? null,
//       };
// }
