// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/body_type_list_model.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/models/city_data_model.dart';
import 'package:nest_matrimony/models/complexion_list_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/dasa_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/education_cat_model.dart';
import 'package:nest_matrimony/models/job_child_categories_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/models/delete_category_image_model.dart';
import 'package:nest_matrimony/models/hide_photo_model.dart';
import 'package:nest_matrimony/models/higher_plans_model.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/models/id_proof_photo_model.dart';
import 'package:nest_matrimony/models/id_proof_photo_model.dart'
    as id_proof_model;
import 'package:nest_matrimony/models/make_primary_model.dart';
import 'package:nest_matrimony/models/my_photos_model.dart';
import 'package:nest_matrimony/models/my_photos_model.dart' as photo_model;
import 'package:nest_matrimony/models/partner_preference_model.dart';
import 'package:nest_matrimony/models/planDetailModel.dart';
import 'package:nest_matrimony/models/profile_complete_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/models/see_all_plans_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/http_requests.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:provider/provider.dart';
import 'package:async/src/result/result.dart';

import '../services/http_requests.dart';

class AccountProvider extends ChangeNotifier with BaseProviderClass {
  //---------------------------------------------------
  // MANAGE PHOTOS
  Map<int, int> primaryIndexMap = {0: -1, 1: -1, 2: -1};
  Map<int, bool> toogleSwitchStatus = {0: false, 1: false, 2: false};

  List<String> profileImages = [
    // "https://images.unsplash.com/photo-1602650231028-97f3f5c709c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    // "https://images.unsplash.com/photo-1602650231028-97f3f5c709c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    // "https://images.unsplash.com/photo-1602650231028-97f3f5c709c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    // "https://images.unsplash.com/photo-1602650231028-97f3f5c709c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
  ];

  updateSwitchStatus(int key) {
    toogleSwitchStatus[key] == true ? unHideMyPhoto() : hideMyPhoto();

    // toogleSwitchStatus[key] = !toogleSwitchStatus[key]!;
    notifyListeners();
  }

  updatePrimaryIndexMap(int key, int value) {
    print(value);
    primaryIndexMap[key] = value;
    notifyListeners();
  }

  // MANAGE PHOTOS CLOSE
//---------------------------------------------------

//---------------------------------------------------
  //ADD HOROSCOPE
  XFile? pickedFile;
  setHoroscopeImage(BuildContext context,
      {XFile? filePicked, required bool isFromHoroscopicScreen}) {
    pickedFile = filePicked;
    notifyListeners();
    if (!isFromHoroscopicScreen) {
      Navigator.pushNamed(context, RouteGenerator.routeAddHoroscope);
    }
  }
  //ADD HOROSCOPE CLOSE
//---------------------------------------------------

//---------------------------------------------------
  //GET PROFILE

  HigherPlansModel? higherPlansData;

  ///Profile Edit Details Section.........
  int selectedProfileCreatedIndex = -1;
  MaritalStatus? maritalStatus;
  HeightData? heightData;
  int heightDataFromIndex = 0;
  bool isHeightUpdated = false;
  String profileId = "";
  String? profileCreated;
  ReligionListData? religionListData;
  TextEditingController subCasteController = TextEditingController();

  ///District Data......
  DistrictData? districtData;

  ///Caste Data.......
  CasteData? casteData;
  CasteListModel? casteListModel;
  LoaderState casteListLoader = LoaderState.loaded;

  ///City Data......
  LoaderState cityListLoader = LoaderState.loaded;
  CityDataModel? cityDataModel;
  CityData? cityData;

  ///State Data.....
  StateData? stateData;

  ///Country.....
  CountryData? countryData;

  ///Education.....
  Map<int, int> tempSelectedEducation = {};
  String tempSelectedEduCategories = '';

  ///Occupation.....
  Map<int, int> tempSelectedChildParentJob = {};
  String tempSelectedJobCategories = '';

  ///BodyType.....
  BodyType? bodyType;

  ///Complexion.....
  ComplexionData? complexionData;

  initHigherPalns() {
    higherPlansData = null;
    notifyListeners();
  }

