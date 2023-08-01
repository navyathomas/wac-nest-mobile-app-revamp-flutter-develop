// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/dasa_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/models/star_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/map_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/http_requests.dart';
import 'package:provider/provider.dart';
import 'package:async/src/result/result.dart';

class ProfileProvider extends ChangeNotifier with BaseProviderClass {
  ValueNotifier<bool> enableBtn = ValueNotifier<bool>(false);
  TextEditingController aboutMeController = TextEditingController();

  ///Validation for family details.....
  bool fatherNameState = false;
  bool fatherJobState = false;
  bool motherNameState = false;
  bool motherJobState = false;
  bool siblingState = false;

  ///Validation for Professional Info......
  bool educationCategoryState = false;
  bool educationDetailState = false;
  bool jobCategoryState = false;
  bool jobDetailState = false;

  ///Validation for Religion Info......
  bool religionState = false;
  bool casteState = false;
  bool subCasteState = false;

  ///Validation for EdiContactInfo.......
  bool isPrimaryFieldValidated = false;
  bool isAlternateFieldValidated = false;
  bool isMobileVerified = false;
  bool enableVerifyButton = false;
  bool isPrimaryContactNumberValid = false;
  bool isAlternateContactNumberValid = false;
  String isPrimaryValidatedErrorMsg = '';
  String isAlternateValidatedErrorMsg = '';
  final TextEditingController myAddress = TextEditingController();
  final TextEditingController primaryNumberController = TextEditingController();
  final TextEditingController alternateNumberController =
      TextEditingController();

  ///Edit Horoscope Details Controllers.....
  TextEditingController malayalmDobController = TextEditingController();
  DateTime? dateTime;

  ///Horoscope Birth Time
  String birthTimeSelected = '';

  ///Janma Sista Dasha Date of Birth.......
  String? day;
  String? month;
  String? year;
  String? janmaSistaDob;

  ///DOB(Malayalam).......
  String? dayMalayalam;
  String? monthMalayalam;
  String? yearMalayalam;
  DateTime? dateOfBirthMalayalam;

  ///Star/Rasi.......
  StarListModel? starsModel;
  StarData? starData;
  LoaderState starsOrRashiLoader = LoaderState.loaded;

  ///Dasa.......
  DasaListModel? dasaListModel;
  DasaData? dasaData;
  LoaderState dasaLoader = LoaderState.loaded;

