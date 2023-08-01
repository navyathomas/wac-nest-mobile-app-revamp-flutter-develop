import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/hive_models/paymentDetails.dart';
import 'package:nest_matrimony/models/accept_terms_model.dart';
import 'package:nest_matrimony/models/body_type_list_model.dart';
import 'package:nest_matrimony/models/build_version_model.dart';
import 'package:nest_matrimony/models/cashfree_sent_order.dart';
import 'package:nest_matrimony/models/complexion_list_model.dart';
import 'package:nest_matrimony/models/contact_address_count_model.dart';
import 'package:nest_matrimony/models/createCashfreeModel.dart';
import 'package:nest_matrimony/models/dasa_model.dart';
import 'package:nest_matrimony/models/job_child_categories_model.dart';
import 'package:nest_matrimony/models/body_type_model.dart';
import 'package:nest_matrimony/models/complexion_model.dart';
import 'package:nest_matrimony/models/jathakam_model.dart';
import 'package:nest_matrimony/models/palayer_id_response_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/base_urls_model.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/branches_model.dart';
import 'package:nest_matrimony/models/blocked_users_model.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/models/contact_address_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/delete_category_image_model.dart';
import 'package:nest_matrimony/models/discover_more_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/education_cat_model.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/models/hide_photo_model.dart';
import 'package:nest_matrimony/models/higher_plans_model.dart';
import 'package:nest_matrimony/models/id_proof_photo_model.dart';
import 'package:nest_matrimony/models/job_data_model.dart';
import 'package:nest_matrimony/models/login_via_otp_model.dart';
import 'package:nest_matrimony/models/make_primary_model.dart';
import 'package:nest_matrimony/models/matching_stars_model.dart';
import 'package:nest_matrimony/models/my_photos_model.dart';
import 'package:nest_matrimony/models/offer_check_response_model.dart';
import 'package:nest_matrimony/models/partner_preference_model.dart';
import 'package:nest_matrimony/models/paymentOrderResponseModel.dart';
import 'package:nest_matrimony/models/paymentRegistrationBodyModel.dart';
import 'package:nest_matrimony/models/payment_registration_response_model.dart';
import 'package:nest_matrimony/models/payment_save_response_model.dart';
import 'package:nest_matrimony/models/payment_verify_response_model.dart';
import 'package:nest_matrimony/models/planDetailModel.dart';
import 'package:nest_matrimony/models/policy_model.dart';
import 'package:nest_matrimony/models/profile_complete_model.dart';
import 'package:nest_matrimony/models/profile_data_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/models/see_all_plans_model.dart';
import 'package:nest_matrimony/models/service_chat_list_response_model.dart';
import 'package:nest_matrimony/models/services_reponse_model.dart';
import 'package:nest_matrimony/models/staff_report_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/models/subscriptions_response_model.dart';
import 'package:nest_matrimony/models/terms_check_model.dart';
import 'package:nest_matrimony/models/testimonials_response_model.dart';
import 'package:nest_matrimony/models/upgrade_plan_details.dart';
import 'package:nest_matrimony/models/view_notification_model.dart';
import 'package:nest_matrimony/services/hive_services.dart';

import '../common/constants.dart';
import '../models/app_data_model.dart';
import '../models/city_data_model.dart';
import '../models/horoscope_images_model.dart';
import '../models/inapp_ep_verification_model.dart';
import '../models/interest_accept_decline_response_model.dart';
import '../models/job_category_model.dart';
import '../models/mail_box_response_model.dart';
import '../models/marital_status_model.dart';
import '../models/partner_interest_model.dart';
import '../models/notification_reponse_model.dart';
import '../models/registration_res_model.dart';
import '../models/star_model.dart';
import 'helpers.dart';
import 'http_requests.dart';

