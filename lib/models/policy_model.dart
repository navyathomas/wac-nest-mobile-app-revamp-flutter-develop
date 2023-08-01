import 'dart:convert';

PolicyModel policyModelFromJson(String str) => PolicyModel.fromJson(json.decode(str));

String policyModelToJson(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
    PolicyModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool? status;
    int? statusCode;
    String ?message;
    String? data;

    factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        status: json["status"] ?? null,
        statusCode: json["status_code"] ?? null,
        message: json["message"] ?? null,
        data: json["data"] ?? null,
    );

    Map<String, dynamic> toJson() => {
        "status": status ?? null,
        "status_code": statusCode ?? null,
        "message": message ?? null,
        "data": data ?? null,
    };
}
