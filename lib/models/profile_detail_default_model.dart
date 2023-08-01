import 'package:nest_matrimony/models/profile_search_model.dart';

import '../common/constants.dart';

class ProfileDetailDefaultModel {
  int? id;
  List<dynamic>? userImage;
  String? userName;
  int? age;
  bool? isMale;
  String? nestId;

  ProfileDetailDefaultModel({
    this.userImage,
    this.age,
    this.id,
    this.isMale,
    this.nestId,
    this.userName,
  });
}

class ProfileDetailArguments {
  UserData? userData;
  int? index;
  NavToProfile? navToProfile;

  ProfileDetailArguments({this.userData, this.index, this.navToProfile});
}

class SimilarProfileDetailArguments {
  List<UserData>? usersData;
  int? index;
  NavToProfile? navToProfile;

  SimilarProfileDetailArguments({this.usersData, this.index, this.navToProfile});
}