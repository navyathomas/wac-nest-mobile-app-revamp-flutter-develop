class ServiceChatListResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<ServiceChatData>? data;

  ServiceChatListResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  ServiceChatListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServiceChatData>[];
      json['data'].forEach((v) {
        data!.add(ServiceChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceChatData {
  int? id;
  int? serviceId;
  String? message;
  String? createdBy;
  String? createdAt;
  GetServiceData? getServiceData;

  ServiceChatData(
      {this.id,
      this.serviceId,
      this.message,
      this.getServiceData,
      this.createdBy,
      this.createdAt});

  ServiceChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    message = json['message'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    getServiceData = json['get_service_data'] != null
        ? GetServiceData.fromJson(json['get_service_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['message'] = message;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    if (getServiceData != null) {
      data['get_service_data'] = getServiceData!.toJson();
    }
    return data;
  }
}

class GetServiceData {
  int? staffsId;
  int? id;
  int? serviceId;
  int? serviceTypesId;
  StaffData? staffData;

  GetServiceData(
      {this.staffsId,
      this.id,
      this.serviceId,
      this.serviceTypesId,
      this.staffData});

  GetServiceData.fromJson(Map<String, dynamic> json) {
    staffsId = json['staffs_id'];
    id = json['id'];
    serviceId = json['service_id'];
    serviceTypesId = json['service_types_id'];
    staffData = json['staff_data'] != null
        ? StaffData.fromJson(json['staff_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staffs_id'] = staffsId;
    data['id'] = id;
    data['service_id'] = serviceId;
    data['service_types_id'] = serviceTypesId;
    if (staffData != null) {
      data['staff_data'] = staffData!.toJson();
    }
    return data;
  }
}

class StaffData {
  String? staffName;
  int? id;

  StaffData({this.staffName, this.id});

  StaffData.fromJson(Map<String, dynamic> json) {
    staffName = json['staff_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staff_name'] = staffName;
    data['id'] = id;
    return data;
  }
}
