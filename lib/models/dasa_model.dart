import 'package:nest_matrimony/models/res_status_model.dart';

class DasaListModel extends ResStatusModel {
  List<DasaData>? dasaData;

  DasaListModel({this.dasaData});

  DasaListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      dasaData = <DasaData>[];
      json['data'].forEach((v) {
        dasaData!.add(DasaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (dasaData != null) {
      data['data'] = dasaData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DasaData {
  int? id;
  String? jathakamType;

  DasaData({this.id, this.jathakamType});

  DasaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jathakamType = json['jathakam_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jathakam_type'] = jathakamType;
    return data;
  }
}
