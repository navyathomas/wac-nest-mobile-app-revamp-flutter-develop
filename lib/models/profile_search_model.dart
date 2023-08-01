import 'package:nest_matrimony/services/helpers.dart';

class ProfileSearchModel {
  bool? status;
  int? statusCode;
  String? message;
  ProfileSearchData? profileSearchData;

  ProfileSearchModel(
      {this.status, this.statusCode, this.message, this.profileSearchData});

  ProfileSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    profileSearchData =
        json['data'] != null ? ProfileSearchData.fromJson(json['data']) : null;
  }
}

class ProfileSearchData {
  Original? original;
  dynamic exception;

  ProfileSearchData({this.original, this.exception});

  ProfileSearchData.fromJson(Map<String, dynamic> json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }
}

class Original {
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<UserData>? data;
  bool? status;
  int? lastPageNumber;
  int? currentPage;
  int? itemPerPage;
  InputData? input;

  Original(
      {this.draw,
      this.recordsTotal,
      this.recordsFiltered,
      this.data,
      this.status,
      this.lastPageNumber,
      this.currentPage,
      this.itemPerPage,
      this.input});

  Original.fromJson(Map<String, dynamic> json) {
    draw = json['draw'];
    recordsTotal = json['recordsTotal'];
    recordsFiltered = json['recordsFiltered'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    status = json['status'];
    lastPageNumber = json['last_page_number'];
    currentPage = Helpers.convertToInt(json['current_page'], defaultVal: 1);
    itemPerPage = Helpers.convertToInt(json['Item_per_page'], defaultVal: 1);
    input = json['input'] != null ? InputData.fromJson(json['input']) : null;
  }
}

class UserData {
  int? id;
  String? name;
  String? registerId;
  int? age;
  String? gender;
  int? heightListId;
  int? religionsId;
  int? casteId;
  int? countriesId;
  int? statesId;
  int? districtsId;
  int? locationsId;
  int? educationParentId;
  int? educationCategoryId;
  int? jobParentId;
  int? jobCategoryId;
  String? registerDate;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  UserFamilyInfo? userFamilyInfo;
  UserReligion? userReligion;
  UserHeightList? userHeightList;
  UserCaste? userCaste;
  UserState? userState;
  UserDistricts? userDistricts;
  UserCountry? userCountry;
  UserEducationSubcategory? userEducationSubcategory;
  UserJobSubCategory? userJobSubCategory;
  String? basicDetails;
  List<UserImage>? userImage;
  String? profileVerificationStatus;
  String? address;
  double? scorePercentage;
  UserData(
      {this.id,
      this.name,
      this.registerId,
      this.age,
      this.gender,
      this.heightListId,
      this.religionsId,
      this.casteId,
      this.countriesId,
      this.statesId,
      this.districtsId,
      this.locationsId,
      this.educationParentId,
      this.educationCategoryId,
      this.jobParentId,
      this.jobCategoryId,
      this.registerDate,
      this.premiumAccount,
      this.isMale,
      this.isHindu,
      this.userFamilyInfo,
      this.userReligion,
      this.userHeightList,
      this.userCaste,
      this.userState,
      this.userDistricts,
      this.userCountry,
      this.userEducationSubcategory,
      this.userJobSubCategory,
      this.userImage,
      this.basicDetails,
      this.profileVerificationStatus,
      this.address,
      this.scorePercentage});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registerId = json['register_id'];
    age = json['age'];
    gender = json['gender'];
    heightListId = json['height_list_id'];
    religionsId = json['religions_id'];
    casteId = json['caste_id'];
    countriesId = json['countries_id'];
    statesId = json['states_id'];
    districtsId = json['districts_id'];
    locationsId = json['locations_id'];
    educationParentId = json['education_parent_id'];
    educationCategoryId = json['education_category_id'];
    jobParentId = json['job_parent_id'];
    jobCategoryId = json['job_category_id'];
    registerDate = json['register_date'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    scorePercentage = Helpers.convertToDouble(json['score_percentage']);
    userFamilyInfo = json['user_family_info'] != null
        ? UserFamilyInfo.fromJson(json['user_family_info'])
        : null;
    userReligion = json['user_religion'] != null
        ? UserReligion.fromJson(json['user_religion'])
        : null;
    userHeightList = json['user_height_list'] != null
        ? UserHeightList.fromJson(json['user_height_list'])
        : null;
    userCaste = json['user_caste'] != null
        ? UserCaste.fromJson(json['user_caste'])
        : null;
    userState = json['user_state'] != null
        ? UserState.fromJson(json['user_state'])
        : null;
    userDistricts = json['user_districts'] != null
        ? UserDistricts.fromJson(json['user_districts'])
        : null;
    userCountry = json['user_country'] != null
        ? UserCountry.fromJson(json['user_country'])
        : null;
    userEducationSubcategory = json['user_education_subcategory'] != null
        ? UserEducationSubcategory.fromJson(json['user_education_subcategory'])
        : null;
    userJobSubCategory = json['user_job_sub_category'] != null
        ? UserJobSubCategory.fromJson(json['user_job_sub_category'])
        : null;
    if (json['user_image'] != null) {
      userImage = <UserImage>[];
      json['user_image'].forEach((v) {
        userImage!.add(UserImage.fromJson(v));
      });
    }
    basicDetails =
        '${age == null ? '' : '${age}yrs, '}${userHeightList?.heightValue == null ? '' : '${userHeightList?.heightValue} cm, '}${(userCaste?.casteName ?? '').isEmpty ? '' : '${userCaste?.casteName!}, '}${(userEducationSubcategory?.eduCategoryTitle ?? '').isEmpty ? '' : '${userEducationSubcategory?.eduCategoryTitle}, '}${userJobSubCategory?.subcategoryName ?? ''}';
    address =
        '${json['user_districts'] != null ? json['user_districts']['district_name'] + ',' : ''} ${json['user_state'] != null ? json['user_state']['state_name'] : ''}';
    profileVerificationStatus = json['profile_verification_status'];
  }
}

class UserFamilyInfo {
  int? id;
  int? usersId;
  int? countriesId;
  int? statesId;
  int? districtsId;

