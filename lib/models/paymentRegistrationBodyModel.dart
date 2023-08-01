
class PaymentRegistrationBodyModel {
  String? clientName;
  int? clientMobile;
  String? clientEmail;
  int? countryCode;
  String? clientAddress;
  String? paymentPurpose;
  String? purposeDetails;
  PaymentRegistrationBodyModel(
      {this.clientAddress,
      this.clientEmail,
      this.clientMobile,
      this.countryCode,
      this.paymentPurpose,
      this.purposeDetails,
      this.clientName});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_name'] = clientName;
    data['client_mobile'] = clientMobile;
    data['client_email'] = clientEmail;
    data['country_code_id'] = countryCode;
    data['client_address'] = clientAddress;
    data['payment_purpose'] = paymentPurpose;
    data['purpose_details'] = purposeDetails;
    return data;
  }
}
