import 'package:nest_matrimony/models/res_status_model.dart';
import 'package:nest_matrimony/services/helpers.dart';

class ContactAddressCountModel extends ResStatusModel {
  Data? data;

  ContactAddressCountModel({this.data});

  ContactAddressCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? totalContactViewLimit;
  int? totalContactDailyLimit;
  Count? count;

  Data({this.totalContactViewLimit, this.totalContactDailyLimit, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    totalContactViewLimit =
        Helpers.convertToInt(json['total_contact_view_limit']);
    totalContactDailyLimit =
        Helpers.convertToInt(json['total_contact_daily_limit']);
    count = json['count'] != null ? Count.fromJson(json['count']) : null;
  }
}

class Count {
  int? userAddressViewCount;
  int? dailyAddressViewCount;

  Count({this.userAddressViewCount, this.dailyAddressViewCount});

  Count.fromJson(Map<String, dynamic> json) {
    userAddressViewCount = Helpers.convertToInt(json['userAddressViewCount']);
    dailyAddressViewCount = Helpers.convertToInt(json['dailyAddressViewCount']);
  }
}
