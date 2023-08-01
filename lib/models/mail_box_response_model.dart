class InterestResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? datas;

  InterestResponseModel({status, statusCode, message, data});

  InterestResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    datas = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Original? original;
  var exception;

  Data({headers, original, exception});

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
  List<InterestUserData>? datas;
  bool? status;
  int? lastPageNumber;
  String? currentPage;
  String? itemPerPage;
  Input? input;

  Original(
      {draw,
      recordsTotal,
      recordsFiltered,
      data,
      status,
      lastPageNumber,
      currentPage,
      itemPerPage,
      input});

  Original.fromJson(Map<String, dynamic> json) {
    draw = json['draw'];
    recordsTotal = json['recordsTotal'];
    recordsFiltered = json['recordsFiltered'];
    if (json['data'] != null) {
      datas = <InterestUserData>[];
      json['data'].forEach((v) {
        datas!.add(InterestUserData.fromJson(v));
      });
    }
    status = json['status'];
    lastPageNumber = json['last_page_number'];
    currentPage = json['current_page'];
    itemPerPage = json['Item_per_page'];
    input = json['input'] != null ? Input.fromJson(json['input']) : null;
  }
}

class InterestUserData {
  String? interestReceivedDate;
  String? interestSentDate;
  String? interestAcceptedDate;
  String? interestApprovedDate;
  String? interestDeclinedDate;
  String? interestRejectedDate;
  String? viewedDate;
  String? shortListDate;
  int? id;
  int? interestProfileId;
  UserDetails? userDetails;
  String? staffPhone;
  InterestUserData(
      {interestReceivedDate,
      userDetails,
      interestSentDate,
      interestAcceptedDate,
      interestApprovedDate,
      interestDeclinedDate,
      id,
      interestProfileId,
      viewedDate,
      shortListDate,
      staffPhone});

  InterestUserData.fromJson(Map<String, dynamic> json) {
    interestReceivedDate = json['interest_received_date'];
    interestSentDate = json['interest_send_date'];
    interestAcceptedDate = json['interest_accepted_date'];
    interestApprovedDate = json['interest_approved_date'];
    interestDeclinedDate = json['interest_declined_date'];
    interestRejectedDate = json['interest_rejected_date'];
    shortListDate = json['short_list_date'];
    viewedDate = json['viewed_date'];
    staffPhone = json['staff_phone'];
    id = json['id'];
    interestProfileId = json['interest_profile_id'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
  }
}

class UserDetails {
  int? id;
  String? name;
  int? age;
  String? registerId;
  String? mobile;
  int? religionsId;
  int? casteId;
  int? heightListId;
  int? educationCategoryId;
  int? jobCategoryId;
  int? countriesId;
  int? statesId;
  int? districtsId;
  int? locationsId;
  String? profileActiveStatus;
  String? profileVerificationStatus;
  bool? premiumAccount;
  bool? isMale;
  bool? isHindu;
  UserReligion? userReligion;
  UserCaste? userCaste;
  UserState? userState;
  UserDistricts? userDistricts;
  UserLocation? userLocation;
  UserHeightList? userHeightList;
  UserJobSubCategory? userJobSubCategory;
  UserEducationSubcategory? userEducationSubcategory;
  List<UserImage>? userImage;
  var userPackage;
  String? basicDetails;
  String? address;
  UserDetails(
      {id,
      name,
      age,
      registerId,
      mobile,
      religionsId,
      casteId,
      heightListId,
      educationCategoryId,
      jobCategoryId,
      countriesId,
      statesId,
      districtsId,
      locationsId,
      profileActiveStatus,
      profileVerificationStatus,
      premiumAccount,
      isMale,
      isHindu,
      userReligion,
      userCaste,
      userState,
      userDistricts,
      userLocation,
      userHeightList,
      userJobSubCategory,
      userEducationSubcategory,
      userImage,
      userPackage,
      basicDetails,
      address});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    registerId = json['register_id'];
    mobile = json['mobile'];
    religionsId = json['religions_id'];
    casteId = json['caste_id'];
    heightListId = json['height_list_id'];
    educationCategoryId = json['education_category_id'];
    jobCategoryId = json['job_category_id'];
    countriesId = json['countries_id'];
    statesId = json['states_id'];
    districtsId = json['districts_id'];
    locationsId = json['locations_id'];
    profileActiveStatus = json['profile_active_status'];
    profileVerificationStatus = json['profile_verification_status'];
    premiumAccount = json['premium_account'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    userReligion = json['user_religion'] != null
        ? UserReligion.fromJson(json['user_religion'])
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
    userLocation = json['user_location'] != null
        ? UserLocation.fromJson(json['user_location'])
        : null;
    userHeightList = json['user_height_list'] != null
        ? UserHeightList.fromJson(json['user_height_list'])
        : null;
    userJobSubCategory = json['user_job_sub_category'] != null
        ? UserJobSubCategory.fromJson(json['user_job_sub_category'])
        : null;
    userEducationSubcategory = json['user_education_subcategory'] != null
        ? UserEducationSubcategory.fromJson(json['user_education_subcategory'])
        : null;
    if (json['user_image'] != null) {
      userImage = <UserImage>[];
      json['user_image'].forEach((v) {
        userImage!.add(UserImage.fromJson(v));
      });
    }
    userPackage = json['user_package'];
    basicDetails =
        '${age != null ? '$age yrs, ' : ''}${userHeightList?.heightValue != null ? "${userHeightList?.heightValue} cm, " : ''}${userCaste?.casteName != null ? '${userCaste?.casteName}, ' : ''}${userEducationSubcategory?.eduCategoryTitle ?? ''}';
    address =
        '${json['user_districts'] != null ? json['user_districts']['district_name'] + ',' : ''} ${json['user_state'] != null ? json['user_state']['state_name'] : ''}';
  }
}

class UserReligion {
  String? religionName;
  int? id;

