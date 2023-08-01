class JobCategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<JobCategoryData>? data;

  JobCategoryModel({this.status, this.statusCode, this.message, this.data});

  JobCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JobCategoryData>[];
      json['data'].forEach((v) {
        data!.add( JobCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobCategoryData {
  int? id;
  String? parentJobCategory;
  List<ChildJobCategory>? childJobCategory;

  JobCategoryData({this.id, this.parentJobCategory, this.childJobCategory});

  JobCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentJobCategory = json['parent_job_category'];
    if (json['child_job_category'] != null) {
      childJobCategory = <ChildJobCategory>[];
      json['child_job_category'].forEach((v) {
        childJobCategory!.add( ChildJobCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['parent_job_category'] = parentJobCategory;
    if (childJobCategory != null) {
      data['child_job_category'] =
         childJobCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildJobCategory {
  int? id;
  String? subcategoryName;
  int? laravelThroughKey;

  ChildJobCategory({this.id, this.subcategoryName, this.laravelThroughKey});

  ChildJobCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcategoryName = json['subcategory_name'];
    laravelThroughKey = json['laravel_through_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['subcategory_name'] = subcategoryName;
    data['laravel_through_key'] = laravelThroughKey;
    return data;
  }
}
