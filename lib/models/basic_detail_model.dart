import 'package:nest_matrimony/models/res_status_model.dart';

class BasicDetailModel extends ResStatusModel {
  BasicDetail? basicDetail;

  BasicDetailModel({this.basicDetail});

  BasicDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    basicDetail =
        json['data'] != null ? BasicDetail.fromJson(json['data']) : null;
  }
}

class BasicDetail {
  int? id;
  int? religionId;
  int? maritalStatusId;
  String? maritalStatus;
  String? name;
  String? email;
  String? mobile;
  String? registerId;
  String? gender;
  String? registerDate;
  String? religion;
  String? caste;
  String? address;
  bool? isMale;
  bool? isHindu;
  bool? premiumAccount;
  bool? isImageUploaded;
  bool? isBasicProfileUpdated;
  bool? isPartnerDetailsUpdated;
  bool? isProfessionalDetailsUpdated;
  bool? isAddressDetailsUpdated;
  bool? isEducationalDetailsUpdated;
  bool? isIdProofUpdated;
  bool? isHoroscopeUpdated;
  ProfileImage? profileImage;
  int? casteId;

  BasicDetail(
      {this.id,
      this.religionId,
      this.maritalStatusId,
      this.maritalStatus,
      this.name,
      this.email,
      this.mobile,
      this.registerId,
      this.gender,
      this.registerDate,
      this.religion,
      this.caste,
      this.address,
      this.isMale,
      this.isHindu,
      this.premiumAccount,
      this.profileImage,
      this.isImageUploaded,
      this.isBasicProfileUpdated,
      this.isPartnerDetailsUpdated,
      this.isProfessionalDetailsUpdated,
      this.isAddressDetailsUpdated,
      this.isEducationalDetailsUpdated,
      this.isIdProofUpdated,
      this.isHoroscopeUpdated,
      this.casteId});

  BasicDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religionId = json['religion_id'];
    maritalStatusId = json['marital_status_id'];
    maritalStatus = json['marital_status'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    registerId = json['register_id'];
    gender = json['gender'];
    registerDate = json['register_date'];
    religion = json['religion'];
    caste = json['caste'];
    address = json['address'];
    isMale = json['is_male'];
    isHindu = json['is_hindu'];
    premiumAccount = json['premium_account'];
    profileImage = json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'])
        : null;
    isImageUploaded = json['is_image_uploaded'];
    isBasicProfileUpdated = json['is_basic_profile_updated'];
    isPartnerDetailsUpdated = json['is_partner_details_updated'];
    isProfessionalDetailsUpdated = json['is_proffesional_details_updated'];
    isAddressDetailsUpdated = json['is_address_details_updated'];
    isEducationalDetailsUpdated = json['is_educational_details_updated'];
    isIdProofUpdated = json['is_id_proof_updated'];
    isHoroscopeUpdated = json['is_horoscope_updated'];
    casteId = json['caste_id'];
  }
}

class ProfileImage {
  int? id;
  int? usersId;
  String? imageFile;
  String? imageApprove;
  int? isPreference;

  ProfileImage(
      {this.id,
      this.usersId,
      this.imageFile,
      this.imageApprove,
      this.isPreference});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    imageFile = json['image_file'];
    imageApprove = json['image_approve'];
    isPreference = json['is_preference'];
  }
}
