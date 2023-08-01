import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/validation_helper.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/firebase_analytics_services.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

import '../models/registration_res_model.dart';
import '../services/shared_preference_helper.dart';

class RegistrationProvider extends ChangeNotifier with BaseProviderClass {
  int tabIndex = 0;
  int genderIndex = -1;
  bool _enableFwdBtn = false;
  String phoneNumber = '';
  String emailId = '';
  String otpInput = '';
  String fullName = '';
  CountryData? countryData;
  bool isNumberValid = false;
  bool isEmailValid = false;
  String errorMsg = '';
  String registrationErrorMsg = '';

  CasteListModel? casteListModel;
  int selectedCasteId = -1;
  List<CasteData>? casteDataList;

  ///Date of Birth
  String? tempDay;
  String? tempMonth;
  String? temYear;

  String? day;
  String? month;
  String? year;

  DateTime? dateOfBirth;
  bool interruptAgeScroll = false;
  AgeDataListModel? ageDataListModel;
  int minAge = 18;
  int maxAge = 70;

  int selectedReligion = -1;

  String get numberWithCode => '+${countryData?.dialCode ?? ''} $phoneNumber';

  bool get enableFwdBtn =>
      (phoneNumber.isNotEmpty || fullName.length > 3) ? true : _enableFwdBtn;

  void updateTabIndex(int val) {
    tabIndex = val;
    notifyListeners();
  }

  /// Register number -------------------------------------------------------

