import '../services/helpers.dart';

class ResponseModel {
  bool? status;
  String? message;
  int? statusCode;
  Errors? errors;
  ResponseData? responseData;

  ResponseModel({this.status, this.message, this.statusCode, this.errors});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    statusCode = Helpers.convertToInt(json['status_code']);
    errors = (json['errors'] != null && json['errors'].runtimeType != List)
        ? Errors.fromJson(json['errors'])
        : null;
    responseData =
        json['data'] != null ? ResponseData.fromJson(json['data']) : null;
  }
}

class Errors {
  String? mobile;
  String? nestId;
  String? interestId;
  String? password;
  String? offerCode;
  String? passcheck;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? clientName;
  Errors(
      {this.mobile,
      this.nestId,
      this.interestId,
      this.password,
      this.offerCode,
      this.passcheck,
      this.countryCode,
      this.phoneNumber,
      this.email,
      this.clientName});

  Errors.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    nestId = json['nest_id'];
    interestId = json['interest_id'];
    password = json['current_password'];
    offerCode = json['offer_code'];
    passcheck = json['password'];
    email = json['email'];
    phoneNumber = json['phone'];
    countryCode = json['country_code_id'];
    clientName = json['client_name'];
  }
}

class ResponseData {
  String? accessToken;
  String? status;
  String? email;

  ResponseData({this.accessToken, this.status, this.email});

  ResponseData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    status = json['status'];
    email = json['email'];
  }
}
