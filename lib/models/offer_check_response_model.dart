class OfferCheckResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  OfferCheckResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  OfferCheckResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? msg;
  bool? status;
  int? amount;
  int? offerAmount;
  int? totalAmount;

  Data(
      {this.id,
      this.msg,
      this.status,
      this.amount,
      this.offerAmount,
      this.totalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    status = json['status'];
    amount = json['amount'];
    offerAmount = json['offer_amount'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['msg'] = msg;
    data['status'] = status;
    data['amount'] = amount;
    data['offer_amount'] = offerAmount;
    data['total_amount'] = totalAmount;
    return data;
  }
}
