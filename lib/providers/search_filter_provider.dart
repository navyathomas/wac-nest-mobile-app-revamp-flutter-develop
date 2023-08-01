import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/job_child_categories_model.dart';
import 'package:nest_matrimony/models/job_data_model.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/models/matching_stars_model.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/models/search_value_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/hive_services.dart';
import 'package:nest_matrimony/services/http_requests.dart';
import 'package:provider/provider.dart';

import '../models/age_data_list_model.dart';
import '../models/caste_list_model.dart';
import '../models/education_cat_model.dart';
import '../models/height_data_model.dart';
import '../models/partner_preference_model.dart';

class SearchFilterProvider extends ChangeNotifier with BaseProviderClass {
  final DateTime _currentDate = DateTime.now();
  bool enableGridView = false;
  bool moreFilterEnabled = false;
  List<UserData> userDataList = [];
  int recordsFiltered = 0;
  List<dynamic> recentlySearchedList = [];
  int length = 20;
  int pageCount = 1;
  String? query;
  int totalPageLength = 0;
  bool paginationLoader = false;
  int selectedSortId = 1;
  bool? isProfileMale;
  bool addEduDataAlertVisibility = true;
  SearchValueModel? searchValueModel;

  CasteListModel? casteListModel;
  List<CasteData>? casteDataList;
  Map<int, String> tempSelectedCaste = {};

  HeightDataModel? heightDataModel;
  double minHeightRange = 1;
  double maxHeightRange = 200;
  double minHeight = 1;
  double maxHeight = 200;
  double? selectedFromHeight;
  double? selectedToHeight;

  AgeDataListModel? ageDataListModel;
  double minAgeRange = 18;
  double maxAgeRange = 70;
  double minAge = 18;
  double maxAge = 70;
  double? selectedFromAge;
  double? selectedToAge;

  EducationCategoryModel? educationCategoryModel;
  List<EducationCategoryData>? eduCatDataList;
  Map<int, List<int>> tempSelectedEducation = {};
  List<String> tempSelectedEduCategories = [];

  ///For Job ParentChildCategory...
  JobChildCategoryListModel? jobCategoryModel;
  List<JobDataCategoryModel>? jobChildCategoryList;
  Map<int, List<int>> tempSelectedJobCategory = {};
  List<String> tempSelectedJobCategories = [];

  JobDataModel? jobDataModel;
  List<JobData>? jobDataList;
  Map<int, JobData?> tempSelectedOccupations = {};

  DistrictDataModel? districtDataModel;
  List<DistrictData>? districtDataList;
  Map<int, DistrictData?> tempSelectedDistricts = {};

  int profileCreatedIndex = 3;

  int selectedProfileCreatedIndex = -1;

  SearchValueModel? searchFilterValueModel;
  SearchValueModel? searchFilterTempValueModel;
  Map<int, String> tempSelectedFilterCaste = {};
  Map<int, List<int>> tempSelectedFilterEducation = {};
  List<String> tempSelectedFilterEduCategories = [];
  Map<int, JobData?> tempSelectedFilterOccupations = {};
  Map<int, DistrictData?> tempSelectedFilterDistricts = {};

  MatchingStarsModel? matchingStarsModel;
  List<MatchingStarsData>? matchingStarsList;
  Map<int, MatchingStarsData?> tempSelectedMatchingStars = {};
  LoaderState matchingStarsLoader = LoaderState.loaded;

  Map<String, dynamic> searchParam = {};
  Map<String, dynamic> searchFilterParam = {};
  Map<String, dynamic> searchReqParam = {};

  List<String> createdOnOptions(BuildContext context) => [
        context.loc.monthsAgo(1),
        context.loc.monthsAgo(3),
        context.loc.monthsAgo(6),
        context.loc.anyTime
      ];

  List<String> profileCreatedOptions(BuildContext context) => [
        context.loc.mySelf,
        context.loc.relative,
        context.loc.friend,
        context.loc.son,
        context.loc.daughter,
        context.loc.brother,
        context.loc.sister
      ];

  /// Caste Data ------------------------------------------------------------

