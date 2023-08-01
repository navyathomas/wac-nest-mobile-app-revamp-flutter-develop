import 'package:nest_matrimony/models/res_status_model.dart';

class MaritalStatusModel extends ResStatusModel {
  List<MaritalStatus>? maritalStatusData;

  MaritalStatusModel({this.maritalStatusData});

  MaritalStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      maritalStatusData = <MaritalStatus>[];
      json['data'].forEach((v) {
        maritalStatusData!.add(MaritalStatus.fromJson(v));
      });
    }
  }
}

class MaritalStatus {
  int? id;
  String? maritalStatus;

  MaritalStatus({this.id, this.maritalStatus});

  MaritalStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maritalStatus = json['marital_status'];
  }
}
