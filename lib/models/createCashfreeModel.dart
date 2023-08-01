class CreateCashFreeModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  CreateCashFreeModel({this.status, this.statusCode, this.message, this.data});

  CreateCashFreeModel.fromJson(Map<String, dynamic> json) {
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
  ResponseJson? responseJson;
  int? statusCode;

  Data({this.responseJson, this.statusCode});

  Data.fromJson(Map<String, dynamic> json) {
    responseJson = json['responseJson'] != null
        ? new ResponseJson.fromJson(json['responseJson'])
        : null;
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseJson != null) {
      data['responseJson'] = this.responseJson!.toJson();
    }
    data['status_code'] = this.statusCode;
    return data;
  }
}

class ResponseJson {
  int? cfOrderId;
  String? createdAt;
  CustomerDetails? customerDetails;
  String? entity;
  int? orderAmount;
  String? orderCurrency;
  String? orderExpiryTime;
  String? orderId;
  String? orderStatus;

  String? paymentSessionId;
  Payments? payments;
  Payments? refunds;
  Payments? settlements;

  ResponseJson(
      {this.cfOrderId,
      this.createdAt,
      this.customerDetails,
      this.entity,
      this.orderAmount,
      this.orderCurrency,
      this.orderExpiryTime,
      this.orderId,
      this.orderStatus,
      this.paymentSessionId,
      this.payments,
      this.refunds,
      this.settlements});

  ResponseJson.fromJson(Map<String, dynamic> json) {
    cfOrderId = json['cf_order_id'];
    createdAt = json['created_at'];
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    entity = json['entity'];
    orderAmount = json['order_amount'];
    orderCurrency = json['order_currency'];
    orderExpiryTime = json['order_expiry_time'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];

    paymentSessionId = json['payment_session_id'];
    payments = json['payments'] != null
        ? new Payments.fromJson(json['payments'])
        : null;
    refunds =
        json['refunds'] != null ? new Payments.fromJson(json['refunds']) : null;
    settlements = json['settlements'] != null
        ? new Payments.fromJson(json['settlements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cf_order_id'] = this.cfOrderId;
    data['created_at'] = this.createdAt;
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails!.toJson();
    }
    data['entity'] = this.entity;
    data['order_amount'] = this.orderAmount;
    data['order_currency'] = this.orderCurrency;
    data['order_expiry_time'] = this.orderExpiryTime;
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;

    data['payment_session_id'] = this.paymentSessionId;
    if (this.payments != null) {
      data['payments'] = this.payments!.toJson();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds!.toJson();
    }
    if (this.settlements != null) {
      data['settlements'] = this.settlements!.toJson();
    }
    return data;
  }
}

class CustomerDetails {
  String? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;

  CustomerDetails(
      {this.customerId,
      this.customerName,
      this.customerEmail,
      this.customerPhone});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    return data;
  }
}

class Payments {
  String? url;

  Payments({this.url});

  Payments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
