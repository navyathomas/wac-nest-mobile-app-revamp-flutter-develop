import 'package:nest_matrimony/models/res_status_model.dart';

class ReligionListModel extends ResStatusModel {
  List<ReligionListData>? data;

  ReligionListModel({this.data});

  ReligionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReligionListData>[];
      json['data'].forEach((v) {
        data!.add(ReligionListData.fromJson(v));
      });
    }
  }
}

class ReligionListData {
  int? id;
  String? religionName;

  ReligionListData({this.id, this.religionName});

  ReligionListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religionName = json['religion_name'];
  }
  Map<String, dynamic> toJson() => {
        "religion_name": religionName,
        "id": id,
      };
}
