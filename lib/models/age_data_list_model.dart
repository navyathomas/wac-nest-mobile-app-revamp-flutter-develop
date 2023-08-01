import 'package:nest_matrimony/models/res_status_model.dart';

class AgeDataListModel extends ResStatusModel {
  AgeListData? data;

  AgeDataListModel({this.data});

  AgeDataListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? AgeListData.fromJson(json['data']) : null;
  }
}

class AgeListData {
  List<AgeList>? ageList;
  MinimumGenderAge? minimumGenderAge;

  AgeListData({this.ageList, this.minimumGenderAge});

  AgeListData.fromJson(Map<String, dynamic> json) {
    if (json['ageList'] != null) {
      ageList = <AgeList>[];
      json['ageList'].forEach((v) {
        ageList!.add(AgeList.fromJson(v));
      });
    }
    minimumGenderAge = json['minimum_gender_age'] != null
        ? MinimumGenderAge.fromJson(json['minimum_gender_age'])
        : null;
  }
}

class AgeList {
  int? age;
  int? id;

  AgeList({this.age, this.id});

  AgeList.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    id = json['id'];
  }
}

class MinimumGenderAge {
  int? male;
  int? female;

  MinimumGenderAge({this.male, this.female});

  MinimumGenderAge.fromJson(Map<String, dynamic> json) {
    male = json['male'];
    female = json['female'];
  }
}
