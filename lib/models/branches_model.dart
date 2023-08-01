import 'dart:convert';

BranchesModel branchesModelFromJson(String str) =>
    BranchesModel.fromJson(json.decode(str));

String branchesModelToJson(BranchesModel data) => json.encode(data.toJson());

class BranchesModel {
  BranchesModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  List<Datum>? data;

  factory BranchesModel.fromJson(Map<String, dynamic> json) => BranchesModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.branchName,
    this.branchCode,
    this.branchAddress,
    this.countryId,
    this.stateId,
    this.districtId,
    this.locationsId,
    this.landLine,
    this.whatsappNo,
    this.mobile1,
    this.mobile2,
    this.email,
    this.landMark,
    this.latitude,
    this.longitude,
  });

  int? id;
  String? branchName;
  String? branchCode;
  String? branchAddress;
  int? countryId;
  int? stateId;
  int? districtId;
  int? locationsId;
  String? landLine;
  String? whatsappNo;
  String? mobile1;
  String? mobile2;
  String? email;
  String? landMark;
  String? latitude;
  String? longitude;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        branchName: json["branch_name"],
        branchCode: json["branch_code"],
        branchAddress: json["branch_address"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        locationsId: json["locations_id"],
        landLine: json["land_line"],
        whatsappNo: json["whatsapp_no"],
        mobile1: json["mobile_1"],
        mobile2: json["mobile_2"],
        email: json["email"],
        landMark: json["land_mark"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName,
        "branch_code": branchCode,
        "branch_address": branchAddress,
        "country_id": countryId,
        "state_id": stateId,
        "district_id": districtId,
        "locations_id": locationsId,
        "land_line": landLine,
        "whatsapp_no": whatsappNo,
        "mobile_1": mobile1,
        "mobile_2": mobile2,
        "email": email,
        "land_mark": landMark,
        "latitude": latitude,
        "longitude": longitude,
      };
}
