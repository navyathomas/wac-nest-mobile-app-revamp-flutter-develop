import 'package:flutter/widgets.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/body_type_model.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:provider/provider.dart';

import '../models/caste_list_model.dart';
import '../models/city_data_model.dart';
import '../models/complexion_model.dart';
import '../models/countries_data_model.dart';
import '../models/district_data_model.dart';
import '../models/education_cat_model.dart';
import '../models/height_data_model.dart';
import '../models/jathakam_model.dart';
import '../models/job_category_model.dart';
import '../models/job_data_model.dart';
import '../models/marital_status_model.dart';
import '../models/profile_request_model.dart';
import '../models/response_model.dart';
import '../models/search_value_model.dart';
import '../models/state_data_model.dart';
import '../services/helpers.dart';
import '../services/http_requests.dart';
import 'app_data_provider.dart';
import 'package:async/src/result/result.dart';

class PartnerPreferenceProvider extends ChangeNotifier with BaseProviderClass {
  HeightData? heightDataFrom;
  HeightData? heightDataTo;
  AgeList? ageListDataTo;
  AgeList? ageListDataFrom;
  int ageToIndex = 0;
  AgeList? ageDataToValue;
  AgeList? ageDataTFromValue;
  HeightData? heightDataToValue;
  HeightData? heightDataFromValue;
  bool isAgeIndexUpdated = false;
  int ageFromIndex = 0;
  int heightFromIndex = 0;
  int heightToIndex = 0;
  SearchValueModel? searchValueModel;
  Map<int, List<int>> tempSelectedFilterEducation = {};
  Map<int, List<int>> tempSelectedFilterJobParents = {};
  List<String> tempSelectedFilterEduCategories = [];
  List<String> tempSelectedFilterJobParentCategories = [];
  List<EducationCategoryData>? eduCatDataList;
  List<JobCategoryData>? jobCatDataList;
  Map<int, String> tempSelectedEducationalValues = {};
  Map<int, String> tempSelectedParentJobValues = {};
  EducationCategoryModel? educationCategoryModel;
  JobCategoryModel? parentJobCategoryModel;
  SearchValueModel? searchFilterValueModel;
  Map<int, String> tempSelectedFilterOccupations = {};
  List<String> tempSelectedFilterOccupationCategories = [];
  List<JobData>? jobDataList;
  JobDataModel? jobDataModel;
  Map<int, String> tempSelectedFilterCaste = {};
  CasteListModel? casteListModel;
  List<CasteData>? casteDataList;
  Map<int, String> tempSelectedFilterDistricts = {};
  Map<int, String> tempSelectedFilterLocation = {};
  List<DistrictData>? districtDataList;
  DistrictDataModel? districtDataModel;
  CityDataModel? cityDataModel;
  CityData? cityData;
  LoaderState cityListLoader = LoaderState.loaded;
  Map<int, String> tempSelectedMartialStatus = {};
  Map<int, String> tempSelectedBodyType = {};
  Map<int, String> tempSelectedState = {};
  MaritalStatusModel? maritalStatusModel;
  BodyTypeModel? bodyTypeModel;
  StateDataModel? stateDataModel;
  List<MaritalStatus>? maritalDataList;
  List<BodyType>? bodyTypeList;
  List<StateData>? stateDataList;
  Map<int, String> tempSelectedComplexion = {};
  ComplexionModel? complexionModel;
  List<Complexion>? complexionList;
  Map<int, String> tempSelectedJathakam = {};
  JathakamModel? jathakamModel;
  List<JathakamType>? jathakamDataList;
  SearchValueModel? searchFilterTempValueModel;
  double? selectedFromHeight;
  double? selectedToHeight;
  double? selectedFromAge;
  HeightDataModel? heightDataModel;
  double? selectedToAge;
  Map<String, dynamic> searchFilterParam = {};
  bool filterAppliedFromAgeWheelFrom = false;
  bool filterAppliedFromAgeWheelTo = false;
  bool filterAppliedFromHeightWheelFrom = false;
  bool filterAppliedFromHeightWheelTo = false;
  bool isFilterApplied = false;
  bool isLocationFilterApplied = false;
  bool isReligiousFilterApplied = false;
  bool isProfessionalFilterApplied = false;
  TextEditingController subCasteController = TextEditingController();
  TextEditingController educationDetailController = TextEditingController();
  TextEditingController jobDetailController = TextEditingController();
  bool isRemoveAllSelected = true;
  bool isRemoveAllSelectedJob = true;
  int? countryId;
  void updateRemoveAllSelected(bool value) {
    isRemoveAllSelected = value;
    notifyListeners();
  }

  void updateRemoveAllSelectedJob(bool value) {
    isRemoveAllSelectedJob = value;
    notifyListeners();
  }

  void updateHeightFrom(HeightData? heightDataValue) {
    if (heightDataValue != null) {
      heightDataFrom = heightDataValue;
      selectedFromHeight = (heightDataFrom!.id ?? 0).toDouble();
      notifyListeners();
    }
  }

