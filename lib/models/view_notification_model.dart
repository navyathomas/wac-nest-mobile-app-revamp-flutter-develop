class ViewNotificationResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  ViewNotificationData? data;

  ViewNotificationResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  ViewNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null
        ? ViewNotificationData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ViewNotificationData {
  bool? status;
  NotificationData? notificationData;

  ViewNotificationData({this.status, this.notificationData});

  ViewNotificationData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notificationData = json['notification_data'] != null
        ? NotificationData.fromJson(json['notification_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notificationData != null) {
      data['notification_data'] = notificationData!.toJson();
    }
    return data;
  }
}

class NotificationData {
  int? id;
  int? userFromId;
  int? userToId;
  String? notificationType;
  String? notificationMsg;
  String? isViewed;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.id,
      this.userFromId,
      this.userToId,
      this.notificationType,
      this.notificationMsg,
      this.isViewed,
      this.createdAt,
      this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFromId = json['user_from_id'];
    userToId = json['user_to_id'];
    notificationType = json['notification_type'];
    notificationMsg = json['notification_msg'];
    isViewed = json['is_viewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_from_id'] = userFromId;
    data['user_to_id'] = userToId;
    data['notification_type'] = notificationType;
    data['notification_msg'] = notificationMsg;
    data['is_viewed'] = isViewed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
