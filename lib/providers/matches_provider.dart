import 'package:async/src/result/result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/views/matches/matches_all.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../models/age_data_list_model.dart';
import '../models/button_style_model.dart';
import '../models/caste_list_model.dart';
import '../models/countries_data_model.dart';
import '../models/custom_tab_model.dart';
import '../models/district_data_model.dart';
import '../models/education_cat_model.dart';
import '../models/height_data_model.dart';
import '../models/job_data_model.dart';
import '../models/marital_status_model.dart';
import '../models/matching_stars_model.dart';
import '../models/profile_search_model.dart';
import '../models/response_model.dart';
import '../models/search_value_model.dart';
import '../models/state_data_model.dart';
import '../services/helpers.dart';
import '../services/hive_services.dart';
import '../services/http_requests.dart';
import '../utils/color_palette.dart';
import 'app_data_provider.dart';

class MatchesProvider extends ChangeNotifier with BaseProviderClass {
  final DateTime _currentDate = DateTime.now();
  int selectedIndex = 0;
  int selectedChildIndex = 0;
  int tabLength = 4;
  int subTabLength = 4;
  int profileCreatedIndex = 3;
  bool? fetchFromBack;
  int selectedProfileCreatedIndex = -1;

  SearchValueModel? searchFilterValueModel;
  SearchValueModel? searchFilterTempValueModel;
  Map<int, String> tempSelectedFilterCaste = {};
  Map<int, String> tempSelectedMartialStatus = {};
  Map<int, String> tempSelectedEducationalValues = {};
  Map<int, List<int>> tempSelectedFilterEducation = {};
  List<String> tempSelectedFilterEduCategories = [];
  Map<int, JobData?> tempSelectedFilterOccupations = {};
  Map<int, DistrictData?> tempSelectedFilterDistricts = {};
  List<UserData> userDataList = [];
  List<UserData> allMatchesViewedUserDataList = [];
  List<UserData> allMatchesNotViewedUserDataList = [];
  List<UserData> topMatchesViewedUserDataList = [];
  List<UserData> topMatchesNotViewedUserDataList = [];
  List<UserData> newProfileMatchesViewedUserDataList = [];
  List<UserData> newProfileMatchesNotViewedUserDataList = [];
  List<UserData> premiumProfilesMatchesViewedUserDataList = [];
  List<UserData> premiumProfilesMatchesNotViewedUserDataList = [];
  List<UserData> nearByMatchesViewedUserDataList = [];
  List<UserData> nearByMatchesNotViewedUserDataList = [];
  int recordsFiltered = 0;
  int allMatchesNotViewRecords = 0;
  int allMatchesViewedRecords = 0;
  int topMatchesNotViewedRecords = 0;
  int topMatchesViewedRecords = 0;
  int newProfilesNotViewedRecords = 0;
  int newProfilesViewedRecords = 0;
  int premiumProfilesNotViewedRecords = 0;
  int premiumProfilesViewedRecords = 0;
  int nearByProfilesNotViewedRecords = 0;
  int nearByProfilesViewedRecords = 0;

  List<dynamic> recentlySearchedList = [];
  int length = 20;
  int pageCount = 1;
  String? query;
  int totalPageLength = 0;
  int allMatchesNotViewedTotalPageLength = 0;
  int allMatchesViewedTotalPageLength = 0;
  int topMatchesNotViewedTotalPageLength = 0;
  int topMatchesViewedTotalPageLength = 0;
  int newProfilesNotViewedTotalPageLength = 0;
  int newProfilesViewedTotalPageLength = 0;
  int premiumProfilesNotViewedTotalPageLength = 0;
  int premiumProfilesViewedTotalPageLength = 0;
  int nearByProfilesNotViewedTotalPageLength = 0;
  int nearByProfilesViewedTotalPageLength = 0;

