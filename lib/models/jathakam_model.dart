class JathakamModel {
  bool? status;
  int? statusCode;
  String? message;
  List<JathakamType>? jathakamData;

  JathakamModel(
      {this.status, this.statusCode, this.message, this.jathakamData});

  JathakamModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      jathakamData = <JathakamType>[];
      json['data'].forEach((v) {
        jathakamData!.add(JathakamType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (jathakamData != null) {
      data['data'] = jathakamData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JathakamType {
  int? id;
  String? jathakamType;

  JathakamType({this.id, this.jathakamType});

  JathakamType.fromJson(Map<String, dynamic> json) {
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
