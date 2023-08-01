class AcceptTermsModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  AcceptTermsModel({this.status, this.statusCode, this.message, this.data});

  AcceptTermsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? isAccepted;
  String? acceptedDateTime;
  String? userIpAddress;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
      this.isAccepted,
      this.acceptedDateTime,
      this.userIpAddress,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    isAccepted = json['is_accepted'];
    acceptedDateTime = json['accepted_date_time'];
    userIpAddress = json['user_ip_address'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['is_accepted'] = this.isAccepted;
    data['accepted_date_time'] = this.acceptedDateTime;
    data['user_ip_address'] = this.userIpAddress;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
