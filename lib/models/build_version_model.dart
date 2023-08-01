class BuildVersionModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  BuildVersionModel({this.status, this.statusCode, this.message, this.data});

  BuildVersionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? minAndroidVersion;
  int? latestAndroidVersion;
  int? minIosVersion;
  int? latestIosVersion;

  Data(
      {this.minAndroidVersion,
        this.latestAndroidVersion,
        this.minIosVersion,
        this.latestIosVersion});

  Data.fromJson(Map<String, dynamic> json) {
    minAndroidVersion = json['min_android_version'];
    latestAndroidVersion = json['latest_android_version'];
    minIosVersion = json['min_ios_version'];
    latestIosVersion = json['latest_ios_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_android_version'] = this.minAndroidVersion;
    data['latest_android_version'] = this.latestAndroidVersion;
    data['min_ios_version'] = this.minIosVersion;
    data['latest_ios_version'] = this.latestIosVersion;
    return data;
  }
}