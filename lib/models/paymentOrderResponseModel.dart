class PaymentOrderResponseModel {
  String? id;
  String? entity;
  int? amount;
  int? amountPaid;
  int? amountDue;
  String? currency;
  String? receipt;
  String? offerId;
  String? status;
  int? attempts;
  Notes? notes;
  int? createdAt;

  PaymentOrderResponseModel(
      {this.id,
      this.entity,
      this.amount,
      this.amountPaid,
      this.amountDue,
      this.currency,
      this.receipt,
      this.offerId,
      this.status,
      this.attempts,
      this.notes,
      this.createdAt});

  PaymentOrderResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    receipt = json['receipt'];
    offerId = json['offer_id'];
    status = json['status'];
    attempts = json['attempts'];
    notes = json['notes'] != null && json['notes'].isNotEmpty
        ? Notes.fromJson(json['notes'])
        : null;
    createdAt = json['created_at'];
  }
//order_KVZVFvfVmq1yAE
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['entity'] = entity;
    data['amount'] = amount;
    data['amount_paid'] = amountPaid;
    data['amount_due'] = amountDue;
    data['currency'] = currency;
    data['receipt'] = receipt;
    data['offer_id'] = offerId;
    data['status'] = status;
    data['attempts'] = attempts;
    if (notes != null) {
      data['notes'] = notes!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Notes {
  String? notesKey1;
  String? notesKey2;

  Notes({this.notesKey1, this.notesKey2});

  Notes.fromJson(Map<String, dynamic> json) {
    notesKey1 = json['notes_key_1'];
    notesKey2 = json['notes_key_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notes_key_1'] = notesKey1;
    data['notes_key_2'] = notesKey2;
    return data;
  }
}
