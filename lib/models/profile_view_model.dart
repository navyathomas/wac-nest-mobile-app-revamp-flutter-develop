import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/services/helpers.dart';

class PartnerDetailModel {
  bool? status;
  int? statusCode;
  String? message;
  PartnerDetailData? data;

  PartnerDetailModel({this.status, this.statusCode, this.message, this.data});

  PartnerDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data =
        json['data'] != null ? PartnerDetailData.fromJson(json['data']) : null;
  }
}

class PartnerDetailData {
  BasicDetails? basicDetails;
  UserPartnerPreference? userPartnerPreference;
  double? matchPercentage;
  int? isBlocked;
  int? isReported;
  String? profileUrl;
  String? nestAdminWhatsapp;
  String? staffNumber;
  int ? numberOfChild;
 

  PartnerDetailData(
      {this.basicDetails, this.userPartnerPreference, this.matchPercentage,this.numberOfChild});

  PartnerDetailData.fromJson(Map<String, dynamic> json) {
    basicDetails = json['basicDetails'] != null
        ? BasicDetails.fromJson(json['basicDetails'])
        : null;
    userPartnerPreference = json['user_partner_preference'] != null
        ? UserPartnerPreference.fromJson(json['user_partner_preference'])
        : null;
    matchPercentage = Helpers.convertToDouble(json['match_percentage']);
    isBlocked = json['is_blocked'];
    isReported = json['is_reported'];
    profileUrl = json['profile_url'];
    nestAdminWhatsapp = json['nest_admin_whatsapp'];
    staffNumber = json['staff_phone'];
    numberOfChild=json['no_of_children'];
  }
}
class ComplexionData {
  int? id;
  String? complexionTitle;

  ComplexionData({this.id, this.complexionTitle});

  ComplexionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complexionTitle = json['complexion_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['complexion_title'] = complexionTitle;
    return data;
  }
}



class BasicDetails {
  int? id;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? profileCreated;
  int? age;
  int? casteId;
  int? religionsId;
  String? userIntro;
  String? mobile;
  String? phoneNo;
  String? whatsappNo;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  int? noOfChildren;
  UserReligion? userReligion;
  UserCaste? userCaste;
  UserFamilyInfo? userFamilyInfo;
  UserReligiousInfo? userReligiousInfo;
  UserEducationCategory? userEducationCategory;
  UserEducationSubcategory? userEducationSubcategory;
  UserJobCategory? userJobCategory;
  UserJobSubCategory? userJobSubCategory;
  List<UserGrahanila>? userGrahanila;
  List<UserGrahanila>? navamshakamList;
  List<UserHoroscopeImage>? userHoroscopeImage;
  String? registerId;
  List<UserImage>? userImage;
  UserPackage? userPackage;
  FromHeight? userHeight;
  MaritalStatus? maritalStatus;
  CountryData? countryData;
  List<AboutMe>? aboutMe;
  String? subCaste;
  String? profileVerificationStatus;
  String? educationInfo;
  String? jobInfo;
  UserStaff? userStaff;
  UserBranch? userBranch;
  PhysicalStatus? physicalStatus;
  ComplexionData? complexion;

  BasicDetails(
      {this.id,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.profileCreated,
      this.age,
      this.casteId,
      this.religionsId,
      this.userIntro,
      this.mobile,
      this.phoneNo,
      this.whatsappNo,
      this.premiumAccount,
      this.isMale,
      this.isHindu,
      this.noOfChildren,
      this.userReligion,
      this.userCaste,
      this.userFamilyInfo,
      this.userReligiousInfo,
      this.userEducationCategory,
      this.userEducationSubcategory,
      this.userJobCategory,
      this.userJobSubCategory,
      this.userGrahanila,
      this.navamshakamList,
      this.userHoroscopeImage,
      this.userImage,
      this.userPackage,
      this.userHeight,
      this.maritalStatus,
      this.countryData,
      this.aboutMe,
      this.subCaste,
      this.registerId,
      this.profileVerificationStatus,
      this.jobInfo,
      this.educationInfo,
      this.userStaff,
      this.userBranch,this.complexion,
      this.physicalStatus});

  BasicDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    profileCreated = json['profile_created'];
    age = json['age'];
    casteId = json['caste_id'];
    religionsId = json['religions_id'];
    userIntro = json['user_intro'];
    mobile = json['mobile'];
    phoneNo = json['phone_no'];
    whatsappNo = json['whatsapp_no'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    noOfChildren = json['no_of_children'];
    userReligion = json['user_religion'] != null
        ? UserReligion.fromJson(json['user_religion'])
        : null;
    userCaste = json['user_caste'] != null
        ? UserCaste.fromJson(json['user_caste'])
        : null;
    userFamilyInfo = json['user_family_info'] != null
        ? UserFamilyInfo.fromJson(json['user_family_info'])
        : null;
    userReligiousInfo = json['user_religious_info'] != null
        ? UserReligiousInfo.fromJson(json['user_religious_info'])
        : null;
    userEducationCategory = json['user_education_category'] != null
        ? UserEducationCategory.fromJson(json['user_education_category'])
        : null;
    userEducationSubcategory = json['user_education_subcategory'] != null
        ? UserEducationSubcategory.fromJson(json['user_education_subcategory'])
        : null;
    userJobCategory = json['user_job_category'] != null
        ? UserJobCategory.fromJson(json['user_job_category'])
        : null;

    userJobSubCategory = json['user_job_sub_category'] != null
        ? UserJobSubCategory.fromJson(json['user_job_sub_category'])
        : null;
    if (json['user_grahanila'] != null) {
      userGrahanila = <UserGrahanila>[];
      json['user_grahanila'].forEach((v) {
        userGrahanila!.add(UserGrahanila.fromJson(v));
      });
    }
    if (json['navamshakam_list'] != null) {
      navamshakamList = <UserGrahanila>[];
      json['navamshakam_list'].forEach((v) {
        navamshakamList!.add(UserGrahanila.fromJson(v));
      });
    }
    if (json['user_horoscope_image'] != null) {
      userHoroscopeImage = [];
      json['user_horoscope_image'].forEach((v) {
        userHoroscopeImage!.add(UserHoroscopeImage.fromJson(v));
      });
    }
    if (json['user_image'] != null) {
      userImage = <UserImage>[];
      json['user_image'].forEach((v) {
        userImage!.add(UserImage.fromJson(v));
      });
    }
    userPackage = json['user_package'] != null
        ? UserPackage.fromJson(json['user_package'])
        : null;
    userHeight = json['user_height_list'] != null
        ? FromHeight.fromJson(json['user_height_list'])
        : null;
    maritalStatus = json['marital_status'] != null
        ? MaritalStatus.fromJson(json['marital_status'])
        : null;
    countryData = json['user_country'] != null
        ? CountryData.fromJson(json['user_country'])
        : null;
    if (json['about_me'] != null) {
      aboutMe = [];
      json['about_me'].forEach((v) {
        aboutMe!.add(AboutMe.fromJson(v));
      });
    }
    subCaste = json['sub_caste'];
    registerId = json['register_id'];
    profileVerificationStatus = json['profile_verification_status'];
    jobInfo = json['job_info'];
    educationInfo = json['educational_info'];
    userStaff = json['user_staff'] != null
        ? UserStaff.fromJson(json['user_staff'])
        : null;
    userBranch = json['user_branch'] != null
        ? UserBranch.fromJson(json['user_branch'])
        : null;
    complexion= json["complexion"] == null
            ? null
            : ComplexionData.fromJson(json["complexion"]);

    physicalStatus = json['physical_status'] != null
        ? PhysicalStatus.fromJson(json['physical_status'])
        : null;
  }
}

class PhysicalStatus {
  int? id;
  String? bodyType;

  PhysicalStatus({this.id, this.bodyType});

  PhysicalStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bodyType = json['body_type'];
  }

}

class UserStaff {
  int? id;
  String? staffName;
  String? officeNumber;