  bool paginationLoader = false;
  int selectedSortId = 0;
  SearchValueModel? searchValueModel;
  String martialStatusValues = '';
  String educationValues = '';
  String casteValues = '';
  String occupationalValues = '';
  String districtValues = '';

  double? selectedFromHeight;
  double? selectedToHeight;
  double? selectedFromAge;
  double? selectedToAge;
  CasteListModel? casteListModel;
  List<CasteData>? casteDataList;
  MaritalStatusModel? maritalStatusModel;
  List<MaritalStatus>? maritalDataList;
  Map<int, String> tempSelectedCaste = {};

  HeightDataModel? heightDataModel;
  double minHeightRange = 1;
  double maxHeightRange = 200;
  double minHeight = 1;
  double maxHeight = 200;
  double? heightFromId;
  double? heightToId;
  AgeDataListModel? ageDataListModel;
  double minAgeRange = 18;
  double maxAgeRange = 70;
  double minAge = 18;
  double maxAge = 70;
  double? ageToId;
  double? ageFromId;

  EducationCategoryModel? educationCategoryModel;
  List<EducationCategoryData>? eduCatDataList;
  Map<int, List<int>> tempSelectedEducation = {};
  List<String> tempSelectedEduCategories = [];

  JobDataModel? jobDataModel;
  List<JobData>? jobDataList;
  Map<int, JobData?> tempSelectedOccupations = {};

  DistrictDataModel? districtDataModel;
  List<DistrictData>? districtDataList;
  Map<int, DistrictData?> tempSelectedDistricts = {};

  MatchingStarsModel? matchingStarsModel;
  List<MatchingStarsData>? matchingStarsList;
  Map<int, MatchingStarsData?> tempSelectedMatchingStars = {};
  LoaderState matchingStarsLoader = LoaderState.loaded;

  Map<String, dynamic> searchParam = {};
  Map<String, dynamic> searchFilterParam = {};
  Map<String, dynamic> searchReqParam = {};

  PageController pageViewController = PageController();
  ScrollController scrollController = ScrollController();
  ScrollController subScrollController = ScrollController();
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
  List<CustomTabModel> matchesMenuList(BuildContext context,
      {TabController? tabController}) {
    return [
      CustomTabModel(
        buttonStyleModel: ButtonStyleModel(
            title: context.loc.allMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsAllMatches,
            gradiantColor: [HexColor('#9AA6FF'), HexColor('#344CFF')]),
        tabBarTitles: tabTitles(context),
        tabBarViews: [],
        tabBarChild: MatchesAll(
          tabController: tabController,
        ),
      ),
      CustomTabModel(
        buttonStyleModel: ButtonStyleModel(
            title: context.loc.topMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsTopMatches,
            gradiantColor: [HexColor('#A5DDFF'), HexColor('#00A7FF')]),
        tabBarTitles: tabTitles(context),
        tabBarViews: [],
        tabBarChild: MatchesAll(
          tabController: tabController,
        ),
      ),
      CustomTabModel(
        buttonStyleModel: ButtonStyleModel(
            title: context.loc.newProfiles.replaceFirst(' ', '\n'),
            icon: Assets.iconsNewProfileMatches,
            gradiantColor: [HexColor('#B6EDD5'), HexColor('#00BC76')]),
        tabBarTitles: tabTitles(context),
        tabBarViews: [],
        tabBarChild: MatchesAll(
          tabController: tabController,
        ),
      ),
      CustomTabModel(
        buttonStyleModel: ButtonStyleModel(
            title: context.loc.premiumProfiles.replaceFirst(' ', '\n'),
            icon: Assets.iconsPremiumProfileMatches,
            gradiantColor: [HexColor('#E8D1FF'), HexColor('#8B0EF7')]),
        tabBarTitles: tabTitles(context),
        tabBarViews: [],
        tabBarChild: MatchesAll(
          tabController: tabController,
        ),
      ),
      CustomTabModel(
        buttonStyleModel: ButtonStyleModel(
            title: context.loc.nearByMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsNearBymatches,
            gradiantColor: [HexColor('#FF9182'), HexColor('#FF4F38')]),
        tabBarTitles: tabTitles(context),
        tabBarViews: [],
        tabBarChild: MatchesAll(
          tabController: tabController,
        ),
      ),
    ];
  }