  Future<void> registerRequestOtp(BuildContext context,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    updateRegistrationErrorMsg('');
    Result res = await serviceConfig.requestRegistrationOtp(
        mobileNumber: phoneNumber,
        id: '${countryData?.id ?? -1}',
        email: emailId);
    if (res.isValue) {
      ResponseModel resModel = res.asValue?.value;
      if (resModel.responseData != null) {
        updateEmailId(resModel.responseData?.email ?? '');
      }
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess(true);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        if ((responseModel.statusCode ?? 0) == 528) {
          if (onSuccess != null) onSuccess(false);
        } else {
          if (responseModel.errors?.mobile != null) {
            updateRegistrationErrorMsg(
                responseModel.errors?.mobile ?? context.loc.invalidMobile);
          } else {
            updateRegistrationErrorMsg(
                responseModel.errors?.email ?? context.loc.invalidEmail);
          }
        }

        updateBtnLoader(false);
      } else {
        updateBtnLoader(false);
      }
    }
  }

  void updatePhoneNumber(String val) {
    phoneNumber = val;
    notifyListeners();
  }

  void updateEmailId(String val) {
    emailId = val;
    notifyListeners();
  }

  void validatePhoneNumber(String val) {
    if (val.length >= (countryData?.minLength ?? 5) &&
        val.length <= (countryData?.maxLength ?? 15)) {
      isNumberValid = true;
    } else {
      isNumberValid = false;
    }
    notifyListeners();
  }

  void validateEmailAddress(String val) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(val)) {
      isEmailValid = true;
    } else {
      isEmailValid = false;
    }
    notifyListeners();
  }

  void assignCountryDataIfNull(BuildContext context) {
    if (countryData?.id == null) {
      List<CountryData> countryList =
          context.read<AppDataProvider>().countryDataList ?? [];
      countryData = countryList.isNotEmpty ? countryList[0] : null;
      notifyListeners();
    }
  }

  ///------------------------------------------------------------------------

  /// Caste Data ------------------------------------------------------------

  Future<void> getCasteDataList(
      {required BuildContext context, Function? onSuccess}) async {
    context.circularLoaderPopUp;
    Result res = await serviceConfig.getCasteDataList(selectedReligion);
    if (res.isValue) {
      CasteListModel model = res.asValue!.value;
      updateCastListModel(model);
      context.rootPop;
      if (onSuccess != null) onSuccess();
    } else {
      updateCastListModel(null);

      ///TODO: need to add toast for error case
      context.rootPop;
    }
  }

  void searchCasteByQuery(String val) {
    if ((casteListModel?.data?.castes ?? []).isNotEmpty) {
      List<CasteData> model = casteListModel!.data!.castes!
          .where((element) => (element.casteName ?? '')
              .toLowerCase()
              .contains(val.toLowerCase()))
          .toList();
      casteDataList = model;
    } else {
      casteDataList = casteListModel?.data?.castes ?? [];
    }
    notifyListeners();
  }

  void updateCastListModel(val) {
    casteListModel = val;
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void reAssignCastListModel() {
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void updateCasteId(val) {
    selectedCasteId = val;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------
  /// Validate Otp ----------------------------------------------------------

  Future<void> registerVerifyOtp(BuildContext context,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    Result res = await serviceConfig.verifyRegistrationOtp(
        mobileNumber: phoneNumber,
        id: '${countryData?.id ?? -1}',
        otp: otpInput);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      updateErrorMsg('');
      updateBtnLoader(false);

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        updateErrorMsg(responseModel.message ?? 'Invalid Otp');
        updateBtnLoader(false);
      } else {
        CommonFunctions.afterInit(() {
          context
              .read<AuthProvider>()
              .updateErrorMessage(Constants.serverError);
        });
        updateBtnLoader(false);
      }
    }
  }

  void updateOtpInput(String val) {
    otpInput = val;
    notifyListeners();
  }

  ///------------------------------------------------------------------------

  /// Register details ------------------------------------------------------
  Future<void> registerUserData(
      {required BuildContext context,
      Function? onSuccess,
      Function? onFailure}) async {
    if (AppConfig.isAuthorized) {
      if (onSuccess != null) onSuccess();
    } else {
      Result res = await serviceConfig.registerUserData(
          name: fullName,
          gender: genderIndex,
          dob: DateFormat('yyyy-MM-dd').format(dateOfBirth!),
          dialCode: countryData?.dialCode ?? '',
          mobNo: phoneNumber,
          religionId: selectedReligion,
          casteId: selectedCasteId);
      if (res.isValue) {
        RegistrationResModel responseModel = res.asValue!.value;
        String token = responseModel.responseData?.accessToken ?? "";
        SharedPreferenceHelper.saveToken(token).then((value) {
          context.read<AuthProvider>().updatePlayerId();
          FirebaseAnalyticsService.instance.loginSignUp(fullName);
        });
        if (onSuccess != null) onSuccess();
      } else {
        if (res.asError!.error is RegistrationResModel) {
          RegistrationResModel responseModel =
              res.asError!.error as RegistrationResModel;
          if (responseModel.errors?.mobile != null) {
            responseModel.errors!.mobile!.showToast();
          }
          if (onFailure != null) onFailure(false);
        } else {
          if (onFailure != null) onFailure(false);
        }
      }
    }
  }

  /// -----------------------------------------------------------------------
  void updateGenderIndex(int val) {
    genderIndex = val;
    dateOfBirth = null;
    notifyListeners();
    reValidateMinMaxAges();
  }

  void updateFullName(val) {
    fullName = val;
    notifyListeners();
  }

  set updateDisableStatus(bool val) {
    _enableFwdBtn = val;
    notifyListeners();
  }

  ///Date of Birth ----------------------------------------------------------

  void updateDateOfBirth(DateTime dateTime) {
    dateOfBirth = dateTime;
    tempDay = '${dateTime.day}';
    tempMonth = '${dateTime.month}';
    temYear = '${dateTime.year}';
    notifyListeners();
  }

  void updateDateFromAge(int val) {
    if (!interruptAgeScroll) {
      DateTime dateTime = DateTime(DateTime.now().year - val);
      day = '${dateTime.day}';
      month = '${dateTime.month}';
      year = '${dateTime.year}';
      tempDay = '${dateTime.day}';
      tempMonth = '${dateTime.month}';
      temYear = '${dateTime.year}';
      dateOfBirth = DateTime(dateTime.year, 1, 1);
      notifyListeners();
    }
  }

  void updateInterruptAgeScroll(val) {
    interruptAgeScroll = val;
    notifyListeners();
  }

  void assignTempToCurrent() {
    day = tempDay;
    month = tempMonth;
    year = temYear;
    notifyListeners();
  }

  Future<int> calculateAge() async {
    DateTime currentDate = DateTime.now();
    DateTime birthDate = dateOfBirth ?? currentDate;
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    int index = age <= maxAge ? ageList.indexWhere((int e) => e == age) : 0;
    return index;
  }

  void updateCountryData(val) {
    countryData = val;
    notifyListeners();
  }

  ///------------------------------------------------------------------------
  ///Religion ---------------------------------------------------------------
  void updateSelectedReligion(int val) {
    selectedReligion = val;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void pageInit({CountryData? countryData}) {
    countryData = countryData;
    isNumberValid = false;
    tabIndex = 0;
    phoneNumber = '';
    registrationErrorMsg = '';
    errorMsg = '';
    fullName = '';
    genderIndex = -1;
    otpInput = '';
    selectedReligion = -1;
    btnLoader = false;
    casteListModel = null;
    selectedCasteId = -1;
    casteDataList = null;
    dateOfBirth = null;
    notifyListeners();
    super.pageInit();
  }

  @override
  void updateBtnLoader(val) {
    btnLoader = val;
    notifyListeners();
  }

  void updateErrorMsg(String val) {
    errorMsg = val;
    notifyListeners();
  }

  void updateRegistrationErrorMsg(String val) {
    registrationErrorMsg = val;
    notifyListeners();
  }

  List<int> get ageList =>
      range(minAge, maxAge + 1).map((e) => e.toInt()).toList();

  void calculateMinAge() {
    MinimumGenderAge? minimumGenderAge =
        ageDataListModel?.data?.minimumGenderAge;
    switch (genderIndex) {
      case 0:
        minAge = minimumGenderAge?.male ?? 21;
        notifyListeners();
        break;

      case 1:
        minAge = minimumGenderAge?.female ?? 18;
        notifyListeners();
        break;

      default:
        minAge = minimumGenderAge?.male ?? 21;
        notifyListeners();
    }
  }

  void calculateMaxAge() {
    List<AgeList> ageList = ageDataListModel?.data?.ageList ?? [];
    maxAge = ageList.isEmpty ? 70 : (ageList.last.age ?? 70);
    notifyListeners();
  }

  void updateAgeListModel(val) {
    ageDataListModel = val;
    notifyListeners();
    reValidateMinMaxAges();
  }

  void reValidateMinMaxAges() {
    calculateMaxAge();
    calculateMinAge();
  }

  void clearCountryData() {
    countryData = null;
    notifyListeners();
  }
}