  UserStaff({this.id, this.staffName, this.officeNumber});

  UserStaff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffName = json['staff_name'];
    officeNumber = json['office_number'];
  }
}

class UserBranch {
  int? id;
  String? branchName;

  UserBranch({this.id, this.branchName});

  UserBranch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
  }
}

class UserHoroscopeImage {
  int? usersId;
  int? id;
  int? userImageTypeId;
  String? userImagePath;
  GetImageType? getImageType;

  UserHoroscopeImage(
      {this.usersId,
      this.id,
      this.userImageTypeId,
      this.userImagePath,
      this.getImageType});

  UserHoroscopeImage.fromJson(Map<String, dynamic> json) {
    usersId = json['users_id'];
    id = json['id'];
    userImageTypeId = json['user_image_type_id'];
    userImagePath = json['user_image_path'];
    getImageType = json['get_image_type'] != null
        ? GetImageType.fromJson(json['get_image_type'])
        : null;
  }
}

class GetImageType {
  String? userImageType;
  int? id;

  GetImageType({this.userImageType, this.id});

  GetImageType.fromJson(Map<String, dynamic> json) {
    userImageType = json['user_image_type'];
    id = json['id'];
  }
}

class UserReligion {
  int? id;
  String? religionName;

  UserReligion({this.id, this.religionName});

  UserReligion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religionName = json['religion_name'];
  }
}

class UserCaste {
  int? id;
  String? casteName;

  UserCaste({this.id, this.casteName});

  UserCaste.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    casteName = json['caste_name'];
  }
}

class UserFamilyInfo {
  int? id;
  int? locationsId;
  int? usersId;
  int? districtsId;
  int? statesId;
  String? fatherName;
  String? motherName;
  String? fatherJob;
  String? motherJob;
  String? sibilingsInfo;
  String? houseAddress;
  double? latitude;
  double? longitude;
  UserLocation? userLocation;
  UserDistrict? userDistrict;
  UserState? userState;
  String? residenceRoute;

  UserFamilyInfo(
      {this.id,
      this.locationsId,
      this.usersId,
      this.districtsId,
      this.statesId,
      this.fatherName,
      this.motherName,
      this.fatherJob,
      this.motherJob,
      this.sibilingsInfo,
      this.houseAddress,
      this.latitude,
      this.longitude,
      this.userLocation,
      this.userDistrict,
      this.userState,
      this.residenceRoute});

  UserFamilyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationsId = json['locations_id'];
    usersId = json['users_id'];
    districtsId = json['districts_id'];
    statesId = json['states_id'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    fatherJob = json['father_job'];
    motherJob = json['mother_job'];
    sibilingsInfo = json['sibilings_info'];
    houseAddress = json['house_address'];
    latitude = Helpers.convertToDouble(json['latitude']);
    longitude = Helpers.convertToDouble(json['longitude']);
    userLocation = json['user_location'] != null
        ? UserLocation.fromJson(json['user_location'])
        : null;
    userDistrict = json['user_district'] != null
        ? UserDistrict.fromJson(json['user_district'])
        : null;
    userState = json['user_state'] != null
        ? UserState.fromJson(json['user_state'])
        : null;
    residenceRoute = json['residence_route'];
  }
}

class UserLocation {
  String? locationName;
  int? id;

  UserLocation({this.locationName, this.id});

  UserLocation.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    id = json['id'];
  }
}

class UserDistrict {
  String? districtName;
  int? id;

  UserDistrict({this.districtName, this.id});

