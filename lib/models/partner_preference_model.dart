import 'dart:convert';

import 'package:nest_matrimony/models/religion_list_model.dart';

import 'countries_data_model.dart';
import 'job_category_model.dart';

PartnerPreferenceModel partnerPreferenceModelFromJson(String str) =>
    PartnerPreferenceModel.fromJson(json.decode(str));

String partnerPreferenceModelToJson(PartnerPreferenceModel data) =>
    json.encode(data.toJson());

class PartnerPreferenceModel {
  PartnerPreferenceModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  factory PartnerPreferenceModel.fromJson(Map<String, dynamic> json) =>
      PartnerPreferenceModel(
        status: json["status"] == null ? null : json["status"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.usersId,
    this.religionsId,
    this.casteId,
    this.subCaste,
    this.preferAgeFromId,
    this.preferAgeToId,
    this.preferHeightFromId,
    this.preferHeightToId,
    this.countriesId,
    this.statesId,
    this.districtsId,
    this.complexionId,
    this.bodyTypesId,
    this.preferJathakamType,
    this.educationCategoryId,
    this.jobCategoryId,
    this.maritalStatusId,
    this.locationId,
    this.educationInfo,
    this.jobInfo,
    this.jobLocation,
    this.financialExpectation,
    this.preferSpecialCase,
    this.otherReligiousExpectation,
    this.createdAt,
    this.updatedAt,
    this.preferJathakamTypeUnserializeId,
    this.preferJathakamTypeUnserialize,
    this.complexionUnserializeId,
    this.complexionUnserialize,
    this.bodyTypesUnserializeId,
    this.bodyTypesUnserialize,
    this.casteUnserializeId,
    this.casteUnserialize,
    this.statesUnserializeId,
    this.statesUnserialize,
    this.districtsUnserializeId,
    this.districtsUnserialize,
    this.educationCategoryUnserializeId,
    this.educationCategoryUnserialize,
    this.jobCategoryUnserializeId,
    this.jobCategoryUnserialize,
    this.maritalStatusUnserializeId,
    this.maritalStatusUnserialize,
    this.locationUnserializeId,
    this.locationUnserialize,
    this.religions,
    this.fromHeight,
    this.toHeight,
    this.fromAge,
    this.toAge,
    this.country,
    this.preferredEducation,
    this.preferedJob,
  });

