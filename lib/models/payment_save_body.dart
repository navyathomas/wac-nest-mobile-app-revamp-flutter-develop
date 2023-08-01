class PaymentSaveBody {
  String? transactionId;
  String? razorpayPaymentId;
  String? razorpayStatus;
  int? planId;
  int? offerAmount;
  int? paymentId;
  int? offerCode;
  PaymentSaveBody(
      {this.transactionId,
      this.offerAmount,
      this.planId,
      this.paymentId,
      this.offerCode,
      this.razorpayPaymentId,
      this.razorpayStatus});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transction_id'] = transactionId;
    data['razor_id'] = razorpayPaymentId;
    data['razor_status'] = razorpayStatus;
    data['plan_id'] = planId;
    data['offer_amount'] = offerAmount;
    data['payment_id'] = paymentId;
    data['offer_code'] = offerCode;
    return data;
  }
}