  UserDistrict.fromJson(Map<String, dynamic> json) {
    districtName = json['district_name'];
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

class UserReligiousInfo {
  String? timeOfBirth;
  int? id;
  String? sistaDasaDay;
  String? sistaDasaMonth;
  String? sistaDasaYear;
  int? jathakamTypesId;
  int? usersId;
  String? dhasaName;
  String? malayalamDob;
  int? starsId;
  UserStars? userStars;
  String? janmaSistaDasaEnd;

  UserReligiousInfo(
      {this.timeOfBirth,
      this.id,
      this.sistaDasaDay,
      this.sistaDasaMonth,
      this.sistaDasaYear,
      this.jathakamTypesId,
      this.usersId,
      this.dhasaName,
      this.malayalamDob,
      this.starsId,
      this.userStars,
      this.janmaSistaDasaEnd});

  UserReligiousInfo.fromJson(Map<String, dynamic> json) {
    timeOfBirth = json['time_of_birth'];
    id = json['id'];
    sistaDasaDay = json['sista_dasa_day'];
    sistaDasaMonth = json['sista_dasa_month'];
    sistaDasaYear = json['sista_dasa_year'];
    jathakamTypesId = json['jathakam_types_id'];
    usersId = json['users_id'];
    dhasaName = json['dhasa_name'];
    malayalamDob = json['malayalam_dob'];
    starsId = json['stars_id'];
    userStars = json['user_stars'] != null
        ? UserStars.fromJson(json['user_stars'])
        : null;
    janmaSistaDasaEnd = '${(sistaDasaYear ?? '').isNotEmpty ? '$sistaDasaYear year ' : ''}${(sistaDasaMonth ?? '').isNotEmpty ? '$sistaDasaMonth months ' : ''}${(sistaDasaDay ?? '').isNotEmpty ? '$sistaDasaDay days' : ''}';
  }
}

class UserStars {
  String? starName;
  int? id;

  UserStars({this.starName, this.id});

  UserStars.fromJson(Map<String, dynamic> json) {
    starName = json['star_name'];
    id = json['id'];
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

class UserEducationCategory {
  int? id;
  String? eduCategoryTitle;

  UserEducationCategory({this.id, this.eduCategoryTitle});

  UserEducationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eduCategoryTitle = json['parent_education_category'];
  }
}

class UserJobSubCategory {
  String? subcategoryName;
  int? id;

  UserJobSubCategory({this.subcategoryName, this.id});

  UserJobSubCategory.fromJson(Map<String, dynamic> json) {
    subcategoryName = json['subcategory_name'];
    id = json['id'];
  }
}

class UserJobCategory {
  String? categoryName;
  int? id;

  UserJobCategory({this.categoryName, this.id});

  UserJobCategory.fromJson(Map<String, dynamic> json) {
    categoryName = json['parent_job_category'];
    id = json['id'];
  }
}

class UserGrahanila {
  int? usersId;
  int? id;
  int? horoscopeTypesId;
  int? grahasId;
  int? horoscopeColumnsId;
  GrahasList? grahasList;

  UserGrahanila(
      {this.usersId,
      this.id,
      this.horoscopeTypesId,
      this.grahasId,
      this.horoscopeColumnsId,
      this.grahasList});

  UserGrahanila.fromJson(Map<String, dynamic> json) {
    usersId = json['users_id'];
    id = json['id'];
    horoscopeTypesId = json['horoscope_types_id'];
    grahasId = json['grahas_id'];
    horoscopeColumnsId = json['horoscope_columns_id'];
    grahasList = json['grahas_list'] != null
        ? GrahasList.fromJson(json['grahas_list'])
        : null;
  }
}

class GrahasList {
  String? grahaName;
  int? id;

  GrahasList({this.grahaName, this.id});

  GrahasList.fromJson(Map<String, dynamic> json) {
    grahaName = json['graha_name'];
    id = json['id'];
  }
}

class UserImage {
  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;

  UserImage({this.id, this.usersId, this.imageFile, this.imageApprove});

  UserImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    imageFile = json['image_file'];
    imageApprove = json['image_approve'];
  }
}

class UserPackage {
  int? id;
  String? subscriptionTitle;
  int? subscriptionPrice;
  int? validityMonth;
  int? subscriptionTypesId;
  String? addressViewFeature;
  int? addressViewCount;
  String? chatFeature;
  int? dailyAddressViewLimit;
  String? interestExpressFeature;
  int? interestExpressCount;
  String? totalCount;
  String? extraFeatures;
  int? isDeleted;
  int? addedBy;
  int? mrpPrice;
  bool? premiumPackage;
  SubscriptionType? subscriptionType;

  UserPackage(
      {this.id,
      this.subscriptionTitle,
      this.subscriptionPrice,
      this.validityMonth,
      this.subscriptionTypesId,
      this.addressViewFeature,
      this.addressViewCount,
      this.chatFeature,
      this.dailyAddressViewLimit,
      this.interestExpressFeature,
      this.interestExpressCount,
      this.totalCount,
      this.extraFeatures,
      this.isDeleted,
      this.addedBy,
      this.mrpPrice,
      this.premiumPackage,
      this.subscriptionType});

  UserPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionTitle = json['subscription_title'];
    subscriptionPrice = json['subscription_price'];
    validityMonth = json['validity_month'];
    subscriptionTypesId = json['subscription_types_id'];
    addressViewFeature = json['address_view_feature'];
    addressViewCount = json['address_view_count'];
    chatFeature = json['chat_feature'];
    dailyAddressViewLimit = json['daily_address_view_limit'];
    interestExpressFeature = json['interest_express_feature'];
    interestExpressCount = json['interest_express_count'];
    totalCount = json['total_count'];
    extraFeatures = json['extra_features'];
    isDeleted = json['is_deleted'];
    addedBy = json['added_by'];
    mrpPrice = json['mrp_price'];
    premiumPackage = json['premium_package'];
    subscriptionType = json['subscription_type'] != null
        ? SubscriptionType.fromJson(json['subscription_type'])
        : null;
  }
}

class SubscriptionType {
  int? id;
  String? subscriptionType;
  String? createdAt;
  String? updatedAt;