  Future<void> getCasteDataList({bool isFromSearch = true}) async {
    int id = isFromSearch
        ? searchValueModel?.religionListData?.id ?? -1
        : searchFilterValueModel?.religionListData?.id ?? -1;
    if (id == -1) return;
    updateLoaderState(LoaderState.loading);
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

  void updateCastListModel(val) {
    casteListModel = val;
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void reAssignCastListModel() {
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void reAssignTempCasteData() {
    tempSelectedCaste = searchValueModel?.selectedCaste ?? {};
    getCasteDataList();
    notifyListeners();
  }

  void assignTempToSelectedCaste() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchValueModel!.copyWith(selectedCaste: {...tempSelectedCaste});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateSelectedCaste(int? id, String? name) {
    Map temp = {...tempSelectedCaste};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = name ?? '';
      }
    }
    tempSelectedCaste = {...temp};
    notifyListeners();
  }

  void clearCasteTempData() {
    tempSelectedCaste = {};
    notifyListeners();
  }

  void clearCasteData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(selectedCaste: {});
    searchValueModel = temp;
    notifyListeners();
  }

  ///Filter Section

  void reAssignTempFilterCasteData() {
    tempSelectedFilterCaste = {...?searchFilterValueModel?.selectedCaste};
    getCasteDataList(isFromSearch: false);
    notifyListeners();
  }

