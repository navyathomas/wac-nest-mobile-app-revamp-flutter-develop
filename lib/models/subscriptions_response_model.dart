class SubscriptionsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<SubscriptionData>? data;

  SubscriptionsResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  SubscriptionsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubscriptionData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionData.fromJson(v));
      });
    }
  }
}

class SubscriptionData {
  int? id;
  String? subscriptionTitle;
  int? subscriptionPrice;
  int? subscriptionTypesId;
  SubscriptionType? subscriptionType;
  String? iosInappTitle;
  int? iosInAppAmount;
  SubscriptionData(
      {this.id,
      this.subscriptionTitle,
      this.subscriptionPrice,
      this.subscriptionTypesId,
      this.subscriptionType,
      this.iosInappTitle,
      this.iosInAppAmount});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionTitle = json['subscription_title'];
    iosInappTitle = json['ios_inapp_title'];
    iosInAppAmount = json['ios_inapp_amount'];
    subscriptionPrice = json['subscription_price'];
    subscriptionTypesId = json['subscription_types_id'];
    subscriptionType = json['subscription_type'] != null
        ? SubscriptionType.fromJson(json['subscription_type'])
        : null;
  }
}

class SubscriptionType {
  int? id;
  String? subscriptionType;

  SubscriptionType({this.id, this.subscriptionType});

  SubscriptionType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionType = json['subscription_type'];
  }
}
