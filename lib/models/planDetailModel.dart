// To parse this JSON data, do
//
//     final planDetailModel = planDetailModelFromJson(jsonString);

import 'dart:convert';

PlanDetailModel planDetailModelFromJson(String str) => PlanDetailModel.fromJson(json.decode(str));

String planDetailModelToJson(PlanDetailModel data) => json.encode(data.toJson());

class PlanDetailModel {
    PlanDetailModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool ?status;
    int ?statusCode;
    String? message;
    Data? data;

    factory PlanDetailModel.fromJson(Map<String, dynamic> json) => PlanDetailModel(
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
        this.id,
        this.subscriptionTitle,
        this.subscriptionPrice,
        this.validityMonth,
        this.subscriptionTypesId,
        this.addressViewFeature,
        this.addressViewCount,
        this.chatFeature,
        this.dailyAddressViewLimit,
        this.interestExpressFeature,
        this.interestExpressCount,
        this.totalCount,
        this.extraFeatures,
        this.isDeleted,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.mrpPrice,
        this.canUpgrade,
        this.premiumPackage,
        this.subscriptionType,
        this.appData,
    });

    int? id;
    String ?subscriptionTitle;
    int ?subscriptionPrice;
    int ?validityMonth;
    int? subscriptionTypesId;
    String? addressViewFeature;
    int? addressViewCount;
    String? chatFeature;
    int ?dailyAddressViewLimit;
    String ?interestExpressFeature;
    int? interestExpressCount;
    dynamic totalCount;
    String ?extraFeatures;
    int ?isDeleted;
    int ?addedBy;
    String ?createdAt;
    String ?updatedAt;
    bool? canUpgrade;
    int ?mrpPrice;
    bool ?premiumPackage;
    List<String?>? appData;
    SubscriptionType? subscriptionType;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        subscriptionTitle: json["subscription_title"] == null ? null : json["subscription_title"],
        subscriptionPrice: json["subscription_price"] == null ? null : json["subscription_price"],
        validityMonth: json["validity_month"] == null ? null : json["validity_month"],
        subscriptionTypesId: json["subscription_types_id"] == null ? null : json["subscription_types_id"],
        addressViewFeature: json["address_view_feature"] == null ? null : json["address_view_feature"],
        addressViewCount: json["address_view_count"] == null ? null : json["address_view_count"],
        chatFeature: json["chat_feature"] == null ? null : json["chat_feature"],
        dailyAddressViewLimit: json["daily_address_view_limit"] == null ? null : json["daily_address_view_limit"],
        interestExpressFeature: json["interest_express_feature"] == null ? null : json["interest_express_feature"],
        interestExpressCount: json["interest_express_count"] == null ? null : json["interest_express_count"],
        totalCount: json["total_count"],
        extraFeatures: json["extra_features"] == null ? null : json["extra_features"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
        premiumPackage: json["premium_package"] == null ? null : json["premium_package"],
        canUpgrade: json["can_upgrade"],
        appData: json["app_data"] == null ? [] : json["app_data"] == null ? [] : List<String?>.from(json["app_data"]!.map((x) => x)),
        subscriptionType: json["subscription_type"] == null ? null : SubscriptionType.fromJson(json["subscription_type"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "subscription_title": subscriptionTitle == null ? null : subscriptionTitle,
        "subscription_price": subscriptionPrice == null ? null : subscriptionPrice,
        "validity_month": validityMonth == null ? null : validityMonth,
        "subscription_types_id": subscriptionTypesId == null ? null : subscriptionTypesId,
        "address_view_feature": addressViewFeature == null ? null : addressViewFeature,
        "address_view_count": addressViewCount == null ? null : addressViewCount,
        "chat_feature": chatFeature == null ? null : chatFeature,
        "daily_address_view_limit": dailyAddressViewLimit == null ? null : dailyAddressViewLimit,
        "interest_express_feature": interestExpressFeature == null ? null : interestExpressFeature,
        "interest_express_count": interestExpressCount == null ? null : interestExpressCount,
        "total_count": totalCount,
        "extra_features": extraFeatures == null ? null : extraFeatures,
        "is_deleted": isDeleted == null ? null : isDeleted,
        "added_by": addedBy == null ? null : addedBy,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "mrp_price": mrpPrice == null ? null : mrpPrice,
        "premium_package": premiumPackage == null ? null : premiumPackage,
        "can_upgrade": canUpgrade,
        "app_data": appData == null ? [] : appData == null ? [] : List<dynamic>.from(appData!.map((x) => x)),
        "subscription_type": subscriptionType == null ? null : subscriptionType?.toJson(),
    };
}

class SubscriptionType {
    SubscriptionType({
        this.subscriptionType,
        this.id,
    });

    String? subscriptionType;
    int ?id;

    factory SubscriptionType.fromJson(Map<String, dynamic> json) => SubscriptionType(
        subscriptionType: json["subscription_type"] == null ? null : json["subscription_type"],
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "subscription_type": subscriptionType == null ? null : subscriptionType,
        "id": id == null ? null : id,
    };
}