  Future<void> updateFamilyDetails(
      FamilyDetailsRequest familyDetailsRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateFamilyDetails(familyDetailsRequest);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateAboutMe(
      String aboutMySelf, String profileId, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateAboutMe(aboutMySelf, profileId);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.aboutMeSuccess);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateReligionInfo(
      ReligionInfoRequest religionInfoRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateReligionInfo(religionInfoRequest);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      await context.read<AppDataProvider>().getBasicDetails();
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateLocationDetails(
      LocationRequest locationRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateLocationDetails(locationRequest);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      context.read<AppDataProvider>().getBasicDetails();
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(errorRes.errors?.mobile ?? '');
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateBasicInfo(
      BasicInfoRequest basicInfoRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateBasicInfo(basicInfoRequest);
    if (res.isValue) {
      if (onSuccess != null) onSuccess();
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateProfessionalInfo(
      ProfessionalInfoRequest professionalRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updateProfessionalInfo(professionalRequest);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      await context.read<AppDataProvider>().getBasicDetails();
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> updateHoroscopeDetails(
      HoroscopeDetailsRequest horoscopeDetailsRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res =
        await serviceConfig.updateHoroscopeDetails(horoscopeDetailsRequest);
    if (res.isValue) {
      await context.read<AccountProvider>().fetchProfile(context);
      await context.read<AppDataProvider>().getBasicDetails();
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        Helpers.successToast(context.loc.somethingWentWrong);
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.loaded);
      }
    }
  }

  Future<void> getStarsDataList() async {
    updateStarsLoader(LoaderState.loading);
    Result res = await serviceConfig.getStarsData();
    if (res.isValue) {
      StarListModel model = res.asValue!.value;
      updateStarsModel(model);
      updateStarsLoader(LoaderState.loaded);
    } else {
      updateStarsLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  Future<void> getDashaDataList() async {
    updateDashaLoader(LoaderState.loading);
    Result res = await serviceConfig.getDasaList();
    if (res.isValue) {
      DasaListModel model = res.asValue!.value;
      updateDashaModel(model);
      updateDashaLoader(LoaderState.loaded);
    } else {
      updateDashaLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  Future<void> changeMobile(
      ChangeMobileRequest changeMobileRequest, BuildContext context,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.changeMobileNumber(changeMobileRequest);
    if (res.isValue) {
      if (onSuccess != null) onSuccess();
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
      }
    }
  }

  Future<void> changeMobileVerify(BuildContext context,
      {Function? onSuccess}) async {
    final profile = Provider.of<AccountProvider>(context, listen: false);
    final model = Provider.of<RegistrationProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.errorMsg = "";
    changeMobileVerifiedStatus(false);
    updateBtnLoader(true);
    var res = await serviceConfig.changeMobileVerify(
        profileId: profile.profile?.id.toString() ?? "",
        mobile: model.phoneNumber,
        countryID: model.countryData?.id.toString(),
        otp: auth.otpValue);
    if (res.isValue) {
      if (onSuccess != null) onSuccess();
      changeMobileVerifiedStatus(true);
      changeDoneBtnActiveState(true);
      Helpers.successToast(context.loc.updatedSuccessFully);
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        auth.errorMsg = errorRes.message ?? '';
        changeMobileVerifiedStatus(false);
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        changeMobileVerifiedStatus(false);
        updateBtnLoader(false);
      }
    }
  }

  ///Star...
  void updateStarsModel(StarListModel? val) {
    starsModel = val;
    notifyListeners();
  }

  void onStarChanged(StarData? selectedStarData) {
    if (selectedStarData != null) starData = selectedStarData;
    notifyListeners();
  }

  void updateStarsLoader(LoaderState state) {
    starsOrRashiLoader = state;
    notifyListeners();
  }

  ///Dasha...
  void updateDashaModel(DasaListModel? val) {
    dasaListModel = val;
    notifyListeners();
  }

  void onDashaChanged(DasaData? selectedDasa) {
    if (selectedDasa != null) {
      dasaData = selectedDasa;
    }
    notifyListeners();
  }

  void updateDashaLoader(LoaderState state) {
    dasaLoader = state;
    notifyListeners();
  }

  ///Janma Sista Date of Birth ---------------------------
  void updateJanmaSistaDasaDate(DateTime? dateTime) {
    if (dateTime != null) {
      day = DateFormat("dd").format(dateTime);
      month = '${dateTime.month}';
      year = '${dateTime.year}';
      janmaSistaDob = DateFormat("dd-MM-yyyy").format(dateTime);
    }
    notifyListeners();
  }

  void updateJanmaDasaOnChanged(DateTime? dateTimee) {
    dateTime = dateTimee;
    notifyListeners();
  }

  ///Date of Birth(Malayalam) -----------------------------
  void updateDobMalayalamDate(DateTime dateTime) {
    dateOfBirthMalayalam = dateTime;
    dayMalayalam = '${dateTime.day}';
    monthMalayalam = '${dateTime.month}';
    yearMalayalam = '${dateTime.year}';
    notifyListeners();
  }

  ///Date of Birth(Malayalam) ---------------------------
  void reAssignBirthTimeOnEditBtn(BuildContext context) {
    birthTimeSelected = context
            .read<AccountProvider>()
            .profile
            ?.userReligiousInfo
            ?.timeOfBirth ??
        '';
    notifyListeners();
  }

  void updateBirthTime(String dateTime) {
    birthTimeSelected = dateTime;
    notifyListeners();
  }

  ///Validation of Family Details on changed......
  void fatherNameOnChanged(val) {
    fatherNameState = val;
    changeDoneButtonState();
    notifyListeners();
  }

  void fatherJobOnChanged(val) {
    fatherJobState = val;
    changeDoneButtonState();
    notifyListeners();
  }

  void motherNameOnChanged(val) {
    motherNameState = val;
    changeDoneButtonState();
    notifyListeners();
  }

  void motherJobOnChanged(val) {
    motherJobState = val;
    changeDoneButtonState();
    notifyListeners();
  }

  void siblingOnChanged(val) {
    siblingState = val;
    changeDoneButtonState();
    notifyListeners();
  }

  void changeDoneButtonState() {
    if (fatherNameState ||
        fatherJobState ||
        motherNameState ||
        motherJobState ||
        siblingState) {
      changeDoneBtnActiveState(true);
    } else {
      changeDoneBtnActiveState(false);
    }
  }

  void clearStateButton() {
    fatherNameState = false;
    fatherJobState = false;
    motherNameState = false;
    motherJobState = false;
    siblingState = false;
    notifyListeners();
  }

  ///..................................................

  ///Validation of Professional Info...........
  void educationCategoryOnChanged(val) {
    educationCategoryState = val;
    changeEducationDoneButtonState();
    notifyListeners();
  }

  void educationDetailOnChanged(val) {
    educationDetailState = val;
    changeEducationDoneButtonState();
    notifyListeners();
  }

  void jobCategoryOnChanged(val) {
    jobCategoryState = val;
    changeEducationDoneButtonState();
    notifyListeners();
  }

  void jobDetailOnChanged(val) {
    jobDetailState = val;
    changeEducationDoneButtonState();
    notifyListeners();
  }

  void changeEducationDoneButtonState() {
    if (educationCategoryState ||
        educationDetailState ||
        jobCategoryState ||
        jobDetailState) {
      changeDoneBtnActiveState(true);
    } else {
      changeDoneBtnActiveState(false);
    }
  }

  void clearEducationStateButton() {
    educationCategoryState = false;
    educationDetailState = false;
    jobCategoryState = false;
    jobDetailState = false;
    notifyListeners();
  }

  ///............................................

  ///............Validation of Edit Contact Info................
  void isPrimaryNumberValid(String val, BuildContext context) {
    final register = Provider.of<RegistrationProvider>(context, listen: false);
    if (val.length >= (register.countryData?.minLength ?? 5) &&
        val.length <= (register.countryData?.maxLength ?? 15)) {
      print(
          '${val.length} --- ${register.countryData?.minLength} --- ${register.countryData?.maxLength}');
      isPrimaryContactNumberValid = true;
    } else {
      isPrimaryContactNumberValid = false;
    }
    notifyListeners();
  }

  void isAlternateNumberValid(String val, BuildContext context) {
    final register = Provider.of<RegistrationProvider>(context, listen: false);
    if (val.length >= (register.countryData?.minLength ?? 5) &&
        val.length <= (register.countryData?.maxLength ?? 15)) {
      print(
          '${val.length} --- ${register.countryData?.minLength} --- ${register.countryData?.maxLength}');
      isAlternateContactNumberValid = true;
    } else {
      isAlternateContactNumberValid = false;
    }
    notifyListeners();
  }

  //Validation used for primary contact details, alternate contact details on done button.....
  void primaryDetailsValidation({bool isButtonTapped = false}) {
    if (isButtonTapped && primaryNumberController.text.isNotEmpty) {
      if ((!isPrimaryContactNumberValid)) {
        isPrimaryValidatedErrorMsg = "Please enter a valid mobile number";
        isPrimaryFieldValidated = true;
      } else {
        isPrimaryValidatedErrorMsg = "";
        isPrimaryFieldValidated = false;
      }
    }
    notifyListeners();
  }

  void alternateDetailsValidation({bool isButtonTapped = false}) {
    if (isButtonTapped && alternateNumberController.text.isNotEmpty) {
      if ((!isAlternateContactNumberValid)) {
        isAlternateValidatedErrorMsg = "Please enter a valid mobile number";
        isAlternateFieldValidated = true;
      } else {
        isAlternateValidatedErrorMsg = "";
        isAlternateFieldValidated = false;
      }
    }
    notifyListeners();
  }

  void enableContactDoneButton(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    if (primaryNumberController.text.isEmpty &&
        alternateNumberController.text.isEmpty &&
        myAddress.text.isEmpty &&
        locationProvider.residenceLocation == null) {
      changeDoneBtnActiveState(false);
    } else {
      changeDoneBtnActiveState(true);
    }
    notifyListeners();
  }

  void changeMobileVerifiedStatus(val) {
    isMobileVerified = val;
    notifyListeners();
  }

  void enableVerifyButtonState(val) {
    enableVerifyButton = val;
    notifyListeners();
  }

  ///............................................

  void changeDoneBtnActiveState(val) {
    enableBtn.value = val;
    notifyListeners();
  }

  void clearData() {
    day = "";
    month = "";
    year = "";
    myAddress.text = '';
    primaryNumberController.text = '';
    alternateNumberController.text = '';
    enableVerifyButton = false;
    isMobileVerified = false;
    enableBtn.value = false;
    isPrimaryFieldValidated = false;
    isAlternateFieldValidated = false;
    isPrimaryContactNumberValid = false;
    isAlternateContactNumberValid = false;
    isPrimaryValidatedErrorMsg = "";
    isAlternateValidatedErrorMsg = "";
    birthTimeSelected = "";
    janmaSistaDob = "";
    dateTime = null;
    notifyListeners();
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
    super.updateBtnLoader(val);
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
