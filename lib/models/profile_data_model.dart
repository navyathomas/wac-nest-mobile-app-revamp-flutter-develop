import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/models/res_status_model.dart';

class ProfileDataModel extends ResStatusModel {
  ProfileData? profileData;

  ProfileDataModel({this.profileData});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    profileData =
        json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }
}

class ProfileData {
  Original? original;
  dynamic exception;

  ProfileData({this.original, this.exception});

  ProfileData.fromJson(Map<String, dynamic> json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }
}
