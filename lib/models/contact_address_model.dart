import 'package:nest_matrimony/models/res_status_model.dart';

import '../services/helpers.dart';

class ContactAddressModel extends ResStatusModel {
  ContactAddressData? data;
  Message? messageModel;

  ContactAddressModel({this.data, this.messageModel});

  ContactAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['message'] != null && json['message'].runtimeType == String) {
      message = json['message'];
    } else {
      messageModel =
          json['message'] != null ? Message.fromJson(json['message']) : null;
    }
    data =
        json['data'] != null ? ContactAddressData.fromJson(json['data']) : null;
  }
}

class Message {
  String? msg;
  int? count;

  Message({this.msg, this.count});

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    count = json['count'];
  }
}

class ContactAddressData {
  Msg? msg;

  ContactAddressData({this.msg});

  ContactAddressData.fromJson(Map<String, dynamic> json) {
    msg = json['msg'] != null ? Msg.fromJson(json['msg']) : null;
  }
}

class Msg {
  Contacts? contacts;
  String? houseAddress;
  String? email;
  String? phoneNo;
  String? whatsappNo;
  String? locationName;
  double? longitude;
  double? latitude;
  AddressCount? addressCount;

  Msg(
      {this.contacts,
      this.houseAddress,
      this.email,
      this.phoneNo,
      this.whatsappNo,
      this.locationName,
      this.longitude,
      this.latitude,
      this.addressCount});

  Msg.fromJson(Map<String, dynamic> json) {
    contacts =
        json['contacts'] != null ? Contacts.fromJson(json['contacts']) : null;
    houseAddress = json['house_address'];
    email = json['email'];
    phoneNo = json['phone_no'];
    whatsappNo = json['whatsapp_no'];
    locationName = json['location_name'];
    longitude = Helpers.convertToDouble(json['longitude']);
    latitude = Helpers.convertToDouble(json['latitude']);
    addressCount = json['address_count'] != null
        ? AddressCount.fromJson(json['address_count'])
        : null;
  }
}

class Contacts {
  String? mobile;

  Contacts({this.mobile});

  Contacts.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
  }
}

class AddressCount {
  int? userAddressViewCount;
  int? dailyAddressViewCount;

  AddressCount({this.userAddressViewCount, this.dailyAddressViewCount});

  AddressCount.fromJson(Map<String, dynamic> json) {
    userAddressViewCount = json['userAddressViewCount'];
    dailyAddressViewCount = json['dailyAddressViewCount'];
  }
}
