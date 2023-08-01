import 'dart:convert';

import 'package:nest_matrimony/models/body_type_list_model.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/models/city_data_model.dart';
import 'package:nest_matrimony/models/complexion_list_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/education_cat_model.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/models/job_data_model.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/star_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';

import 'profile_search_model.dart';

class ProfileModel {
  ProfileModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.basicDetails,
  });

  BasicDetails? basicDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        basicDetails: json["basicDetails"] == null
            ? null
            : BasicDetails.fromJson(json["basicDetails"]),
      );
}

class BasicDetails {
  BasicDetails({
    this.id,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.profileCreated,
    this.registerPackageId,
    this.age,
    this.heightListId,
    this.educationParentId,
    this.educationCategoryId,
    this.jobParentId,
    this.jobCategoryId,
    this.registerId,
    this.educationalInfo,
    this.jobInfo,
    this.casteId,
    this.religionsId,
    this.userIntro,
    this.mobile,
    this.phoneNo,
    this.whatsappNo,
    this.countriesId,
    this.maritalStatusId,
    this.isMale,
    this.subCaste,
    this.premiumAccount,
    this.userReligion,
    this.userCaste,
    this.userFamilyInfo,
    this.userReligiousInfo,
    this.userEducationSubcategory,
    this.userJobSubCategory,
    this.userImage,
    this.isHindu,
    this.userGrahanila,
    this.userHoroscopeImage,
    this.aboutMe,
    this.maritalStatus,
    this.userCountry,
    this.physicalStatus,
    this.complexion,
    this.userHeightList,
    this.isProtected,
    this.noOfChildren
  });

  int? id;
  String? name;
  String? gender;
  DateTime? dateOfBirth;
  String? profileCreated;
  int? registerPackageId;
  int? age;
  int? heightListId;
  int? educationParentId;
  int? educationCategoryId;
  int? jobParentId;
  int? jobCategoryId;
  String? registerId;
  String? educationalInfo;
  String? jobInfo;
  int? casteId;
  int? religionsId;
  String? userIntro;
  String? mobile;
  String? phoneNo;
  String? whatsappNo;
  int? countriesId;
  String? subCaste;
  int? maritalStatusId;
  bool? isMale;
  bool? premiumAccount;
  bool? isHindu;
  ReligionListData? userReligion;
  CasteData? userCaste;
  UserFamilyInfo? userFamilyInfo;
  UserReligiousInfo? userReligiousInfo;
  ChildEducationCategory? userEducationSubcategory;
  JobData? userJobSubCategory;
  List<UserImage>? userImage;
  List<UserGrahanila>? userGrahanila;
  List<UserHoroscopeImage>? userHoroscopeImage;
  List<AboutMe>? aboutMe;
  MaritalStatus? maritalStatus;
  CountryData? userCountry;
  BodyType? physicalStatus;
  ComplexionData? complexion;
  HeightData? userHeightList;
  bool? isProtected;
  int? noOfChildren;

  factory BasicDetails.fromJson(Map<String, dynamic> json) => BasicDetails(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        profileCreated: json["profile_created"],
        registerPackageId: json["register_package_id"],
        age: json["age"],
        heightListId: json["height_list_id"],
        educationParentId: json["education_parent_id"],
        educationCategoryId: json["education_category_id"],
        jobParentId: json["job_parent_id"],
        jobCategoryId: json["job_category_id"],
        registerId: json["register_id"],
        educationalInfo: json["educational_info"],
        jobInfo: json["job_info"],
        casteId: json["caste_id"],
        religionsId: json["religions_id"],
        userIntro: json["user_intro"],
        mobile: json["mobile"],
        phoneNo: json["phone_no"],
        whatsappNo: json["whatsapp_no"],
        countriesId: json["countries_id"],
        maritalStatusId: json["marital_status_id"],
        isMale: json["is_male"],
        subCaste: json["sub_caste"],
        premiumAccount: json["premium_account"],
        isHindu: json["is_hindu"],
        userReligion: json["user_religion"] == null
            ? null
            : ReligionListData.fromJson(json["user_religion"]),
        userCaste: json["user_caste"] == null
            ? null
            : CasteData.fromJson(json["user_caste"]),
        userFamilyInfo: json["user_family_info"] == null
            ? null
            : UserFamilyInfo.fromJson(json["user_family_info"]),
        userReligiousInfo: json["user_religious_info"] == null
            ? null
            : UserReligiousInfo.fromJson(json["user_religious_info"]),
        userEducationSubcategory: json["user_education_subcategory"] == null
            ? null
            : ChildEducationCategory.fromJson(
                json["user_education_subcategory"]),
        userJobSubCategory: json["user_job_sub_category"] == null
            ? null
            : JobData.fromJson(json["user_job_sub_category"]),
        userImage: json["user_image"] == null
            ? null
            : List<UserImage>.from(
                json["user_image"].map((x) => UserImage.fromJson(x))),
        userGrahanila: json["user_grahanila"] == null
            ? null
            : List<UserGrahanila>.from(
                json["user_grahanila"].map((x) => UserGrahanila.fromJson(x))),
        userHoroscopeImage: json["user_horoscope_image"] == null
            ? null
            : List<UserHoroscopeImage>.from(json["user_horoscope_image"]
                .map((x) => UserHoroscopeImage.fromJson(x))),
        aboutMe: json["about_me"] == null
            ? null
            : List<AboutMe>.from(
                json["about_me"].map((x) => AboutMe.fromJson(x))),
        maritalStatus: json["marital_status"] == null
            ? null
            : MaritalStatus.fromJson(json["marital_status"]),
        userCountry: json["user_country"] == null
            ? null
            : CountryData.fromJson(json["user_country"]),
        physicalStatus: json["physical_status"] == null
            ? null
            : BodyType.fromJson(json["physical_status"]),
        complexion: json["complexion"] == null
            ? null
            : ComplexionData.fromJson(json["complexion"]),
        userHeightList: json["user_height_list"] == null
            ? null
            : HeightData.fromJson(json["user_height_list"]),
        isProtected: json["is_protected"] == null ? null : json["is_protected"],
      noOfChildren: json["no_of_children"]
      );
}

