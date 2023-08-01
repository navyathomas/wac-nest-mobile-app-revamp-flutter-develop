import 'package:nest_matrimony/models/res_status_model.dart';

class JobDataModel extends ResStatusModel {
  List<JobData>? jobData;

  JobDataModel({this.jobData});

  JobDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      jobData = <JobData>[];
      json['data'].forEach((v) {
        jobData!.add(JobData.fromJson(v));
      });
    }
  }
}

class JobData {
  int? id;
  String? parentJobCategory;

  JobData({this.id, this.parentJobCategory});

  JobData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['parent_job_category'] != null) {
      parentJobCategory = json['parent_job_category'];
    } else {
      parentJobCategory = json['subcategory_name'];
    }
  }
}
