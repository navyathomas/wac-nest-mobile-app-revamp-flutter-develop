import 'package:nest_matrimony/models/res_status_model.dart';

class CityDataModel extends ResStatusModel {
  List<CityData>? cityData;

  CityDataModel({this.cityData});

  CityDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      cityData = <CityData>[];
      json['data'].forEach((v) {
        cityData!.add(CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cityData != null) {
      data['data'] = cityData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityData {
  String? locationName;
  int? id;

  CityData({this.locationName, this.id});

  CityData.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_name'] = locationName;
    data['id'] = id;
    return data;
  }
}
