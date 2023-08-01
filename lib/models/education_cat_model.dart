import 'package:nest_matrimony/models/res_status_model.dart';

class EducationCategoryModel extends ResStatusModel {
  List<EducationCategoryData>? data;

  EducationCategoryModel({this.data});

  EducationCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EducationCategoryData>[];
      json['data'].forEach((v) {
        data!.add(EducationCategoryData.fromJson(v));
      });
    }
  }
}

class EducationCategoryData {
  int? id;
  String? parentEducationCategory;
  List<ChildEducationCategory>? childEducationCategory;

  EducationCategoryData(
      {this.id, this.parentEducationCategory, this.childEducationCategory});

  EducationCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentEducationCategory = json['parent_education_category'];
    if (json['child_education_category'] != null) {
      childEducationCategory = <ChildEducationCategory>[];
      json['child_education_category'].forEach((v) {
        childEducationCategory!.add(ChildEducationCategory.fromJson(v));
      });
    }
  }
}

class ChildEducationCategory {
  int? id;
  String? eduCategoryTitle;
  int? laravelThroughKey;

  ChildEducationCategory(
      {this.id, this.eduCategoryTitle, this.laravelThroughKey});

  ChildEducationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eduCategoryTitle = json['edu_category_title'];
    laravelThroughKey = json['laravel_through_key'];
  }
}
