class ComplexionModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Complexion>? complexionData;

  ComplexionModel(
      {this.status, this.statusCode, this.message, this.complexionData});

  ComplexionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      complexionData = <Complexion>[];
      json['data'].forEach((v) {
        complexionData!.add(Complexion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (complexionData != null) {
      data['data'] = complexionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Complexion {
  int? id;
  String? complexion;

  Complexion({this.id, this.complexion});

  Complexion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complexion = json['complexion_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['complexion_title'] = complexion;
    return data;
  }
}
