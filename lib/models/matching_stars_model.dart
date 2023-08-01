import 'package:nest_matrimony/models/res_status_model.dart';

class MatchingStarsModel extends ResStatusModel {
  List<MatchingStarsData>? data;

  MatchingStarsModel({this.data});

  MatchingStarsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MatchingStarsData>[];
      json['data'].forEach((v) {
        data!.add(MatchingStarsData.fromJson(v));
      });
    }
  }
}

class MatchingStarsData {
  int? id;
  String? starName;

  MatchingStarsData({this.id, this.starName});

  MatchingStarsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    starName = json['star_name'];
  }
}
