import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nest_matrimony/common/instagram_constants.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/route_arguments.dart';

class InstagramServiceProvider extends ChangeNotifier {
  List<String> userFields = ['id', 'username', 'account_type', 'media_count'];

  String? authorizationCode;
  String? accessToken;
  String? userID;
  String? username;

  var imageId;

  List<String> imagURLs = [];
  List<String> imagIDs = [];

  bool isDownloading = false;

  initProvider() {
    // imagURLs = [];
    // imagIDs = [];
    // imageId;
  }

  void getAuthorizationCode(String url) {
    authorizationCode = url
        .replaceAll('${InstagramConstant.redirectUri}?code=', '')
        .replaceAll('#_', '');
  }

  Future<bool> getTokenAndUserID() async {
    var url = Uri.parse('${InstagramConstant.instaAuthBase}oauth/access_token');
    final response = await http.post(url, body: {
      'client_id': InstagramConstant.clientID,
      'redirect_uri': InstagramConstant.redirectUri,
      'client_secret': InstagramConstant.appSecret,
      'code': authorizationCode,
      'grant_type': 'authorization_code'
    });
    accessToken = convert.jsonDecode(response.body)['access_token'];
    log("TOKEN : $accessToken");
    userID = convert.jsonDecode(response.body)['user_id'].toString();
    return (accessToken != null && userID != null) ? true : false;
  }

  getUserProfile(context,bool isFromManPhotos) async {
    final fields = userFields.join(',');
    final responseNode = await http.get(Uri.parse(
        '${InstagramConstant.instaBase}$userID?fields=$fields&access_token=$accessToken'));

    var instaProfile = {
      'id': convert.jsonDecode(responseNode.body)['id'].toString(),
      'username': convert.jsonDecode(responseNode.body)['username'],
    };
    log(instaProfile.toString());
    username = convert.jsonDecode(responseNode.body)['username'];
    log('username: $username');
    log(responseNode.body);
    imageId = convert.jsonDecode(responseNode.body)['media_count'];
    Navigator.pushNamed(
        context, RouteGenerator.routeInstagram,arguments: RouteArguments(isFromMangePhotos: isFromManPhotos));
    // Navigator.pushNamedAndRemoveUntil(
    //     context, RouteGenerator.routeInstagram, (route) => false);
    notifyListeners();
  }

  Future<void> getProfilpic(context, int mediaCount) async {
    log("getProfilpic API");
    final responseNode = await http.get(Uri.parse(
        "${InstagramConstant.instaBase}me/media?fields=id&access_token=$accessToken"));

    username = convert.jsonDecode(responseNode.body)['username'];
    List a = convert.jsonDecode(responseNode.body)['data'];
    log("getProfilpic API RES ${responseNode.body}");
    for (var element in a) {
      debugPrint(element['id'].toString());
      if (mediaCount <= 15) {
        debugPrint('15 times');
        getMedia(element['id'].toString(), mediaCount, context);
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<void> getMedia(mediaId, mediaCount, context) async {
    final responseNode = await http.get(Uri.parse(
        "${InstagramConstant.instaBase}$mediaId?fields=id,media_type,media_url,username,timestamp&access_token=$accessToken"));
    var b = convert.jsonDecode(responseNode.body);
    log("json $b");
    imagURLs.add(b['media_url']);
    imagIDs.add(b['id']);
    notifyListeners();
    log("MEDIA IDs :  $imagURLs");
  }

  isDownloadingStatus(bool status) {
    isDownloading = status;
    notifyListeners();
  }
}
