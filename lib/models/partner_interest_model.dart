import 'package:nest_matrimony/models/res_status_model.dart';

class PartnerInterestModel extends ResStatusModel {
  List<InterestData>? data;

  PartnerInterestModel({this.data});

  PartnerInterestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InterestData>[];
      json['data'].forEach((v) {
        data!.add(InterestData.fromJson(v));
      });
    }
  }
}

class InterestData {
  int? key;
  String? value;

  InterestData({this.key, this.value});

  InterestData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }
}