  UserReligion({religionName, id});

  UserReligion.fromJson(Map<String, dynamic> json) {
    religionName = json['religion_name'];
    id = json['id'];
  }
}

class UserCaste {
  String? casteName;
  int? id;

  UserCaste({casteName, id});

  UserCaste.fromJson(Map<String, dynamic> json) {
    casteName = json['caste_name'];
    id = json['id'];
  }
}

class UserState {
  String? stateName;
  int? id;

  UserState({stateName, id});

  UserState.fromJson(Map<String, dynamic> json) {
    stateName = json['state_name'];
    id = json['id'];
  }
}

class UserDistricts {
  String? districtName;
  int? id;

  UserDistricts({districtName, id});

  UserDistricts.fromJson(Map<String, dynamic> json) {
    districtName = json['district_name'];
    id = json['id'];
  }
}

class UserLocation {
  String? locationName;
  int? id;

  UserLocation({locationName, id});

  UserLocation.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    id = json['id'];
  }
}

class UserHeightList {
  String? height;
  int? heightValue;
  int? id;

  UserHeightList({height, heightValue, id});

  UserHeightList.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    heightValue = json['height_value'];
    id = json['id'];
  }
}

class UserJobSubCategory {
  String? subcategoryName;
  int? id;

  UserJobSubCategory({subcategoryName, id});

  UserJobSubCategory.fromJson(Map<String, dynamic> json) {
    subcategoryName = json['subcategory_name'];
    id = json['id'];
  }
}

class UserEducationSubcategory {
  String? eduCategoryTitle;
  int? id;

  UserEducationSubcategory({eduCategoryTitle, id});

  UserEducationSubcategory.fromJson(Map<String, dynamic> json) {
    eduCategoryTitle = json['edu_category_title'];
    id = json['id'];
  }
}

class Input {
  String? length;
  String? page;

  Input({length, page});

  Input.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    page = json['page'];
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
