class PlayerIdResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  PlayerIdResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  PlayerIdResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? userId;
  String? playerId;
  String? deviceType;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
      this.playerId,
      this.deviceType,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    playerId = json['player_id'];
    deviceType = json['device_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['player_id'] = playerId;
    data['device_type'] = deviceType;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
