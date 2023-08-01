class AppVersionModel {
  bool? status;
  Data? data;

  AppVersionModel({this.status, this.data});

  AppVersionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? version;

  Data({this.version});

  Data.fromJson(Map<String, dynamic> json) {
    version = json['version'];
  }
}