  higherPlans({Function? onSuccess}) async {
    updateBtnLoader(true);

    var res = await serviceConfig.higherPlans();
    if (res.isValue) {
      higherPlansData = res.asValue!.value;
      log("SUCCESS : ${higherPlansData?.message}");
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateBtnLoader(false);
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        //All exceptions
      }
    }
    notifyListeners();
  }

  //GET PROFILE CLOSE
//---------------------------------------------------

//---------------------------------------------------
// 1. PROFILE
  ProfileModel? profileData;
  BasicDetails? profile;
  bool isProtected = false;

  void initProfile() {
    profileData = null;
    profile = null;
    isProtected = false;
    notifyListeners();
  }

  Future<bool> fetchProfile(BuildContext context, {Function? onSuccess}) async {
    updateBtnLoader(true);
    bool resFlag = false;
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.profileDetails();
    if (res.isValue) {
      updateBtnLoader(false);
      updateLoaderState(LoaderState.loaded);
      ProfileModel model = res.asValue!.value;
      profile = model.data?.basicDetails;
      maritalStatus = profile?.maritalStatus;
      heightData = profile?.userHeightList;
      bodyType = profile?.physicalStatus;
      complexionData = profile?.complexion;
      profileCreated = profile?.profileCreated;
      religionListData = profile?.userReligion;
      casteData = profile?.userCaste;
      districtData = profile?.userFamilyInfo?.userDistrict;
      cityData = profile?.userFamilyInfo?.userLocation;
      countryData = profile?.userCountry;
      stateData = profile?.userFamilyInfo?.userState;
      tempSelectedEduCategories =
          profile?.userEducationSubcategory?.eduCategoryTitle ?? '';
      tempSelectedJobCategories =
          profile?.userJobSubCategory?.parentJobCategory ?? '';
      reAssignStarOnEditBtn(context);
      reAssignDobMalayalamOnEditBtn(context);
      reAssignDasaOnEditBtn(context);
      reAssignJanmaSistaOnEditBtn(context);
      isProtected = model.data?.basicDetails?.isProtected ?? false;
      notifyListeners();
      log("RES MESSAGE : ${model.message}");
      resFlag = true;

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateLoaderState(LoaderState.loaded);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return resFlag;
  }

// PROFILE CLOSE
//---------------------------------------------------
//---------------------------------------------------
// PROFILE PERCENTAGE

  ProfileCompleteModel? profileComplete;
  int percentage = 0;
  initProfileComplete() {
    profileComplete = null;
    percentage = 0;
    notifyListeners();
  }

  Future profilePercentage({Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.profilePercentage();
    if (res.isValue) {
      profileComplete = res.asValue!.value;
      if (profileComplete?.data != null) {
        percentage = profileComplete!.data?.percentage! ?? 0;
      }
      log("SUCCESS : ${profileComplete?.message}");
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

// PROFILE PERCENTAGE CLOSE
//---------------------------------------------------
//---------------------------------------------------

// SEE ALL PLANS
//---------------------------------------------------
//---------------------------------------------------

  SeeAllPlansModel? seeAllPlans;
  initSeeAll() {
    seeAllPlans = null;
    notifyListeners();
  }

  getSeeAllPlans({Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.getSeeAllPlansList();
    if (res.isValue) {
      seeAllPlans = res.asValue!.value;
      log("SUCCESS : ${profileComplete?.message}");
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    // return seeAllPlans;
    notifyListeners();
  }

// SEE ALL PLANS  CLOSE
//---------------------------------------------------
// SEE ALL PLANS DETAIL
//---------------------------------------------------

  PlanDetailModel? planDetail;

  initPlanDetail() {
    planDetail = null;
    notifyListeners();
  }

  getPlanDetail({Function? onSuccess, String? planId}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.getPlanDetail(planId.toString());
    if (res.isValue) {
      planDetail = res.asValue!.value;
      log("SUCCESS : ${profileComplete?.message}");
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    // return seeAllPlans;
    notifyListeners();
  }

// SEE ALL PLANS DETAIL CLOSE
//---------------------------------------------------

//---------------------------------------------------
// PARTNER PREFERNCE
//---------------------------------------------------

  PartnerPreferenceModel? partnerPreferenceData;

  Future<PartnerPreferenceModel?> getPartnerPreference(BuildContext ctxt,
      {Function? onSuccess, String? profileId}) async {
    updateBtnLoader(true);
    updateLoaderState(LoaderState.loading);
    String userID = ctxt
            .read<AppDataProvider>()
            .basicDetailModel
            ?.basicDetail
            ?.id
            ?.toString() ??
        "";
    // var res = await serviceConfig.getPartnerPreference("10853");
    var res = await serviceConfig.getPartnerPreference(userID);
    if (res.isValue) {
      updateBtnLoader(false);
      updateLoaderState(LoaderState.loaded);
      partnerPreferenceData = res.asValue!.value;
      updatePreferenceValues(ctxt);
      log("SUCCESS : ${profileComplete?.message}");
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateLoaderState(LoaderState.error);
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        updateBtnLoader(false);
        //All exceptions
      }
    }
    // return seeAllPlans;
    notifyListeners();
    return partnerPreferenceData;
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
    super.updateBtnLoader(val);
  }

  updatePreferenceValues(BuildContext context) {
    HeightData heightDataTo = HeightData(
      height: partnerPreferenceData?.data?.toHeight?.height,
      heightValue: partnerPreferenceData?.data?.toHeight?.heightValue,
      id: partnerPreferenceData?.data?.toHeight?.id,
    );
    context.read<PartnerPreferenceProvider>().updateHeightTo(heightDataTo);
    HeightData heightDataFrom = HeightData(
      height: partnerPreferenceData?.data?.fromHeight?.height,
      heightValue: partnerPreferenceData?.data?.fromHeight?.heightValue,
      id: partnerPreferenceData?.data?.fromHeight?.id,
    );
    context.read<PartnerPreferenceProvider>().updateHeightFrom(heightDataFrom);
    AgeList ageDatFrom = AgeList(
        age: partnerPreferenceData?.data?.fromAge?.age,
        id: partnerPreferenceData?.data?.fromAge?.id);
    context.read<PartnerPreferenceProvider>().updateAgeFrom(ageDatFrom);
    AgeList ageDatTo = AgeList(
        age: partnerPreferenceData?.data?.toAge?.age,
        id: partnerPreferenceData?.data?.toAge?.id);
    context.read<PartnerPreferenceProvider>().updateAgeTo(ageDatTo);
    if (partnerPreferenceData!.data!.educationCategoryUnserializeId != null) {
      for (int i = 0;
          i <
              partnerPreferenceData!
                  .data!.educationCategoryUnserializeId!.length;
          i++) {
        debugPrint(
            'education id ${partnerPreferenceData?.data?.educationCategoryUnserializeId![i]}');
      }
    }

    // MaritalStatus maritalStatus = MaritalStatus(
    //     id: int.parse(partnerPreferenceData?.data?.maritalStatusId ?? '0'),
    //     maritalStatus:
    //         partnerPreferenceData?.data?.maritalStatusUnserialize![0]);
    // context
    //     .read<PartnerPreferenceProvider>()
    //     .updateMaritalStatus(maritalStatus);
  }

//---------------------------------------------------
// PARTNER PREFERNCE CLOSE
//---------------------------------------------------
//---------------------------------------------------

  clearImagePicked() {
    pickedFile = null;
    notifyListeners();
  }

  ///---------------- Profile Edit Section Starts --------------------

  Future<void> getCasteDataList(
      {required BuildContext context, Function? onSuccess}) async {
    updateCasteLoader(LoaderState.loading);
    Result res =
        await serviceConfig.getCasteDataList(religionListData?.id ?? -1);
    if (res.isValue) {
      CasteListModel model = res.asValue!.value;
      updateCastListModel(model);
      if (onSuccess != null) onSuccess();
      updateCasteLoader(LoaderState.loaded);
    } else {
      updateCastListModel(null);
      updateCasteLoader(LoaderState.loaded);
      updateCasteLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  Future<void> getCityData(int districtId, BuildContext context,
      {Function? onSuccess}) async {
    updateCityListLoader(LoaderState.loading);
    var res = await serviceConfig.getCityDataList(districtId);
    if (res.isValue) {
      CityDataModel model = res.asValue!.value;
      updateCityDataModel(model);
      updateCityListLoader(LoaderState.loaded);
    } else {
      updateCityListLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateCastListModel(val) {
    casteListModel = val;
    notifyListeners();
  }

  void updateMaritalStatus(
      MaritalStatus? maritalStatses, BuildContext context) {
    if (maritalStatses != null) maritalStatus = maritalStatses;
    sendBasicInfoRequest(context, needPop: false);
    notifyListeners();
  }

  void updateBodyTypeStatus(BodyType? bodyTypeModel, BuildContext context) {
    if (bodyTypeModel != null) bodyType = bodyTypeModel;
    sendBasicInfoRequest(context, needPop: false);
    notifyListeners();
  }

  void updateComplexionStatus(
      ComplexionData? complexionModel, BuildContext context) {
    if (complexionModel != null) complexionData = complexionModel;
    sendBasicInfoRequest(context, needPop: false);
    notifyListeners();
  }

  void updateHeight(HeightData? heightDatas) {
    if (heightDatas != null) heightData = heightDatas;
    notifyListeners();
  }

  getHeightWheelFromIndex(BuildContext context) {
    var data = context.read<AppDataProvider>().heightDataModel?.heightData;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].heightValue == heightData?.heightValue) {
          updateHeightFromIndex(i);
          break;
        }
      }
    }
  }

  updateHeightFromIndex(int index) {
    heightDataFromIndex = index;
  }

  void updateProfileCreatedBy(String val, int index) {
    selectedProfileCreatedIndex = index;
    profileCreated = val;
    notifyListeners();
  }

  ///...............Religion Info.................
  void updateReligionOnChanged(
      ReligionListData? religionListDatas, BuildContext context) {
    if (religionListDatas != null) {
      religionListData = religionListDatas;
      casteData = null;
      subCasteController.clear();
      notifyListeners();
    }
  }

  //Used to reassign the initial value of religion on edit button clicked.....
  void reAssignReligionOnEditBtn() {
    religionListData = profile?.userReligion;
    notifyListeners();
  }

  void updateCasteOnChanged(CasteData? casteDatas, BuildContext context) {
    if (casteDatas != null) {
      updateButtonState(casteData?.id ?? 0, casteDatas.id ?? 0, context);
      casteData = casteDatas;
      subCasteController.clear();
      notifyListeners();
    }
  }

  void changeReligionButtonState(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    if (subCasteController.text.trim().isNotEmpty && casteData != null) {
      profile.changeDoneBtnActiveState(true);
    } else {
      profile.changeDoneBtnActiveState(false);
    }
    notifyListeners();
  }

  void reAssignCasteOnEditBtn() {
    casteData = profile?.userCaste;
    notifyListeners();
  }

  ///.........Education............
  void updateSelectedEduCatData(
      {required int? parentId, required int? childId, required String title}) {
    if (parentId != null && childId != null) {
      if (tempSelectedEducation.isEmpty) {
        tempSelectedEducation[parentId] = childId;
        tempSelectedEduCategories = title;
      } else if (!tempSelectedEducation.containsKey(parentId)) {
        tempSelectedEducation.clear();
        tempSelectedEducation[parentId] = childId;
        tempSelectedEduCategories = title;
      } else {
        tempSelectedEducation.clear();
        tempSelectedEducation[parentId] = childId;
        tempSelectedEduCategories = title;
      }
      notifyListeners();
    }
  }

  void searchEduByQuery(String val, BuildContext context) {
    final searchProvider =
        Provider.of<SearchFilterProvider>(context, listen: false);
    if ((searchProvider.educationCategoryModel?.data ?? []).isNotEmpty &&
        val.isNotEmpty) {
      List<EducationCategoryData> model = searchProvider
          .educationCategoryModel!.data!
          .where((EducationCategoryData? element) {
        bool isContain = (element?.parentEducationCategory ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      searchProvider.eduCatDataList = model;
    } else {
      searchProvider.eduCatDataList =
          searchProvider.educationCategoryModel?.data ?? [];
    }
    notifyListeners();
  }

  void reAssignTempToEducationCatData() {
    tempSelectedEduCategories =
        profile?.userEducationSubcategory?.eduCategoryTitle ?? '';
    notifyListeners();
  }

  ///.........Occupation............
  void updateSelectedParentChildJobCatData(
      {required int? parentId, required int? childId, required String title}) {
    if (parentId != null && childId != null) {
      if (tempSelectedChildParentJob.isEmpty) {
        tempSelectedChildParentJob[parentId] = childId;
        tempSelectedJobCategories = title;
      } else if (!tempSelectedChildParentJob.containsKey(parentId)) {
        tempSelectedChildParentJob.clear();
        tempSelectedChildParentJob[parentId] = childId;
        tempSelectedJobCategories = title;
      } else {
        tempSelectedChildParentJob.clear();
        tempSelectedChildParentJob[parentId] = childId;
        tempSelectedJobCategories = title;
      }
      notifyListeners();
    }
  }

  void searchJobByQuery(String val, BuildContext context) {
    final searchProvider =
        Provider.of<SearchFilterProvider>(context, listen: false);
    if ((searchProvider.jobCategoryModel?.data ?? []).isNotEmpty &&
        val.isNotEmpty) {
      List<JobDataCategoryModel> model = searchProvider.jobCategoryModel!.data!
          .where((JobDataCategoryModel? element) {
        bool isContain = (element?.parentJobCategory ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      searchProvider.jobChildCategoryList = model;
    } else {
      searchProvider.jobChildCategoryList =
          searchProvider.jobCategoryModel?.data ?? [];
    }
    notifyListeners();
  }

  void reAssignTempToJobCatData() {
    tempSelectedJobCategories =
        profile?.userJobSubCategory?.parentJobCategory ?? '';
    notifyListeners();
  }

  void clearTempSelectedData() {
    tempSelectedEducation = {};
    tempSelectedChildParentJob = {};
    tempSelectedEduCategories = '';
    tempSelectedJobCategories = '';
    notifyListeners();
  }

  ///...........Country..............
  void updateCountry(CountryData? val) {
    countryData = val;
    stateData = null;
    districtData = null;
    cityData = null;
    notifyListeners();
  }

  void reAssignCountryOnEditBtn() {
    countryData = profile?.userCountry;
    notifyListeners();
  }

  ///...........State..............
  void updateState(StateData? val) {
    stateData = val;
    districtData = null;
    cityData = null;
    notifyListeners();
  }

  void reAssignStateOnEditBtn() {
    stateData = profile?.userFamilyInfo?.userState;
    notifyListeners();
  }

  ///...........District..............
  void updateDistrict(DistrictData? districtDatas) {
    if (districtDatas != null) districtData = districtDatas;
    cityData = null;
    notifyListeners();
  }

  void reAssignDistrictOnEditBtn() {
    districtData = profile?.userFamilyInfo?.userDistrict;
    notifyListeners();
  }

  ///...........City................
  void updateCityData(CityData? cityDatas) {
    if (cityDatas != null) cityData = cityDatas;
    notifyListeners();
  }

  void reAssignCityOnEditBtn() {
    cityData = profile?.userFamilyInfo?.userLocation;
    notifyListeners();
  }

  void sendBasicInfoRequest(BuildContext context, {bool needPop = true}) {
    BasicInfoRequest basicInfoRequest = BasicInfoRequest(
        profileId: profile?.id?.toString() ?? '',
        height: heightData?.id?.toString() ?? '',
        maritalStatus: maritalStatus?.id?.toString() ?? '',
        createdBy: profileCreated ?? '',
        bodyType: bodyType?.id,
        complexion: complexionData?.id);
    context.read<ProfileProvider>().updateBasicInfo(basicInfoRequest, context,
        onSuccess: () async {
      await clearData();
      await fetchProfile(context);
      context.read<AppDataProvider>().getBasicDetails();
      Helpers.successToast(context.loc.updatedSuccessFully);
      if (needPop) Navigator.of(context).pop();
    });
  }

  void updateCityDataModel(val) {
    cityDataModel = val;
    notifyListeners();
  }

  void updateCityListLoader(LoaderState val) {
    cityListLoader = val;
    notifyListeners();
  }

  ///...........Star................
  void reAssignStarOnEditBtn(BuildContext context) {
    context.read<ProfileProvider>().starData =
        profile?.userReligiousInfo?.userStars;
    notifyListeners();
  }

  ///...........Dasha................
  void reAssignDasaOnEditBtn(BuildContext context) {
    context.read<ProfileProvider>().onDashaChanged(DasaData(
        jathakamType: profile?.userReligiousInfo?.dhasaName,
        id: profile?.userReligiousInfo?.jathakamTypesId));
  }

  ///...........Malayalam DOB................
  void reAssignDobMalayalamOnEditBtn(BuildContext context) {
    context.read<ProfileProvider>().malayalmDobController.text =
        profile?.userReligiousInfo?.malayalamDob ?? '';
    notifyListeners();
  }

  ///...........Janma sista DOB................
  void reAssignJanmaSistaOnEditBtn(BuildContext context) {
    if (profile?.userReligiousInfo != null &&
        profile?.userReligiousInfo?.sistaDasaDay != null &&
        profile?.userReligiousInfo?.sistaDasaMonth != null &&
        profile?.userReligiousInfo?.sistaDasaYear != null) {
      context.read<ProfileProvider>().day =
          profile?.userReligiousInfo?.sistaDasaDay;
      context.read<ProfileProvider>().month =
          profile?.userReligiousInfo?.sistaDasaMonth;
      context.read<ProfileProvider>().year =
          profile?.userReligiousInfo?.sistaDasaYear;
      context.read<ProfileProvider>().janmaSistaDob =
          "${profile?.userReligiousInfo?.sistaDasaDay}-"
          "${profile?.userReligiousInfo?.sistaDasaMonth}"
          "-${profile?.userReligiousInfo?.sistaDasaYear}";
    }
    notifyListeners();
  }

  void updateButtonState(int initialId, int updatedId, BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    initialId != updatedId
        ? profile.changeDoneBtnActiveState(true)
        : profile.changeDoneBtnActiveState(false);
    changeReligionButtonState(context);
    notifyListeners();
  }

  Future<void> clearData() async {
    profileCreated = '';
    selectedProfileCreatedIndex = -1;
    maritalStatus = null;
    heightData = null;
    notifyListeners();
  }

  void updateCasteLoader(LoaderState loaderState) {
    casteListLoader = loaderState;
    notifyListeners();
  }

  ///---------------- Profile Edit Section Ends --------------------

// MANAGE PHOTOS API INTEGRATION SECTION

//--------------------------
  MyPhotosModel? myPhotos;
  bool myPhotoLoader = false;
  updateMyPhotosLoader(bool value) {
    myPhotoLoader = value;
    notifyListeners();
  }

  int pageNo = 1;
  updatePageNumber() {
    pageNo++;
    notifyListeners();
  }

  bool paginationLoading = false;
  paginationLoad(bool value) {
    paginationLoading = value;
    notifyListeners();
  }

  bool firstLoad = false;
  firstLoaded(bool value) {
    firstLoad = value;
    notifyListeners();
  }

  int? myPhotoCount = 0;
  List<photo_model.Datum>? myPhotoList = [];

  Future getMyOWnPhotos(BuildContext context,
      {Function? onSuccess, bool? enableLoader = true}) async {
    firstLoaded(true);
    if (enableLoader ?? false) updateMyPhotosLoader(true);
    updateLoaderState(LoaderState.loading);

    var res = await serviceConfig.getMyPhotos(page: pageNo);
    if (res.isValue) {
      toogleSwitchStatus[0] = isProtected; // set default value of toggle button

      myPhotos = res.asValue!.value;
      myPhotoList?.addAll(res.asValue!.value.data?.original?.data ?? []);

      if (myPhotos?.data != null) {
        myPhotos?.data?.original?.data?.forEach(
          (element) {
            profileImages.add((element.imageFile ?? "").fullImagePath(context));
            if (element.isPreference == 1) {
              int? index = myPhotos?.data?.original?.data?.indexOf(element);
              primaryIndexMap[0] = index ?? -1;
            }
          },
        );
        log(myPhotos!.data.toString());
        myPhotoCount = myPhotos!.data!.original!.recordsTotal;
      }
      log("SUCCESS : ${myPhotos?.message}");
      updateLoaderState(LoaderState.loaded);
      updateMyPhotosLoader(false);
      updatePageNumber();
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        log(errorRes.errors.toString());
        updateMyPhotosLoader(false);
        updateLoaderState(LoaderState.error);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.error);
        updateMyPhotosLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  Future makePrimaryPhoto({Function? onSuccess, String? id}) async {
    //my photos - in manage photos
    updateBtnLoader(true);
    var res = await serviceConfig.makeImagePrimary(imageID: id);
    if (res.isValue) {
      updateBtnLoader(false);
      MakePrimaryModel primaryStatus = res.asValue?.value as MakePrimaryModel;
      log("SUCCESS : ${primaryStatus.message}");

      if (onSuccess != null) onSuccess(true);
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  Future deleteMyPhoto({Function? onSuccess, String? id}) async {
    //delete my photos - in manage photos
    // updateBtnLoader(true);
    var res = await serviceConfig.deleteMyPhoto(imageID: id);
    if (res.isValue) {
      // updateBtnLoader(false);
      MakePrimaryModel primaryStatus = res.asValue?.value as MakePrimaryModel;
      log("SUCCESS : ${primaryStatus.message}");

      if (onSuccess != null) onSuccess(true);
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  Future deleteCategoryImages({Function? onSuccess, String? id}) async {
    //delete my photos - in manage photos
    // updateBtnLoader(true);
    var res = await serviceConfig.deleteCategoryImages(imageID: id);
    if (res.isValue) {
      // updateBtnLoader(false);
      DeleteCategoryModel primaryStatus =
          res.asValue?.value as DeleteCategoryModel;
      log("SUCCESS : ${primaryStatus.message}");

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        // updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

//hide photos
  Future hideMyPhoto({Function? onSuccess}) async {
    //delete my photos - in manage photos
    updateBtnLoader(true);
    var res = await serviceConfig.hideMyPhoto();
    if (res.isValue) {
      updateBtnLoader(false);

      toogleSwitchStatus[0] = true; // make hide
      notifyListeners();

      HidePhotoModel primaryStatus = res.asValue?.value as HidePhotoModel;
      log("SUCCESS : ${primaryStatus.message}");

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  // unhide photos
  Future unHideMyPhoto({Function? onSuccess}) async {
    //delete my photos - in manage photos
    updateBtnLoader(true);
    var res = await serviceConfig.unhideMyPhoto();
    if (res.isValue) {
      updateBtnLoader(false);

      toogleSwitchStatus[0] = false; // make unhide
      notifyListeners();

      HidePhotoModel primaryStatus = res.asValue?.value as HidePhotoModel;
      log("SUCCESS : ${primaryStatus.message}");

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
        log(errorRes.errors.toString());
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  clearManagePhotoSections() {
    // myPhotos = null;
    // profileImages = [];
    myPhotoLoader = false;
    btnLoader = false;
    paginationLoading = false;
    notifyListeners();
  }

  clearAllManagePhotoSections() {
    myPhotos = null;
    profileImages = [];
    myPhotoLoader = false;
    btnLoader = false;
    paginationLoading = false;
    pageNo = 1;
    myPhotoList = [];
    myPhotoCount = 0;
    notifyListeners();
  }

//--------------------------------

  List<id_proof_model.Datum>? idProofPhoto = [];

  // get my id proof images
  Future getIDproofPhotos({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);

    var res = await serviceConfig.getIDproofPhotos();
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      OtherPhotosModel idProofPhotos = res.asValue?.value as OtherPhotosModel;
      idProofPhoto = idProofPhotos.data;

      log("SUCCESS : ${idProofPhotos.message}");

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.errors.toString());
        updateMyPhotosLoader(false);
        updateLoaderState(LoaderState.error);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.error);
        updateMyPhotosLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

//--
  List<id_proof_model.Datum>? myhousePhoto = [];
// get my house photos
  Future getMyhousePhoto({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);

    var res = await serviceConfig.getMyHousePhotos();
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      OtherPhotosModel housePhotosModel =
          res.asValue?.value as OtherPhotosModel;
      myhousePhoto = housePhotosModel.data;

      log("SUCCESS : ${housePhotosModel.message}");

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.errors.toString());
        updateMyPhotosLoader(false);
        updateLoaderState(LoaderState.error);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.error);
        updateMyPhotosLoader(false);
        //All exceptions
      }
    }
    return percentage;
    // notifyListeners();
  }

  clearIdProofSection() {
    // idProofPhoto = [];
    // notifyListeners();
  }

  clearHouseSection() {
    // myhousePhoto = [];
    // notifyListeners();
  }

// MANAGE PHOTOS API INTEGRATION SECTION CLOSE

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
