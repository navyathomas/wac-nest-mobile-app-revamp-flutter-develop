import 'package:hive/hive.dart';

part 'paymentDetails.g.dart';

@HiveType(typeId: 0)
class PaymentDetails extends HiveObject {
  @HiveField(0)
  String? razorpayPaymentId;
  @HiveField(1)
  String? razorpayStatus;
  @HiveField(2)
  int? planId;
  @HiveField(3)
  int? offerAmount;
  @HiveField(4)
  int? paymentId;
  @HiveField(5)
  int? offerCode;
  @HiveField(6)
  String? razorpayOrderId;
  @HiveField(7)
  String? razorpaySignature;
  @HiveField(8)
  int? totalAmount;
  PaymentDetails(
      {this.offerAmount,
      this.planId,
      this.paymentId,
      this.offerCode,
      this.razorpayPaymentId,
      this.razorpayStatus,
      this.razorpayOrderId,
      this.razorpaySignature,
      this.totalAmount});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['razorpay_order_id'] = razorpayOrderId;
    data['razorpay_payment_id'] = razorpayPaymentId;
    data['razor_status'] = razorpayStatus;
    data['plan_id'] = planId;
    data['offer_amount'] = offerAmount;
    data['payment_id'] = paymentId;
    data['offer_code'] = offerCode;
    data['razorpay_signature'] = razorpaySignature;
    data['total_amount'] = totalAmount;
    return data;
  }
}