  List<String> matchesMenuTitleList(BuildContext context) => [
        context.loc.allMatches,
        context.loc.topMatches,
        context.loc.newProfiles,
        context.loc.premiumProfiles,
        context.loc.nearByMatches
      ];

  List<Color> tabSelectedColors = [
    HexColor('#354DFF'),
    HexColor('#15A7FF'),
    HexColor('#1FBD77'),
    HexColor('#8B0EF7'),
    HexColor('#FF4F38')
  ];

  List<String> tabTitles(BuildContext context) =>
      [context.loc.notViewed, context.loc.viewed];

  @override
  void pageInit() {
    selectedIndex = 0;
    selectedChildIndex = 0;
    tabLength = 4;
    subTabLength = 4;
    notifyListeners();
  }

  resetSliderValues() {
    heightToId = null;
    heightFromId = null;
    ageToId = null;
    ageFromId = null;
    notifyListeners();
  }

  void updateSelectedIndex(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  void updateSelectedChildIndex(int val) {
    selectedChildIndex = val;
    notifyListeners();
  }

  void clearFilterTempValues() {
    selectedSortId = 0;
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

  void clearValues() {
    userDataList.clear();
    allMatchesViewedUserDataList.clear();
    allMatchesNotViewedUserDataList.clear();
    topMatchesNotViewedUserDataList.clear();
    topMatchesViewedUserDataList.clear();
    newProfileMatchesNotViewedUserDataList.clear();
    newProfileMatchesViewedUserDataList.clear();
    premiumProfilesMatchesNotViewedUserDataList.clear();
    premiumProfilesMatchesViewedUserDataList.clear();
    nearByMatchesViewedUserDataList.clear();
    nearByMatchesNotViewedUserDataList.clear();
    pageCount = 1;
    recordsFiltered = 0;
    length = 20;
    totalPageLength = 0;
    paginationLoader = false;

    // profileCreatedIndex = 3;
    // selectedProfileCreatedIndex = -1;
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  clearFilterValues() {
    selectedSortId = 0;
    searchFilterTempValueModel = null;
    selectedFromHeight = null;
    selectedFromAge = null;
    selectedProfileCreatedIndex = -1;
    profileCreatedIndex = 3;
    searchFilterValueModel = null;
    searchReqParam = {};
    notifyListeners();
  }

  void setSearchFilterParam() {
    Map<String, dynamic> params = {};
    searchFilterTempValueModel = searchFilterValueModel;
    if (searchFilterValueModel != null) {
      params['gender'] = (searchFilterValueModel!.selectedGender == Gender.male)
          ? 'Male'
          : 'Female';
    }
    if (selectedFromHeight != null && selectedFromHeight != 0) {
      params['height_from'] = getHeightFromId(
          Helpers.convertToInt(selectedFromHeight?.ceil() ?? 0));
      heightFromId = (selectedFromHeight?.ceil() ?? 0).toDouble();
      params['height_to'] =
          getHeightFromId(Helpers.convertToInt(selectedToHeight?.ceil() ?? 0));
      heightToId = (selectedToHeight?.ceil() ?? 0).toDouble();
    }
    if ((selectedFromAge?.floor() ?? 0) != 0 &&
        (selectedToAge?.floor() ?? 0) != 0) {
      params['age_from'] = selectedFromAge?.floor();
      ageFromId = selectedFromAge?.floor().toDouble();
      params['age_to'] = selectedToAge?.floor();
      ageToId = selectedToAge?.floor().toDouble();
    }
    if (selectedProfileCreatedIndex != -1) {
      params['profile_created_for'] = selectedProfileCreatedIndex + 1;
    }
    if (profileCreatedIndex != 3) {
      params['from_date'] = _convertDateToString(_currentDate);
      params['to_date'] = _getDateFromMonth();
    }
    if (searchFilterValueModel != null) {
      if (searchFilterValueModel!.getSelectedMaritalStatus.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedMaritalStatus.keys.toList();
        params['marital_status'] = idList;
      }
      if (searchFilterValueModel?.religionListData?.id != null) {
        params['religion'] = searchFilterValueModel?.religionListData?.id;
      }
      if (searchFilterValueModel!.getSelectedCaste.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedCaste.keys.toList();
        params['caste'] = idList;
        // for (var i = 0; i < idList.length; i++) {
        //   params['caste[$i]'] = idList[i];
        // }
      }
      if (selectedFromHeight != null && selectedFromHeight != 0) {
        params['height_from'] = getHeightFromId(
            Helpers.convertToInt(selectedFromHeight?.ceil() ?? 0));
        heightFromId = (selectedFromHeight?.ceil() ?? 0).toDouble();
        params['height_to'] = getHeightFromId(
            Helpers.convertToInt(selectedToHeight?.ceil() ?? 0));
        heightToId = (selectedToHeight?.ceil() ?? 0).toDouble();
      }
      if ((selectedFromAge?.floor() ?? 0) != 0 &&
          (selectedToAge?.floor() ?? 0) != 0) {
        params['age_from'] = selectedFromAge?.floor();
        params['age_to'] = selectedToAge?.floor();
      }
      if (searchFilterValueModel!.getSelectedEducation.isNotEmpty) {
        List<int> idList =
            searchFilterValueModel!.getSelectedEducation.keys.toList();

        // for (var education
        //     in searchFilterValueModel!.getSelectedEducation.values) {
        //   idList = [...idList, ...education];
        // }
        params['education'] = idList;
        // for (var i = 0; i < idList.length; i++) {
        //   params['education[$i]'] = idList[i];
        // }
      }
      if (searchFilterValueModel!.getSelectedOccupations.isNotEmpty) {
        List<int?> idList =
            searchFilterValueModel!.getSelectedOccupations.keys.toList();
        params['job'] = idList;
        // for (var i = 0; i < idList.length; i++) {
        //   params['job[$i]'] = idList[i]?.id ?? -1;
        // }
      }
      if (searchFilterValueModel!.countryData?.id != null) {
        params['country'] = searchFilterValueModel!.countryData!.id;
      }
      if (searchFilterValueModel!.stateData?.id != null) {
        params['state'] = searchFilterValueModel!.stateData!.id;
      }
      if (searchFilterValueModel!.getSelectedDistricts.isNotEmpty) {
        List<int?> idList =
            searchFilterValueModel!.getSelectedDistricts.keys.toList();
        params['district'] = idList;
        // for (int i = 0; i < idList.length; i++) {
        //   debugPrint('i list ${idList[i]!.id}');
        //   params['district[$i]'] = idList[i]?.id;
        // }

        // for (var i = 0; i < idList.length; i++) {
        //   params['district[$i]'] = idList[i]?.id ?? -1;
        // }
      }

      if (selectedProfileCreatedIndex != -1) {
        params['profile_created_by'] = selectedProfileCreatedIndex + 1;
      }

      if (profileCreatedIndex != 3) {
        params['from_date'] = _convertDateToString(_currentDate);
        params['to_date'] = _getDateFromMonth();
      }
    }
    searchFilterParam = params;
    notifyListeners();
  }

  Future<void> assignSearchFilterToReqPram() async {
    searchReqParam = searchFilterParam;
    notifyListeners();
  }

  Future<void> advancedSearchRequest(
      {required BuildContext context,
      Function? onSuccess,
      required MatchesTypes matchesTypes,
      bool enableLoader = true}) async {
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Map<String, dynamic> params = {};
    if (selectedSortId != 0) {
      params = {
        "length": 20,
        "page": pageCount,
        "sort_order": selectedSortId,
      };
    } else {
      params = {
        "length": 20,
        "page": pageCount,
      };
    }

    params.addAll(searchReqParam);
    debugPrint('selected sort id $selectedSortId');
    await getMatchesList(
        params: params,
        context: context,
        onSuccess: onSuccess,
        matchesTypes: matchesTypes,
        enableLoader: enableLoader);
  }

  Future<ProfileSearchModel?> getMatchesList(
      {required Map<String, dynamic> params,
      Function? onSuccess,
      required BuildContext context,
      required bool enableLoader,
      required MatchesTypes matchesTypes}) async {
    ProfileSearchModel? profileSearchModel;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getMatchesList(matchesTypes, params);
    if (res.isValue) {
      profileSearchModel = res.asValue!.value;
      updateUserDataList(profileSearchModel);
      // if (enableLoader) updateLoaderState(LoaderState.loaded);
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
        // Helpers.successToast(
        //     responseModel.errors?.nestId ?? context.loc.anErrorOccurred);
        notifyListeners();
      } else {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
        // Helpers.successToast(context.loc.somethingWentWrong);
        btnLoader = false;
        paginationLoader = false;
        notifyListeners();
      }
    }
    return profileSearchModel;
  }

  getMatchesSwitch(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: selectedChildIndex == 0
                ? MatchesTypes.allMatchesNotViewed
                : MatchesTypes.allMatchesViewed);
        break;
      case 1:
        advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: selectedChildIndex == 0
                ? MatchesTypes.topMatchesNotViewed
                : MatchesTypes.topMatchesViewed);
        break;
      case 2:
        advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: selectedChildIndex == 0
                ? MatchesTypes.newProfileNotViewed
                : MatchesTypes.newProfileViewed);
        break;
      case 3:
        advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: selectedChildIndex == 0
                ? MatchesTypes.premiumProfilesNotViewed
                : MatchesTypes.premiumProfilesViewed);
        break;
      case 4:
        advancedSearchRequest(
            context: context,
            enableLoader: true,
            matchesTypes: selectedChildIndex == 0
                ? MatchesTypes.nearByMatchesNotViewed
                : MatchesTypes.nearByMatchesViewed);
        break;
    }
  }

  loadMoreSwitch(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        loadMore(
            context,
            selectedChildIndex == 0
                ? MatchesTypes.allMatchesNotViewed
                : MatchesTypes.allMatchesViewed,
            totalPages: selectedChildIndex == 0
                ? allMatchesNotViewedTotalPageLength
                : allMatchesViewedTotalPageLength);
        break;
      case 1:
        loadMore(
            context,
            selectedChildIndex == 0
                ? MatchesTypes.topMatchesNotViewed
                : MatchesTypes.topMatchesViewed,
            totalPages: selectedChildIndex == 0
                ? topMatchesNotViewedTotalPageLength
                : topMatchesViewedTotalPageLength);
        break;
      case 2:
        loadMore(
            context,
            selectedChildIndex == 0
                ? MatchesTypes.newProfileNotViewed
                : MatchesTypes.newProfileViewed,
            totalPages: selectedChildIndex == 0
                ? newProfilesNotViewedTotalPageLength
                : newProfilesViewedTotalPageLength);
        break;
      case 3:
        loadMore(
            context,
            selectedChildIndex == 0
                ? MatchesTypes.premiumProfilesNotViewed
                : MatchesTypes.premiumProfilesViewed,
            totalPages: selectedChildIndex == 0
                ? premiumProfilesNotViewedTotalPageLength
                : premiumProfilesViewedTotalPageLength);
        break;
      case 4:
        loadMore(
            context,
            selectedChildIndex == 0
                ? MatchesTypes.nearByMatchesNotViewed
                : MatchesTypes.nearByMatchesViewed,
            totalPages: selectedChildIndex == 0
                ? nearByProfilesNotViewedTotalPageLength
                : nearByProfilesViewedTotalPageLength);
        break;
    }
  }

  Future<ProfileSearchModel?> loadMore(
      BuildContext context, MatchesTypes matchesTypes,
      {bool fromSearchById = true, int? totalPages}) async {
    ProfileSearchModel? profileSearchModel;
    if ((totalPages ?? 0) > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      notifyListeners();
      await advancedSearchRequest(
          context: context, enableLoader: false, matchesTypes: matchesTypes);
    }
    return profileSearchModel;
  }

  void updateUserDataList(ProfileSearchModel? profileSearchModel) {
    if (pageCount == 1) {
      switch (selectedIndex) {
        case 0:
          if (selectedChildIndex == 0) {
            allMatchesNotViewedUserDataList = [];
            allMatchesNotViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            allMatchesNotViewRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            allMatchesNotViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          } else {
            allMatchesViewedUserDataList = [];
            allMatchesViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            allMatchesViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            allMatchesViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          }
          break;
        case 1:
          if (selectedChildIndex == 0) {
            topMatchesNotViewedUserDataList = [];
            topMatchesNotViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            topMatchesNotViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            topMatchesNotViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          } else {
            topMatchesViewedUserDataList = [];
            topMatchesViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            topMatchesViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            topMatchesViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          }
          break;
        case 2:
          if (selectedChildIndex == 0) {
            newProfileMatchesNotViewedUserDataList = [];
            newProfileMatchesNotViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            newProfilesNotViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            newProfilesNotViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          } else {
            newProfileMatchesViewedUserDataList = [];
            newProfileMatchesViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            newProfilesViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            newProfilesViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          }
          break;
        case 3:
          if (selectedChildIndex == 0) {
            premiumProfilesMatchesNotViewedUserDataList = [];
            premiumProfilesMatchesNotViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            premiumProfilesNotViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            premiumProfilesNotViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          } else {
            premiumProfilesMatchesViewedUserDataList = [];
            premiumProfilesMatchesViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            premiumProfilesViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            premiumProfilesViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          }
          break;
        case 4:
          if (selectedChildIndex == 0) {
            nearByMatchesNotViewedUserDataList = [];
            nearByMatchesNotViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            nearByProfilesNotViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            nearByProfilesNotViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          } else {
            nearByMatchesViewedUserDataList = [];
            nearByMatchesViewedUserDataList =
                profileSearchModel?.profileSearchData?.original?.data ?? [];
            nearByProfilesViewedRecords =
                profileSearchModel?.profileSearchData?.original?.recordsTotal ??
                    0;
            nearByProfilesViewedTotalPageLength = ((profileSearchModel
                            ?.profileSearchData?.original?.recordsTotal ??
                        20) /
                    20)
                .ceil();
          }
          break;
      }

      userDataList =
          profileSearchModel?.profileSearchData?.original?.data ?? [];
    } else {
      switch (selectedIndex) {
        case 0:
          if (selectedChildIndex == 0) {
            List<UserData> tempUserDataList = [
              ...allMatchesNotViewedUserDataList
            ];
            allMatchesNotViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          } else {
            List<UserData> tempUserDataList = [...allMatchesViewedUserDataList];
            allMatchesViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          }

          break;
        case 1:
          if (selectedChildIndex == 0) {
            List<UserData> tempUserDataList = [
              ...topMatchesNotViewedUserDataList
            ];
            topMatchesNotViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          } else {
            List<UserData> tempUserDataList = [...topMatchesViewedUserDataList];
            topMatchesViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          }
          break;
        case 2:
          if (selectedChildIndex == 0) {
            List<UserData> tempUserDataList = [
              ...newProfileMatchesNotViewedUserDataList
            ];
            newProfileMatchesNotViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          } else {
            List<UserData> tempUserDataList = [
              ...newProfileMatchesViewedUserDataList
            ];
            newProfileMatchesViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          }
          break;
        case 3:
          if (selectedChildIndex == 0) {
            List<UserData> tempUserDataList = [
              ...premiumProfilesMatchesNotViewedUserDataList
            ];
            premiumProfilesMatchesNotViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          } else {
            List<UserData> tempUserDataList = [
              ...premiumProfilesMatchesViewedUserDataList
            ];
            premiumProfilesMatchesViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          }
          break;
        case 4:
          if (selectedChildIndex == 0) {
            List<UserData> tempUserDataList = [
              ...nearByMatchesNotViewedUserDataList
            ];
            nearByMatchesNotViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          } else {
            List<UserData> tempUserDataList = [
              ...nearByMatchesViewedUserDataList
            ];
            nearByMatchesViewedUserDataList = [
              ...tempUserDataList,
              ...profileSearchModel?.profileSearchData?.original?.data ?? []
            ];
          }
      }

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
    updateLoaderState(LoaderState.loaded);
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

  String _convertDateToString(DateTime dateTime) {
    String formatted = DateFormat('yyyy-MM-dd').format(dateTime);
    return formatted;
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

  String getCmInFeet(int id) {
    int valInCm = getHeightFromId(id);
    double length = valInCm / 2.54;
    int feet = (length / 12).floor();
    double inch = length - (12 * feet);
    return "$feet'${inch.floor()}";
  }

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

  void updateSelectedEducation(int? id, String? name) {
    if (id != null) {
      if (tempSelectedEducationalValues.containsKey(id)) {
        tempSelectedEducationalValues.remove(id);
      } else {
        tempSelectedEducationalValues[id] = name ?? '';
      }
      notifyListeners();
    }
  }

  void clearCasteTempFilterData() {
    tempSelectedFilterCaste = {};
    notifyListeners();
  }

  void clearMartialStatusData() {
    tempSelectedMartialStatus = {};
    notifyListeners();
  }

  Future<void> getCasteDataList({bool isFromSearch = true}) async {
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

  Future<bool> get checkFetchFromBack async {
    if (fetchFromBack != null) return fetchFromBack!;
    String resString = await HiveServices.getAppVersion();
    return resString.isEmpty;
  }

  void updateCastListModel(val) {
    casteListModel = val;
    casteDataList = casteListModel?.data?.castes ?? [];
    notifyListeners();
  }

  void updateMaritalStatusModel(val) {
    maritalStatusModel = val;
    maritalDataList = maritalStatusModel?.maritalStatusData ?? [];
    notifyListeners();
  }

  void assignTempToSelectedCaste() {
    searchValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchValueModel!.copyWith(selectedCaste: {...tempSelectedCaste});
    searchValueModel = temp;
    notifyListeners();
  }

  void assignTempToSelectedFilterCaste() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedCaste: {...tempSelectedFilterCaste});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void assignTempToSelectedMartialStatus() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedMaritalStatus: {...tempSelectedMartialStatus});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempFilterCasteData() {
    tempSelectedFilterCaste = searchFilterValueModel?.selectedCaste ?? {};
    notifyListeners();
  }

  void reAssignTempMaritalStatus() {
    tempSelectedMartialStatus =
        searchFilterValueModel?.selectedMaritalStatus ?? {};
    notifyListeners();
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

  void clearCasteFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(selectedCaste: {});
    searchFilterValueModel = temp;
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

  void clearFilterEduCategoryData() {
    tempSelectedFilterEducation = {};
    tempSelectedFilterEduCategories = [];
    notifyListeners();
  }

  void updateSelectedEduCatData(
      {required int? parentId, required int? childId, required String title}) {
    if (parentId != null && childId != null) {
      if (tempSelectedEducation.containsKey(parentId)) {
        List<int> idList = [...tempSelectedEducation[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            tempSelectedEducation.remove(parentId);
            tempSelectedEduCategories.remove(title);
          } else {
            idList.remove(childId);
            tempSelectedEducation[parentId] = idList;
            tempSelectedEduCategories.remove(title);
          }
        } else {
          idList.add(childId);
          tempSelectedEducation[parentId] = idList;
          tempSelectedEduCategories.add(title);
        }
      } else {
        tempSelectedEducation[parentId] = [childId];
        tempSelectedEduCategories.add(title);
      }

      notifyListeners();
    }
  }

  void assignTempToSelectedFilterEduCatDat() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!.copyWith(
        selectedEducation: {...tempSelectedFilterEducation},
        selectedEduCategories: [...tempSelectedFilterEduCategories]);
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

  Future<void> updateSelectedFilterEduCatData(
      {required int? parentId,
      required int? childId,
      required String title}) async {
    if (parentId != null && childId != null) {
      if (tempSelectedFilterEducation.containsKey(parentId)) {
        List<int> idList = [...tempSelectedFilterEducation[parentId]!];
        if (idList.contains(childId)) {
          if (idList.length == 1) {
            tempSelectedFilterEducation.remove(parentId);
            tempSelectedFilterEduCategories.remove(title);
          } else {
            idList.remove(childId);
            tempSelectedFilterEducation[parentId] = idList;
            tempSelectedFilterEduCategories.remove(title);
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

  void updateSelectedOccupationFilterData(
      {required int? id, required JobData? jobData}) {
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
    notifyListeners();
  }

  void assignTempToSelectedOccupationFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedOccupations: {...tempSelectedFilterOccupations});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempOccupationFilterData() {
    tempSelectedFilterOccupations =
        searchFilterValueModel?.selectedOccupations ?? {};
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

  void clearDistrictFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp =
        searchFilterValueModel!.copyWith(selectedDistricts: {});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void clearDistrictTempFilterData() {
    tempSelectedFilterDistricts = {};
    notifyListeners();
  }

  void updateSelectedDistrictFilterData(
      {required int? id, required DistrictData? districtData}) {
    if (id != null) {
      if (tempSelectedFilterDistricts.containsKey(id)) {
        tempSelectedFilterDistricts.remove(id);
        notifyListeners();
      } else {
        tempSelectedFilterDistricts[id] = districtData;
        tempSelectedFilterDistricts = {...tempSelectedFilterDistricts};
        notifyListeners();
      }
    }
  }

  void assignTempToSelectedDistrictFilterData() {
    searchFilterValueModel ??= SearchValueModel();
    SearchValueModel temp = searchFilterValueModel!
        .copyWith(selectedDistricts: {...tempSelectedFilterDistricts});
    searchFilterValueModel = temp;
    notifyListeners();
  }

  void reAssignTempDistrictFilterData() {
    tempSelectedFilterDistricts =
        searchFilterValueModel?.selectedDistricts ?? {};
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
  }

  void updateEduCatModel(val) {
    educationCategoryModel = val;
    eduCatDataList = educationCategoryModel?.data ?? [];
    notifyListeners();
  }

  void updateOccupationModel(val) {
    jobDataModel = val;
    jobDataList = jobDataModel?.jobData ?? [];
    notifyListeners();
  }

  void updateProfileCreatedIndex(int val) {
    profileCreatedIndex = val;
    notifyListeners();
  }

  void updateProfileCreatedBy(int val) {
    selectedProfileCreatedIndex = val;
    notifyListeners();
  }

  void updateDistrictModel(DistrictDataModel? val) {
    districtDataModel = val;
    districtDataList = districtDataModel?.districtData ?? [];
    notifyListeners();
  }

  void updateSelectedSortId(int val) {
    selectedSortId = val;
    notifyListeners();
  }

  void clearPageLoader() {
    pageCount = 1;
    userDataList = [];
    notifyListeners();
  }

  void updateUserList(List<UserData> userdata) {
    userDataList = userdata;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