  void assignTempToSelectedFilterCaste() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedCaste: {...tempSelectedFilterCaste});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void updateSelectedFilterCaste(int? id, String? name) {
    Map temp = {...tempSelectedFilterCaste};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = name ?? '';
      }
      tempSelectedFilterCaste = {...temp};
      notifyListeners();
    }
  }

  void clearQuery() {
    query = '';
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

  /// -----------------------------------------------------------------------

  /// Education cat List Data------------------------------------------------

  void updateEduCatModel(val) {
    educationCategoryModel = val;
    eduCatDataList = educationCategoryModel?.data ?? [];
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

  void reAssignTempEduCatData() {
    tempSelectedEducation = {...?searchValueModel?.selectedEducation};
    tempSelectedEduCategories = [...?searchValueModel?.selectedEduCategories];
    notifyListeners();
  }

  void assignTempToSelectedEduCatDat() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(
        selectedEduCategories: [...tempSelectedEduCategories],
        selectedEducation: {...tempSelectedEducation});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateSelectedEduCatData(
      {required int? parentId, required int? childId, required String title}) {
    Map<int, List<int>> temp = {...tempSelectedEducation};
    if (parentId != null && childId != null) {
      if (temp.containsKey(parentId)) {
        List<int> idList = [...temp[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            temp.remove(parentId);
            tempSelectedEduCategories.remove(title);
          } else {
            idList.remove(childId);
            temp[parentId] = idList;
            tempSelectedEduCategories.remove(title);
          }
        } else {
          idList.add(childId);
          temp[parentId] = idList;
          tempSelectedEduCategories.add(title);
        }
      } else {
        temp[parentId] = [childId];
        tempSelectedEduCategories.add(title);
      }
      tempSelectedEducation = {...temp};
      notifyListeners();
    }
  }

  void clearEduCategoryData() {
    tempSelectedEducation = {};
    tempSelectedEduCategories = [];
    notifyListeners();
  }

  /// Job Child parent category List Data------------------------------------------------

  void updateParentChildCatModel(val) {
    jobCategoryModel = val;
    jobChildCategoryList = jobCategoryModel?.data ?? [];
    notifyListeners();
  }

  void searchParentChildByQuery(String val) {
    if ((jobCategoryModel?.data ?? []).isNotEmpty && val.isNotEmpty) {
      List<JobDataCategoryModel> model =
          jobCategoryModel!.data!.where((JobDataCategoryModel? element) {
        bool isContain = (element?.parentJobCategory ?? '')
            .toLowerCase()
            .contains(val.toLowerCase());
        return isContain;
      }).toList();
      jobChildCategoryList = model;
    } else {
      jobChildCategoryList = jobCategoryModel?.data ?? [];
    }
    notifyListeners();
  }

  void reAssignTempJobCatData() {
    tempSelectedJobCategory = searchValueModel?.selectedParentChildJob ?? {};
    tempSelectedJobCategories =
        searchValueModel?.selectedParentChildCategories ?? [];
    notifyListeners();
  }

  void assignTempToSelectedParentChildCatDat() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(
        selectedParentChildCategories: [...tempSelectedJobCategories],
        selectedParentChildJob: {...tempSelectedJobCategory});
    searchValueModel = temp;
    notifyListeners();
  }

  void clearParentChildJobCategoryData() {
    tempSelectedJobCategory = {};
    tempSelectedJobCategories = [];
    notifyListeners();
  }

  ///Filter section

  void reAssignTempEduCatFilterData() {
    tempSelectedFilterEducation =
        searchFilterValueModel?.selectedEducation ?? {};
    tempSelectedFilterEduCategories =
        searchFilterValueModel?.selectedEduCategories ?? [];
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

  void updateSelectedFilterEduCatData(
      {required int? parentId, required int? childId, required String title}) {
    Map<int, List<int>> temp = {...tempSelectedFilterEducation};
    if (parentId != null && childId != null) {
      if (temp.containsKey(parentId)) {
        List<int> idList = [...temp[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            temp.remove(parentId);
            tempSelectedFilterEduCategories.remove(title);
          } else {
            idList.remove(childId);
            temp[parentId] = idList;
            tempSelectedFilterEduCategories.remove(title);
          }
        } else {
          idList.add(childId);
          temp[parentId] = idList;
          tempSelectedFilterEduCategories.add(title);
        }
      } else {
        temp[parentId] = [childId];
        tempSelectedFilterEduCategories.add(title);
      }
      tempSelectedFilterEducation = {...temp};
      notifyListeners();
    }
  }

  void clearFilterEduCategoryData() {
    tempSelectedFilterEducation = {};
    tempSelectedFilterEduCategories = [];
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// Occupation List Data------------------------------------------------

  void updateOccupationModel(val) {
    jobDataModel = val;
    jobDataList = jobDataModel?.jobData ?? [];
    notifyListeners();
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

  void reAssignTempOccupationData() {
    tempSelectedOccupations = searchValueModel?.selectedOccupations ?? {};
    notifyListeners();
  }

  void assignTempToSelectedOccupationData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!
        .copyWith(selectedOccupations: {...tempSelectedOccupations});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateSelectedOccupationData(
      {required int? id, required JobData? jobData}) {
    Map temp = {...tempSelectedOccupations};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = jobData;
      }
      tempSelectedOccupations = {...temp};
      notifyListeners();
    }
  }

  void clearOccupationData() {
    tempSelectedOccupations = {};
    notifyListeners();
  }

  ///Filter section

  void reAssignTempOccupationFilterData() {
    tempSelectedFilterOccupations =
        searchFilterValueModel?.selectedOccupations ?? {};
    notifyListeners();
  }

  void assignTempToSelectedOccupationFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedOccupations: {...tempSelectedFilterOccupations});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void updateSelectedOccupationFilterData(
      {required int? id, required JobData? jobData}) {
    Map temp = {...tempSelectedFilterOccupations};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = jobData;
      }
      tempSelectedFilterOccupations = {...temp};
      notifyListeners();
    }
  }

  void clearOccupationFilterData() {
    tempSelectedFilterOccupations = {};
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// Height List Data--------------------------------------------------------

  Future<void> updateHeightData(val) async {
    heightDataModel = val;
    if ((heightDataModel?.heightData ?? []).length >= 2) {
      minHeightRange =
          Helpers.convertToDouble(heightDataModel?.heightData?.first.id ?? 1);
      maxHeightRange =
          Helpers.convertToDouble(heightDataModel?.heightData?.last.id ?? 1);
      minHeight = (minHeightRange + 5) < maxHeightRange
          ? (minHeightRange + 5)
          : minHeightRange;
      maxHeight = (maxHeightRange - 10) > minHeight
          ? (maxHeightRange - 10)
          : maxHeightRange;
    }
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

  String getCmInFeet(int id) {
    int valInCm = getHeightFromId(id);
    double length = valInCm / 2.54;
    int feet = (length / 12).floor();
    double inch = length - (12 * feet);
    return "$feet'${inch.floor()}";
  }

  void updateSelectedHeight(double from, double to) {
    selectedFromHeight = from;
    selectedToHeight = to;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// Age List Data--------------------------------------------------------

  Future<void> updateAgeModelData(val) async {
    ageDataListModel = val;
    int minimumAge = searchValueModel?.selectedGender == Gender.male
        ? (ageDataListModel?.data?.minimumGenderAge?.male ?? 21)
        : (ageDataListModel?.data?.minimumGenderAge?.female ?? 18);
    minAgeRange = Helpers.convertToDouble(minimumAge);
    if ((ageDataListModel?.data?.ageList ?? []).length >= 2) {
      maxAgeRange = Helpers.convertToDouble(
          ageDataListModel?.data?.ageList?.last.id ?? 1);
      minAge =
          (minAgeRange + 5) < maxAgeRange ? (minAgeRange + 5) : minAgeRange;
      maxAge = (maxAgeRange - 10) > minAge ? (maxAgeRange - 10) : maxAgeRange;
    }
    notifyListeners();
  }

  void updateSelectedAge(double from, double to) {
    selectedFromAge = from;
    selectedToAge = to;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// District data ---------------------------------------------------------

  void updateDistrictModel(DistrictDataModel? val) {
    districtDataModel = val;
    districtDataList = districtDataModel?.districtData ?? [];
    notifyListeners();
  }

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

  void reAssignTempDistrictData() {
    tempSelectedDistricts = searchValueModel?.selectedDistricts ?? {};
    notifyListeners();
  }

  void assignTempToSelectedDistrictData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!
        .copyWith(selectedDistricts: {...tempSelectedDistricts});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateSelectedDistrictData(
      {required int? id, required DistrictData? districtData}) {
    Map temp = {...tempSelectedDistricts};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = districtData;
      }
      tempSelectedDistricts = {...temp};
      notifyListeners();
    }
  }

  void clearDistrictTempData() {
    tempSelectedDistricts = {};
    notifyListeners();
  }

  void clearDistrictData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(selectedDistricts: {});
    searchValueModel = temp;
    notifyListeners();
  }

  ///Filter section

  void reAssignTempDistrictFilterData() {
    tempSelectedFilterDistricts =
        searchFilterValueModel?.selectedDistricts ?? {};
    notifyListeners();
  }

  void assignTempToSelectedDistrictFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedDistricts: {...tempSelectedFilterDistricts});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void updateSelectedDistrictFilterData(
      {required int? id, required DistrictData? districtData}) {
    Map temp = {...tempSelectedFilterDistricts};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = districtData;
      }
      tempSelectedFilterDistricts = {...temp};
      notifyListeners();
    }
  }

  void clearDistrictTempFilterData() {
    tempSelectedFilterDistricts = {};
    notifyListeners();
  }

  void clearDistrictFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchFilterValueModel!.copyWith(selectedDistricts: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// Matching stars data ---------------------------------------------------------

  Future<void> getMatchingStarsData() async {
    updateMatchingStarsLoader(LoaderState.loading);
    Result res = await serviceConfig.getMatchingStarsData();
    if (res.isValue) {
      MatchingStarsModel model = res.asValue!.value;
      updateMatchingStarsModel(model);
      updateMatchingStarsLoader(LoaderState.loaded);
    } else {
      updateMatchingStarsLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateMatchingStarsModel(MatchingStarsModel? val) {
    matchingStarsModel = val;
    matchingStarsList = matchingStarsModel?.data ?? [];
    notifyListeners();
  }

  void searchMatchingStarByQuery(String val) {
    if ((matchingStarsModel?.data ?? []).isNotEmpty && val.isNotEmpty) {
      List<MatchingStarsData> model =
          matchingStarsModel!.data!.where((MatchingStarsData? element) {
        bool isContain =
            (element?.starName ?? '').toLowerCase().contains(val.toLowerCase());
        return isContain;
      }).toList();
      matchingStarsList = model;
    } else {
      matchingStarsList = matchingStarsModel?.data ?? [];
    }
    notifyListeners();
  }

  void reAssignTempMatchingStarData() {
    tempSelectedMatchingStars = searchValueModel?.selectedMatchingStars ?? {};
    notifyListeners();
  }

  void assignTempToSelectedMatchingStarData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!
        .copyWith(selectedMatchingStars: {...tempSelectedMatchingStars});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateSelectedMatchingStarData(
      {required int? id, required MatchingStarsData? matchingStarsData}) {
    Map temp = {...tempSelectedMatchingStars};
    if (id != null) {
      if (temp.containsKey(id)) {
        temp.remove(id);
      } else {
        temp[id] = matchingStarsData;
      }
      tempSelectedMatchingStars = {...temp};
      notifyListeners();
    }
  }

  void clearMatchingStarsTempData() {
    tempSelectedMatchingStars = {};
    notifyListeners();
  }

  void clearMatchingStarsData() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchValueModel!.copyWith(selectedMatchingStars: {});
    searchValueModel = temp;
    notifyListeners();
  }

  void updateMatchingStarsLoader(LoaderState state) {
    matchingStarsLoader = state;
    notifyListeners();
  }

  ///------------------------------------------------------------------------

  /// Advanced search data---------------------------------------------------

  Future<ProfileSearchModel?> advancedSearchRequest(
      {required BuildContext context,
      Function? onSuccess,
      bool enableLoader = true}) async {
    ProfileSearchModel? profileSearchModel;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Map<String, dynamic> params = {
      "length": 20,
      "page": pageCount,
      "sort_order": selectedSortId,
    };
    params.addAll(searchReqParam);
    profileSearchModel = await searchApiRequest(
        params: params,
        context: context,
        onSuccess: onSuccess,
        enableLoader: enableLoader);
    return profileSearchModel;
  }

  void updateUserDataList(ProfileSearchModel? profileSearchModel) {
    if (pageCount == 1) {
      userDataList =
          profileSearchModel?.profileSearchData?.original?.data ?? [];
    } else {
      List<UserData> tempUserDataList = [...userDataList];
      userDataList = [
        ...tempUserDataList,
        ...profileSearchModel?.profileSearchData?.original?.data ?? []
      ];
    }
    recordsFiltered =
        profileSearchModel?.profileSearchData?.original?.recordsTotal ?? 0;
    totalPageLength =
        ((profileSearchModel?.profileSearchData?.original?.recordsTotal ?? 20) /
                20)
            .ceil();
    notifyListeners();
  }

  Future<ProfileSearchModel?> searchApiRequest(
      {required Map<String, dynamic> params,
      required Function? onSuccess,
      required BuildContext context,
      required bool enableLoader}) async {
    ProfileSearchModel? profileSearchModel;
    Result res = await serviceConfig.searchByData(params);
    if (res.isValue) {
      profileSearchModel = res.asValue!.value;
      updateUserDataList(profileSearchModel);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
      btnLoader = false;
      paginationLoader = false;
      notifyListeners();
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel responseModel = res.asError!.error as ResponseModel;
        btnLoader = false;
        paginationLoader = false;
        if (enableLoader) updateLoaderState(LoaderState.loaded);
        Helpers.successToast(
            responseModel.errors?.nestId ?? 'An error occurred');
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        Helpers.successToast('Something went wrong');
        btnLoader = false;
        paginationLoader = false;
        notifyListeners();
      }
    }
    return profileSearchModel;
  }

  /// -----------------------------------------------------------------------

  /// Search by Id ----------------------------------------------------------

  Future<ProfileSearchModel?> searchById(BuildContext context,
      {Function? onSuccess, enableLoader = true}) async {
    ProfileSearchModel? profileSearchModel;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Map<String, dynamic> params = {
      "length": 20,
      "page": pageCount,
      "sort_order": selectedSortId,
      "register_id": query ?? ''
    };
    profileSearchModel = await searchApiRequest(
        params: params,
        context: context,
        onSuccess: onSuccess,
        enableLoader: enableLoader);
    return profileSearchModel;
  }

  Future<ProfileSearchModel?> loadMore(BuildContext context,
      {bool fromSearchById = true}) async {
    ProfileSearchModel? profileSearchModel;
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      notifyListeners();
      profileSearchModel = fromSearchById
          ? await searchById(context, enableLoader: false)
          : await advancedSearchRequest(context: context, enableLoader: false);
    }
    return profileSearchModel;
  }

  void getRecentlySearchedKeys() async {
    updateLoaderState(LoaderState.loading);
    recentlySearchedList = await HiveServices.getRecentlySearchedKeys();
    await HiveServices.closeRecentlySearchedBox();
    debugPrint('recently searched list $recentlySearchedList');
    updateLoaderState(LoaderState.loaded);
    notifyListeners();
  }

  void addRecentlySearchedKeys(String key) async {
    String value = '';
    if (!recentlySearchedList.contains(key)) {
      await HiveServices.addRecentlySearchedKeys(key);
    } else {
      for (int i = 0; i < recentlySearchedList.length; i++) {
        if (key == recentlySearchedList[i]) {
          value = recentlySearchedList[i];
          break;
        }
      }
      deleteKeyFromRecentlySearchedList(value, false);
      await HiveServices.addRecentlySearchedKeys(key);
    }
    notifyListeners();
  }

  void deleteKeyFromRecentlySearchedList(String value, bool isFromClose) {
    HiveServices.deleteItemFromRecentlySearchedList(value);
    if (isFromClose) {
      getRecentlySearchedKeys();
    }
  }

  void updateQueryId(val) {
    query = val;
    notifyListeners();
  }

  void clearValues({bool fromSearch = true}) {
    userDataList.clear();
    pageCount = 1;
    recordsFiltered = 0;
    length = 20;
    totalPageLength = 0;
    selectedSortId = 1;
    if (fromSearch) {
      profileCreatedIndex = 3;
      selectedProfileCreatedIndex = -1;
    }
    paginationLoader = false;
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  void clearFilterTempValues() {
    profileCreatedIndex = 3;
    selectedProfileCreatedIndex = -1;
    tempSelectedFilterCaste.clear();
    tempSelectedFilterEducation.clear();
    tempSelectedFilterEduCategories.clear();
    tempSelectedFilterOccupations.clear();
    tempSelectedFilterDistricts.clear();
    searchFilterTempValueModel = searchFilterValueModel;
    searchFilterValueModel = searchValueModel?.cloneOld();
    notifyListeners();
    getCasteDataList(isFromSearch: false);
  }

  /// -----------------------------------------------------------------------

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
    notifyListeners();
  }

  void setMoreFilterEnabled() {
    moreFilterEnabled = !moreFilterEnabled;
    notifyListeners();
  }

  void updateEnableGridView() {
    enableGridView = !enableGridView;
    notifyListeners();
  }

  void searchPageInit() {
    enableGridView = false;
    notifyListeners();
  }

  void updateSelectedGender(Gender gender) {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp = searchValueModel!.copyWith(selectedGender: gender);
    searchValueModel = temp;
    notifyListeners();
  }

  @override
  void pageInit() {
    tempSelectedCaste = {};
    tempSelectedEducation = {};
    profileCreatedIndex = 3;
    btnLoader = false;
    loaderState = LoaderState.loaded;
    addEduDataAlertVisibility = true;
    searchValueModel = SearchValueModel(selectedGender: Gender.female);
    searchFilterTempValueModel = null;
    searchFilterValueModel = null;
    isProfileMale = null;
    notifyListeners();
  }

  Future<void> fetchFromAppData(BuildContext context) async {
    final model = context.read<AppDataProvider>();
    if (model.educationCategoryModel != null) {
      updateEduCatModel(model.educationCategoryModel);
    } else {
      model.getEduCatListData().then((value) => updateEduCatModel(value));
    }
    if (model.jobDataModel != null) {
      updateOccupationModel(model.jobDataModel);
    } else {
      model.getOccupationList().then((value) => updateOccupationModel(value));
    }
    if (model.jobChildCategoryListModel != null) {
      updateParentChildCatModel(model.jobChildCategoryListModel);
    } else {
      model
          .getChildEducationCategories()
          .then((value) => updateParentChildCatModel(value));
    }
  }

  Future<void> assignLoginUserData(BuildContext context) async {
    BasicDetail? basicDetail =
        context.read<AppDataProvider>().basicDetailModel?.basicDetail;

    searchValueModel ??= SearchValueModel();
    if (basicDetail?.isMale != null) {
      isProfileMale = basicDetail!.isMale;
      updateSelectedGender(basicDetail.isMale! ? Gender.female : Gender.male);
    }
    updateMaritalStatus(MaritalStatus(
        id: basicDetail?.maritalStatusId,
        maritalStatus: basicDetail?.maritalStatus));
    updateReligionData(ReligionListData(
        id: basicDetail?.religionId, religionName: basicDetail?.religion));
    if (basicDetail?.religionId != null) {
      /* if (basicDetail?.casteId != null && basicDetail?.casteId != 3) {
        context.read<SearchFilterProvider>()
          ..updateSelectedCaste(basicDetail?.casteId, basicDetail?.caste)
          ..assignTempToSelectedCaste();
      }*/
      getCasteDataList();
    }
    /* if (basicDetail?.isMale != null) {
      isProfileMale = basicDetail!.isMale;
      updateSelectedGender(basicDetail.isMale! ? Gender.female : Gender.male);
    }
    context.read<AccountProvider>().getPartnerPreference(context).then((value) {
      PartnerPreferenceModel? model = value;
      if (model?.data != null) {
        if ((model?.data?.maritalStatusUnserializeId ?? []).isNotEmpty) {
          updateMaritalStatus(MaritalStatus(
              id: int.tryParse(model!.data!.maritalStatusUnserializeId![0]),
              maritalStatus:
              (model.data?.maritalStatusUnserialize ?? []).join(', ')));
        }
      }
*/
    notifyListeners();
  }

  void updateMaritalStatus(MaritalStatus? val, {bool isFromSearch = true}) {
    if (isFromSearch) {
      searchValueModel ??= SearchValueModel();
      SearchValueModel temp = searchValueModel!.copyWith(maritalStatus: val);
      searchValueModel = temp;
    } else {
      searchFilterValueModel ??= SearchValueModel();
      SearchValueModel temp =
          searchFilterValueModel!.copyWith(maritalStatus: val);
      searchFilterValueModel = temp;
    }
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

  void updateSelectedCountry(CountryData? val, {bool isFromSearch = true}) {
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
    notifyListeners();
  }

  void updateSelectedSortId(int val) {
    selectedSortId = val;
    notifyListeners();
  }

  void updateSelectedState(StateData? val, {bool isFromSearch = true}) {
    if (isFromSearch) {
      searchValueModel ??= SearchValueModel();
      SearchValueModel temp = searchValueModel!.copyWith(stateData: val);
      searchValueModel = temp;
    } else {
      searchFilterValueModel ??= SearchValueModel();
      SearchValueModel temp = searchFilterValueModel!.copyWith(stateData: val);
      searchFilterValueModel = temp;
    }
    notifyListeners();
  }

  void updateProfileCreatedIndex(int val) {
    profileCreatedIndex = val;
    notifyListeners();
  }

  String _getDateFromMonth() {
    int val = 0;
    switch (profileCreatedIndex) {
      case 0:
        val = 1;
        break;
      case 1:
        val = 3;
        break;
      case 2:
        val = 6;
        break;
      case 3:
        val = 0;
        break;
    }

    return val == 0
        ? ''
        : _convertDateToString(DateTime(
            _currentDate.year, _currentDate.month - val, _currentDate.day));
  }

  String _convertDateToString(DateTime dateTime) {
    String formatted = DateFormat('yyyy-MM-dd').format(dateTime);
    return formatted;
  }

  /// Search Filter request --------------------------------------------------

  void assignValuesSearchToFilter() {
    searchFilterValueModel = searchValueModel;
    searchFilterTempValueModel = searchFilterValueModel;
    notifyListeners();
  }

  void assignValuesTempToFilter() {
    if (searchFilterTempValueModel != null) {
      searchFilterValueModel = searchFilterTempValueModel;
      notifyListeners();
    }
  }

  ///-------------------------------------------------------------------------

  void setSearchParam() {
    Map<String, dynamic> params = {};
    if ((query ?? '').isNotEmpty) {
      params['register_id'] = query;
    }
    if (selectedFromHeight != null && selectedFromHeight != 0.0) {
      params['height_from'] = getHeightFromId(selectedFromHeight?.ceil() ?? 0);
      params['height_to'] = getHeightFromId(selectedToHeight?.ceil() ?? 0);
    }
    if ((selectedFromAge?.floor() ?? 0) != 0 &&
        (selectedToAge?.floor() ?? 0) != 0) {
      params['age_from'] = selectedFromAge?.floor();
      params['age_to'] = selectedToAge?.floor();
    }
    if (searchValueModel != null) {
      if (searchValueModel!.selectedGender != null) {
        params['gender'] = (searchValueModel!.selectedGender == Gender.male)
            ? 'Male'
            : 'Female';
      }
      if (searchValueModel?.maritalStatus?.id != null) {
        params['marital_status'] = [searchValueModel?.maritalStatus?.id];
        //params['marital_status[0]'] = searchValueModel?.maritalStatus?.id;
      }
      if (searchValueModel?.religionListData?.id != null) {
        params['religion'] = searchValueModel?.religionListData?.id;
      }
      if (searchValueModel!.getSelectedCaste.isNotEmpty) {
        List<int> idList = searchValueModel!.getSelectedCaste.keys.toList();
        params['caste'] = idList;
      }

      if (searchValueModel!.getSelectedEducation.isNotEmpty) {
        List<int> idList = [];
        for (var education in searchValueModel!.getSelectedEducation.values) {
          idList = [...idList, ...education];
        }
        params['education'] = idList;
      }
      if (searchValueModel!.getSelectedOccupations.isNotEmpty) {
        List<JobData?> idList =
            searchValueModel!.getSelectedOccupations.values.toList();
        params['job'] = idList.map((e) => e?.id ?? -1).toList();
      }
      if (searchValueModel?.countryData?.id != null) {
        params['country'] = searchValueModel!.countryData!.id;
      }
      if (searchValueModel?.stateData?.id != null) {
        params['state[0]'] = searchValueModel!.stateData!.id;
      }
      if (searchValueModel!.getSelectedDistricts.isNotEmpty) {
        List<DistrictData?> idList =
            searchValueModel!.getSelectedDistricts.values.toList();
        params['district'] = idList.map((e) => e?.id ?? -1).toList();
      }
      if (searchFilterValueModel!.getSelectedMatchingStars.isNotEmpty) {
        List<MatchingStarsData?> idList =
            searchFilterValueModel!.getSelectedMatchingStars.values.toList();
        params['matching_star'] = idList.map((e) => e?.id ?? -1).toList();
      }
    }
    if (profileCreatedIndex != 3) {
      params['from_date'] = _convertDateToString(_currentDate);
      params['to_date'] = _getDateFromMonth();
    }
    searchParam = params;
    notifyListeners();
  }

  void setSearchFilterParam() {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    if ((query ?? '').isNotEmpty) {
      params['register_id'] = query;
    }
    if (searchFilterValueModel != null) {
      params['gender'] = (searchFilterValueModel!.selectedGender == Gender.male)
          ? 'Male'
          : 'Female';
    }
    if (searchFilterValueModel != null) {
      if (searchFilterValueModel?.maritalStatus?.id != null) {
        params['marital_status'] = [searchFilterValueModel?.maritalStatus?.id];
        //  params['marital_status[0]'] = searchFilterValueModel?.maritalStatus?.id;
      }
      if (searchFilterValueModel?.religionListData?.id != null) {
        params['religion'] = searchFilterValueModel?.religionListData?.id;
      }
      if (searchFilterValueModel!.getSelectedCaste.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedCaste.keys.toList();
        params['caste'] = idList;
      }
      if (searchFilterValueModel!.getSelectedEducation.isNotEmpty) {
        List<int> idList = [];
        for (var education
            in searchFilterValueModel!.getSelectedEducation.values) {
          idList = [...idList, ...education];
        }
        params['education'] = idList;
      }
      if (searchFilterValueModel!.getSelectedOccupations.isNotEmpty) {
        List<JobData?> idList =
            searchFilterValueModel!.getSelectedOccupations.values.toList();
        params['job'] = idList.map((e) => e?.id ?? -1).toList();
      }
      if (searchFilterValueModel!.countryData?.id != null) {
        params['country'] = searchFilterValueModel!.countryData!.id;
      }
      if (searchFilterValueModel!.stateData?.id != null) {
        params['state'] = [searchFilterValueModel!.stateData!.id];
      }
      if (searchFilterValueModel!.getSelectedDistricts.isNotEmpty) {
        List<DistrictData?> idList =
            searchFilterValueModel!.getSelectedDistricts.values.toList();
        params['district'] = idList.map((e) => e?.id ?? -1).toList();
      }
    }
    if (selectedFromHeight != null && selectedFromHeight != 0) {
      params['height_from'] = getHeightFromId(
          Helpers.convertToInt(selectedFromHeight?.ceil() ?? 0));
      params['height_to'] =
          getHeightFromId(Helpers.convertToInt(selectedToHeight?.ceil() ?? 0));
    }
    if ((selectedFromAge?.floor() ?? 0) != 0 &&
        (selectedToAge?.floor() ?? 0) != 0) {
      params['age_from'] = selectedFromAge?.floor();
      params['age_to'] = selectedToAge?.floor();
    }
    if (selectedProfileCreatedIndex != -1) {
      params['profile_created_by'] = selectedProfileCreatedIndex + 1;
    }

    if (profileCreatedIndex != 3) {
      params['from_date'] = _convertDateToString(_currentDate);
      params['to_date'] = _getDateFromMonth();
    }
    searchFilterParam = params;
    notifyListeners();
  }

  void updateDiscoverMatchParams(BuildContext context,
      {int? city, int? profession, int? religion, int? education}) {
    Map<String, dynamic> param = {"discover_flag": true};
    selectedFromAge = null;
    selectedToAge = null;
    selectedFromHeight = null;
    selectedToHeight = null;
    if (city != null) {
      param['district'] = [city];
    }
    if (profession != null) {
      param['job'] = [profession];
    }
    if (religion != null) {
      param['religion'] = religion;
    }
    if (education != null) {
      param['education'] = [education];
    }

    pageInit();
    clearValues();
    searchParam = param;
    notifyListeners();
    assignSearchToReqPram();
    advancedSearchRequest(
      context: context,
    );
  }

  void assignSearchToReqPram() {
    searchReqParam = searchParam;
    notifyListeners();
  }

  void assignSearchFilterToReqPram() {
    searchReqParam = searchFilterParam;
    notifyListeners();
  }

  void updateProfileCreatedBy(int val) {
    selectedProfileCreatedIndex = val;
    notifyListeners();
  }

  Future<bool> checkEducationDataUpdated(BuildContext context) async {
    bool resFlag = true;
    if (addEduDataAlertVisibility) {
      BasicDetail? basicDetail =
          context.read<AppDataProvider>().basicDetailModel?.basicDetail;
      if ((basicDetail?.isAddressDetailsUpdated ?? true) == false) {
        addEduDataAlertVisibility = false;
        notifyListeners();
        resFlag = false;
      } else {
        resFlag = true;
      }
    } else {
      resFlag = true;
    }
    return resFlag;
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
    super.updateBtnLoader(val);
  }
}
