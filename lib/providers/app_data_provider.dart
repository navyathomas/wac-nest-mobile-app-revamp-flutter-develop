import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/app_data_model.dart';
import 'package:nest_matrimony/models/base_urls_model.dart' as base;
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/body_type_list_model.dart';
import 'package:nest_matrimony/models/complexion_list_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/education_cat_model.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/models/job_category_model.dart';
import 'package:nest_matrimony/models/home_slider_banner_model.dart';
import 'package:nest_matrimony/models/job_data_model.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/upgrade_plan_details.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/hive_services.dart';
import 'package:provider/provider.dart';

import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../hive_models/paymentDetails.dart';
import '../models/job_child_categories_model.dart';
import '../models/state_data_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';
import '../services/shared_preference_helper.dart';

class AppDataProvider extends ChangeNotifier with BaseProviderClass {
  bool? fetchFromBack;

  CountriesDataModel? _countriesDataModel;
  List<CountryData>? countryDataList;
  AgeDataListModel? ageDataListModel;
  ReligionListModel? religionListModel;
  BodyTypeListModel? bodyTypeListModel;
  ComplexionListModel? complexionListModel;
  base.BaseUrLmodel? uRLsModel;
  base.Data? urlData;
  MaritalStatusModel? maritalStatusModel;
  HeightDataModel? heightDataModel;
  StateDataModel? stateDataModel;
  EducationCategoryModel? educationCategoryModel;
  JobChildCategoryListModel? jobChildCategoryListModel;
  JobCategoryModel? jobCategoryModel;
  DistrictDataModel? districtDataModel;
  JobDataModel? jobDataModel;
  BasicDetailModel? basicDetailModel;
  bool paymentStatus = false;
  bool upgradePlanStatus = false;

  LoaderState religionListLoader = LoaderState.loaded;
  LoaderState maritalStatusLoader = LoaderState.loaded;
  LoaderState eduCatListLoader = LoaderState.loaded;
  LoaderState jobParentListLoader = LoaderState.loaded;
  LoaderState stateListLoader = LoaderState.loaded;
  LoaderState districtListLoader = LoaderState.loaded;
  LoaderState jobListLoader = LoaderState.loaded;
  LoaderState bodyTypeListLoader = LoaderState.loaded;
  LoaderState complexionListLoader = LoaderState.loaded;
  LoaderState childEducationCategoryLoader = LoaderState.loaded;

  List<HomeSliderBannerModel>? homeSliderBannerList;
  Future<void> getAppBaseVersion() async {
    String resString = await HiveServices.getAppVersion();
    Result res = await serviceConfig.getAppBackendVersion();
    if (res.isValue) {
      AppVersionModel appVersionModel = res.asValue!.value;
      if (resString.isEmpty ||
          resString != (appVersionModel.data?.version ?? '')) {
        await HiveServices.saveAppVersion(
            val: appVersionModel.data?.version ?? '',
            key: HiveServices.appVersion);
        updateFetchFromBack(false);
      } else {
        updateFetchFromBack(true);
      }
    } else {
      updateFetchFromBack(true);
    }
  }

//Base Urls
  Future<bool> getBaseUrls() async {
    bool resFlag = false;
    bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getBaseUrls(fetchFromLocal: fetchStat);
    if (res.isValue) {
      base.BaseUrLmodel model = res.asValue!.value;
      updateUrlsDataModel(model);
      await HiveServices.closeHiveBox();
      resFlag = true;
    } else {
      await HiveServices.closeHiveBox();
      resFlag = false;
    }
    return resFlag;
  }

  void updateUrlsDataModel(val) {
    uRLsModel = val;
    urlData = uRLsModel?.data;
    notifyListeners();
  }
//Base Urls close

