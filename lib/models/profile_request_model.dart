class LocationRequest {
  String? profileId;
  String? houseAddress = '';
  String? locationName = '';
  double? longitude;
  double? latitude;
  String? mobile;
  String? phoneNo;
  String? whatsappNo;
  int? location;
  int? district;
  int? state;
  int? country;
  String? dialCode;

  LocationRequest(
      {this.profileId,
      this.houseAddress = '',
      this.locationName = '',
      this.longitude = 0,
      this.latitude = 0,
      this.mobile,
      this.phoneNo,
      this.whatsappNo,
      this.location,
      this.district,
      this.state,
      this.country,
      this.dialCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_id'] = profileId;
    if ((houseAddress ?? "") != "") data['house_address'] = houseAddress;
    if ((locationName ?? "") != "") data['location_name'] = locationName;
    if ((longitude ?? 0.0) != 0.0) data['longitude'] = longitude;
    if ((latitude ?? 0.0) != 0.0) data['latitude'] = latitude;
    if ((mobile ?? "") != "") data['mobile'] = mobile;
    if ((phoneNo ?? "") != "") data['phone_no'] = phoneNo;
    if ((whatsappNo ?? "") != "") data['whatsapp_no'] = whatsappNo;
    if ((location ?? 0) != 0) data['location'] = location;
    if ((district ?? 0) != 0) data['district'] = district;
    if ((state ?? 0) != 0) data['state'] = state;
    if ((country ?? 0) != 0) data['country'] = country;
    if ((dialCode ?? "") != "") data['user_dial_code'] = dialCode;
    return data;
  }
}

class BasicInfoRequest {
  String? profileId;
  String? height;
  String? maritalStatus;
  String? createdBy;
  int? bodyType;
  int? complexion;

  BasicInfoRequest(
      {this.profileId,
      this.height,
      this.maritalStatus,
      this.createdBy,
      this.bodyType,
      this.complexion});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((profileId ?? "") != "") data['profile_id'] = profileId;
    if ((height ?? "") != "") data['height'] = height;
    if ((maritalStatus ?? "") != "") data['martial_status'] = maritalStatus;
    if ((createdBy ?? "") != "") data['created_by'] = createdBy;
    if ((bodyType ?? 0) != 0) data['body_type'] = bodyType;
    if ((complexion ?? 0) != 0) data['complexion'] = complexion;
    return data;
  }
}

class FamilyDetailsRequest {
  String? profileId;
  String? fatherName;
  String? fatherJob;
  String? motherName;
  String? motherJob;
  String? siblingDetails;

  FamilyDetailsRequest(
      {this.profileId,
      this.fatherName,
      this.fatherJob,
      this.motherName,
      this.motherJob,
      this.siblingDetails});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_id'] = profileId;
    data['father_name'] = fatherName;
    data['father_job'] = fatherJob;
    data['mother_name'] = motherName;
    data['mother_job'] = motherJob;
    data['sibling_info'] = siblingDetails;
    return data;
  }
}

class ReligionInfoRequest {
  int? profileId;
  int? religion;
  int? caste;
  String? subCaste;

  ReligionInfoRequest(
      {this.profileId, this.religion, this.caste, this.subCaste});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((profileId ?? 0) != 0) data['profile_id'] = profileId;
    if ((religion ?? 0) != 0) data['religion'] = religion;
    if ((caste ?? 0) != 0) data['caste'] = caste;
    if ((subCaste ?? "") != "") data['sub_caste'] = subCaste;
    return data;
  }
}

class ProfessionalInfoRequest {
  int? profileId;
  int? educationCategory;
  String? educationDetail;
  int? jobCategory;
  String? jobDetail;
  int? educationParentId;
  int? jobParentId;

  ProfessionalInfoRequest(
      {this.profileId,
      this.educationCategory,
      this.educationDetail,
      this.jobCategory,
      this.jobDetail,
      this.educationParentId,
      this.jobParentId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_id'] = profileId;
    data['education'] = educationCategory;
    data['education_info'] = educationDetail;
    data['job_category'] = jobCategory;
    data['job_details'] = jobDetail;
    data['education_parent_id'] = educationParentId;
    data['job_parent_id'] = jobParentId;
    return data;
  }
}

class HoroscopeDetailsRequest {
  String? birthTime;
  String? janmaSistaDate;
  int? dasa;
  String? dobMalayalam;
  String? starRasi;

  HoroscopeDetailsRequest(
      {this.birthTime,
      this.janmaSistaDate,
      this.dasa,
      this.dobMalayalam,
      this.starRasi});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birth_time'] = birthTime;
    data['janma_sista_dasa_end'] = janmaSistaDate;
    if ((dasa ?? 0) != 0) data['jathakam_types_id'] = dasa;
    if ((dobMalayalam ?? "") != "") data['dob_malayalam'] = dobMalayalam;
    if ((starRasi ?? "") != "") data['star_rasi'] = starRasi;
    return data;
  }
}

class ChangeMobileRequest {
  int? countryCode;
  String? mobileNumber;
  int? profileId;
  int? otp;

  ChangeMobileRequest(
      {this.countryCode, this.mobileNumber, this.profileId, this.otp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((countryCode ?? 0) != 0) data['country_code_id'] = countryCode;
    if ((mobileNumber ?? "") != "") data['mobile'] = mobileNumber;
    if ((profileId ?? 0) != 0) data['profile_id'] = profileId;
    if (otp != null) data['otp'] = otp;
    return data;
  }
}
