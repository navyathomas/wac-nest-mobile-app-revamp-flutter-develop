class TermsCheckModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  TermsCheckModel({this.status, this.statusCode, this.message, this.data});

  TermsCheckModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  bool? termsOfUseStatus;

  Data({this.termsOfUseStatus});

  Data.fromJson(Map<String, dynamic> json) {
    termsOfUseStatus = json['terms_of_use_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terms_of_use_status'] = this.termsOfUseStatus;
    return data;
  }
}



// import 'dart:convert';

// TermsCheckModel? termsCheckModelFromJson(String str) =>
//     TermsCheckModel.fromJson(json.decode(str));

// String termsCheckModelToJson(TermsCheckModel? data) =>
//     json.encode(data!.toJson());

// class TermsCheckModel {
//   TermsCheckModel({
//     this.status,
//     this.statusCode,
//     this.message,
//     this.data,
//   });

//   bool? status;
//   int? statusCode;
//   String? message;
//   Data? data;

//   factory TermsCheckModel.fromJson(Map<String, dynamic> json) =>
//       TermsCheckModel(
//         status: json["status"],
//         statusCode: json["status_code"],
//         message: json["message"],
//         data: json["data"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "status_code": statusCode,
//         "message": message,
//         "data": data,
//       };
// }

// class Data {
//   Data({
//     this.termsOfUseStatus,
//   });

//   bool? termsOfUseStatus;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         termsOfUseStatus: json["terms_of_use_status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "terms_of_use_status": termsOfUseStatus,
//       };
// }
