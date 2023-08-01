import 'package:nest_matrimony/models/res_status_model.dart';

class DistrictDataModel extends ResStatusModel {
  List<DistrictData>? districtData;

  DistrictDataModel({this.districtData});

  DistrictDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      districtData = <DistrictData>[];
      json['data'].forEach((v) {
        districtData!.add(DistrictData.fromJson(v));
      });
    }
  }
}

class DistrictData {
  int? id;
  String? districtName;

  DistrictData({this.id, this.districtName});

  DistrictData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtName = json['district_name'];
  }
}