  SubscriptionType(
      {this.id, this.subscriptionType, this.createdAt, this.updatedAt});

  SubscriptionType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionType = json['subscription_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class UserPartnerPreference {
  int? id;
  int? usersId;
  String? subCaste;
  String? preferJathakamType;
  String? educationInfo;
  String? jobInfo;
  String? jobLocation;
  String? financialExpectation;
  String? preferSpecialCase;
  String? otherReligiousExpectation;
  List<String>? preferJathakamTypeUnserialize;
  List<String>? complexionUnserialize;
  List<String>? bodyTypesUnserialize;
  List<String>? casteUnserialize;
  List<String>? statesUnserialize;
  List<String>? districtsUnserialize;
  List<String>? educationCategoryUnserialize;
  List<String>? jobCategoryUnserialize;
  List<String>? maritalStatusUnserialize;
  List<String>? locationUnserialize;
  UserReligion? religions;
  FromHeight? fromHeight;
  FromHeight? toHeight;
  FromAge? fromAge;
  FromAge? toAge;
  CountryData? countryData;

  UserPartnerPreference(
      {this.id,
      this.usersId,
      this.subCaste,
      this.preferJathakamType,
      this.educationInfo,
      this.jobInfo,
      this.jobLocation,
      this.financialExpectation,
      this.preferSpecialCase,
      this.otherReligiousExpectation,
      this.preferJathakamTypeUnserialize,
      this.complexionUnserialize,
      this.bodyTypesUnserialize,
      this.casteUnserialize,
      this.statesUnserialize,
      this.districtsUnserialize,
      this.educationCategoryUnserialize,
      this.jobCategoryUnserialize,
      this.maritalStatusUnserialize,
      this.locationUnserialize,
      this.religions,
      this.fromHeight,
      this.toHeight,
      this.fromAge,
      this.toAge,
      this.countryData});

  UserPartnerPreference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    subCaste = json['sub_caste'];
    preferJathakamType = json['prefer_jathakam_type'];
    educationInfo = json['education_info'];
    jobInfo = json['job_info'];
    jobLocation = json['job_location'];
    financialExpectation = json['financial_expectation'];
    preferSpecialCase = json['prefer_special_case'];
    otherReligiousExpectation = json['other_religious_expectation'];
    if (json['prefer_jathakam_type_unserialize'] != null &&
        json['prefer_jathakam_type_unserialize'] is List) {
      preferJathakamTypeUnserialize = <String>[];
      json['prefer_jathakam_type_unserialize'].forEach((v) {
        if (v != null) preferJathakamTypeUnserialize!.add(v);
      });
    }
    if (json['complexion_unserialize'] != null &&
        json['complexion_unserialize'] is List) {
      complexionUnserialize = <String>[];
      json['complexion_unserialize'].forEach((v) {
        if (v != null) complexionUnserialize!.add(v);
      });
    }
    if (json['body_types_unserialize'] != null &&
        json['body_types_unserialize'] is List) {
      bodyTypesUnserialize = <String>[];
      json['body_types_unserialize'].forEach((v) {
        if (v != null) bodyTypesUnserialize!.add(v);
      });
    }
    if (json['caste_unserialize'] != null &&
        json['caste_unserialize'] is List) {
      casteUnserialize = <String>[];
      json['caste_unserialize'].forEach((v) {
        if (v != null) casteUnserialize!.add(v);
      });
    }
    if (json['states_unserialize'] != null &&
        json['states_unserialize'] is List) {
      statesUnserialize = <String>[];
      json['states_unserialize'].forEach((v) {
        if (v != null) statesUnserialize!.add(v);
      });
    }
    if (json['districts_unserialize'] != null &&
        json['districts_unserialize'] is List) {
      districtsUnserialize = <String>[];
      json['districts_unserialize'].forEach((v) {
        if (v != null) districtsUnserialize!.add(v);
      });
    }
    if (json['education_category_unserialize'] != null &&
        json['education_category_unserialize'] is List) {
      educationCategoryUnserialize = [];
      json['education_category_unserialize'].forEach((v) {
        if (v != null) educationCategoryUnserialize!.add(v ?? '');
      });
    }
    if (json['job_category_unserialize'] != null &&
        json['job_category_unserialize'] is List) {
      jobCategoryUnserialize = [];
      json['job_category_unserialize'].forEach((v) {
        if (v != null) jobCategoryUnserialize!.add(v ?? '');
      });
    }
    if (json['marital_status_unserialize'] != null &&
        json['marital_status_unserialize'] is List) {
      maritalStatusUnserialize = <String>[];
      json['marital_status_unserialize'].forEach((v) {
        if (v != null) maritalStatusUnserialize!.add(v);
      });
    }
    if (json['location_unserialize'] != null &&
        json['location_unserialize'] is List) {
      locationUnserialize = <String>[];
      json['location_unserialize'].forEach((v) {
        if (v != null) locationUnserialize!.add(v);
      });
    }
    religions = json['religions'] != null
        ? UserReligion.fromJson(json['religions'])
        : null;
    fromHeight = json['from_height'] != null
        ? FromHeight.fromJson(json['from_height'])
        : null;
    toHeight = json['to_height'] != null
        ? FromHeight.fromJson(json['to_height'])
        : null;
    fromAge =
        json['from_age'] != null ? FromAge.fromJson(json['from_age']) : null;
    toAge = json['to_age'] != null ? FromAge.fromJson(json['to_age']) : null;
    countryData =
        json['country'] != null ? CountryData.fromJson(json['country']) : null;
  }
}

class FromHeight {
  String? height;
  int? heightValue;
  int? id;

  FromHeight({this.height, this.heightValue, this.id});

  FromHeight.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    heightValue = json['height_value'];
    id = json['id'];
  }
}

class FromAge {
  int? age;
  int? id;

  FromAge({this.age, this.id});

  FromAge.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    id = json['id'];
  }
}

class MaritalStatus {
  int? id;
  String? maritalStatus;
  int ? haveChildren;


  MaritalStatus({this.id, this.maritalStatus,this.haveChildren});

  MaritalStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maritalStatus = json['marital_status'];
    haveChildren=json['have_children'];
  }
}

class AboutMe {
  int? id;
  int? usersId;
  String? approveContent;

  AboutMe({this.id, this.usersId, this.approveContent});

  AboutMe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    approveContent = json['approve_content'];
  }
}
