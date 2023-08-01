class NotificationResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<NotificationListData>? data;

  NotificationResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationListData>[];
      json['data'].forEach((v) {
        data!.add(NotificationListData.fromJson(v));
      });
    }
  }
}

class NotificationListData {
  String? label;
  List<NotificationUserData>? list;

  NotificationListData({this.label, this.list});

  NotificationListData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['list'] != null) {
      list = <NotificationUserData>[];
      json['list'].forEach((v) {
        list!.add(NotificationUserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationUserData {
  int? id;
  int? userFromId;
  int? userToId;
  String? notificationType;
  var notificationTypeId;
  String? notificationMsg;
  int? isViewed;
  var deletedAt;
  String? createdAt;
  String? updatedAt;
  User? user;

  NotificationUserData(
      {this.id,
      this.userFromId,
      this.userToId,
      this.notificationType,
      this.notificationTypeId,
      this.notificationMsg,
      this.isViewed,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.user});

  NotificationUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userFromId = json['user_from_id'];
    userToId = json['user_to_id'];
    notificationType = json['notification_type'];
    notificationTypeId = json['notification_type_id'];
    notificationMsg = json['notification_msg'];
    isViewed = json['is_viewed'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_from_id'] = userFromId;
    data['user_to_id'] = userToId;
    data['notification_type'] = notificationType;
    data['notification_type_id'] = notificationTypeId;
    data['notification_msg'] = notificationMsg;
    data['is_viewed'] = isViewed;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? registerId;
  int? age;
  String? name;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  int? scorePercentage;
  bool? isProtected;
  var matchingScore;
  UserProfileImage? userProfileImage;
  var userPackage;
  var userReligion;

  User(
      {this.id,
      this.registerId,
      this.age,
      this.name,
      this.premiumAccount,
      this.isMale,
      this.isHindu,
      this.scorePercentage,
      this.isProtected,
      this.matchingScore,
      this.userProfileImage,
      this.userPackage,
      this.userReligion});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registerId = json['register_id'];
    age = json['age'];
    name = json['name'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    scorePercentage = json['score_percentage'];
    isProtected = json['is_protected'];
    matchingScore = json['matching_score'];
    userProfileImage = json['user_profile_image'] != null
        ? UserProfileImage.fromJson(json['user_profile_image'])
        : null;
    userPackage = json['user_package'];
    userReligion = json['user_religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['register_id'] = registerId;
    data['age'] = age;
    data['name'] = name;
    data['premium_account'] = premiumAccount;
    data['is_male'] = isMale;
    data['is_hindu'] = isHindu;
    data['score_percentage'] = scorePercentage;
    data['is_protected'] = isProtected;
    data['matching_score'] = matchingScore;
    if (userProfileImage != null) {
      data['user_profile_image'] = userProfileImage!.toJson();
    }
    data['user_package'] = userPackage;
    data['user_religion'] = userReligion;
    return data;
  }
}

class UserProfileImage {
  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;
  int? isPreference;

  UserProfileImage(
      {this.id,
      this.usersId,
      this.imageFile,
      this.imageApprove,
      this.isPreference});

  UserProfileImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    imageFile = json['image_file'];
    imageApprove = json['image_approve'];
    isPreference = json['is_preference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['users_id'] = usersId;
    data['image_file'] = imageFile;
    data['image_approve'] = imageApprove;
    data['is_preference'] = isPreference;
    return data;
  }
}

// class NotificationResponseModel {
//   bool? status;
//   int? statusCode;
//   String? message;
//   Data? data;
//
//   NotificationResponseModel(
//       {this.status, this.statusCode, this.message, this.data});
//
//   NotificationResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     statusCode = json['status_code'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['status_code'] = statusCode;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<NotificationData>? list;
//   int? count;
//   int? unreadCount;
//
//   Data({this.list, this.count, this.unreadCount});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['list'] != null) {
//       list = <NotificationData>[];
//       json['list'].forEach((v) {
//         list!.add(NotificationData.fromJson(v));
//       });
//     }
//     count = json['count'];
//     unreadCount = json['unread_count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (list != null) {
//       data['list'] = list!.map((v) => v.toJson()).toList();
//     }
//     data['count'] = count;
//     data['unread_count'] = unreadCount;
//
//     return data;
//   }
// }
//
// class NotificationData {
//   int? id;
//   int? userFromId;
//   int? userToId;
//   String? notificationType;
//   var notificationTypeId;
//   String? notificationMsg;
//   int? isViewed;
//   var deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//   String? registerId;
//   String? age;
//   bool isOpened = false;
//   NotificationData(
//       {this.id,
//       this.userFromId,
//       this.userToId,
//       this.notificationType,
//       this.notificationTypeId,
//       this.notificationMsg,
//       this.isViewed,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.user,
//       this.registerId,
//       this.age,
//       this.isOpened = false});
//
//   NotificationData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userFromId = json['user_from_id'];
//     userToId = json['user_to_id'];
//     notificationType = json['notification_type'];
//     notificationTypeId = json['notification_type_id'];
//     notificationMsg = json['notification_msg'];
//     isViewed = json['is_viewed'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//     registerId = json['register_id'];
//     age = json['age'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_from_id'] = userFromId;
//     data['user_to_id'] = userToId;
//     data['notification_type'] = notificationType;
//     data['notification_type_id'] = notificationTypeId;
//     data['notification_msg'] = notificationMsg;
//     data['is_viewed'] = isViewed;
//     data['deleted_at'] = deletedAt;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     data['register_id'] = registerId;
//     data['age'] = age;
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   String? registerId;
//   int? age;
//   String? name;
//   bool? premiumAccount;
//   bool? isMale;
//   bool? isHindu;
//   int? scorePercentage;
//   UserProfileImage? userImage;
//   var userPackage;
//   var userReligion;
//
//   User(
//       {this.id,
//       this.registerId,
//       this.age,
//       this.name,
//       this.premiumAccount,
//       this.isMale,
//       this.isHindu,
//       this.scorePercentage,
//       this.userPackage,
//       this.userReligion,
//       this.userImage});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     registerId = json['register_id'];
//     age = json['age'];
//     name = json['name'];
//     premiumAccount = json['premium_account'];
//     isMale = json['is_male'];
//     isHindu = json['is_hindu'];
//     scorePercentage = json['score_percentage'] ?? 0;
//     userPackage = json['user_package'];
//     userReligion = json['user_religion'];
//     userImage = json['user_profile_image'] != null
//         ? UserProfileImage.fromJson(json['user_profile_image'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['register_id'] = registerId;
//     data['age'] = age;
//     data['name'] = name;
//     data['premium_account'] = premiumAccount;
//     data['is_male'] = isMale;
//     data['is_hindu'] = isHindu;
//     data['score_percentage'] = scorePercentage;
//     data['user_package'] = userPackage;
//     data['user_religion'] = userReligion;
//     if (userImage != null) {
//       data['user_profile_image'] = userImage!.toJson();
//     }
//     return data;
//   }
// }
//
// class UnreadCount {
//   int? total;
//
//   UnreadCount({this.total});
//
//   UnreadCount.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total'] = total;
//     return data;
//   }
// }
//
// class UserProfileImage {
//   int? id;
//   int? usersId;
//   String? imageFile;
//   String? imageApprove;
//   int? isPreference;
//
//   UserProfileImage(
//       {this.id,
//       this.usersId,
//       this.imageFile,
//       this.imageApprove,
//       this.isPreference});
//
//   UserProfileImage.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     usersId = json['users_id'];
//     imageFile = json['image_file'];
//     imageApprove = json['image_approve'];
//     isPreference = json['is_preference'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['users_id'] = usersId;
//     data['image_file'] = imageFile;
//     data['image_approve'] = imageApprove;
//     data['is_preference'] = isPreference;
//     return data;
//   }
// }
