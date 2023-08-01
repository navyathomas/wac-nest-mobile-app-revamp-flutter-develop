import 'package:nest_matrimony/models/res_status_model.dart';

class CasteListModel extends ResStatusModel {
  CasteListData? data;

  CasteListModel({this.data});

  CasteListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? CasteListData.fromJson(json['data']) : null;
  }
}

class CasteListData {
  List<CasteData>? mostUsedCaste;
  List<CasteData>? castes;

  CasteListData({this.mostUsedCaste, this.castes});

  CasteListData.fromJson(Map<String, dynamic> json) {
    if (json['most_used_caste'] != null) {
      mostUsedCaste = <CasteData>[];
      json['most_used_caste'].forEach((v) {
        mostUsedCaste!.add(CasteData.fromJson(v));
      });
    }
    if (json['castes'] != null) {
      castes = <CasteData>[];
      json['castes'].forEach((v) {
        castes!.add(CasteData.fromJson(v));
      });
    }
  }
}

class MostUsedCaste {
  int? total;
  int? casteId;
  CasteData? userCaste;

  MostUsedCaste({this.total, this.casteId, this.userCaste});

  MostUsedCaste.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    casteId = json['caste_id'];
    userCaste = json['user_caste'] != null
        ? CasteData.fromJson(json['user_caste'])
        : null;
  }
}

class CasteData {
  String? casteName;
  int? id;

  CasteData({this.casteName, this.id});

  CasteData.fromJson(Map<String, dynamic> json) {
    casteName = json['caste_name'];
    id = json['id'];
  }
}
