import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:nest_matrimony/services/shared_preference_helper.dart';

import 'app_config.dart';

enum Exceptions { socketErr, serverErr, err, noData, authError }

class HttpReq {
  static final HttpReq _instance = HttpReq._internal();

  factory HttpReq() => _instance;

  HttpReq._internal();

  static const String _appJson = 'application/json';

  static Future<String> get token async {
    return AppConfig.accessToken == null
        ? await SharedPreferenceHelper.getToken()
        : AppConfig.accessToken!;
  }

  static String _fetchUrl(String endPoint) {
    dev.log(AppConfig.baseUrl + endPoint, name: 'URL');
    return AppConfig.baseUrl + endPoint;
  }

  static Future<Result> postRequest(String endpoint, {Map? parameters}) async {
    try {
      print(parameters);
      String bearerToken = await token;
      var response = await http
          .post(
            Uri.parse(_fetchUrl(endpoint)),
            headers: {
              HttpHeaders.acceptHeader: _appJson,
              HttpHeaders.contentTypeHeader: _appJson,
              HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
            },
            body: parameters != null ? json.encode(parameters) : null,
          )
          .timeout(const Duration(seconds: 60));

      return _returnResponse(response, endpoint);
    } on SocketException {
      return Result.error(Exceptions.socketErr);
    } on ServerSocket {
      return Result.error(Exceptions.serverErr);
    } on FormatException {
      return Result.error(Exceptions.err);
    } on HandshakeException {
      return Result.error(Exceptions.serverErr);
    } on Exception {
      return Result.error(Exceptions.serverErr);
    }
  }

  static Future<Result> postRequestForPayment(String endpoint,
      {Map? parameters, var basicAuth}) async {
    try {
      var response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              HttpHeaders.acceptHeader: _appJson,
              HttpHeaders.contentTypeHeader: _appJson,
              HttpHeaders.authorizationHeader: basicAuth,
            },
            body: parameters != null ? json.encode(parameters) : null,
          )
          .timeout(const Duration(seconds: 60));

      return _returnResponse(response, endpoint);
    } on SocketException {
      return Result.error(Exceptions.socketErr);
    } on ServerSocket {
      return Result.error(Exceptions.serverErr);
    } on FormatException {
      return Result.error(Exceptions.err);
    } on HandshakeException {
      return Result.error(Exceptions.serverErr);
    } on Exception {
      return Result.error(Exceptions.serverErr);
    }
  }

  static Future<Result> getRequest(String endpoint) async {
    try {
      String bearerToken = await token;
      var response = await http.get(
        Uri.parse(_fetchUrl(endpoint)),
        headers: <String, String>{
          HttpHeaders.acceptHeader: _appJson,
          HttpHeaders.contentTypeHeader: _appJson,
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
      ).timeout(const Duration(seconds: 60));
      return _returnResponse(response, endpoint);
    } on SocketException {
      return Result.error(Exceptions.socketErr);
    } on FormatException {
      return Result.error(Exceptions.err);
    } on ServerSocket {
      return Result.error(Exceptions.serverErr);
    } on HandshakeException {
      return Result.error(Exceptions.serverErr);
    } on Exception {
      return Result.error(Exceptions.serverErr);
    }
  }

  static Result _returnResponse(http.Response response, String endpoint) {
    switch (response.statusCode) {
      case 200:
        dev.log(/*jsonDecode(response.body).toString()*/ '',
            name: 'Status: 200 - $endpoint');
        return Result.value(jsonDecode(response.body));
      case 400:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Status: 400 - $endpoint');
        return Result.error(response.body);
      case 401:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Status: 401 - $endpoint');
        return Result.error(Exceptions.authError);
      case 403:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Status: 403 - $endpoint');
        return Result.error(Exceptions.err);
      case 500:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Status: 500 - $endpoint');
        return Result.error(Exceptions.serverErr);
      default:
        dev.log(jsonDecode(response.body).toString(),
            name: 'Error: ${response.statusCode}');
        return Result.error(Exceptions.err);
    }
  }
}