  /// Country List ----------------------------------------------
  Future<void> getCountryData() async {
    bool fetchStat = await checkFetchFromBack;
    updateLoaderState(LoaderState.loading);
    Result res =
        await serviceConfig.getCountriesData(fetchFromLocal: fetchStat);
    if (res.isValue) {
      CountriesDataModel model = res.asValue!.value;
      updateCountryDataModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateCountryDataModel(val) {
    _countriesDataModel = val;
    countryDataList = _countriesDataModel?.countryData;
    notifyListeners();
  }

  void resetCountryList() {
    countryDataList = _countriesDataModel?.countryData;
    notifyListeners();
  }

  void searchByQuery(String val) {
    if ((_countriesDataModel?.countryData ?? []).isNotEmpty) {
      List<CountryData> model = _countriesDataModel!.countryData!
          .where((element) =>
              (element.countryName.toString())
                  .toLowerCase()
                  .contains(val.toLowerCase()) ||
              (element.dialCode.toString()).contains(val.toLowerCase()))
          .toList();
      countryDataList = model;
    } else {
      countryDataList = _countriesDataModel?.countryData;
    }
    notifyListeners();
  }

  ///----------------------------------------------------------------

  /// Ages List Data -----------------------------------------------

  Future<void> getAgeData(BuildContext context) async {
    bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getAgeData(fetchFromLocal: fetchStat);
    if (res.isValue) {
      AgeDataListModel model = res.asValue!.value;
      updateAgeListModel(model);
      Future.microtask(() {
        context.read<RegistrationProvider>().updateAgeListModel(model);
        context.read<SearchFilterProvider>().updateAgeModelData(model);
        context.read<MatchesProvider>().updateAgeModelData(model);
      });
    }
  }

  void updateAgeListModel(val) {
    ageDataListModel = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Edu Category List Data -----------------------------------------------

  Future<EducationCategoryModel?> getEduCatListData() async {
    EducationCategoryModel? model;
    bool fetchStat = await checkFetchFromBack;
    updateEduCatListLoader(LoaderState.loading);
    Result res =
        await serviceConfig.getEduCatListData(fetchFromLocal: fetchStat);
    if (res.isValue) {
      model = res.asValue!.value;
      updateEduCatListModel(model);
      updateEduCatListLoader(LoaderState.loaded);
    } else {
      updateEduCatListLoader(fetchError(res.asError!.error as Exceptions));
    }
    return model;
  }

  Future<JobCategoryModel?> getJobParentListData() async {
    JobCategoryModel? model;
    bool fetchStat = await checkFetchFromBack;
    updateJobListLoader(LoaderState.loading);
    Result res =
        await serviceConfig.getJobParentListData(fetchFromLocal: false);
    if (res.isValue) {
      model = res.asValue!.value;
      updateJobParentListModel(model);
      updateJobListLoader(LoaderState.loaded);
    } else {
      updateJobListLoader(fetchError(res.asError!.error as Exceptions));
    }
    return model;
  }

  void updateEduCatListModel(val) {
    educationCategoryModel = val;
    notifyListeners();
  }

  void updateJobParentListModel(val) {
    jobCategoryModel = val;
    notifyListeners();
  }

  void updateEduCatListLoader(val) {
    eduCatListLoader = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// ChildJob Category List Data -----------------------------------------------

  Future<JobChildCategoryListModel?> getChildEducationCategories() async {
    JobChildCategoryListModel? model;
    bool fetchStat = await checkFetchFromBack;
    updateEduCatListLoader(LoaderState.loading);
    Result res = await serviceConfig.getChildEducationCategories(
        fetchFromLocal: fetchStat);
    if (res.isValue) {
      model = res.asValue!.value;
      updateChildJobCategoryListModel(model);
      updateChildJobCategoryLoader(LoaderState.loaded);
    } else {
      updateEduCatListLoader(fetchError(res.asError!.error as Exceptions));
    }
    return model;
  }

  void updateChildJobCategoryListModel(val) {
    jobChildCategoryListModel = val;
    notifyListeners();
  }

  void updateChildJobCategoryLoader(val) {
    childEducationCategoryLoader = val;
    notifyListeners();
  }

  void updateJobParentListLoader(val) {
    jobParentListLoader = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// District List Data -----------------------------------------------

  Future<void> getDistrictList(BuildContext context, int stateId) async {
    updateDistrictListLoader(LoaderState.loading);
    Result res = await serviceConfig.getDistrictDataList(stateId);
    if (res.isValue) {
      DistrictDataModel model = res.asValue!.value;
      updateDistrictListModel(model);
      updateDistrictListLoader(LoaderState.loaded);
      Future.microtask(() {
        context.read<SearchFilterProvider>().updateDistrictModel(model);
        context.read<MatchesProvider>().updateDistrictModel(model);
        context.read<PartnerPreferenceProvider>().updateDistrictModel(model);
      });
    } else {
      updateDistrictListLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateDistrictListModel(DistrictDataModel? val) {
    districtDataModel = val;
    notifyListeners();
  }

  void updateDistrictListLoader(LoaderState val) {
    districtListLoader = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// State List Data -----------------------------------------------

  Future<void> getStatesList(int countryId) async {
    updateStateListLoader(LoaderState.loading);
    Result res = await serviceConfig.getStateDataList(countryId);
    if (res.isValue) {
      StateDataModel model = res.asValue!.value;
      updateStateListModel(model);
      updateStateListLoader(LoaderState.loaded);
    } else {
      updateStateListLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateStateListModel(val) {
    stateDataModel = val;
    notifyListeners();
  }

  void updateStateListLoader(val) {
    stateListLoader = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Job List Data -----------------------------------------------

  Future<JobDataModel?> getOccupationList() async {
    JobDataModel? model;
    updateJobListLoader(LoaderState.loading);
    Result res = await serviceConfig.getJobListData();
    if (res.isValue) {
      model = res.asValue!.value;
      updateJobListModel(model);
      updateJobListLoader(LoaderState.loaded);
    } else {
      updateJobListLoader(fetchError(res.asError!.error as Exceptions));
    }
    return model;
  }

  void updateJobListModel(JobDataModel? val) {
    jobDataModel = val;
    notifyListeners();
  }

  void updateJobListLoader(LoaderState val) {
    jobListLoader = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Height List Data --------------------------------------------------

  Future<void> getHeightListData(BuildContext context) async {
    bool fetchStat = await checkFetchFromBack;
    Result res = await serviceConfig.getHeightData(fetchFromLocal: fetchStat);
    if (res.isValue) {
      HeightDataModel model = res.asValue!.value;
      updateHeightListModel(model);
      Future.microtask(() {
        context.read<SearchFilterProvider>().updateHeightData(model);
        context.read<MatchesProvider>().updateHeightData(model);
      });
    }
  }

  void updateHeightListModel(val) {
    heightDataModel = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Height List Data --------------------------------------------------

  Future<BasicDetailModel?> getBasicDetails({BuildContext? context}) async {
    BasicDetailModel? model;
    if ((AppConfig.accessToken ?? '').isNotEmpty) {
      Result res = await serviceConfig.getBasicDetails();
      if (res.isValue) {
        model = res.asValue!.value;
        updateBasicDetailModel(model);
        assignHomeSliderBannerData();
      } else {
        updateHomeSliderBannerList(<HomeSliderBannerModel>[]);
        if ((res.asError?.error ?? Exceptions.err) == Exceptions.authError &&
            context != null) {
          await SharedPreferenceHelper.clearData();
          updateBasicDetailModel(null);
          await HiveServices.removeDataFromLocal(HiveServices.basicDetails);
          await Future.microtask(() {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteGenerator.routeAuthScreen, (route) => false);
          });
        }
      }
    }
    return model;
  }

  Future<void> getPaymentStatus(BuildContext context) async {
    PaymentProvider paymentProvider = context.read<PaymentProvider>();
    paymentStatus = await SharedPreferenceHelper.getPaymentStatus();
    if (paymentStatus == false) {
      Future.microtask(() {
        paymentProvider.getPaymentDetails().then((value) {
          PaymentDetails paymentDetails = paymentProvider.paymentDetailsHive;
          paymentProvider.savePayment(context, paymentDetails,
              isFromPayment: false);
        });
      });
    }
    notifyListeners();
  }

  Future<void> getUpgradeStatus(BuildContext context) async {
    PaymentProvider paymentProvider = context.read<PaymentProvider>();
    upgradePlanStatus = await SharedPreferenceHelper.getUpgradePlanStatus();
    if (upgradePlanStatus == false) {
      Future.microtask(() {
        paymentProvider.getUpgradePlanDetails().then((value) {
          UpgradePlanDetails upgradePlanDetails =
              paymentProvider.upgradePlanDetailsHive;
          paymentProvider.savePaymentPlan(context, upgradePlanDetails,
              isFromPayment: false);
        });
      });
    }
    notifyListeners();
  }

  void updateBasicDetailModel(val) {
    basicDetailModel = val;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Marital Status Data -----------------------------------------------

  Future<void> getMaritalStatusData() async {
    bool fetchStat = await checkFetchFromBack;
    updateMaritalStatusLoader(LoaderState.loading);
    Result res =
        await serviceConfig.getMaritalStatusData(fetchFromLocal: fetchStat);
    if (res.isValue) {
      MaritalStatusModel model = res.asValue!.value;
      updateMaritalStatusModel(model);
      updateMaritalStatusLoader(LoaderState.loaded);
    } else {
      updateMaritalStatusLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateMaritalStatusModel(val) {
    maritalStatusModel = val;
    notifyListeners();
  }

  void updateMaritalStatusLoader(LoaderState loaderState) {
    maritalStatusLoader = loaderState;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Religion List -----------------------------------------------------

  Future<void> getReligionList() async {
    bool fetchStat = await checkFetchFromBack;
    updateReligionLoader(LoaderState.loading);
    Result res = await serviceConfig.getReligionList(fetchFromLocal: fetchStat);
    if (res.isValue) {
      ReligionListModel model = res.asValue!.value;
      updateReligionListModel(model);
      updateReligionLoader(LoaderState.loaded);
    } else {
      updateMaritalStatusLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateReligionListModel(val) {
    religionListModel = val;
    notifyListeners();
  }

  void updateReligionLoader(LoaderState loaderState) {
    religionListLoader = loaderState;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// BodType List -----------------------------------------------------

  Future<void> getBodyTypeList() async {
    bool fetchStat = await checkFetchFromBack;
    updateReligionLoader(LoaderState.loading);
    Result res = await serviceConfig.getBodyTypeList(fetchFromLocal: fetchStat);
    if (res.isValue) {
      BodyTypeListModel model = res.asValue!.value;
      updateBodyTypeListModel(model);
      updateReligionLoader(LoaderState.loaded);
    } else {
      updateMaritalStatusLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateBodyTypeListModel(val) {
    bodyTypeListModel = val;
    notifyListeners();
  }

  void updateBodyTypeLoader(LoaderState loaderState) {
    bodyTypeListLoader = loaderState;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  /// Complexion List -----------------------------------------------------

  Future<void> getComplexionList() async {
    bool fetchStat = await checkFetchFromBack;
    updateReligionLoader(LoaderState.loading);
    Result res =
        await serviceConfig.getComplexionsList(fetchFromLocal: fetchStat);
    if (res.isValue) {
      ComplexionListModel model = res.asValue!.value;
      updateComplexionListModel(model);
      updateReligionLoader(LoaderState.loaded);
    } else {
      updateMaritalStatusLoader(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateComplexionListModel(val) {
    complexionListModel = val;
    notifyListeners();
  }

  void updateComplexionLoader(LoaderState loaderState) {
    complexionListLoader = loaderState;
    notifyListeners();
  }

  ///--------------------------------------------------------------------

  void updateFetchFromBack(bool val) {
    fetchFromBack = val;
    notifyListeners();
  }

  Future<bool> get checkFetchFromBack async {
    if (fetchFromBack != null) return fetchFromBack!;
    String resString = await HiveServices.getAppVersion();
    return resString.isEmpty;
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void assignHomeSliderBannerData() {
    List<HomeSliderBannerModel> bannerList = [];
    BasicDetail? basicDetail = basicDetailModel?.basicDetail;
    if ((basicDetail?.isImageUploaded ?? true) == false) {
      bannerList.add(HomeSliderBannerModel(
          dataCollectionTypes: DataCollectionTypes.addPhotos,
          image: Assets.imagesHomeAddPhoto));
    }
    if ((basicDetail?.isIdProofUpdated ?? true) == false) {
      bannerList.add(HomeSliderBannerModel(
          dataCollectionTypes: DataCollectionTypes.addIdProof,
          image: Assets.imagesHomeVerifyPhotos));
    }
    if ((basicDetail?.isProfessionalDetailsUpdated ?? true) == false) {
      bannerList.add(HomeSliderBannerModel(
          dataCollectionTypes: DataCollectionTypes.addProfessionalInfo,
          image: Assets.imagesHomeAddOrganization));
    }
    if ((basicDetail?.isEducationalDetailsUpdated ?? true) == false) {
      bannerList.add(HomeSliderBannerModel(
          dataCollectionTypes: DataCollectionTypes.addEducation,
          image: Assets.imagesHomeAddInstitutions));
    }
    homeSliderBannerList = bannerList;
    notifyListeners();
  }

  void updateHomeSliderBannerList(val) {
    homeSliderBannerList = val;
    notifyListeners();
  }
}