class AboutMe {
  AboutMe({
    this.id,
    this.usersId,
    this.approveContent,
  });

  int? id;
  int? usersId;
  String? approveContent;

  factory AboutMe.fromJson(Map<String, dynamic> json) => AboutMe(
        id: json["id"],
        usersId: json["users_id"],
        approveContent: json["approve_content"],
      );
}

class UserFamilyInfo {
  UserFamilyInfo({
    this.id,
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
  });

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
  String? latitude;
  String? longitude;
  CityData? userLocation;
  DistrictData? userDistrict;
  StateData? userState;

  factory UserFamilyInfo.fromJson(Map<String, dynamic> json) => UserFamilyInfo(
        id: json["id"],
        locationsId: json["locations_id"],
        usersId: json["users_id"],
        districtsId: json["districts_id"],
        statesId: json["states_id"],
        fatherName: json["father_name"],
        motherName: json["mother_name"],
        fatherJob: json["father_job"],
        motherJob: json["mother_job"],
        sibilingsInfo: json["sibilings_info"],
        houseAddress: json["house_address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userLocation: json["user_location"] == null
            ? null
            : CityData.fromJson(json["user_location"]),
        userDistrict: json["user_district"] == null
            ? null
            : DistrictData.fromJson(json["user_district"]),
        userState: json["user_state"] == null
            ? null
            : StateData.fromJson(json["user_state"]),
      );
}

class UserGrahanila {
  UserGrahanila({
    this.usersId,
    this.id,
    this.horoscopeTypesId,
    this.grahasId,
    this.horoscopeColumnsId,
    this.grahasList,
    this.navamshakamList,
  });

  int? usersId;
  int? id;
  int? horoscopeTypesId;
  int? grahasId;
  int? horoscopeColumnsId;
  GrahasList? grahasList;
  NavamshakamList? navamshakamList;

  factory UserGrahanila.fromJson(Map<String, dynamic> json) => UserGrahanila(
        usersId: json["users_id"],
        id: json["id"],
        horoscopeTypesId: json["horoscope_types_id"],
        grahasId: json["grahas_id"],
        horoscopeColumnsId: json["horoscope_columns_id"],
        grahasList: json["grahas_list"] == null
            ? null
            : GrahasList.fromJson(json["grahas_list"]),
        navamshakamList: json["navamshakam_list"] == null
            ? null
            : NavamshakamList.fromJson(json["navamshakam_list"]),
      );
}

class GrahasList {
  GrahasList({
    this.grahaName,
    this.id,
  });

  String? grahaName;
  int? id;

  factory GrahasList.fromJson(Map<String, dynamic> json) => GrahasList(
        grahaName: json["graha_name"],
        id: json["id"],
      );
}

class NavamshakamList {
  NavamshakamList({
    this.columnName,
    this.id,
  });

  String? columnName;
  int? id;

  factory NavamshakamList.fromJson(Map<String, dynamic> json) =>
      NavamshakamList(
        columnName: json["column_name"],
        id: json["id"],
      );
}

class UserHoroscopeImage {
  UserHoroscopeImage({
    this.usersId,
    this.id,
    this.userImageTypeId,
    this.userImagePath,
    this.getImageType,
  });

  int? usersId;
  int? id;
  int? userImageTypeId;
  String? userImagePath;
  GetImageType? getImageType;

  factory UserHoroscopeImage.fromJson(Map<String, dynamic> json) =>
      UserHoroscopeImage(
        usersId: json["users_id"],
        id: json["id"],
        userImageTypeId: json["user_image_type_id"],
        userImagePath: json["user_image_path"],
        getImageType: json["get_image_type"] == null
            ? null
            : GetImageType.fromJson(json["get_image_type"]),
      );
}

class GetImageType {
  GetImageType({
    this.userImageType,
    this.id,
  });

  String? userImageType;
  int? id;

  factory GetImageType.fromJson(Map<String, dynamic> json) => GetImageType(
        userImageType: json["user_image_type"],
        id: json["id"],
      );
}

class SubscriptionType {
  SubscriptionType({
    this.id,
    this.subscriptionType,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? subscriptionType;
  String? createdAt;
  String? updatedAt;

  factory SubscriptionType.fromJson(Map<String, dynamic> json) =>
      SubscriptionType(
        id: json["id"],
        subscriptionType: json["subscription_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class UserReligiousInfo {
  UserReligiousInfo({
    this.timeOfBirth,
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
  });

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
  StarData? userStars;

  factory UserReligiousInfo.fromJson(Map<String, dynamic> json) =>
      UserReligiousInfo(
        timeOfBirth: json["time_of_birth"],
        id: json["id"],
        sistaDasaDay: json["sista_dasa_day"],
        sistaDasaMonth: json["sista_dasa_month"],
        sistaDasaYear: json["sista_dasa_year"],
        jathakamTypesId: json["jathakam_types_id"],
        usersId: json["users_id"],
        dhasaName: json["dhasa_name"],
        malayalamDob: json["malayalam_dob"],
        starsId: json["stars_id"],
        userStars: json["user_stars"] == null
            ? null
            : StarData.fromJson(json["user_stars"]),
      );
}
