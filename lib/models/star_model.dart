import 'package:nest_matrimony/models/res_status_model.dart';

class StarListModel extends ResStatusModel {
  List<StarData>? starData;

  StarListModel({this.starData});

  StarListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      starData = <StarData>[];
      json['data'].forEach((v) {
        starData!.add(StarData.fromJson(v));
      });
    }
  }
}

class StarData {
  int? id;
  String? starName;

  StarData({this.id, this.starName});

  StarData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    starName = json['star_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['star_name'] = starName;
    return data;
  }
}