  int? id;
  int? usersId;
  int? religionsId;
  String? casteId;
  String? subCaste;
  int? preferAgeFromId;
  int? preferAgeToId;
  int? preferHeightFromId;
  int? preferHeightToId;
  String? countriesId;
  String? statesId;
  String? districtsId;
  String? complexionId;
  String? bodyTypesId;
  String? preferJathakamType;
  String? educationCategoryId;
  String? jobCategoryId;
  String? maritalStatusId;
  String? locationId;
  String? educationInfo;
  String? jobInfo;
  String? jobLocation;
  String? financialExpectation;
  String? preferSpecialCase;
  String? otherReligiousExpectation;
  String? createdAt;
  String? updatedAt;
  List<String>? preferJathakamTypeUnserializeId;
  List<String>? preferJathakamTypeUnserialize;
  List<String>? complexionUnserializeId;
  List<String>? complexionUnserialize;
  List<String>? bodyTypesUnserializeId;
  List<String>? bodyTypesUnserialize;
  List<String>? casteUnserializeId;
  List<String>? casteUnserialize;
  List<String>? statesUnserializeId;
  List<String>? statesUnserialize;
  List<String>? districtsUnserializeId;
  List<String>? districtsUnserialize;
  List<String>? educationCategoryUnserializeId;
  List<String>? educationCategoryUnserialize;
  List<String>? jobCategoryUnserializeId;
  List<dynamic>? jobCategoryUnserialize;
  List<String>? maritalStatusUnserializeId;
  List<String>? maritalStatusUnserialize;
  List<String>? locationUnserializeId;
  List<String>? locationUnserialize;
  ReligionListData? religions;
  Height? fromHeight;
  Height? toHeight;
  Age? fromAge;
  Age? toAge;
  CountryData? country;
  List<PreferredEducation>? preferredEducation;
  List<PreferredJob>? preferedJob;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        usersId: json["users_id"] == null ? null : json["users_id"],
        religionsId: json["religions_id"] == null ? null : json["religions_id"],
        casteId: json["caste_id"] == null ? null : json["caste_id"],
        subCaste: json["sub_caste"] == null ? null : json["sub_caste"],
        preferAgeFromId: json["prefer_age_from_id"] == null
            ? null
            : json["prefer_age_from_id"],
        preferAgeToId:
            json["prefer_age_to_id"] == null ? null : json["prefer_age_to_id"],
        preferHeightFromId: json["prefer_height_from_id"] == null
            ? null
            : json["prefer_height_from_id"],
        preferHeightToId: json["prefer_height_to_id"] == null
            ? null
            : json["prefer_height_to_id"],
        countriesId: json["countries_id"] == null ? null : json["countries_id"],
        statesId: json["states_id"] == null ? null : json["states_id"],
        districtsId: json["districts_id"] == null ? null : json["districts_id"],
        complexionId:
            json["complexion_id"] == null ? null : json["complexion_id"],
        bodyTypesId:
            json["body_types_id"] == null ? null : json["body_types_id"],
        preferJathakamType: json["prefer_jathakam_type"] == null
            ? null
            : json["prefer_jathakam_type"],
        educationCategoryId: json["education_category_id"] == null
            ? null
            : json["education_category_id"],
        jobCategoryId:
            json["job_category_id"] == null ? null : json["job_category_id"],
        maritalStatusId: json["marital_status_id"] == null
            ? null
            : json["marital_status_id"],
        locationId: json["location_id"] == null ? null : json["location_id"],
        educationInfo:
            json["education_info"] == null ? null : json["education_info"],
        jobInfo: json["job_info"] == null ? null : json["job_info"],
        jobLocation: json["job_location"] == null ? null : json["job_location"],
        financialExpectation: json["financial_expectation"] == null
            ? null
            : json["financial_expectation"],
        preferSpecialCase: json["prefer_special_case"] == null
            ? null
            : json["prefer_special_case"],
        otherReligiousExpectation: json["other_religious_expectation"] == null
            ? null
            : json["other_religious_expectation"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        preferJathakamTypeUnserializeId:
            json["prefer_jathakam_type_unserialize_id"] == null
                ? null
                : json["prefer_jathakam_type_unserialize_id"] != ""
                    ? List<String>.from(
                        json["prefer_jathakam_type_unserialize_id"]
                            .map((x) => x))
                    : null,
        preferJathakamTypeUnserialize:
            json["prefer_jathakam_type_unserialize"] == null
                ? null
                : json["prefer_jathakam_type_unserialize"] != ""
                    ? List<String>.from(json["prefer_jathakam_type_unserialize"]
                        .map((x) => x ?? ""))
                    : null,
        complexionUnserializeId: json["complexion_unserialize_id"] == null
            ? null
            : json["complexion_unserialize_id"] != ""
                ? List<String>.from(
                    json["complexion_unserialize_id"].map((x) => x ?? ""))
                : null,
        complexionUnserialize: json["complexion_unserialize"] == null
            ? null
            : json["complexion_unserialize"] != ""
                ? List<String>.from(
                    json["complexion_unserialize"].map((x) => x ?? ""))
                : null,
        bodyTypesUnserializeId: json["body_types_unserialize_id"] == null
            ? null
            : json["body_types_unserialize_id"] != ""
                ? List<String>.from(
                    json["body_types_unserialize_id"].map((x) => x ?? ""))
                : null,
        bodyTypesUnserialize: json["body_types_unserialize"] == null
            ? null
            : json["body_types_unserialize"] != ""
                ? List<String>.from(
                    json["body_types_unserialize"].map((x) => x ?? ""))
                : null,
        casteUnserializeId: json["caste_unserialize_id"] == null
            ? null
            : json["caste_unserialize_id"] != ""
                ? List<String>.from(
                    json["caste_unserialize_id"].map((x) => x ?? ""))
                : null,
        casteUnserialize: json["caste_unserialize"] == null
            ? null
            : json["caste_unserialize"] != ""
                ? List<String>.from(
                    json["caste_unserialize"].map((x) => x ?? ""))
                : null,
        statesUnserializeId: json["states_unserialize_id"] == null
            ? null
            : json["states_unserialize_id"] != ""
                ? List<String>.from(
                    json["states_unserialize_id"].map((x) => x ?? ""))
                : null,
        statesUnserialize: json["states_unserialize"] == null
            ? null
            : json["states_unserialize"] != ""
                ? List<String>.from(
                    json["states_unserialize"].map((x) => x ?? ""))
                : null,
        districtsUnserializeId: json["districts_unserialize_id"] == null
            ? null
            : json["districts_unserialize_id"] != ""
                ? List<String>.from(
                    json["districts_unserialize_id"].map((x) => x ?? ""))
                : null,
        districtsUnserialize: json["districts_unserialize"] == null
            ? null
            : json["districts_unserialize"] != ""
                ? List<String>.from(
                    json["districts_unserialize"].map((x) => x ?? ""))
                : null,
        educationCategoryUnserializeId:
            json["education_category_unserialize_id"] == null
                ? null
                : json["education_category_unserialize_id"] != ""
                    ? List<String>.from(
                        json["education_category_unserialize_id"]
                            .map((x) => x ?? ""))
                    : null,
        educationCategoryUnserialize: json["education_category_unserialize"] ==
                null
            ? null
            : json["education_category_unserialize"] != ""
                ? List<String>.from(
                    json["education_category_unserialize"].map((x) => x ?? ""))
                : null,
        jobCategoryUnserializeId: json["job_category_unserialize_id"] == null
            ? null
            : json["job_category_unserialize_id"] != ""
                ? List<String>.from(
                    json["job_category_unserialize_id"].map((x) => x ?? ""))
                : null,
        jobCategoryUnserialize: json["job_category_unserialize"] == null
            ? null
            : json["job_category_unserialize"] != ""
                ? List<dynamic>.from(
                    json["job_category_unserialize"].map((x) => x ?? ''))
                : null,
        maritalStatusUnserializeId: json["marital_status_unserialize_id"] ==
                    null ||
                json["marital_status_unserialize_id"] == ""
            ? null
            : json["marital_status_unserialize_id"] != ""
                ? List<String>.from(
                    json["marital_status_unserialize_id"].map((x) => x ?? ""))
                : null,
        maritalStatusUnserialize: json["marital_status_unserialize"] == null ||
                json["marital_status_unserialize"] == ""
            ? null
            : json["marital_status_unserialize"] != ""
                ? List<String>.from(
                    json["marital_status_unserialize"].map((x) => x ?? ""))
                : null,
        locationUnserializeId: json["location_unserialize_id"] == null
            ? null
            : json["location_unserialize_id"] != ""
                ? List<String>.from(
                    json["location_unserialize_id"].map((x) => x ?? ""))
                : null,
        locationUnserialize: json["location_unserialize"] == null
            ? null
            : json["location_unserialize"] != ""
                ? List<String>.from(
                    json["location_unserialize"].map((x) => x ?? ""))
                : null,
        religions: json["religions"] == null
            ? null
            : ReligionListData.fromJson(json["religions"]),
        fromHeight: json["from_height"] == null
            ? null
            : Height.fromJson(json["from_height"]),
        toHeight: json["to_height"] == null
            ? null
            : Height.fromJson(json["to_height"]),
        fromAge:
            json["from_age"] == null ? null : Age.fromJson(json["from_age"]),
        toAge: json["to_age"] == null ? null : Age.fromJson(json["to_age"]),
        country: json["country"] == null
            ? null
            : CountryData.fromJson(json["country"]),
        preferredEducation: json["prefered_education"] != null
            ? List<PreferredEducation>.from(json["prefered_education"]
                .map((x) => PreferredEducation.fromJson(x)))
            : null,
        preferedJob: json["prefered_job"] != null
            ? List<PreferredJob>.from(
                json["prefered_job"].map((x) => PreferredJob.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "users_id": usersId == null ? null : usersId,
        "religions_id": religionsId == null ? null : religionsId,
        "caste_id": casteId == null ? null : casteId,
        "sub_caste": subCaste == null ? null : subCaste,
        "prefer_age_from_id": preferAgeFromId == null ? null : preferAgeFromId,
        "prefer_age_to_id": preferAgeToId == null ? null : preferAgeToId,
        "prefer_height_from_id":
            preferHeightFromId == null ? null : preferHeightFromId,
        "prefer_height_to_id":
            preferHeightToId == null ? null : preferHeightToId,
        "countries_id": countriesId == null ? null : countriesId,
        "states_id": statesId == null ? null : statesId,
        "districts_id": districtsId == null ? null : districtsId,
        "complexion_id": complexionId == null ? null : complexionId,
        "body_types_id": bodyTypesId == null ? null : bodyTypesId,
        "prefer_jathakam_type":
            preferJathakamType == null ? null : preferJathakamType,
        "education_category_id":
            educationCategoryId == null ? null : educationCategoryId,
        "job_category_id": jobCategoryId == null ? null : jobCategoryId,
        "marital_status_id": maritalStatusId == null ? null : maritalStatusId,
        "location_id": locationId == null ? null : locationId,
        "education_info": educationInfo == null ? null : educationInfo,
        "job_info": jobInfo == null ? null : jobInfo,
        "job_location": jobLocation == null ? null : jobLocation,
        "financial_expectation":
            financialExpectation == null ? null : financialExpectation,
        "prefer_special_case":
            preferSpecialCase == null ? null : preferSpecialCase,
        "other_religious_expectation": otherReligiousExpectation == null
            ? null
            : otherReligiousExpectation,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "prefer_jathakam_type_unserialize_id":
            preferJathakamTypeUnserializeId == null
                ? null
                : List<dynamic>.from(
                    preferJathakamTypeUnserializeId!.map((x) => x)),
        "prefer_jathakam_type_unserialize": preferJathakamTypeUnserialize ==
                null
            ? null
            : List<dynamic>.from(preferJathakamTypeUnserialize!.map((x) => x)),
        "complexion_unserialize_id": complexionUnserializeId == null
            ? null
            : List<dynamic>.from(complexionUnserializeId!.map((x) => x)),
        "complexion_unserialize": complexionUnserialize == null
            ? null
            : List<dynamic>.from(complexionUnserialize!.map((x) => x)),
        "body_types_unserialize_id": bodyTypesUnserializeId == null
            ? null
            : List<dynamic>.from(bodyTypesUnserializeId!.map((x) => x)),
        "body_types_unserialize": bodyTypesUnserialize == null
            ? null
            : List<dynamic>.from(bodyTypesUnserialize!.map((x) => x)),
        "caste_unserialize_id": casteUnserializeId == null
            ? null
            : List<dynamic>.from(casteUnserializeId!.map((x) => x)),
        "caste_unserialize": casteUnserialize == null
            ? null
            : List<dynamic>.from(casteUnserialize!.map((x) => x)),
        "states_unserialize_id": statesUnserializeId == null
            ? null
            : List<dynamic>.from(statesUnserializeId!.map((x) => x)),
        "states_unserialize": statesUnserialize == null
            ? null
            : List<dynamic>.from(statesUnserialize!.map((x) => x)),
        "districts_unserialize_id": districtsUnserializeId == null
            ? null
            : List<dynamic>.from(districtsUnserializeId!.map((x) => x)),
        "districts_unserialize": districtsUnserialize == null
            ? null
            : List<dynamic>.from(districtsUnserialize!.map((x) => x)),
        "education_category_unserialize_id": educationCategoryUnserializeId ==
                null
            ? null
            : List<dynamic>.from(educationCategoryUnserializeId!.map((x) => x)),
        "education_category_unserialize": educationCategoryUnserialize == null
            ? null
            : List<dynamic>.from(educationCategoryUnserialize!.map((x) => x)),
        "job_category_unserialize_id": jobCategoryUnserializeId == null
            ? null
            : List<dynamic>.from(jobCategoryUnserializeId!.map((x) => x)),
        "job_category_unserialize": jobCategoryUnserialize == null
            ? null
            : List<dynamic>.from(jobCategoryUnserialize!.map((x) => x)),
        "marital_status_unserialize_id": maritalStatusUnserializeId == null
            ? null
            : List<dynamic>.from(maritalStatusUnserializeId!.map((x) => x)),
        "marital_status_unserialize": maritalStatusUnserialize == null
            ? null
            : List<dynamic>.from(maritalStatusUnserialize!.map((x) => x)),
        "location_unserialize_id": locationUnserializeId == null
            ? null
            : List<dynamic>.from(locationUnserializeId!.map((x) => x)),
        "location_unserialize": locationUnserialize == null
            ? null
            : List<dynamic>.from(locationUnserialize!.map((x) => x)),
        "religions": religions == null ? null : religions?.toJson(),
        "from_height": fromHeight == null ? null : fromHeight?.toJson(),
        "to_height": toHeight == null ? null : toHeight?.toJson(),
        "from_age": fromAge == null ? null : fromAge?.toJson(),
        "to_age": toAge == null ? null : toAge?.toJson(),
        "country": country == null ? null : country?.toJson(),
        "prefered_education":
            List<dynamic>.from(preferredEducation!.map((x) => x.toJson())),
        "prefered_job": List<dynamic>.from(preferedJob!.map((x) => x.toJson())),
      };
}

// class CountryData {
//   CountryData({
//     this.id,
//     this.countryName,
//     this.countryFlag,
//   });
//
//   int? id;
//   String? countryName;
//   String? countryFlag;
//
//   factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
//         id: json["id"] == null ? null : json["id"],
//         countryName: json["country_name"] == null ? null : json["country_name"],
//         countryFlag: json["country_flag"] == null ? null : json["country_flag"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "country_name": countryName == null ? null : countryName,
//         "country_flag": countryFlag == null ? null : countryFlag,
//       };
// }

class Age {
  Age({
    this.age,
    this.id,
  });

  int? age;
  int? id;

  factory Age.fromJson(Map<String, dynamic> json) => Age(
        age: json["age"] == null ? null : json["age"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "age": age == null ? null : age,
        "id": id == null ? null : id,
      };
}

class Height {
  Height({
    this.height,
    this.heightValue,
    this.id,
  });

  String? height;
  int? heightValue;
  int? id;

  factory Height.fromJson(Map<String, dynamic> json) => Height(
        height: json["height"] == null ? null : json["height"],
        heightValue: json["height_value"] == null ? null : json["height_value"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "height": height == null ? null : height,
        "height_value": heightValue == null ? null : heightValue,
        "id": id == null ? null : id,
      };
}

class PreferredEducation {
  int? id;
  String? parentEducationCategory;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? marks;
  int? position;
  List<ChildEducationCategory>? childEducationCategory;

  PreferredEducation(
      {this.id,
      this.parentEducationCategory,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.marks,
      this.position,
      this.childEducationCategory});

  PreferredEducation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentEducationCategory = json['parent_education_category'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    marks = json['marks'];
    position = json['position'];
    if (json['child_education_category'] != null) {
      childEducationCategory = <ChildEducationCategory>[];
      json['child_education_category'].forEach((v) {
        childEducationCategory!.add(ChildEducationCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_education_category'] = parentEducationCategory;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['marks'] = marks;
    data['position'] = position;
    if (childEducationCategory != null) {
      data['child_education_category'] =
          childEducationCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildEducationCategory {
  int? id;
  String? eduCategoryTitle;
  int? isSelected;
  String? createdAt;
  String? updatedAt;
  int? laravelThroughKey;

  ChildEducationCategory(
      {this.id,
      this.eduCategoryTitle,
      this.isSelected,
      this.createdAt,
      this.updatedAt,
      this.laravelThroughKey});

  ChildEducationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eduCategoryTitle = json['edu_category_title'];
    isSelected = json['is_selected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    laravelThroughKey = json['laravel_through_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['edu_category_title'] = eduCategoryTitle;
    data['is_selected'] = isSelected;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['laravel_through_key'] = laravelThroughKey;
    return data;
  }
}

class PreferredJob {
  PreferredJob({
    this.id,
    this.parentJobCategory,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.childJobCategory,
  });

  int? id;
  String? parentJobCategory;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ChildJobCategory>? childJobCategory;

  factory PreferredJob.fromJson(Map<String, dynamic> json) => PreferredJob(
        id: json["id"],
        parentJobCategory: json["parent_job_category"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        childJobCategory: List<ChildJobCategory>.from(json["child_job_category"]
            .map((x) => ChildJobCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_job_category": parentJobCategory,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "child_job_category":
            List<dynamic>.from(childJobCategory!.map((x) => x.toJson())),
      };
}

// class ReligionListData {
//   ReligionListData({
//     this.religionName,
//     this.id,
//   });
//
//   String? religionName;
//   int? id;
//
//   factory ReligionListData.fromJson(Map<String, dynamic> json) => ReligionListData(
//         religionName:
//             json["religion_name"] == null ? null : json["religion_name"],
//         id: json["id"] == null ? null : json["id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "religion_name": religionName == null ? null : religionName,
//         "id": id == null ? null : id,
//       };
// }
