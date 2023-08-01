import 'package:nest_matrimony/models/res_status_model.dart';

class ComplexionListModel extends ResStatusModel {
  List<ComplexionData>? complexionData;

  ComplexionListModel({this.complexionData});

  ComplexionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      complexionData = <ComplexionData>[];
      json['data'].forEach((v) {
        complexionData!.add(ComplexionData.fromJson(v));
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

class ComplexionData {
  int? id;
  String? complexionTitle;

  ComplexionData({this.id, this.complexionTitle});

  ComplexionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complexionTitle = json['complexion_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['complexion_title'] = complexionTitle;
    return data;
  }
}
