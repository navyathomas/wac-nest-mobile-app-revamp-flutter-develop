import 'dart:developer';

class ServicesResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  ServicesResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Original? original;
  var exception;

  Data({this.original, this.exception});

  Data.fromJson(Map<String, dynamic> json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }
}

class Original {
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<ListData>? data;
  bool? status;
  int? lastPageNumber;
  String? currentPage;
  String? itemPerPage;
  Input? input;

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
      data = <ListData>[];
      json['data'].forEach((v) {
        data!.add(ListData.fromJson(v));
      });
    }
    status = json['status'];
    lastPageNumber = json['last_page_number'];
    currentPage = json['current_page'];
    itemPerPage = json['Item_per_page'];
    input = json['input'] != null ? Input.fromJson(json['input']) : null;
  }
}

class ListData {
  String? label;
  List<ServicesData>? data;

  ListData({this.label, this.data});

  ListData.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['data'] != null) {
      data = <ServicesData>[];
      json['data'].forEach((v) {
        data!.add(ServicesData.fromJson(v));
      });
    }
  }
}

class ServicesData {
  int? id;
  int? serviceTypesId;
  int? serviceId;
  int? clientUsersId;
  String? clientWebId;
  int? partnerClientUsersId;
  String? partnerClientWebId;
  String? datedOn;
  String? followUpDate;
  String? followUpTime;
  List<dynamic>? serviceRemark;
  String? createdAt;
  String? updatedAt;
  int? isDeleted;
  int? staffsId;
  var clientAcceptStatus;
  var partnerAcceptStatus;
  int? clientViewStatus;
  int? partnerViewStatus;
  UserServiceType? userServiceType;
  UserData? userData;
  PartnerUserData? partnerUserData;
  StaffData? staffData;
  List<Service>? service;

  ServicesData(
      {this.id,
      this.serviceTypesId,
      this.serviceId,
      this.clientUsersId,
      this.clientWebId,
      this.partnerClientUsersId,
      this.partnerClientWebId,
      this.datedOn,
      this.followUpDate,
      this.followUpTime,
      this.serviceRemark,
      this.createdAt,
      this.updatedAt,
      this.isDeleted,
      this.staffsId,
      this.clientAcceptStatus,
      this.partnerAcceptStatus,
      this.clientViewStatus,
      this.partnerViewStatus,
      this.userServiceType,
      this.userData,
      this.partnerUserData,
      this.staffData,
      this.service});

  ServicesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceTypesId = json['service_types_id'];
    serviceId = json['service_id'];
    clientUsersId = json['client_users_id'];
    clientWebId = json['client_web_id'];
    partnerClientUsersId = json['partner_client_users_id'];
    partnerClientWebId = json['partner_client_web_id'];
    datedOn = json['dated_on'];
    followUpDate = json['follow_up_date'];
    followUpTime = json['follow_up_time'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    staffsId = json['staffs_id'];
    clientAcceptStatus = json['client_accept_status'];
    partnerAcceptStatus = json['partner_accept_status'];
    clientViewStatus = json['client_view_status'];
    partnerViewStatus = json['partner_view_status'];
    userServiceType = json['user_service_type'] != null
        ? UserServiceType.fromJson(json['user_service_type'])
        : null;
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
    partnerUserData = json['partner_user_data'] != null
        ? PartnerUserData.fromJson(json['partner_user_data'])
        : null;
    staffData = json['staff_data'] != null
        ? StaffData.fromJson(json['staff_data'])
        : null;
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(Service.fromJson(v));
      });
    }
  }
}

class UserServiceType {
  int? id;
  String? serviceType;

  UserServiceType({this.id, this.serviceType});

  UserServiceType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceType = json['service_type'];
  }
}

class UserData {
  int? id;
  String? name;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  int? scorePercentage;
  bool? isProtected;
  List<UserPreferImage>? userPerferImage;
  var userPackage;
  var userReligion;