  UserFamilyInfo(
      {this.id,
      this.usersId,
      this.countriesId,
      this.statesId,
      this.districtsId});

  UserFamilyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    countriesId = json['countries_id'];
    statesId = json['states_id'];
    districtsId = json['districts_id'];
  }
}

class UserReligion {
  String? religionName;
  int? id;

  UserReligion({this.religionName, this.id});

  UserReligion.fromJson(Map<String, dynamic> json) {
    religionName = json['religion_name'];
    id = json['id'];
  }
}

class UserHeightList {
  String? height;
  int? heightValue;
  int? id;

  UserHeightList({this.height, this.heightValue, this.id});

  UserHeightList.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    heightValue = json['height_value'];
    id = json['id'];
  }
}

class UserCaste {
  String? casteName;
  int? id;

  UserCaste({this.casteName, this.id});

  UserCaste.fromJson(Map<String, dynamic> json) {
    casteName = json['caste_name'];
    id = json['id'];
  }
}

class UserState {
  String? stateName;
  int? id;

  UserState({this.stateName, this.id});

  UserState.fromJson(Map<String, dynamic> json) {
    stateName = json['state_name'];
    id = json['id'];
  }
}

class UserDistricts {
  String? districtName;
  int? id;

  UserDistricts({this.districtName, this.id});

  UserDistricts.fromJson(Map<String, dynamic> json) {
    districtName = json['district_name'];
    id = json['id'];
  }
}

class UserCountry {
  String? countryName;
  int? id;
  String? countryFlag;

  UserCountry({this.countryName, this.id, this.countryFlag});

  UserCountry.fromJson(Map<String, dynamic> json) {
    countryName = json['country_name'];
    id = json['id'];
    countryFlag = json['country_flag'];
  }
}

class UserEducationSubcategory {
  int? id;
  String? eduCategoryTitle;

  UserEducationSubcategory({this.id, this.eduCategoryTitle});

  UserEducationSubcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eduCategoryTitle = json['edu_category_title'];
  }
}

class UserJobSubCategory {
  int? id;
  String? subcategoryName;

  UserJobSubCategory({this.id, this.subcategoryName});

  UserJobSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcategoryName = json['subcategory_name'];
  }
}

class UserImage {
  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;
  int? isBackedUp;
  String? createdAt;
  String? updatedAt;
  int? isPreference;

  UserImage(
      {this.id,
      this.usersId,
      this.imageFile,
      this.imageApprove,
      this.isBackedUp,
      this.createdAt,
      this.updatedAt,
      this.isPreference});

  UserImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    imageFile = json['image_file'];
    imageApprove = json['image_approve'];
    isBackedUp = json['is_backed_up'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isPreference = json['is_preference'];
  }
}

class InputData {
  String? nestId;
  int? length;
  int? page;

  InputData({this.nestId, this.length, this.page});

  InputData.fromJson(Map<String, dynamic> json) {
    nestId = json['nest_id'];
    length = Helpers.convertToInt(json['length'], defaultVal: 1);
    page = Helpers.convertToInt(json['page'], defaultVal: 1);
  }
}
