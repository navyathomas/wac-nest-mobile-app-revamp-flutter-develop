import '../services/helpers.dart';

class RegistrationResModel {
  bool? status;
  String? message;
  int? statusCode;
  Errors? errors;
  ResponseData? responseData;

  RegistrationResModel(
      {this.status, this.message, this.statusCode, this.errors});

  RegistrationResModel.fromJson(Map<String, dynamic> json) {
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
  Errors({this.mobile, this.nestId, this.interestId, this.password});

  Errors.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    nestId = json['nest_id'];
    interestId = json['interest_id'];
    password = json['current_password'];
  }
}

class ResponseData {
  String? accessToken;

  ResponseData({this.accessToken});

  ResponseData.fromJson(Map<String, dynamic> json) {
    accessToken = json['token'] != null ? json['token']['access_token'] : null;
  }
}