class ServiceConfig {
  Future<Result> getAppBackendVersion() async {
    try {
      Result res = await HttpReq.getRequest("app-backend-version");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        AppVersionModel appVersionModel = AppVersionModel.fromJson(response);
        if (appVersionModel.status ?? false) {
          return Result.value(appVersionModel);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getCountriesData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.countryDataList);
      if (fetchFromLocal && localRes != null) {
        CountriesDataModel countriesDataModel =
            CountriesDataModel.fromJson(jsonDecode(localRes));
        return Result.value(countriesDataModel);
      } else {
        Result res = await HttpReq.getRequest("countries-with-dialcode");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          CountriesDataModel countriesDataModel =
              CountriesDataModel.fromJson(response);
          if (countriesDataModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.countryDataList);
            return Result.value(countriesDataModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

// BASE URLS FETCH AND SAVE
  Future<Result> getBaseUrls({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getBaseURLsLocal(HiveServices.baseURLs);
      if (fetchFromLocal && localRes != null) {
        BaseUrLmodel baseURLDataModel =
            BaseUrLmodel.fromJson(jsonDecode(localRes));
        return Result.value(baseURLDataModel);
      } else {
        Result res = await HttpReq.getRequest("image-urls");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          BaseUrLmodel baseURLDataModel = BaseUrLmodel.fromJson(response);
          if (baseURLDataModel.status ?? false) {
            HiveServices.saveBaseURLsLocal(
                val: jsonEncode(response), key: HiveServices.baseURLs);
            return Result.value(baseURLDataModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getAgeData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.agesDataList);
      if (fetchFromLocal && localRes != null) {
        AgeDataListModel ageListModel =
            AgeDataListModel.fromJson(jsonDecode(localRes));
        return Result.value(ageListModel);
      } else {
        Result res = await HttpReq.getRequest("ages");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          AgeDataListModel ageListModel = AgeDataListModel.fromJson(response);
          if (ageListModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.agesDataList);
            return Result.value(ageListModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getEduCatListData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.eduCatListData);
      if (fetchFromLocal && localRes != null) {
        EducationCategoryModel educationCategoryModel =
            EducationCategoryModel.fromJson(jsonDecode(localRes));
        return Result.value(educationCategoryModel);
      } else {
        Result res = await HttpReq.getRequest("child-education-categories");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          EducationCategoryModel educationCategoryModel =
              EducationCategoryModel.fromJson(response);
          if (educationCategoryModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.eduCatListData);
            return Result.value(educationCategoryModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getJobParentListData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.eduCatListData);
      if (fetchFromLocal && localRes != null) {
        JobCategoryModel jobCategoryModel =
            JobCategoryModel.fromJson(jsonDecode(localRes));
        return Result.value(jobCategoryModel);
      } else {
        Result res = await HttpReq.getRequest("child-job-categories");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          JobCategoryModel jobCategoryModel =
              JobCategoryModel.fromJson(response);
          if (jobCategoryModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.jobParentListData);
            return Result.value(jobCategoryModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getJobListData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.jobListData);
      if (fetchFromLocal && localRes != null) {
        JobDataModel jobDataModel = JobDataModel.fromJson(jsonDecode(localRes));
        return Result.value(jobDataModel);
      } else {
        Result res = await HttpReq.getRequest("job-categories");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          JobDataModel jobDataModel = JobDataModel.fromJson(response);
          if (jobDataModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.jobListData);
            return Result.value(jobDataModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getStateDataList(int countryId) async {
    try {
      Result res =
          await HttpReq.getRequest("states-from-country?country_id=$countryId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        StateDataModel stateModel = StateDataModel.fromJson(response);
        return (stateModel.status ?? false)
            ? Result.value(stateModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getSeeAllPlansList() async {
    try {
      Result res = await HttpReq.getRequest("subscriptions");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        SeeAllPlansModel plansModel = SeeAllPlansModel.fromJson(response);
        return (plansModel.status ?? false)
            ? Result.value(plansModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getDistrictDataList(int stateId) async {
    try {
      Result res =
          await HttpReq.getRequest("districts-from-state?state_id=$stateId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        DistrictDataModel dataModel = DistrictDataModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPlanDetail(String planId) async {
    try {
      Result res =
          await HttpReq.getRequest("subscription-plan-details?plan_id=$planId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PlanDetailModel dataModel = PlanDetailModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getHoroscopeimages() async {
    try {
      Result res = await HttpReq.getRequest("horoscope-image");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        HoroscopeImagesModel dataModel =
            HoroscopeImagesModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPartnerPreference(String profileId) async {
    try {
      Result res =
          await HttpReq.getRequest("partner-preferences?profile_id=$profileId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PartnerPreferenceModel dataModel =
            PartnerPreferenceModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getBlockedUsers() async {
    try {
      Result res = await HttpReq.getRequest("blocked-user-list");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        BlockedUsersModel dataModel = BlockedUsersModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getMatchingStarsData() async {
    try {
      Result res = await HttpReq.getRequest("stars");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        MatchingStarsModel dataModel = MatchingStarsModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getTermsOfUse() async {
    try {
      Result res = await HttpReq.getRequest("terms-of-use");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PolicyModel dataModel = PolicyModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPolicy() async {
    try {
      Result res = await HttpReq.getRequest("privacy-policy");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PolicyModel dataModel = PolicyModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getHeightData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.heightListData);
      if (fetchFromLocal && localRes != null) {
        HeightDataModel heightDataModel =
            HeightDataModel.fromJson(jsonDecode(localRes));
        return Result.value(heightDataModel);
      } else {
        Result res = await HttpReq.getRequest("heights");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          HeightDataModel heightDataModel = HeightDataModel.fromJson(response);
          if (heightDataModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.heightListData);
            return Result.value(heightDataModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getBasicDetails() async {
    try {
      Result res = await HttpReq.getRequest("basic-details");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        BasicDetailModel basicDetailModel = BasicDetailModel.fromJson(response);
        if (basicDetailModel.status ?? false) {
          return Result.value(basicDetailModel);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getBuildVersionDetails() async {
    try {
      Result res = await HttpReq.getRequest("app-versions");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        BuildVersionModel buildNumber = BuildVersionModel.fromJson(response);
        if (buildNumber.status ?? false) {
          return Result.value(buildNumber);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getMaritalStatusData({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.maritalStatusData);
      if (fetchFromLocal && localRes != null) {
        MaritalStatusModel maritalStatusModel =
            MaritalStatusModel.fromJson(jsonDecode(localRes));
        return Result.value(maritalStatusModel);
      } else {
        Result res = await HttpReq.getRequest("marital-statuses");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          MaritalStatusModel maritalStatusModel =
              MaritalStatusModel.fromJson(response);
          if (maritalStatusModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.maritalStatusData);
            return Result.value(maritalStatusModel);
          } else {
            return Result.error(Exceptions.noData);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getReligionList({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.religionListData);
      if (fetchFromLocal && localRes != null) {
        ReligionListModel religionListModel =
            ReligionListModel.fromJson(jsonDecode(localRes));
        return Result.value(religionListModel);
      } else {
        Result res = await HttpReq.getRequest("religions");
        if (res.isError) {
          return res;
        } else {
          var response = res.asValue!.value;
          ReligionListModel religionListModel =
              ReligionListModel.fromJson(response);
          if (religionListModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.religionListData);
            return Result.value(religionListModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> requestRegistrationOtp(
      {required String mobileNumber,
      required String id,
      required String email}) async {
    try {
      Map param = {
        "country_code_id": id,
        "mobile": mobileNumber,
        "email": email
      };
      Result res =
          await HttpReq.postRequest("register-mobile", parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel resModel = ResponseModel.fromJson(response);
        return (resModel.status ?? false)
            ? Result.value(resModel)
            : Result.error(resModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getCasteDataList(int religionId) async {
    try {
      Map param = {};
      if (religionId != -1) {
        param['religion_id'] = religionId;
      }
      Result res =
          await HttpReq.postRequest("castes-from-religion", parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        CasteListModel casteModel = CasteListModel.fromJson(response);
        return (casteModel.status ?? false)
            ? Result.value(casteModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> registerUserData(
      {required String name,
      required int gender,
      required String dob,
      required String dialCode,
      required String mobNo,
      required int religionId,
      required int casteId}) async {
    try {
      Map param = {
        "name": name,
        "gender": gender == 0 ? "Male" : "Female",
        "date_of_birth": dob,
        "phone_code": dialCode,
        "mobile": mobNo,
        "religion": religionId,
        "caste": casteId,
        "agree": 0
      };

      Result res = await HttpReq.postRequest("register", parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          RegistrationResModel errorResModel =
              RegistrationResModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        RegistrationResModel resModel = RegistrationResModel.fromJson(response);
        return (resModel.status ?? false)
            ? Result.value(resModel)
            : Result.error(resModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> verifyRegistrationOtp(
      {required String mobileNumber,
      required String id,
      required String otp}) async {
    try {
      Map param = {"country_code_id": id, "mobile": mobileNumber, "otp": otp};
      Result res =
          await HttpReq.postRequest("verify-mobile", parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel resModel = ResponseModel.fromJson(response);
        return (resModel.status ?? false)
            ? Result.value(resModel)
            : Result.error(resModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> loginViaOtpPOST(
      {String? mobile, String? countryID, String? email}) async {
    Map<dynamic, dynamic> param = {
      "country_code_id": countryID ?? "1",
      "mobile": mobile ?? "",
      "email": email ?? ''
    };
    log(param.toString());
    try {
      Result res =
          await HttpReq.postRequest("login-with-otp", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        final loginViaOtpModel = LoginViaOtpModel.fromJson(response);
        if (loginViaOtpModel.status ?? false) {
          return Result.value(loginViaOtpModel);
        } else {
          return Result.error(loginViaOtpModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> changePasswordPOST(
      {String? current, String? newPass, String? confirmPass}) async {
    Map<dynamic, dynamic> param = {
      "current_password": current ?? "",
      "password": newPass ?? "",
      "confirm_password": confirmPass ?? ""
    };
    log(param.toString());
    try {
      Result res =
          await HttpReq.postRequest("change-passsword", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          Helpers.successToast(Constants.noInternet);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        final changePassModel = ResponseModel.fromJson(response);
        if (changePassModel.status ?? false) {
          return Result.value(changePassModel);
        } else {
          return Result.error(Exceptions.err);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> profileDetails({bool fromProfilePreview = false}) async {
    try {
      Result res = await HttpReq.getRequest("my-profile");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;

        if (fromProfilePreview) {
          PartnerDetailModel profileDetailModel =
              PartnerDetailModel.fromJson(response);
          if (profileDetailModel.status ?? false) {
            return Result.value(profileDetailModel);
          } else {
            return Result.error(Exceptions.err);
          }
        } else {
          ProfileModel profileDetailModel = ProfileModel.fromJson(response);
          if (profileDetailModel.status ?? false) {
            return Result.value(profileDetailModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> verifyLoginViaOtp({
    String? otp,
    String? mobile,
    String? countryID,
  }) async {
    Map<dynamic, dynamic> param = {
      "country_code_id": countryID ?? "1",
      "mobile": mobile ?? "",
      "otp": otp ?? ""
    };
    log(param.toString());
    try {
      Result res =
          await HttpReq.postRequest("verify-login-otp", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel verifyOtpModel = ResponseModel.fromJson(response);
        if (verifyOtpModel.status ?? false) {
          return Result.value(verifyOtpModel);
        } else {
          return Result.error(verifyOtpModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> login({
    String? nestiD,
    String? password,
  }) async {
    Map<dynamic, dynamic> param = {
      "nest_id": nestiD ?? "",
      "password": password ?? "",
    };
    log(param.toString());
    try {
      Result res = await HttpReq.postRequest("id-password-based-login",
          parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel loginModel = ResponseModel.fromJson(response);
        if (loginModel.status ?? false) {
          return Result.value(loginModel);
        } else {
          return Result.error(loginModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> forgetPasswordRequestOtp(
      {String? mobileNo, String? countryID, String? email}) async {
    Map<dynamic, dynamic> param = {
      "country_code_id": countryID ?? "1",
      "mobile": mobileNo ?? "",
      "email": email ?? ''
    };
    log(param.toString());
    try {
      Result res =
          await HttpReq.postRequest("forgot-password", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel forgotPasswordRequestModel =
            ResponseModel.fromJson(response);
        if (forgotPasswordRequestModel.status ?? false) {
          return Result.value(forgotPasswordRequestModel);
        } else {
          return Result.error(forgotPasswordRequestModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> forgotPasswordVerifyOtp({
    String? otp,
    String? mobile,
    String? countryID,
  }) async {
    Map<dynamic, dynamic> param = {
      "country_code_id": countryID ?? "1",
      "mobile": mobile ?? "",
      "otp": otp ?? ""
    };
    log(param.toString());
    try {
      Result res = await HttpReq.postRequest("verify-forgot-password",
          parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel forgotPasswordVerifyOtpModel =
            ResponseModel.fromJson(response);
        if (forgotPasswordVerifyOtpModel.status ?? false) {
          return Result.value(forgotPasswordVerifyOtpModel);
        } else {
          return Result.error(forgotPasswordVerifyOtpModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> resetPassword(
      {String? password, String? confirmPassword}) async {
    Map<dynamic, dynamic> param = {
      "password": password ?? "1",
      "confirm_password": confirmPassword ?? "",
    };
    try {
      Result res =
          await HttpReq.postRequest("reset-password", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('reset password response value ${res.asValue!.value}');
        ResponseModel resetPasswordModel = ResponseModel.fromJson(response);
        if (resetPasswordModel.status ?? false) {
          return Result.value(resetPasswordModel);
        } else {
          return Result.error(resetPasswordModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> deleteAccount({String? id, String? reason}) async {
    Map<dynamic, dynamic> param = {
      "delete_reason_id": id ?? "0",
      "custom_reason": reason ?? "Marriage fixed",
    };
    debugPrint(param.toString());
    try {
      Result res =
          await HttpReq.postRequest("delete-account", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('Delete Account response ${res.asValue!.value}');
        ResponseModel deleteModel = ResponseModel.fromJson(response);
        if (deleteModel.status ?? false) {
          return Result.value(deleteModel);
        } else {
          return Result.error(deleteModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> higherPlans() async {
    try {
      Result res = await HttpReq.getRequest("higher-plans");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('Higher plans response : ${res.asValue!.value}');
        HigherPlansModel model = HigherPlansModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getTermsStatusCheck() async {
    try {
      Result res = await HttpReq.getRequest("terms-of-use-status");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('terms-of-use-status response : ${res.asValue!.value}');
        TermsCheckModel model = TermsCheckModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> agreeTermsOfuse() async {
    try {
      Result res = await HttpReq.getRequest("accept-terms-of-use");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('accept-terms-of-use response : ${res.asValue!.value}');
        AcceptTermsModel model = AcceptTermsModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getContactBranches() async {
    try {
      Result res = await HttpReq.getRequest("branches");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('Branches response : ${res.asValue!.value}');
        BranchesModel model = BranchesModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> profilePercentage() async {
    try {
      Result res = await HttpReq.getRequest("profile-complete");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ProfileCompleteModel model = ProfileCompleteModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getMyPhotos({int? page}) async {
    try {
      Map<dynamic, dynamic> param = {
        "length": "",
        "page": "",
      };

      Result res = await HttpReq.getRequest("user-images?length=10&page=$page");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        MyPhotosModel model = MyPhotosModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getIDproofPhotos() async {
    try {
      Result res = await HttpReq.getRequest("id-proof-image");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        OtherPhotosModel model = OtherPhotosModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getMyHousePhotos() async {
    try {
      Result res = await HttpReq.getRequest("house-image");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        OtherPhotosModel model = OtherPhotosModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> makeImagePrimary({String? imageID}) async {
    // used in manage photos - my photos
    try {
      Map<dynamic, dynamic> param = {
        "image_id": imageID ?? "",
      };

      Result res =
          await HttpReq.postRequest("primary-photo", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        MakePrimaryModel model = MakePrimaryModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> deleteMyPhoto({String? imageID}) async {
    // used in manage photos - my photos
    try {
      Map<dynamic, dynamic> param = {
        "imageId": imageID ?? "",
      };

      Result res =
          await HttpReq.postRequest("user-image-delete", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        MakePrimaryModel model = MakePrimaryModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> deleteCategoryImages({String? imageID}) async {
    // used in manage photos - my photos
    try {
      Map<dynamic, dynamic> param = {
        "category_image": imageID ?? "",
      };

      Result res =
          await HttpReq.postRequest("category-image-delete", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        DeleteCategoryModel model = DeleteCategoryModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> hideMyPhoto() async {
    // used in manage photos - my photos
    try {
      Result res = await HttpReq.postRequest("hide-photos");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        HidePhotoModel model = HidePhotoModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> unhideMyPhoto() async {
    // used in manage photos - my photos
    try {
      Result res = await HttpReq.postRequest("unhide-photos");

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        HidePhotoModel model = HidePhotoModel.fromJson(response);
        if (model.status ?? false) {
          return Result.value(model);
        } else {
          return Result.error(model);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getOrderIdForPayment(basicAuth, Map param) async {
    try {
      Result res = await HttpReq.postRequestForPayment(
          "https://api.razorpay.com/v1/orders",
          parameters: param,
          basicAuth: basicAuth);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        PaymentOrderResponseModel paymentOrderResponseModel =
            PaymentOrderResponseModel.fromJson(response);
        return Result.value(paymentOrderResponseModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> searchById(String id, String length, String page) async {
    Map<dynamic, dynamic> param = {
      "nest_id": id,
      "length": length,
      "page": page
    };
    try {
      Result res =
          await HttpReq.postRequest("nest-id-search", parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('search by id response value ${res.asValue!.value}');
        ProfileSearchModel userInfoModel =
            ProfileSearchModel.fromJson(response);
        if (userInfoModel.status ?? false) {
          return Result.value(userInfoModel);
        } else {
          return Result.error(userInfoModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> searchByData(Map<String, dynamic> param) async {
    log(param.toString());
    try {
      Result res = await HttpReq.postRequest("search", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        debugPrint('search by id response value ${res.asValue!.value}');
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          ProfileSearchModel userInfoModel =
              ProfileSearchModel.fromJson(response);
          if (userInfoModel.status ?? false) {
            return Result.value(userInfoModel);
          } else {
            return Result.error(userInfoModel);
          }
        }
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> paymentRegistration(
      PaymentRegistrationBodyModel paymentRegistrationBodyModel) async {
    try {
      Result res = await HttpReq.postRequest("payment-registration",
          parameters: paymentRegistrationBodyModel.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        PaymentRegistrationResponseModel paymentRegistrationResponseModel =
            PaymentRegistrationResponseModel.fromJson(response);
        if (paymentRegistrationResponseModel.status ?? false) {
          return Result.value(paymentRegistrationResponseModel);
        } else {
          return Result.error(paymentRegistrationResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getSubscriptions() async {
    try {
      Result res = await HttpReq.getRequest("subscriptions");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        //debugPrint('subscriptions response $response');
        SubscriptionsResponseModel subscriptionsResponseModel =
            SubscriptionsResponseModel.fromJson(response);
        if (subscriptionsResponseModel.status ?? false) {
          return Result.value(subscriptionsResponseModel);
        } else {
          return Result.error(subscriptionsResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> offerCheck(int planId, String offerId) async {
    try {
      Result res = await HttpReq.getRequest(
          'valid-offercode?plan_id=$planId&offer_code=$offerId');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        OfferCheckResponseModel offerCheckResponseModel =
            OfferCheckResponseModel.fromJson(response);
        if (offerCheckResponseModel.status ?? false) {
          return Result.value(offerCheckResponseModel);
        } else {
          return Result.error(offerCheckResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> verifyPayment(
      String orderId, String paymentId, String signature) async {
    Map<dynamic, dynamic> param = {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature
    };
    try {
      Result res =
          await HttpReq.postRequest('verify-payment', parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        PaymentVerifyResponseModel paymentVerifyResponseModel =
            PaymentVerifyResponseModel.fromJson(response);
        if (paymentVerifyResponseModel.status ?? false) {
          return Result.value(paymentVerifyResponseModel);
        } else {
          return Result.error(paymentVerifyResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> createCashFreePayment(
      {String? paymentId, String? orderAmount}) async {
    Map<dynamic, dynamic> param = {
      "payment_id": paymentId,
      "order_amount": orderAmount,
    };
    try {
      Result res =
          await HttpReq.postRequest('create-cashfree-order', parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        debugPrint('cash free response $response');
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        CreateCashFreeModel createCashFreeResponseModel =
            CreateCashFreeModel.fromJson(response);
        if (createCashFreeResponseModel.status ?? false) {
          return Result.value(createCashFreeResponseModel);
        } else {
          return Result.error(createCashFreeResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> createCashFreeupgradePayment(
      {String? planId, String? orderAmount}) async {
    Map<dynamic, dynamic> param = {
      "plan_id": planId,
      "order_amount": orderAmount,
    };
    try {
      Result res = await HttpReq.postRequest('upgrade-plan-cashfree-order',
          parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        debugPrint('cash free response $response');
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        CreateCashFreeModel createCashFreeResponseModel =
            CreateCashFreeModel.fromJson(response);
        if (createCashFreeResponseModel.status ?? false) {
          return Result.value(createCashFreeResponseModel);
        } else {
          return Result.error(createCashFreeResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> cashFreeVerifyOrderID({String? orderID}) async {
    Map<dynamic, dynamic> param = {
      "order_id": orderID,
    };
    try {
      Result res =
          await HttpReq.postRequest('cashfree-payments', parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        debugPrint('cash free response $response');
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        SentOrderCashFreeModel createCashFreeResponseModel =
            SentOrderCashFreeModel.fromJson(response);
        if (createCashFreeResponseModel.status ?? false) {
          return Result.value(createCashFreeResponseModel);
        } else {
          return Result.error(createCashFreeResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> verifyInAppEasyPayment(
      {String? token, String? paymentId, String? orderAmount}) async {
    Map<dynamic, dynamic> param = {
      "token": token,
      "order_amount": orderAmount,
      "payment_id": paymentId,
    };
    try {
      Result res = await HttpReq.postRequest('verify-payment-applepay',
          parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        print('verify payment response $response');
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InAppEasyPayVerificationModel paymentVerifyResponseModel =
            InAppEasyPayVerificationModel.fromJson(response);
        if (paymentVerifyResponseModel.status ?? false) {
          return Result.value(paymentVerifyResponseModel);
        } else {
          return Result.error(paymentVerifyResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> verifyInAppUpgradePayment(
      {String? token, String? planId, String? orderAmount}) async {
    Map<dynamic, dynamic> param = {
      "token": token,
      "order_amount": orderAmount,
      "plan_id": planId,
    };
    try {
      Result res = await HttpReq.postRequest('upgrade-plan-verify-applepay',
          parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        debugPrint('verify payment response $response');
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InAppEasyPayVerificationModel paymentVerifyResponseModel =
            InAppEasyPayVerificationModel.fromJson(response);
        if (paymentVerifyResponseModel.status ?? false) {
          return Result.value(paymentVerifyResponseModel);
        } else {
          return Result.error(paymentVerifyResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> savePayment(PaymentDetails paymentSaveBody) async {
    try {
      Result res = await HttpReq.postRequest('verify-payment',
          parameters: paymentSaveBody.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        PaymentSaveResponseModel paymentSaveResponseModel =
            PaymentSaveResponseModel.fromJson(response);
        if (paymentSaveResponseModel.status ?? false) {
          return Result.value(paymentSaveResponseModel);
        } else {
          return Result.error(paymentSaveResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> saveUpgradePlanPayment(
      UpgradePlanDetails paymentSaveBody) async {
    try {
      Result res = await HttpReq.postRequest('upgrade-plan-verify-save',
          parameters: paymentSaveBody.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        PaymentSaveResponseModel paymentSaveResponseModel =
            PaymentSaveResponseModel.fromJson(response);
        if (paymentSaveResponseModel.status ?? false) {
          return Result.value(paymentSaveResponseModel);
        } else {
          return Result.error(paymentSaveResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getDailyRecommendation(int pageCount,
      [int length = 20]) async {
    try {
      Result res = await HttpReq.postRequest("daily-recommendations",
          parameters: {"length": length, "page": pageCount});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel dailyRecommendationModel =
            ProfileDataModel.fromJson(response);
        return (dailyRecommendationModel.status ?? false)
            ? Result.value(dailyRecommendationModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getDiscoverMoreData() async {
    try {
      Result res = await HttpReq.getRequest(
        "discover-matches",
      );
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        DiscoverMoreModel discoverMoreModel =
            DiscoverMoreModel.fromJson(response);
        return (discoverMoreModel.status ?? false)
            ? Result.value(discoverMoreModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getTopMatches(int pageCount, [int length = 20]) async {
    try {
      Result res = await HttpReq.postRequest("top-matches",
          parameters: {"length": length, "page": pageCount});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel topMatchesModel = ProfileDataModel.fromJson(response);
        return (topMatchesModel.status ?? false)
            ? Result.value(topMatchesModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPremiumMembersData(int pageCount, [int length = 20]) async {
    try {
      Result res = await HttpReq.postRequest("premium-profiles",
          parameters: {"length": length, "page": pageCount});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel premiumMembersModel =
            ProfileDataModel.fromJson(response);
        return (premiumMembersModel.status ?? false)
            ? Result.value(premiumMembersModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getNewProfileData(int pageCount, [int length = 20]) async {
    try {
      Result res = await HttpReq.postRequest("new-profiles",
          parameters: {"length": length, "page": pageCount});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel newProfileModel = ProfileDataModel.fromJson(response);
        return (newProfileModel.status ?? false)
            ? Result.value(newProfileModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getNewProfileViewedData(int pageCount,
      [int length = 20]) async {
    try {
      Result res = await HttpReq.getRequest(
          "viewed-profile?length=$length&page=$pageCount");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel profileDataModel = ProfileDataModel.fromJson(response);
        return (profileDataModel.status ?? false)
            ? Result.value(profileDataModel)
            : Result.error(Exceptions.noData);
      }
    } on Exception {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getInterestReceivedData(int pageCount,
      [int length = 20]) async {
    try {
      Result res = await HttpReq.getRequest(
          "interest-receive?length=$length&page=$pageCount");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        InterestResponseModel profileDataModel =
            InterestResponseModel.fromJson(response);
        return (profileDataModel.status ?? false)
            ? Result.value(profileDataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getInterestList(
      int page, int length, InterestTypes interestTypes) async {
    Result? res;
    try {
      switch (interestTypes) {
        case InterestTypes.received:
          res = await HttpReq.getRequest(
              'interest-receive?length=$length&page=$page');
          break;
        case InterestTypes.sent:
          res = await HttpReq.getRequest(
              'interest-sent?length=$length&page=$page');
          break;
        case InterestTypes.acceptedByMe:
          res = await HttpReq.getRequest(
              'interest-accepted?length=$length&page=$page');
          break;
        case InterestTypes.accepted:
          res = await HttpReq.getRequest(
              'interest-approved?length=$length&page=$page');
          break;
        case InterestTypes.declined:
          res = await HttpReq.getRequest(
              'interest-rejected?length=$length&page=$page');
          break;
        case InterestTypes.declinedByMe:
          res = await HttpReq.getRequest(
              'interest-declined?length=$length&page=$page');
          break;
      }

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InterestResponseModel interestReceivedResponseModel =
            InterestResponseModel.fromJson(response);
        if (interestReceivedResponseModel.status ?? false) {
          return Result.value(interestReceivedResponseModel);
        } else {
          return Result.error(interestReceivedResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> acceptOrDeclineInterest(
      int interestId, InterestAction interestAction) async {
    Map<String, dynamic> params = {'interest_id': interestId};
    Result? res;
    try {
      interestAction == InterestAction.accept
          ? res =
              await HttpReq.postRequest('accept-interest', parameters: params)
          : res =
              await HttpReq.postRequest('reject-interest', parameters: params);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InterestAcceptDeclineResponse interestAcceptDeclineResponse =
            InterestAcceptDeclineResponse.fromJson(response);
        if (interestAcceptDeclineResponse.status ?? false) {
          return Result.value(interestAcceptDeclineResponse);
        } else {
          return Result.error(interestAcceptDeclineResponse);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getProfileViewedList(
      int page, int length, ViewedBy profileViewed) async {
    Result? res;
    try {
      profileViewed == ViewedBy.viewedByOthers
          ? res = await HttpReq.getRequest(
              'who-viewed-profile?length=$length&page=$page')
          : res = await HttpReq.getRequest(
              'viewed-profile?length=$length&page=$page');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InterestResponseModel interestReceivedResponseModel =
            InterestResponseModel.fromJson(response);
        if (interestReceivedResponseModel.status ?? false) {
          return Result.value(interestReceivedResponseModel);
        } else {
          return Result.error(interestReceivedResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getAddressViewedList(
      int page, int length, ViewedBy addressViewedBy) async {
    Result? res;
    try {
      addressViewedBy == ViewedBy.viewedByOthers
          ? res = await HttpReq.getRequest(
              'who-viewed-address?length=$length&page=$page')
          : res = await HttpReq.getRequest(
              'viewed-address?length=$length&page=$page');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InterestResponseModel interestReceivedResponseModel =
            InterestResponseModel.fromJson(response);
        if (interestReceivedResponseModel.status ?? false) {
          return Result.value(interestReceivedResponseModel);
        } else {
          return Result.error(interestReceivedResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getShortList(
      int page, int length, ShortListedBy shortListedBy) async {
    try {
      Result? res;
      shortListedBy == ShortListedBy.shortListedByMe
          ? res =
              await HttpReq.getRequest('shortlist?length=$length&page=$page')
          : res = await HttpReq.getRequest(
              'who-shortlisted-me?length=$length&page=$page');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        InterestResponseModel interestReceivedResponseModel =
            InterestResponseModel.fromJson(response);
        if (interestReceivedResponseModel.status ?? false) {
          return Result.value(interestReceivedResponseModel);
        } else {
          return Result.error(interestReceivedResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPartnerDetailsData(int id) async {
    try {
      Result res = await HttpReq.getRequest("profile-view?id=$id");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PartnerDetailModel partnerDetailModel =
            PartnerDetailModel.fromJson(response);
        return (partnerDetailModel.status ?? false)
            ? Result.value(partnerDetailModel)
            : Result.error(Exceptions.err);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getSimilarProfiles(int pageCount, int profileId,
      [int length = 10]) async {
    try {
      Result res = await HttpReq.getRequest(
          "similar-profiles?length=$length&page=$pageCount&profile_id=$profileId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ProfileDataModel similarProfileModel =
            ProfileDataModel.fromJson(response);
        return (similarProfileModel.status ?? false)
            ? Result.value(similarProfileModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> sendInterestRequest(int profileId, int sendInterestId) async {
    try {
      Result res = await HttpReq.postRequest("send-interest", parameters: {
        "interest_profile_id": profileId,
        "send_interest_message": sendInterestId
      });
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> shortListProfileRequest(int profileId) async {
    try {
      Result res = await HttpReq.postRequest("shortList",
          parameters: {"shortlist_profile_id": profileId});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> removerFromShortList(int profileId) async {
    try {
      Result res = await HttpReq.postRequest("remove-from-shortlist",
          parameters: {"shortlist_profile_id": profileId});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> contactAddressCount() async {
    try {
      Result res = await HttpReq.getRequest("current-contact-count");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ContactAddressCountModel countModel =
            ContactAddressCountModel.fromJson(response);
        return (countModel.status ?? false)
            ? Result.value(countModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> reportProfile(int profileId, String response) async {
    try {
      Result res = await HttpReq.postRequest("report-user",
          parameters: {"report_profile_id": profileId, "reason": response});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> blockProfile(int userId) async {
    try {
      Result res = await HttpReq.postRequest("block/unblock-user",
          parameters: {"user_id": userId});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> reportStaff(String staffId, String reason) async {
    try {
      Result res = await HttpReq.postRequest("report-staff",
          parameters: {"staff_id": staffId, "reason": reason});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        StaffReportModel responseModel = StaffReportModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getProfileAddress(int profileId) async {
    try {
      Result res =
          await HttpReq.getRequest("contact-info?profile_id=$profileId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ContactAddressModel contactAddressModel =
            ContactAddressModel.fromJson(response);
        return (contactAddressModel.status ?? false)
            ? Result.value(contactAddressModel)
            : Result.error(contactAddressModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> requestContactCount(int profileId, {int? limit}) async {
    try {
      Result res = await HttpReq.postRequest("request-contact-count",
          parameters: {"profile_id": profileId, "limit": "${limit ?? ''}"});
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          _errorMsg(Exceptions.err);
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(responseModel);
      }
    } catch (_) {
      _errorMsg(Exceptions.err);
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getPartnerInterestData() async {
    try {
      Result res = await HttpReq.getRequest("send-interest-message");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        PartnerInterestModel partnerDetailModel =
            PartnerInterestModel.fromJson(response);
        return (partnerDetailModel.status ?? false)
            ? Result.value(partnerDetailModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getMatchesList(
      MatchesTypes matchesTypes, Map<String, dynamic> params) async {
    Result? res;
    try {
      switch (matchesTypes) {
        case MatchesTypes.allMatchesNotViewed:
          res = await HttpReq.postRequest('all-matches', parameters: params);
          break;
        case MatchesTypes.allMatchesViewed:
          res = await HttpReq.postRequest('viewed/all-matches',
              parameters: params);
          break;
        case MatchesTypes.topMatchesNotViewed:
          res = await HttpReq.postRequest('top-matches', parameters: params);
          break;
        case MatchesTypes.topMatchesViewed:
          res = await HttpReq.postRequest('viewed/top-matches',
              parameters: params);
          break;
        case MatchesTypes.nearByMatchesNotViewed:
          res = await HttpReq.postRequest('nearby-matches', parameters: params);
          break;
        case MatchesTypes.nearByMatchesViewed:
          res = await HttpReq.postRequest('viewed/nearby-matches',
              parameters: params);
          break;
        case MatchesTypes.newProfileNotViewed:
          res = await HttpReq.postRequest('new-profiles', parameters: params);
          break;
        case MatchesTypes.newProfileViewed:
          res = await HttpReq.postRequest('viewed/new-profiles',
              parameters: params);
          break;
        case MatchesTypes.premiumProfilesNotViewed:
          res =
              await HttpReq.postRequest('premium-profiles', parameters: params);
          break;
        case MatchesTypes.premiumProfilesViewed:
          res = await HttpReq.postRequest('viewed/premium-profiles',
              parameters: params);
          break;
      }
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          ProfileSearchModel userInfoModel =
              ProfileSearchModel.fromJson(response);
          if (userInfoModel.status ?? false) {
            return Result.value(userInfoModel);
          } else {
            return Result.error(userInfoModel);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getTestimonials() async {
    try {
      Result res = await HttpReq.getRequest('testimonials?length=50&page=1');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          TestimonialsResponseModel testimonialsResponseModel =
              TestimonialsResponseModel.fromJson(response);
          if (testimonialsResponseModel.status ?? false) {
            return Result.value(testimonialsResponseModel);
          } else {
            return Result.error(testimonialsResponseModel);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getServices(
      int page, int length, ServiceType serviceType) async {
    try {
      Result? res;
      serviceType == ServiceType.crmService
          ? res = await HttpReq.getRequest(
              'user-service-info-list?length=$length&page=$page')
          : res = await HttpReq.getRequest(
              'profile-suggestion-service-list?length=$length&page=$page');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          ServicesResponseModel servicesResponseModel =
              ServicesResponseModel.fromJson(response);
          if (servicesResponseModel.status ?? false) {
            return Result.value(servicesResponseModel);
          } else {
            return Result.error(servicesResponseModel);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getServiceChat(int serviceId) async {
    try {
      Result res = await HttpReq.getRequest(
          'service-chat-data?user_service_id=$serviceId');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          ServiceChatListResponseModel serviceChatListResponseModel =
              ServiceChatListResponseModel.fromJson(response);
          if (serviceChatListResponseModel.status ?? false) {
            return Result.value(serviceChatListResponseModel);
          } else {
            return Result.error(serviceChatListResponseModel);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> sendChatMessage(Map<String, dynamic> params) async {
    try {
      Result res = await HttpReq.postRequest('service-chat-send-message',
          parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          ResponseModel resModel = ResponseModel.fromJson(response);
          return (resModel.status ?? false)
              ? Result.value(resModel)
              : Result.error(resModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getNotifications() async {
    try {
      Result res = await HttpReq.getRequest('notifications');
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          NotificationResponseModel notificationResponseModel =
              NotificationResponseModel.fromJson(response);
          return (notificationResponseModel.status ?? false)
              ? Result.value(notificationResponseModel)
              : Result.error(notificationResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateLocationDetails(LocationRequest locationSaveBody) async {
    try {
      Result res = await HttpReq.postRequest('update-location-details',
          parameters: locationSaveBody.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateBasicInfo(BasicInfoRequest basicInfoRequest) async {
    try {
      Result res = await HttpReq.postRequest('update-basic-info',
          parameters: basicInfoRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateFamilyDetails(
      FamilyDetailsRequest familyDetailsRequest) async {
    try {
      Result res = await HttpReq.postRequest('update-family-details',
          parameters: familyDetailsRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateAboutMe(String aboutMySelf, String profileId) async {
    try {
      Map param = {"about_myself": aboutMySelf, "profile_id": profileId};
      Result res =
          await HttpReq.postRequest('update-about-me', parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateReligionInfo(
      ReligionInfoRequest religionInfoRequest) async {
    try {
      Result res = await HttpReq.postRequest('update-religion-details',
          parameters: religionInfoRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getCityDataList(int districtId) async {
    try {
      Result res = await HttpReq.getRequest(
          "locations-from-district?district_id=$districtId");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        CityDataModel cityDataModel = CityDataModel.fromJson(response);
        return (cityDataModel.status ?? false)
            ? Result.value(cityDataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateProfessionalInfo(
      ProfessionalInfoRequest professionalInfoRequest) async {
    try {
      Result res = await HttpReq.postRequest('update-proffesional-details',
          parameters: professionalInfoRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updateHoroscopeDetails(
      HoroscopeDetailsRequest horoscopeDetailsRequest) async {
    try {
      Result res = await HttpReq.postRequest('update-horoscope-details',
          parameters: horoscopeDetailsRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel basicInfo = ResponseModel.fromJson(response);
        if (basicInfo.status ?? false) {
          return Result.value(basicInfo);
        } else {
          return Result.error(basicInfo);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getBodyTypeList({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.bodyTypeList);
      if (fetchFromLocal && localRes != null) {
        BodyTypeListModel bodyTypeListModel =
            BodyTypeListModel.fromJson(jsonDecode(localRes));
        return Result.value(bodyTypeListModel);
      } else {
        Result res = await HttpReq.getRequest("body-types");
        if (res.isError) {
          var response = res.asError!.error;
          if (response is Exceptions) {
            _errorMsg(response);
            return res;
          } else {
            return Result.error(Exceptions.err);
          }
        } else {
          var response = res.asValue!.value;
          BodyTypeListModel bodyTypeListModel =
              BodyTypeListModel.fromJson(response);
          if (bodyTypeListModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.bodyTypeList);
            return Result.value(bodyTypeListModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getComplexionsList({bool fetchFromLocal = false}) async {
    try {
      final localRes =
          await HiveServices.getDataFromLocal(HiveServices.complexionList);
      if (fetchFromLocal && localRes != null) {
        ComplexionListModel complexionListModel =
            ComplexionListModel.fromJson(jsonDecode(localRes));
        return Result.value(complexionListModel);
      } else {
        Result res = await HttpReq.getRequest("complexions");
        if (res.isError) {
          var response = res.asError!.error;
          if (response is Exceptions) {
            _errorMsg(response);
            return res;
          } else {
            return Result.error(Exceptions.err);
          }
        } else {
          var response = res.asValue!.value;
          ComplexionListModel complexionListModel =
              ComplexionListModel.fromJson(response);
          if (complexionListModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response), key: HiveServices.complexionList);
            return Result.value(complexionListModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getChildEducationCategories(
      {bool fetchFromLocal = false}) async {
    try {
      final localRes = await HiveServices.getDataFromLocal(
          HiveServices.childJobCategoryList);
      if (fetchFromLocal && localRes != null) {
        JobChildCategoryListModel jobChildCategoryListModel =
            JobChildCategoryListModel.fromJson(jsonDecode(localRes));
        return Result.value(jobChildCategoryListModel);
      } else {
        Result res = await HttpReq.getRequest("child-job-categories");
        if (res.isError) {
          var response = res.asError!.error;
          if (response is Exceptions) {
            _errorMsg(response);
            return res;
          } else {
            return Result.error(Exceptions.err);
          }
        } else {
          var response = res.asValue!.value;
          JobChildCategoryListModel jobChildCategoryListModel =
              JobChildCategoryListModel.fromJson(response);
          if (jobChildCategoryListModel.status ?? false) {
            HiveServices.saveDataToLocal(
                val: jsonEncode(response),
                key: HiveServices.childJobCategoryList);
            return Result.value(jobChildCategoryListModel);
          } else {
            return Result.error(Exceptions.err);
          }
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getStarsData() async {
    try {
      Result res = await HttpReq.getRequest("stars");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        StarListModel dataModel = StarListModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getDasaList() async {
    try {
      Result res = await HttpReq.getRequest("jathakam-types");
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        DasaListModel dataModel = DasaListModel.fromJson(response);
        return (dataModel.status ?? false)
            ? Result.value(dataModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> changeMobileNumber(
      ChangeMobileRequest changeMobileRequest) async {
    try {
      Result res = await HttpReq.postRequest('change-mobile',
          parameters: changeMobileRequest.toJson());
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel changeMobile = ResponseModel.fromJson(response);
        if (changeMobile.status ?? false) {
          return Result.value(changeMobile);
        } else {
          return Result.error(changeMobile);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> changeMobileVerify(
      {String? otp,
      String? mobile,
      String? countryID,
      String? profileId}) async {
    try {
      Map<dynamic, dynamic> param = {
        "country_code_id": countryID ?? "1",
        "mobile": mobile ?? "",
        "otp": otp ?? "",
        "profile_id": profileId ?? ""
      };
      Result res =
          await HttpReq.postRequest('change-mobile-verify', parameters: param);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          _errorMsg(response);
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel changeMobile = ResponseModel.fromJson(response);
        if (changeMobile.status ?? false) {
          return Result.value(changeMobile);
        } else {
          return Result.error(changeMobile);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<List<String>> downloadImage(
      {required List<String> imageUrls, required String filePath}) async {
    List<String> imagePaths = [];
    for (int i = 0; i < imageUrls.length; i++) {
      if (imageUrls[i].isNotEmpty) {
        String pathDir = '/storage/emulated/0/Download/$filePath$i.jpg';
        bool fileExist = await _checkFile(pathDir);

        if (fileExist) {
          imagePaths.add(pathDir);
          return imagePaths;
        } else {
          Helpers.successToast('Downloading ...');
          try {
            String imageUrl = imageUrls[i].contains(' ')
                ? imageUrls[i].replaceAll(' ', '%20')
                : imageUrls[i];
            var imageId = await ImageDownloader.downloadImage(imageUrl,
                destination:
                    AndroidDestinationType.custom(directory: 'Download')
                      ..subDirectory("$filePath.jpg"));

            if (imageId == null) {
              imagePaths = [];
            }
            // saved image information.
            var path = await ImageDownloader.findPath(imageId!);
            imagePaths.add(path ?? '');
            Helpers.successToast('Download completed');
          } on PlatformException catch (error) {
            debugPrint(error.toString());
          }
        }
      } else {
        continue;
      }
    }
    return imagePaths;
  }

  Future<bool> _checkFile(String filePath) async {
    bool status = await File(filePath).exists();
    return status;
  }

  Future<Result> saveBasicPreferences(Map<String, dynamic> params) async {
    try {
      Result res =
          await HttpReq.postRequest('basic-preference', parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          PartnerPreferenceModel partnerPreferenceModel =
              PartnerPreferenceModel.fromJson(response);
          return (partnerPreferenceModel.status ?? false)
              ? Result.value(partnerPreferenceModel)
              : Result.error(partnerPreferenceModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getBodyType({bool fetchFromLocal = false}) async {
    try {
      Result res = await HttpReq.getRequest("body-types");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        BodyTypeModel bodyTypeModel = BodyTypeModel.fromJson(response);
        if (bodyTypeModel.status ?? false) {
          return Result.value(bodyTypeModel);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getComplexion({bool fetchFromLocal = false}) async {
    try {
      Result res = await HttpReq.getRequest("complexions");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        ComplexionModel complexionModel = ComplexionModel.fromJson(response);
        if (complexionModel.status ?? false) {
          return Result.value(complexionModel);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getJathakam({bool fetchFromLocal = false}) async {
    try {
      Result res = await HttpReq.getRequest("jathakam-types");
      if (res.isError) {
        return res;
      } else {
        var response = res.asValue!.value;
        JathakamModel jathakamModel = JathakamModel.fromJson(response);
        if (jathakamModel.status ?? false) {
          return Result.value(jathakamModel);
        } else {
          return Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> saveReligionPreference(Map<String, dynamic> params) async {
    try {
      Result res =
          await HttpReq.postRequest('religion-preference', parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          PartnerPreferenceModel partnerPreferenceModel =
              PartnerPreferenceModel.fromJson(response);
          return (partnerPreferenceModel.status ?? false)
              ? Result.value(partnerPreferenceModel)
              : Result.error(partnerPreferenceModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getDistrictFromMultipleStates(
      Map<String, dynamic> params) async {
    try {
      Result res = await HttpReq.postRequest('mutiple-district-from-state',
          parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          DistrictDataModel dataModel = DistrictDataModel.fromJson(response);
          return (dataModel.status ?? false)
              ? Result.value(dataModel)
              : Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> getLocationFromMultipleDistricts(
      Map<String, dynamic> params) async {
    try {
      Result res = await HttpReq.postRequest('mutiple-location-from-district',
          parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          CityDataModel cityDataModel = CityDataModel.fromJson(response);
          return (cityDataModel.status ?? false)
              ? Result.value(cityDataModel)
              : Result.error(Exceptions.noData);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> saveLocationPreference(Map<String, dynamic> params) async {
    try {
      Result res =
          await HttpReq.postRequest('location-preference', parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          PartnerPreferenceModel partnerPreferenceModel =
              PartnerPreferenceModel.fromJson(response);
          return (partnerPreferenceModel.status ?? false)
              ? Result.value(partnerPreferenceModel)
              : Result.error(partnerPreferenceModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> saveProfessionalPreference(Map<String, dynamic> params) async {
    try {
      Result res = await HttpReq.postRequest('professional-preference',
          parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          PartnerPreferenceModel partnerPreferenceModel =
              PartnerPreferenceModel.fromJson(response);
          return (partnerPreferenceModel.status ?? false)
              ? Result.value(partnerPreferenceModel)
              : Result.error(partnerPreferenceModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> profileViewed(int profileId) async {
    try {
      Result res = await HttpReq.getRequest(
        'profile-viewed?id=$profileId',
      );
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          return Result.error(Exceptions.err);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel responseModel = ResponseModel.fromJson(response);
        return (responseModel.status ?? false)
            ? Result.value(responseModel)
            : Result.error(Exceptions.noData);
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> updatePlayerId(Map<String, dynamic> params) async {
    try {
      Result res =
          await HttpReq.postRequest('update/player-id', parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          PlayerIdResponseModel playerIdResponseModel =
              PlayerIdResponseModel.fromJson(response);
          return (playerIdResponseModel.status ?? false)
              ? Result.value(playerIdResponseModel)
              : Result.error(playerIdResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> logout({
    String? userID,
  }) async {
    Map<dynamic, dynamic> param = {
      "player_id": userID ?? "",
    };
    log(param.toString());
    try {
      Result res = await HttpReq.postRequest("logout", parameters: param);

      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        ResponseModel logoutModel = ResponseModel.fromJson(response);
        if (logoutModel.status ?? false) {
          return Result.value(logoutModel);
        } else {
          return Result.error(logoutModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  Future<Result> viewNotification(Map<String, dynamic> params) async {
    try {
      Result res =
          await HttpReq.postRequest('view-notification', parameters: params);
      if (res.isError) {
        var response = res.asError!.error;
        if (response is Exceptions) {
          return res;
        } else {
          ResponseModel errorResModel =
              ResponseModel.fromJson(jsonDecode(response.toString()));
          return Result.error(errorResModel);
        }
      } else {
        var response = res.asValue!.value;
        if (response['status_code'] != null && response['status_code'] == 401) {
          return Result.error(Exceptions.authError);
        } else {
          var response = res.asValue!.value;
          ViewNotificationResponseModel viewNotificationResponseModel =
              ViewNotificationResponseModel.fromJson(response);
          return (viewNotificationResponseModel.status ?? false)
              ? Result.value(viewNotificationResponseModel)
              : Result.error(viewNotificationResponseModel);
        }
      }
    } catch (_) {
      return Result.error(Exceptions.err);
    }
  }

  void _errorMsg(Exceptions exceptions) {
    switch (exceptions) {
      case Exceptions.socketErr:
        Helpers.successToast(Constants.noInternet);
        break;
      case Exceptions.serverErr:
        Helpers.successToast(Constants.serverError);
        break;
      case Exceptions.err:
        Helpers.successToast(Constants.serverError);
        break;
      case Exceptions.noData:
        Helpers.successToast(Constants.noDataFound);
        break;
      case Exceptions.authError:
        Helpers.successToast(Constants.authErrorMsg);
        break;
    }
  }
}