  void updateHeightTo(HeightData? heightDataValue) {
    if (heightDataValue != null) {
      heightDataTo = heightDataValue;
      selectedToHeight = (heightDataTo!.id ?? 0).toDouble();
      notifyListeners();
    }
  }

  void updateAgeTo(AgeList? ageDataValue) {
    if (ageDataValue != null) {
      ageListDataTo = ageDataValue;
      selectedToAge = (ageListDataTo?.id ?? 0).toDouble();
      notifyListeners();
    }
  }

  updateAgeToIndex(int index) {
    ageToIndex = index;
  }

  updateAgeFromIndex(int index) {
    ageFromIndex = index;
  }

  updateHeightFromIndex(int index) {
    heightFromIndex = index;
  }

  updateHeightToIndex(int index) {
    heightToIndex = index;
  }

  void updateAgeFrom(AgeList? ageDataValue) {
    if (ageDataValue != null) {
      ageListDataFrom = ageDataValue;
      selectedFromAge = (ageListDataFrom?.id ?? 0).toDouble();
      notifyListeners();
    }
  }

  getAgeWheeFromIndex(BuildContext context) {
    var data = context.read<AppDataProvider>().ageDataListModel?.data?.ageList;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].age == ageListDataFrom?.age) {
          updateAgeFromIndex(i);
          break;
        }
      }
    }
  }

  getAgeWheeToIndex(BuildContext context) {
    var data = context.read<AppDataProvider>().ageDataListModel?.data?.ageList;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].age == ageListDataTo?.age) {
          updateAgeToIndex(i);
          break;
        }
      }
    }
  }

  getHeightWheeToIndex(BuildContext context) {
    var data = context.read<AppDataProvider>().heightDataModel?.heightData;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].heightValue == heightDataTo?.heightValue) {
          updateHeightToIndex(i);
          break;
        }
      }
    }
  }

  getHeightWheeFromIndex(BuildContext context) {
    var data = context.read<AppDataProvider>().heightDataModel?.heightData;
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].heightValue == heightDataFrom?.heightValue) {
          updateHeightFromIndex(i);
          break;
        }
      }
    }
  }

