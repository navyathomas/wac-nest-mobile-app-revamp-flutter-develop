class InAppEasyPayVerificationModel {
  bool ?status;
  int ?statusCode;
  String ?message;
  Data ?data;

  InAppEasyPayVerificationModel(
      {this.status, this.statusCode, this.message, this.data});

  InAppEasyPayVerificationModel.fromJson(Map<String, dynamic> json) {
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
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  bool ?success;
  String ?applePayOrderId;

  Data({this.success, this.applePayOrderId});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    applePayOrderId = json['apple_pay_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['apple_pay_order_id'] = this.applePayOrderId;
    return data;
  }
}
