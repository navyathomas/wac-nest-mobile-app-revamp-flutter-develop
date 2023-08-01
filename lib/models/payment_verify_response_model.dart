class PaymentVerifyResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  bool? data;

  PaymentVerifyResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  PaymentVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