//marital status
  void updateMaritalStatus(MaritalStatus? val, {bool isFromSearch = true}) {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(maritalStatus: val);
    searchValueModel = temp;

    notifyListeners();
  }

  void updateSelectedMaritalStatus(int? id, String? name) {
    if (id != null) {
      if (tempSelectedMartialStatus.containsKey(id)) {
        tempSelectedMartialStatus.remove(id);
      } else {
        tempSelectedMartialStatus[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  Future<void> getMaritalStatusDataList({bool isFromSearch = true}) async {
    updateLoaderState(LoaderState.loading);
    //  bool fetchStat = await checkFetchFromBack;
    Result res =
        await serviceConfig.getMaritalStatusData(fetchFromLocal: false);
    if (res.isValue) {
      MaritalStatusModel model = res.asValue!.value;
      updateMaritalStatusModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateMaritalStatusModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateMaritalStatusModel(val) {
    maritalStatusModel = val;
    maritalDataList = maritalStatusModel?.maritalStatusData ?? [];
    notifyListeners();
  }

  void assignTempToSelectedMartialStatus() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedMaritalStatus: {...tempSelectedMartialStatus});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempMaritalStatus() {
    tempSelectedMartialStatus =
        searchFilterValueModel?.selectedMaritalStatus ?? {};
    notifyListeners();
  }

  void clearMartialStatusData() {
    tempSelectedMartialStatus = {};
    notifyListeners();
  }

  void updateSelectedBodyType(int? id, String? name) {
    if (id != null) {
      if (tempSelectedBodyType.containsKey(id)) {
        tempSelectedBodyType.remove(id);
      } else {
        tempSelectedBodyType[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  Future<void> getBodyType({bool isFromSearch = true}) async {
    updateLoaderState(LoaderState.loading);
    //  bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getBodyType(fetchFromLocal: false);
    if (res.isValue) {
      BodyTypeModel model = res.asValue!.value;
      updateBodyTypeModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateBodyTypeModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateBodyTypeModel(val) {
    bodyTypeModel = val;
    bodyTypeList = bodyTypeModel?.data ?? [];
    notifyListeners();
  }

  updateStateModel(val) {
    stateDataModel = val;
    stateDataList = stateDataModel?.stateData ?? [];
  }

  void assignTempToBodyType() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedBodyType: {...tempSelectedBodyType});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempMBodyType() {
    tempSelectedBodyType = searchFilterValueModel?.selectedBodyType ?? {};
    notifyListeners();
  }

  void clearBodyTypeData() {
    tempSelectedBodyType = {};
    notifyListeners();
  }

  void clearComplexion() {
    tempSelectedComplexion = {};
    notifyListeners();
  }

  clearBasicPreference() {
    clearBodyTypeData();
    clearMartialStatusData();
    clearComplexion();
  }

  Future<void> getStateList(int countryId) async {
    //updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getStateDataList(countryId);
    if (res.isValue) {
      StateDataModel stateDataModel = res.asValue!.value;
      updateStateModel(stateDataModel);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateStateModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  getDistrictsFromMultipleStates() async {
    //updateLoaderState(LoaderState.loading);
    Map<String, dynamic> params = {};
    if (searchFilterValueModel!.getSelectedState.isNotEmpty) {
      List<int> idList = searchFilterValueModel!.getSelectedState.keys.toList();
      List<String> stringList = [];
      for (int i = 0; i < idList.length; i++) {
        stringList.add(idList[i].toString());
      }
      params['state_id'] = stringList;
    }
    Result res = await serviceConfig.getDistrictFromMultipleStates(params);
    if (res.isValue) {
      DistrictDataModel districtDataModel = res.asValue!.value;
      updateDistrictModel(districtDataModel);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateDistrictModel(null);
      updateLoaderState(LoaderState.loaded);
    }
  }

  getLocationFromMultipleDistricts() async {
    updateLoaderState(LoaderState.loading);
    Map<String, dynamic> params = {};
    if (searchFilterValueModel!.getSelectedDistrict.isNotEmpty) {
      List<int> idList =
          searchFilterValueModel!.getSelectedDistrict.keys.toList();
      List<String> stringList = [];
      for (int i = 0; i < idList.length; i++) {
        stringList.add(idList[i].toString());
      }
      params['district_id'] = stringList;
    }
    Result res = await serviceConfig.getLocationFromMultipleDistricts(params);
    if (res.isValue) {
      CityDataModel cityDataModel = res.asValue!.value;
      updateCityDataModel(cityDataModel);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateCityDataModel(null);
      updateLoaderState(LoaderState.loaded);
    }
  }

  void assignTempToSelectedState() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchFilterValueModel!.copyWith(selectedState: {...tempSelectedState});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void clearStateFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(selectedState: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void updateSelectedState(int? id, String? name) {
    if (id != null) {
      if (tempSelectedState.containsKey(id)) {
        tempSelectedState.remove(id);
      } else {
        tempSelectedState[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void updateSelectedDistrict(int? id, String? name) {
    if (id != null) {
      if (tempSelectedFilterDistricts.containsKey(id)) {
        tempSelectedFilterDistricts.remove(id);
      } else {
        tempSelectedFilterDistricts[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void assignTempToSelectedDistrict() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedDistrict: {...tempSelectedFilterDistricts});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void assignTempToSelectedLocation() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedCity: {...tempSelectedFilterLocation});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void updateSelectedLocation(int? id, String? name) {
    if (id != null) {
      if (tempSelectedFilterLocation.containsKey(id)) {
        tempSelectedFilterLocation.remove(id);
      } else {
        tempSelectedFilterLocation[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void clearLocationFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(selectedCity: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  // void assignTempToSelectedState(StateData? val, {bool isFromSearch = true}) {
  //   if (isFromSearch) {
  //     searchValueModel ??= SearchValueModel();
  //     SearchValueModel temp = searchValueModel!.copyWith(stateData: val);
  //     searchValueModel = temp;
  //   } else {
  //     searchFilterValueModel ??= SearchValueModel();
  //     SearchValueModel temp = searchFilterValueModel!.copyWith(stateData: val);
  //     searchFilterValueModel = temp;
  //   }
  //   notifyListeners();
  // }

  void reAssignSelectedState() {
    tempSelectedState = searchFilterValueModel?.selectedState ?? {};
    notifyListeners();
  }

  void reAssignSelectedDistrict() {
    tempSelectedFilterLocation = searchFilterValueModel?.selectedDistrict ?? {};
    notifyListeners();
  }

  void reAssignSelectedLocation() {
    tempSelectedFilterLocation = searchFilterValueModel?.selectedDistrict ?? {};
    notifyListeners();
  }

  void updateSelectedComplexion(int? id, String? name) {
    if (id != null) {
      if (tempSelectedComplexion.containsKey(id)) {
        tempSelectedComplexion.remove(id);
      } else {
        tempSelectedComplexion[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  Future<void> getComplexion({bool isFromSearch = true}) async {
    updateLoaderState(LoaderState.loading);
    //  bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getComplexion(fetchFromLocal: false);
    if (res.isValue) {
      ComplexionModel model = res.asValue!.value;
      updateComplexionModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateComplexionModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateComplexionModel(val) {
    complexionModel = val;
    complexionList = complexionModel?.complexionData ?? [];
    notifyListeners();
  }

  void assignTempToComplexion() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedComplexion: {...tempSelectedComplexion});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempComplexion() {
    tempSelectedComplexion = searchFilterValueModel?.selectedComplexion ?? {};
    notifyListeners();
  }

  void updateSelectedJathakam(int? id, String? name) {
    if (id != null) {
      if (tempSelectedJathakam.containsKey(id)) {
        tempSelectedJathakam.remove(id);
      } else {
        tempSelectedJathakam[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  Future<void> getJathakam({bool isFromSearch = true}) async {
    updateLoaderState(LoaderState.loading);
    //  bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getJathakam(fetchFromLocal: false);
    if (res.isValue) {
      JathakamModel model = res.asValue!.value;
      updateJathakamModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateJathakamModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateJathakamModel(val) {
    jathakamModel = val;
    jathakamDataList = jathakamModel?.jathakamData ?? [];
    notifyListeners();
  }

  void assignTempToJathakam() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedJathakam: {...tempSelectedJathakam});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempJathakam() {
    tempSelectedJathakam = searchFilterValueModel?.selectedJathakam ?? {};
    notifyListeners();
  }

  void clearJathakamTypeData() {
    tempSelectedJathakam = {};
    notifyListeners();
  }

  void clearFilterEduCategoryData() {
    tempSelectedFilterEducation = {};
    tempSelectedFilterEduCategories = [];
    notifyListeners();
  }

  void clearFilterJobParentCategoryData() {
    tempSelectedFilterJobParents = {};
    tempSelectedFilterJobParentCategories = [];
    notifyListeners();
  }

  void updateSelectedEducation(int? id, String? name,
      {bool isRemoveSelected = true, bool isRemoveAllSelected = false}) {
    if (id != null) {
      if (tempSelectedEducationalValues.containsKey(id)) {
        tempSelectedEducationalValues.remove(id);
      } else {
        tempSelectedEducationalValues[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void updateAllSelectedEducation(
    List<ChildEducationCategory>? childEducationCategory,
  ) {
    if ((childEducationCategory ?? []).isNotEmpty) {
      for (int i = 0; i < childEducationCategory!.length; i++) {
        if (isRemoveAllSelected) {
          tempSelectedEducationalValues.remove(childEducationCategory[i].id);
        } else {
          if (childEducationCategory[i].id != null) {
            tempSelectedEducationalValues[(childEducationCategory[i].id!)] =
                childEducationCategory[i].eduCategoryTitle ?? '';
          }
        }
      }
    }
    notifyListeners();
  }

  void updateSelectedJobParent(
    int? id,
    String? name,
  ) {
    if (id != null) {
      if (tempSelectedParentJobValues.containsKey(id)) {
        tempSelectedParentJobValues.remove(id);
      } else {
        tempSelectedParentJobValues[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void updateAllSelectedJobParent(List<ChildJobCategory>? childJobCategory) {
    if ((childJobCategory ?? []).isNotEmpty) {
      for (int i = 0; i < childJobCategory!.length; i++) {
        if (isRemoveAllSelectedJob) {
          tempSelectedEducationalValues.remove(childJobCategory[i].id);
        } else {
          if (childJobCategory[i].id != null) {
            tempSelectedEducationalValues[(childJobCategory[i].id!)] =
                childJobCategory[i].subcategoryName ?? '';
          }
        }
      }
    }
    notifyListeners();
  }

  clearTempSelectedEducation() {
    tempSelectedFilterEducation = {};
    tempSelectedFilterEduCategories = [];
    notifyListeners();
  }

  Future<void> updateSelectedFilterEduCatData(
      {required int? parentId,
      required int? childId,
      required String title,
      bool isRemoveSelected = true,
      bool isRemoveAllSelected = false}) async {
    if (parentId != null && childId != null) {
      if (tempSelectedFilterEducation.containsKey(parentId)) {
        List<int> idList = [...tempSelectedFilterEducation[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            tempSelectedFilterEducation.remove(parentId);
            tempSelectedFilterEduCategories.remove(title);
          } else {
            if (isRemoveSelected) {
              idList.remove(childId);
              tempSelectedFilterEducation[parentId] = idList;
              tempSelectedFilterEduCategories.remove(title);
            }
          }
        } else {
          idList.add(childId);
          tempSelectedFilterEducation[parentId] = idList;
          tempSelectedFilterEduCategories.add(title);
        }
      } else {
        tempSelectedFilterEducation[parentId] = [childId];
        tempSelectedFilterEduCategories.add(title);
      }

      notifyListeners();
    }
  }

  Future<void> updateAllSelectedFilterEduCatData({
    required int? parentId,
    List<ChildEducationCategory>? childEducationCategory,
    bool isRemoveSelected = true,
  }) async {
    if ((childEducationCategory ?? []).isNotEmpty) {
      for (int i = 0; i < childEducationCategory!.length; i++) {
        List<int> idList = [...tempSelectedFilterEducation[parentId] ?? []];
        if (!isRemoveAllSelected) {
          idList.add(childEducationCategory[i].id ?? 0);
          tempSelectedFilterEducation[parentId!] = idList;
          tempSelectedFilterEduCategories
              .add(childEducationCategory[i].eduCategoryTitle ?? '');
          debugPrint(tempSelectedFilterEducation.toString());
        } else {
          tempSelectedFilterEducation.remove(parentId);
          idList = [];
          tempSelectedFilterEduCategories
              .remove(childEducationCategory[i].eduCategoryTitle ?? '');
          debugPrint(tempSelectedFilterEducation.toString());
        }
      }
    }

    notifyListeners();
  }

  Future<void> updateSelectedFilterJobParentData(
      {required int? parentId,
      required int? childId,
      required String title}) async {
    if (parentId != null && childId != null) {
      if (tempSelectedFilterJobParents.containsKey(parentId)) {
        List<int> idList = [...tempSelectedFilterJobParents[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            tempSelectedFilterJobParents.remove(parentId);
            tempSelectedFilterJobParentCategories.remove(title);
          } else {
            idList.remove(childId);
            tempSelectedFilterJobParents[parentId] = idList;
            tempSelectedFilterJobParentCategories.remove(title);
          }
        } else {
          idList.add(childId);
          tempSelectedFilterJobParents[parentId] = idList;
          tempSelectedFilterJobParentCategories.add(title);
        }
      } else {
        tempSelectedFilterJobParents[parentId] = [childId];
        tempSelectedFilterJobParentCategories.add(title);
      }

      notifyListeners();
    }
  }

  Future<void> updateAllSelectedFilterJobParentData(
      {required int? parentId,
      List<ChildJobCategory>? childJobCategory}) async {
    if ((childJobCategory ?? []).isNotEmpty) {
      for (int i = 0; i < childJobCategory!.length; i++) {
        List<int> idList = [...tempSelectedFilterJobParents[parentId] ?? []];
        if (!isRemoveAllSelectedJob) {
          idList.add(childJobCategory[i].id ?? 0);
          tempSelectedFilterJobParents[parentId!] = idList;
          tempSelectedFilterJobParentCategories
              .add(childJobCategory[i].subcategoryName ?? '');
          debugPrint(tempSelectedFilterJobParents.toString());
        } else {
          tempSelectedFilterJobParents.remove(parentId);
          idList = [];
          tempSelectedFilterJobParentCategories
              .remove(childJobCategory[i].subcategoryName ?? '');
          debugPrint(tempSelectedFilterEducation.toString());
        }
      }
    }

    notifyListeners();
  }

  void assignTempToSelectedFilterEduCatDat() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(
        selectedEducation: {...tempSelectedFilterEducation},
        selectedEduCategories: [...tempSelectedFilterEduCategories]);
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void assignTempToSelectedFilterJobParentCatDat() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(
        selectedJobParent: {
          ...tempSelectedFilterJobParents
        },
        selectedOccupationCategories: [
          ...tempSelectedFilterJobParentCategories
        ]);
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempEduCatFilterData() {
    tempSelectedFilterEducation =
        searchFilterValueModel?.selectedEducation ?? {};
    tempSelectedFilterEduCategories =
        searchFilterValueModel?.selectedEduCategories ?? [];
    notifyListeners();
  }

  void reAssignTempJobParentFilterData() {
    tempSelectedFilterJobParents =
        searchFilterValueModel?.selectedJobParent ?? {};
    tempSelectedFilterJobParentCategories =
        searchFilterValueModel?.selectedOccupationCategories ?? [];
    notifyListeners();
  }

  void searchEduByQuery(String val) {
    if ((educationCategoryModel?.data ?? []).isNotEmpty && val.isNotEmpty) {
      List<EducationCategoryData> model =
          educationCategoryModel!.data!.where((EducationCategoryData? element) {
        bool isContain = (element?.parentEducationCategory ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      eduCatDataList = model;
    } else {
      eduCatDataList = educationCategoryModel?.data ?? [];
    }
    notifyListeners();
  }

  Future<void> fetchFromAppData(BuildContext context) async {
    final model = context.read<AppDataProvider>();
    if (model.educationCategoryModel != null) {
      updateEduCatModel(model.educationCategoryModel);
    } else {
      model.getEduCatListData().then((value) => updateEduCatModel(value));
    }
    if (model.jobCategoryModel != null) {
      updateParentJobModel(model.jobCategoryModel);
    } else {
      model.getJobParentListData().then((value) => updateParentJobModel(value));
    }
  }

  void updateEduCatModel(val) {
    educationCategoryModel = val;
    eduCatDataList = educationCategoryModel?.data ?? [];
    notifyListeners();
  }

  void updateParentJobModel(val) {
    parentJobCategoryModel = val;
    jobCatDataList = parentJobCategoryModel?.data ?? [];
    notifyListeners();
  }

  void updateSelectedOccupationFilterData(
      {required int? id, required String jobData}) {
    if (id != null) {
      if (tempSelectedFilterOccupations.containsKey(id)) {
        tempSelectedFilterOccupations.remove(id);
        notifyListeners();
      } else {
        tempSelectedFilterOccupations[id] = jobData;
        tempSelectedFilterOccupations = {...tempSelectedFilterOccupations};
        notifyListeners();
      }
    }
  }

  void clearOccupationFilterData() {
    tempSelectedFilterOccupations = {};
    tempSelectedFilterJobParents = {};
    tempSelectedFilterOccupationCategories = [];
    tempSelectedFilterJobParentCategories = [];
    notifyListeners();
  }

  void assignTempToSelectedOccupationFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedOccupation: {...tempSelectedFilterOccupations});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempOccupationFilterData() {
    tempSelectedFilterOccupations =
        searchFilterValueModel?.selectedOccupation ?? {};
    tempSelectedFilterOccupationCategories =
        searchFilterValueModel?.selectedOccupationCategories ?? [];
    notifyListeners();
  }

  clearProfessionalPreference() {
    clearTempSelectedEducation();
    clearOccupationFilterData();
  }

  void searchOccupationByQuery(String val) {
    if ((jobDataModel?.jobData ?? []).isNotEmpty && val.isNotEmpty) {
      List<JobData> model = jobDataModel!.jobData!.where((JobData? element) {
        bool isContain = (element?.parentJobCategory ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      jobDataList = model;
    } else {
      jobDataList = jobDataModel?.jobData ?? [];
    }
    notifyListeners();
  }

  void updateOccupationModel(val) {
    jobDataModel = val;
    jobDataList = jobDataModel?.jobData ?? [];
    notifyListeners();
  }

  void updateReligionData(val, {bool isFromSearch = true}) {
    if (isFromSearch) {
      searchValueModel ??= SearchValueModel();
      SearchValueModel temp = searchValueModel!.copyWith(religionListData: val);
      searchValueModel = temp;
    } else {
      searchFilterValueModel ??= SearchValueModel();
      SearchValueModel temp =
          searchFilterValueModel!.copyWith(religionListData: val);
      searchFilterValueModel = temp;
    }
    notifyListeners();
  }

  void clearCasteTempFilterData() {
    tempSelectedFilterCaste = {};
    notifyListeners();
  }

  void clearCasteFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(selectedCaste: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void clearJathakamFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchFilterValueModel!.copyWith(selectedJathakam: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  Future<void> getCasteDataList({bool isFromSearch = true}) async {
    // updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getCasteDataList(isFromSearch
        ? searchValueModel?.religionListData?.id ?? -1
        : searchFilterValueModel?.religionListData?.id ?? -1);
    if (res.isValue) {
      CasteListModel model = res.asValue!.value;
      updateCastListModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateCastListModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateCastListModel(val) {
    casteListModel = val;
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void updateSelectedFilterCaste(int? id, String? name) {
    if (id != null) {
      if (tempSelectedFilterCaste.containsKey(id)) {
        tempSelectedFilterCaste.remove(id);
      } else {
        tempSelectedFilterCaste[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void assignTempToSelectedFilterCaste() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedCaste: {...tempSelectedFilterCaste});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempFilterCasteData() {
    tempSelectedFilterCaste = searchFilterValueModel?.selectedCaste ?? {};
    notifyListeners();
  }

  clearReligiousPreference() {
    clearCasteTempFilterData();
    clearJathakamFilterData();
  }

  void searchCasteByQuery(String val) {
    if ((casteListModel?.data?.castes ?? []).isNotEmpty && val.isNotEmpty) {
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

  void sendBasicInfoRequest(BuildContext context) {
    // BasicInfoRequest basicInfoRequest = BasicInfoRequest(
    //     profileId: profile?.id?.toString() ?? '',
    //     height: heightData?.id?.toString() ?? '',
    //     maritalStatus: maritalStatus?.id?.toString() ?? '',
    //     createdBy: profileCreated ?? '');
    // context.read<ProfileProvider>().updateBasicInfo(basicInfoRequest, context,
    //     onSuccess: () async {
    //   await clearData();
    //   await fetchProfile(context);
    //   Helpers.successToast(context.loc.updatedSuccessFully);
    //   Navigator.of(context).pop();
    // });
  }

  Future<void> updateSelectedCountry(CountryData? val,
      {bool isFromSearch = true}) async {
    if (isFromSearch) {
      searchValueModel ??= SearchValueModel();
      SearchValueModel temp = searchValueModel!.copyWith(countryData: val);
      searchValueModel = temp;
    } else {
      searchFilterValueModel ??= SearchValueModel();
      SearchValueModel temp =
          searchFilterValueModel!.copyWith(countryData: val);
      searchFilterValueModel = temp;
    }
    countryId = val?.id;
    notifyListeners();
  }

  void clearDistrictFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchFilterValueModel!.copyWith(selectedDistrict: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  // void updateSelectedDistrictFilterData(
  //     {required int? id, required DistrictData? districtData}) {
  //   if (id != null) {
  //     if (tempSelectedFilterDistricts.containsKey(id)) {
  //       tempSelectedFilterDistricts.remove(id);
  //       notifyListeners();
  //     } else {
  //       tempSelectedFilterDistricts[id] = districtData;
  //       tempSelectedFilterDistricts = {...tempSelectedFilterDistricts};
  //       notifyListeners();
  //     }
  //   }
  // }

  void clearDistrictTempFilterData() {
    tempSelectedFilterDistricts = {};
    notifyListeners();
  }

  void clearStateTempFilterData() {
    tempSelectedState = {};
    notifyListeners();
  }

  void clearLocationTempFilterData() {
    tempSelectedFilterLocation = {};
    notifyListeners();
  }

  clearLocationPreference() {
    clearDistrictTempFilterData();
    clearStateTempFilterData();
    clearLocationTempFilterData();
  }

  // void assignTempToSelectedDistrictFilterData() {
  //   searchFilterValueModel ??= SearchValueModel();
  //   SearchValueModel temp = searchFilterValueModel!
  //       .copyWith(selectedDistricts: {...tempSelectedFilterDistricts});
  //   searchFilterValueModel = temp;
  //   notifyListeners();
  // }

  // void reAssignTempDistrictFilterData() {
  //   tempSelectedFilterDistricts =
  //       searchFilterValueModel?.selectedDistricts ?? {};
  //   notifyListeners();
  // }

  void searchDistrictByQuery(String val) {
    if ((districtDataModel?.districtData ?? []).isNotEmpty && val.isNotEmpty) {
      List<DistrictData> model =
          districtDataModel!.districtData!.where((DistrictData? element) {
        bool isContain = (element?.districtName ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      districtDataList = model;
    } else {
      districtDataList = districtDataModel?.districtData ?? [];
    }
    notifyListeners();
  }

  void updateCityDataModel(val) {
    cityDataModel = val;
    notifyListeners();
  }

  Future<void> updateCity(int districtId, BuildContext context,
      {Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.getCityDataList(districtId);
    if (res.isValue) {
      CityDataModel model = res.asValue!.value;
      updateCityDataModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateCityData(CityData? cityDatas) {
    if (cityDatas != null) cityData = cityDatas;
    notifyListeners();
  }

  void updateDistrictModel(DistrictDataModel? val) {
    districtDataModel = val;
    districtDataList = districtDataModel?.districtData ?? [];
    notifyListeners();
  }

  int getHeightFromId(int id) {
    int val = 0;
    HeightData? heightData;
    try {
      heightData = heightDataModel?.heightData?[id - 1];
    } catch (_) {
      val = 0;
    }
    val = heightData?.heightValue ?? 0;
    return val;
  }

  void updateSelectedHeight(double from, double to) {
    selectedFromHeight = from;
    selectedToHeight = to;
    notifyListeners();
  }

  void updateSelectedAge(double from, double to) {
    selectedFromAge = from;
    selectedToAge = to;
    notifyListeners();
  }

  Future<void> setBasicPreferenceParam(BuildContext context) async {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    String userID = context
            .read<AppDataProvider>()
            .basicDetailModel
            ?.basicDetail
            ?.id
            ?.toString() ??
        "";
    params['profile_id'] = userID;
    if (selectedFromHeight != null && selectedFromHeight != 0) {
      params['prefer_height_from'] =
          Helpers.convertToInt(selectedFromHeight?.ceil());
      params['prefer_hight_to'] =
          Helpers.convertToInt(selectedToHeight?.ceil());
    }
    if ((selectedFromAge?.floor() ?? 0) != 0 &&
        (selectedToAge?.floor() ?? 0) != 0) {
      params['prefer_age_from'] = selectedFromAge?.floor();
      params['prefer_age_to'] = selectedToAge?.floor();
    }
    params['prefer_martial_status'] = [];
    params['prefer_body_type'] = [];
    params['prefer_complexion'] = [];
    if (searchFilterValueModel != null) {
      if (searchFilterValueModel!.getSelectedMaritalStatus.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedMaritalStatus.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_martial_status'] = stringList;
      }

      if (selectedFromHeight != null && selectedFromHeight != 0) {
        params['prefer_height_from'] =
            Helpers.convertToInt(selectedFromHeight?.ceil() ?? 0);
        params['prefer_hight_to'] =
            Helpers.convertToInt(selectedToHeight?.ceil() ?? 0);
      }
      if ((selectedFromAge?.floor() ?? 0) != 0 ||
          (selectedToAge?.floor() ?? 0) != 0) {
        params['prefer_age_from'] = selectedFromAge?.floor();
        params['prefer_age_to'] = selectedToAge?.floor();
      }
      if (searchFilterValueModel!.getSelectedBodyType.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedBodyType.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_body_type'] = stringList;
      }
      if (searchFilterValueModel!.getSelectedComplexion.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedComplexion.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_complexion'] = stringList;
      }
    }
    searchFilterParam = params;
    notifyListeners();
  }

  saveBasicPreference(BuildContext context) async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.saveBasicPreferences(searchFilterParam);
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      Helpers.successToast('Updated successfully');
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        btnLoader = false;
        updateLoaderState(LoaderState.loaded);
        Helpers.successToast(
            responseModel.errors?.nestId ?? context.loc.anErrorOccurred);
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        Helpers.successToast(context.loc.somethingWentWrong);
        btnLoader = false;
        notifyListeners();
      }
    }
  }

  Future<void> setReligiousPreferenceParam(BuildContext context) async {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    String userID = context
            .read<AppDataProvider>()
            .basicDetailModel
            ?.basicDetail
            ?.id
            ?.toString() ??
        "";
    params['profile_id'] = userID;
    params['prefer_jathakam_type'] = [];
    params['prefercaste'] = [];

    if (searchFilterValueModel != null) {
      if (searchFilterValueModel?.religionListData?.id != null) {
        params['prefer_religion'] =
            searchFilterValueModel?.religionListData?.id;
      }
      if (searchFilterValueModel!.getSelectedCaste.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedCaste.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefercaste'] = stringList;
      }

      if (searchFilterValueModel!.getSelectedJathakam.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedJathakam.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_jathakam_type'] = stringList;
      }
      params['prefer_sub_caste'] = subCasteController.text;
    }
    searchFilterParam = params;
    notifyListeners();
  }

  saveReligiousPreference(BuildContext context) async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.saveReligionPreference(searchFilterParam);
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      Helpers.successToast('Updated successfully');
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        btnLoader = false;
        updateLoaderState(LoaderState.loaded);
        Helpers.successToast(
            responseModel.errors?.nestId ?? context.loc.anErrorOccurred);
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        Helpers.successToast(context.loc.somethingWentWrong);
        btnLoader = false;
        notifyListeners();
      }
    }
  }

  Future<void> setLocationPreferenceParam(BuildContext context) async {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    String userID = context
            .read<AppDataProvider>()
            .basicDetailModel
            ?.basicDetail
            ?.id
            ?.toString() ??
        "";
    params['profile_id'] = userID;
    if (searchFilterValueModel != null) {
      if (searchFilterValueModel?.countryData?.id != null) {
        params['prefer_country'] = searchFilterValueModel?.countryData?.id;
      }
      if (searchFilterValueModel!.getSelectedState.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedState.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_state'] = stringList;
      }

      if (searchFilterValueModel!.getSelectedDistrict.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedDistrict.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_district'] = stringList;
      }
      if (searchFilterValueModel!.getSelectedCity.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedCity.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_location'] = stringList;
      }
    }
    searchFilterParam = params;
    notifyListeners();
  }

  Future<void> saveLocationPreference(BuildContext context) async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.saveLocationPreference(searchFilterParam);
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      Helpers.successToast('Updated successfully');
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        btnLoader = false;
        updateLoaderState(LoaderState.loaded);
        Helpers.successToast(
            responseModel.errors?.nestId ?? context.loc.anErrorOccurred);
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        Helpers.successToast(context.loc.somethingWentWrong);
        btnLoader = false;
        notifyListeners();
      }
    }
  }

  Future<void> setProfessionalPreferenceParam(BuildContext context) async {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    String userID = context
            .read<AppDataProvider>()
            .basicDetailModel
            ?.basicDetail
            ?.id
            ?.toString() ??
        "";
    params['profile_id'] = userID;
    params['prefer_education'] = [];
    params['prefer_job'] = [];
    params['prefer_education_info'] = educationDetailController.text;
    params['prefer_job_info'] = jobDetailController.text;
    if (searchFilterValueModel != null) {
      if (searchFilterValueModel!.getSelectedEducation.isNotEmpty) {
        List<int> idList = [];
        searchFilterValueModel!.getSelectedEducation.forEach((key, value) {
          for (int i = 0; i < value.length; i++) {
            idList.add(value[i]);
          }
        });

        // List<int> idList =
        //     searchFilterValueModel!.getSelectedEducation.keys.toList();
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_education'] = stringList;
      }

      if (searchFilterValueModel!.getSelectedJobParent.isNotEmpty) {
        List<int> idList = [];
        searchFilterValueModel!.getSelectedJobParent.forEach((key, value) {
          for (int i = 0; i < value.length; i++) {
            idList.add(value[i]);
          }
        });
        List<String> stringList = [];
        for (int i = 0; i < idList.length; i++) {
          stringList.add(idList[i].toString());
        }
        params['prefer_job'] = stringList;
      }
    }
    searchFilterParam = params;
    notifyListeners();
  }

  saveProfessionalPreference(BuildContext context) async {
    updateLoaderState(LoaderState.loading);
    Result res =
        await serviceConfig.saveProfessionalPreference(searchFilterParam);
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      Helpers.successToast('Updated successfully');
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        btnLoader = false;
        updateLoaderState(LoaderState.loaded);
        Helpers.successToast(
            responseModel.errors?.nestId ?? context.loc.anErrorOccurred);
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        Helpers.successToast(context.loc.somethingWentWrong);
        btnLoader = false;
        notifyListeners();
      }
    }
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
