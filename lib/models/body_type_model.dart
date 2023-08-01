class BodyTypeModel {
  bool? status;
  int? statusCode;
  String? message;
  List<BodyType>? data;

  BodyTypeModel({this.status, this.statusCode, this.message, this.data});

  BodyTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BodyType>[];
      json['data'].forEach((v) {
        data!.add(BodyType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
