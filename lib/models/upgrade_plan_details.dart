class UpgradePlanDetails {
  int? userId;
  String? clientName;
  String? clientEmail;
  String? clientAddress;
  String? paymentPurpose;
  String? razorpayPaymentId;
  String? razorpayStatus;
  int? planId;
  int? offerAmount;
  int? offerCode;
  int? paymentAmount;
  String? razorpayOrderId;
  String? razorpaySignature;
  int? totalAmount;
  UpgradePlanDetails(
      {this.offerAmount,
      this.planId,
      this.offerCode,
      this.paymentAmount,
      this.razorpayPaymentId,
      this.razorpayStatus,
      this.razorpayOrderId,
      this.razorpaySignature,
      this.paymentPurpose,
      this.clientName,
      this.clientAddress,
      this.clientEmail,
      this.userId,
      this.totalAmount});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['razorpay_order_id'] = razorpayOrderId;
    data['razorpay_payment_id'] = razorpayPaymentId;
    data['razor_status'] = razorpayStatus;
    data['plan_id'] = planId;
    data['offer_amount'] = offerAmount;
    data['offer_code'] = offerCode;
    data['razorpay_signature'] = razorpaySignature;
    data['users_id'] = userId;
    data['client_name'] = clientName;
    data['client_email'] = clientEmail;
    data['client_address'] = clientAddress;
    data['payment_purpose'] = paymentPurpose;
    data['payment_amount'] = paymentAmount;
    data['total_amount'] = totalAmount;
    return data;
  }

  UpgradePlanDetails.fromJson(Map<String, dynamic> json) {
    paymentAmount = json['payment_amount'];
    planId = json['plan_id'];
    razorpayStatus = json['razor_status'];
    offerAmount = json['offer_amount'];
    razorpayOrderId = json['razorpay_order_id'];
    razorpayPaymentId = json['razorpay_payment_id'];
    razorpaySignature = json['razorpay_signature'];
    offerCode = json['offer_code'];
    userId = json['users_id'];
    clientName = json['client_name'];
    clientEmail = json['client_email'];
    clientAddress = json['client_address'];
    paymentPurpose = json['payment_purpose'];
    totalAmount = json['total_amount'];
  }
}
