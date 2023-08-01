import 'package:nest_matrimony/models/res_status_model.dart';

class HeightDataModel extends ResStatusModel {
  List<HeightData>? heightData;

  HeightDataModel({this.heightData});

  HeightDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      heightData = <HeightData>[];
      json['data'].forEach((v) {
        heightData!.add(HeightData.fromJson(v));
      });
    }
  }
}

class HeightData {
  int? id;
  String? height;
  int? heightValue;

  HeightData({this.id, this.height, this.heightValue});

  HeightData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    height = json['height'];
    heightValue = json['height_value'];
  }
}
