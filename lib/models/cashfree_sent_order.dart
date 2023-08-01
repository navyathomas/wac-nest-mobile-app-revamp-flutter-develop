// To parse this JSON data, do
//
//     final sentOrderCashFreeModel = sentOrderCashFreeModelFromJson(jsonString);

import 'dart:convert';

SentOrderCashFreeModel sentOrderCashFreeModelFromJson(String str) => SentOrderCashFreeModel.fromJson(json.decode(str));

String sentOrderCashFreeModelToJson(SentOrderCashFreeModel data) => json.encode(data.toJson());

class SentOrderCashFreeModel {
    SentOrderCashFreeModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool? status;
    int? statusCode;
    String? message;
    Data? data;

    factory SentOrderCashFreeModel.fromJson(Map<String, dynamic> json) => SentOrderCashFreeModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        // this.responseJson,
        this.statusCode,
    });

    // ResponseJson? responseJson;
    int? statusCode;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        // responseJson: json["responseJson"] == null ? null : ResponseJson.fromJson(json["responseJson"]),
        statusCode: json["status_code"],
    );

    Map<String, dynamic> toJson() => {
        // "responseJson": responseJson?.toJson(),
        "status_code": statusCode,
    };
}

class ResponseJson {
    ResponseJson({
        this.message,
        this.code,
        this.type,
    });

    String? message;
    String? code;
    String? type;

    factory ResponseJson.fromJson(Map<String, dynamic> json) => ResponseJson(
        message: json["message"],
        code: json["code"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "type": type,
    };
}
