import 'package:nest_matrimony/models/body_type_model.dart';
import 'package:nest_matrimony/models/complexion_model.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/models/partner_preference_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';

import '../common/constants.dart';
import 'countries_data_model.dart';
import 'district_data_model.dart';
import 'jathakam_model.dart';
import 'job_data_model.dart';
import 'matching_stars_model.dart';

class SearchValueModel {
  MaritalStatus? maritalStatus;
  BodyType? bodyType;
  Complexion? complexion;
  JathakamType? jathakamType;
  Gender? selectedGender;
  ReligionListData? religionListData;
  ReligionListData? religions;
  Map<int, String>? selectedCaste = {};
  Map<int, String>? selectedMaritalStatus = {};
  Map<int, String>? selectedBodyType = {};
  Map<int, String>? selectedState = {};
  Map<int, String>? selectedDistrict = {};
  Map<int, String>? selectedOccupation = {};
  Map<int, String>? selectedCity = {};
  Map<int, String>? selectedComplexion = {};
  Map<int, String>? selectedJathakam = {};
  Map<int, List<int>>? selectedEducation;
  Map<int, List<int>>? selectedJobParent;
  List<String>? selectedEduCategories;
  List<String>? selectedCasteCategories;
  Map<int, List<int>>? selectedParentChildJob;
  List<String>? selectedParentChildCategories;
  List<String>? selectedOccupationCategories;
  Map<int, JobData?>? selectedOccupations;
  CountryData? countryData;
  StateData? stateData;
  DistrictData? districtData;
  Map<int, DistrictData?>? selectedDistricts;
  Map<int, MatchingStarsData?>? selectedMatchingStars;

  SearchValueModel(
      {this.maritalStatus,
      this.bodyType,
      this.religionListData,
      this.religions,
      this.selectedCaste,
      this.selectedMaritalStatus,
      this.selectedBodyType,
      this.selectedState,
      this.selectedOccupation,
      this.selectedDistrict,
      this.selectedCity,
      this.selectedComplexion,
      this.selectedJathakam,
      this.selectedEducation,
      this.selectedJobParent,
      this.selectedEduCategories,
      this.selectedCasteCategories,
      this.selectedParentChildJob,
      this.selectedParentChildCategories,
      this.selectedOccupationCategories,
      this.selectedOccupations,
      this.countryData,
      this.stateData,
      this.districtData,
      this.selectedGender,
      this.selectedDistricts,
      this.selectedMatchingStars});

  SearchValueModel copyWith(
      {MaritalStatus? maritalStatus,
      BodyType? bodyType,
      ReligionListData? religionListData,
      ReligionListData? religions,
      Map<int, String>? selectedCaste,
      Map<int, String>? selectedMaritalStatus,
      Map<int, String>? selectedBodyType,
      Map<int, String>? selectedState,
      Map<int, String>? selectedDistrict,
      Map<int, String>? selectedCity,
      Map<int, String>? selectedComplexion,
      Map<int, String>? selectedJathakam,
      Map<int, List<int>>? selectedEducation,
      Map<int, List<int>>? selectedJobParent,
      List<String>? selectedEduCategories,
      List<String>? selectedCasteCategories,
      Map<int, List<int>>? selectedParentChildJob,
      List<String>? selectedParentChildCategories,
      List<String>? selectedJobParentCategories,
      List<String>? selectedOccupationCategories,
      Map<int, JobData?>? selectedOccupations,
      Map<int, String>? selectedOccupation,
      CountryData? countryData,
      StateData? stateData,
      DistrictData? districtData,
      Gender? selectedGender,
      Map<int, DistrictData?>? selectedDistricts,
      Map<int, MatchingStarsData?>? selectedMatchingStars}) {
    return SearchValueModel(
        maritalStatus: maritalStatus ?? this.maritalStatus,
        bodyType: bodyType ?? this.bodyType,
        religionListData: religionListData ?? this.religionListData,
        religions: religions ?? this.religions,
        selectedCaste: selectedCaste ?? this.selectedCaste,
        selectedMaritalStatus:
            selectedMaritalStatus ?? this.selectedMaritalStatus,
        selectedBodyType: selectedBodyType ?? this.selectedBodyType,
        selectedState: selectedState ?? this.selectedState,
        selectedOccupation: selectedOccupation ?? this.selectedOccupation,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedDistrict: selectedDistrict ?? this.selectedDistrict,
        selectedComplexion: selectedComplexion ?? this.selectedComplexion,
        selectedJathakam: selectedJathakam ?? this.selectedJathakam,
        selectedEducation: selectedEducation ?? this.selectedEducation,
        selectedJobParent: selectedJobParent ?? this.selectedJobParent,
        selectedEduCategories:
            selectedEduCategories ?? this.selectedEduCategories,
        selectedCasteCategories:
            selectedCasteCategories ?? this.selectedCasteCategories,
        selectedParentChildJob:
            selectedParentChildJob ?? this.selectedParentChildJob,
        selectedParentChildCategories:
            selectedParentChildCategories ?? this.selectedParentChildCategories,
        selectedOccupationCategories:
            selectedOccupationCategories ?? this.selectedOccupationCategories,
        selectedOccupations: selectedOccupations ?? this.selectedOccupations,
        countryData: countryData ?? this.countryData,
        stateData: stateData ?? this.stateData,
        districtData: districtData ?? this.districtData,
        selectedDistricts: selectedDistricts ?? this.selectedDistricts,
        selectedGender: selectedGender ?? this.selectedGender,
        selectedMatchingStars:
            selectedMatchingStars ?? this.selectedMatchingStars);
  }

