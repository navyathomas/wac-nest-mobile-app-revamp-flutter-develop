import 'dart:convert';

StaffReportModel staffReportModelFromJson(String str) => StaffReportModel.fromJson(json.decode(str));

String staffReportModelToJson(StaffReportModel data) => json.encode(data.toJson());

class StaffReportModel {
    StaffReportModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool? status;
    int? statusCode;
    String? message;
    bool? data;

    factory StaffReportModel.fromJson(Map<String, dynamic> json) => StaffReportModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data,
    };
}
