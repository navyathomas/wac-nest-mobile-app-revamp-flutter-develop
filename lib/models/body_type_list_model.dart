import 'package:nest_matrimony/models/res_status_model.dart';

class BodyTypeListModel extends ResStatusModel {
  List<BodyType>? bodyTypeData;

  BodyTypeListModel({this.bodyTypeData});

  BodyTypeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      bodyTypeData = <BodyType>[];
      json['data'].forEach((v) {
        bodyTypeData!.add(BodyType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bodyTypeData != null) {
      data['data'] = bodyTypeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyType {
  int? id;
  String? bodyType;

  BodyType({this.id, this.bodyType});

  BodyType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bodyType = json['body_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['body_type'] = bodyType;
    return data;
  }
}