  SearchValueModel cloneOld({SearchValueModel? model}) {
    return SearchValueModel(
        maritalStatus: model?.maritalStatus ?? maritalStatus,
        bodyType: model?.bodyType ?? bodyType,
        religionListData: model?.religionListData ?? religionListData,
        religions: model?.religions ?? religions,
        selectedCaste: model?.selectedCaste ?? selectedCaste,
        selectedMaritalStatus:
            model?.selectedMaritalStatus ?? selectedMaritalStatus,
        selectedBodyType: model?.selectedBodyType ?? selectedBodyType,
        selectedState: model?.selectedState ?? selectedState,
        selectedOccupation: model?.selectedOccupation ?? selectedOccupation,
        selectedCity: model?.selectedCity ?? selectedCity,
        selectedDistrict: model?.selectedDistrict ?? selectedDistrict,
        selectedComplexion: model?.selectedComplexion ?? selectedComplexion,
        selectedJathakam: model?.selectedJathakam ?? selectedJathakam,
        selectedEducation: model?.selectedEducation ?? selectedEducation,
        selectedJobParent: model?.selectedJobParent ?? selectedJobParent,
        selectedEduCategories:
            model?.selectedEduCategories ?? selectedEduCategories,
        selectedCasteCategories:
            model?.selectedCasteCategories ?? selectedCasteCategories,
        selectedParentChildJob:
            model?.selectedParentChildJob ?? selectedParentChildJob,
        selectedParentChildCategories: model?.selectedParentChildCategories ??
            selectedParentChildCategories,
        selectedOccupationCategories:
            model?.selectedOccupationCategories ?? selectedOccupationCategories,
        selectedOccupations: model?.selectedOccupations ?? selectedOccupations,
        countryData: model?.countryData ?? countryData,
        stateData: model?.stateData ?? stateData,
        districtData: model?.districtData ?? districtData,
        selectedDistricts: model?.selectedDistricts ?? selectedDistricts,
        selectedGender: model?.selectedGender ?? selectedGender,
        selectedMatchingStars:
            model?.selectedMatchingStars ?? selectedMatchingStars);
  }

  Map<int, String> get getSelectedCaste => selectedCaste ?? {};
  Map<int, String> get getSelectedMaritalStatus => selectedMaritalStatus ?? {};
  Map<int, String> get getSelectedBodyType => selectedBodyType ?? {};
  Map<int, String> get getSelectedState => selectedState ?? {};
  Map<int, String> get getSelectedOccupation => selectedOccupation ?? {};
  Map<int, String> get getSelectedCity => selectedCity ?? {};
  Map<int, String> get getSelectedDistrict => selectedDistrict ?? {};
  Map<int, String> get getSelectedComplexion => selectedComplexion ?? {};
  Map<int, String> get getSelectedJathakam => selectedJathakam ?? {};
  Map<int, List<int>> get getSelectedEducation => selectedEducation ?? {};
  Map<int, List<int>> get getSelectedJobParent => selectedJobParent ?? {};
  Map<int, List<int>> get getSelectedJobData => getSelectedJobData;
  List<String> get getSelectedEduCategories => selectedEduCategories ?? [];
  List<String> get getSelectedCasteCategories => selectedCasteCategories ?? [];
  Map<int, List<int>> get getSelectedParentChildJob =>
      selectedParentChildJob ?? {};
  List<String> get getSelectedParentChildJobCategories =>
      selectedParentChildCategories ?? [];
  List<String> get getSelectedOccupationCategories =>
      selectedOccupationCategories ?? [];
  Map<int, JobData?> get getSelectedOccupations => selectedOccupations ?? {};
  Map<int, DistrictData?> get getSelectedDistricts => selectedDistricts ?? {};
  Map<int, MatchingStarsData?> get getSelectedMatchingStars =>
      selectedMatchingStars ?? {};
}
