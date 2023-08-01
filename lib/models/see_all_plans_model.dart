import 'dart:convert';

SeeAllPlansModel seeAllPlansModelFromJson(String str) =>
    SeeAllPlansModel.fromJson(json.decode(str));

String seeAllPlansModelToJson(SeeAllPlansModel data) =>
    json.encode(data.toJson());

class SeeAllPlansModel {
  SeeAllPlansModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  List<Datum>? data;

  factory SeeAllPlansModel.fromJson(Map<String, dynamic> json) =>
      SeeAllPlansModel(
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
  Datum(
      {this.id,
      this.subscriptionTitle,
      this.subscriptionPrice,
      this.validityMonth,
      this.extraFeatures,
      this.subscriptionTypesId,
      this.premiumPackage,
      this.subscriptionType,
      this.appData,
      this.canUpgrade,
      this.validity,
      this.iosAppTitle,this.iosInAppAmount});

  int? id;
  String? subscriptionTitle;
  int? subscriptionPrice;
  int? validityMonth;
  String? validity;
  String? extraFeatures;
  int? subscriptionTypesId;
  bool? premiumPackage;
  bool? canUpgrade;
  List<String?>? appData;
  SubscriptionType? subscriptionType;
  String? iosAppTitle;
  int ? iosInAppAmount;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? null,
        validity: json['validity'],
        subscriptionTitle: json["subscription_title"] ?? null,
        subscriptionPrice: json["subscription_price"] ?? null,
        iosAppTitle: json["ios_inapp_title"] ?? null,
        iosInAppAmount: json["ios_inapp_amount"] ?? null,
        validityMonth: json["validity_month"] ?? null,
        extraFeatures: json["extra_features"] ?? null,
        subscriptionTypesId: json["subscription_types_id"] ?? null,
        premiumPackage: json["premium_package"] ?? null,
        canUpgrade: json["can_upgrade"],
        appData: json["app_data"] == null
            ? []
            : json["app_data"] == null
                ? []
                : List<String?>.from(json["app_data"]!.map((x) => x)),
        subscriptionType: json["subscription_type"] == null
            ? null
            : SubscriptionType.fromJson(json["subscription_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "subscription_title": subscriptionTitle ?? null,
        "subscription_price": subscriptionPrice ?? null,
        "validity_month": validityMonth ?? null,
        "validity": validity ?? null,
        "extra_features": extraFeatures ?? null,
        "subscription_types_id": subscriptionTypesId ?? null,
        "premium_package": premiumPackage ?? null,
        "app_data": appData == null
            ? []
            : appData == null
                ? []
                : List<dynamic>.from(appData!.map((x) => x)),
        "can_upgrade": canUpgrade,
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
        id: json["id"] ?? null,
        subscriptionType: json["subscription_type"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "subscription_type": subscriptionType ?? null,
      };
}
