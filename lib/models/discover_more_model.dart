class DiscoverMoreModel {
  bool? status;
  int? statusCode;
  String? message;
  DiscoverMoreData? data;

  DiscoverMoreModel({this.status, this.statusCode, this.message, this.data});

  DiscoverMoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data =
        json['data'] != null ? DiscoverMoreData.fromJson(json['data']) : null;
  }
}

class DiscoverMoreData {
  City? city;
  City? proffesion;
  City? education;
  Religion? religion;

  DiscoverMoreData({this.city, this.proffesion, this.education, this.religion});

  DiscoverMoreData.fromJson(Map<String, dynamic> json) {
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    proffesion =
        json['proffesion'] != null ? City.fromJson(json['proffesion']) : null;
    education =
        json['education'] != null ? City.fromJson(json['education']) : null;
    religion =
        json['religion'] != null ? Religion.fromJson(json['religion']) : null;
  }
}

class City {
  int? id;
  int? matches;

  City({this.id, this.matches});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matches = json['matches'];
  }
}

class Religion {
  int? id;
  int? matches;

  Religion({this.id, this.matches});

  Religion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matches = json['matches'];
  }
}