  UserData(
      {this.id,
      this.name,
      this.premiumAccount,
      this.isMale,
      this.isHindu,
      this.scorePercentage,
      this.isProtected,
      this.userPerferImage,
      this.userPackage,
      this.userReligion});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    scorePercentage = json['score_percentage'];
    isProtected = json['is_protected'];
    if (json['user_perfer_image'] != null) {
      userPerferImage = <UserPreferImage>[];
      json['user_perfer_image'].forEach((v) {
        userPerferImage!.add(UserPreferImage.fromJson(v));
      });
    }
    userPackage = json['user_package'];
    userReligion = json['user_religion'];
  }
}

class UserPreferImage {
  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;
  int? isBackedUp;
  String? createdAt;
  String? updatedAt;
  int? isPreference;

  UserPreferImage(
      {this.id,
      this.usersId,
      this.imageFile,
      this.imageApprove,
      this.isBackedUp,
      this.createdAt,
      this.updatedAt,
      this.isPreference});

  UserPreferImage.fromJson(Map<String, dynamic> json) {
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

class PartnerUserData {
  int? id;
  String? name;
  String? nestId;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  int? scorePercentage;
  bool? isProtected;
  List<UserPreferImage>? userPerferImage;
  var userPackage;
  var userReligion;

  PartnerUserData(
      {this.id,
      this.name,
      this.nestId,
      this.premiumAccount,
      this.isMale,
      this.isHindu,
      this.scorePercentage,
      this.isProtected,
      this.userPerferImage,
      this.userPackage,
      this.userReligion});

  PartnerUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nestId = json['nest_id'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    scorePercentage = json['score_percentage'];
    isProtected = json['is_protected'];
    if (json['user_perfer_image'] != null) {
      userPerferImage = <UserPreferImage>[];
      json['user_perfer_image'].forEach((v) {
        userPerferImage!.add(UserPreferImage.fromJson(v));
      });
    }
    userPackage = json['user_package'];
    userReligion = json['user_religion'];
  }
}

class StaffData {
  int? id;
  String? staffName;
  String? mobile;
  String? officeNumber;
  int? branchesId;
  Branch? branch;

  StaffData(
      {this.id,
      this.staffName,
      this.branchesId,
      this.branch,
      this.mobile,
      this.officeNumber});

  StaffData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffName = json['staff_name'];
    branchesId = json['branches_id'];
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    mobile = json['mobile'];
    officeNumber = json['office_number'];
  }
}

class Branch {
  int? id;
  String? branchName;
  String? branchCode;
  String? branchAddress;
  int? countryId;
  int? stateId;
  int? districtId;
  int? locationsId;
  String? landLine;
  String? whatsappNo;
  String? mobile1;
  String? mobile2;
  String? email;
  String? landMark;
  String? bankAccountNo;
  String? bankName;
  String? ifscCode;
  String? bankLocation;
  String? latitude;
  String? longitude;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  Branch(
      {this.id,
      this.branchName,
      this.branchCode,
      this.branchAddress,
      this.countryId,
      this.stateId,
      this.districtId,
      this.locationsId,
      this.landLine,
      this.whatsappNo,
      this.mobile1,
      this.mobile2,
      this.email,
      this.landMark,
      this.bankAccountNo,
      this.bankName,
      this.ifscCode,
      this.bankLocation,
      this.latitude,
      this.longitude,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
    branchCode = json['branch_code'];
    branchAddress = json['branch_address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    districtId = json['district_id'];
    locationsId = json['locations_id'];
    landLine = json['land_line'];
    whatsappNo = json['whatsapp_no'];
    mobile1 = json['mobile_1'];
    mobile2 = json['mobile_2'];
    email = json['email'];
    landMark = json['land_mark'];
    bankAccountNo = json['bank_account_no'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    bankLocation = json['bank_location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Service {
  int? id;
  String? serviceTitle;

  Service({this.id, this.serviceTitle});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceTitle = json['service_title'];
  }
}

class Input {
  String? length;
  String? page;

  Input({this.length, this.page});

  Input.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    page = json['page'];
  }
}
