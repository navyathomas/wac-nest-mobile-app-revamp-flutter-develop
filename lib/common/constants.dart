import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';

class Constants {
  static const String validateNetwork =
      "Please validate your network connection";
  static const String noInternet = "No Internet Connection";
  static const String serverError = "Oops Something went wrong, Try again";
  static const String noDataFound = "No data found";
  static const String authErrorMsg = "User login expired, please login again";
  static const String desc = "desc";
  static const String icon = "icon";
  static const String title = "title";
  static const String btnTitle = "btn_title";
  static const double lat = 10.311879;
  static const double lng = 76.331978;
  static const String contactDetailAlert = "contactDetailAlert";
  static const String sendInterestAlert = "sendInterestAlert";
  static const String dataCollectionAlert = "dataCollectionAlert";
  static const String fullImageScreen = "/fullScreenImage";
  static const String imageErrorMsg = "Failed to upload image";
  static const String mobileErrorType = 'mobile';
  static const String emailErrorType = 'email';

  static const String appID = "";
  static const String applestoreURL = "https://apps.apple.com/app/ _ /id";
  static const String playstoreURL =
      "https://play.google.com/store/apps/details?id=";

  static List<String> accountList = ["Change password", "Blocked users"];
  static List<String> legalList = ["Terms of use", "Privacy policy"];

  static const List<String> partnerCardBtn = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedCloseRed,
    Assets.iconsRoundedStar,
    Assets.iconsRoundedHeart,
    Assets.iconsRoundedCallYellow
  ];

  static const List<String> partnerCardBtnSelected = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedCloseRedSelected,
    Assets.iconsRoundedStarSelected,
    Assets.iconsRoundedHeartSelected,
    Assets.iconsRoundedCallYellow
  ];

  static Map<Errors, Map<String, String>> errorType(BuildContext context) => {
        Errors.networkError: {
          icon: Assets.iconsNetworkError,
          title: context.loc.networkError,
          desc: context.loc.noInternetConnectionFound
        },
        Errors.serverError: {
          icon: Assets.iconsServerError,
          title: context.loc.serverError,
          desc: context.loc.somethingWentWrong
        },
        Errors.searchResultError: {
          icon: Assets.iconsNoSearchResult,
          title: context.loc.searchResultNotFound,
          desc: context.loc.checkYourSpellingOrTrySomethingElse
        },
        Errors.noDatFound: {
          icon: Assets.iconsNoDataFound,
          title: context.loc.noDataFound,
          desc: context.loc.noDataFoundPleaseTryAgain,
        },
        Errors.noMatchingStars: {
          icon: Assets.iconsNoDataFound,
          title: context.loc.starNotUpdated,
          desc: context.loc.updateUrStarDetailsToFindTheMatch,
          btnTitle: context.loc.update
        },
      };
}

CountryData indianData = CountryData(
    id: 1,
    countryName: 'India',
    countryFlag: 'https://flagcdn.com/in.svg',
    isoAlpha2Code: 'IN',
    isoAlpha3Code: 'IND',
    dialCode: '91',
    minLength: 7,
    maxLength: 10);

enum LoaderState { loaded, loading, error, networkErr, noData }

enum NavFrom {
  navFromRegister,
  navFromAddress,
  navFromOthers,
  navFromLogin,
  navFromForgot,
  navFromInterests,
  navFromSearch,
  navFromContact,
  navFromShortList,
  navFromSplash,
  navFromPartnerDetail,
  navFromSinglePartnerDetail,
}

enum Gender { male, female }

enum Errors {
  declinesError,
  searchResultError,
  noMatchingStars,
  serverError,
  networkError,
  noDatFound,
  noAccepts
}

enum NavToProfile {
  navFromDailyRec,
  navFromTopMatches,
  navFromPremiumMembers,
  navFromNewJoin,
  navFromRecentlyViewed,
  navFromSimilarProfiles,
  navFromSearchById,
  navFromSearch,
  navFromMatches,
  navFromMailBox,
  navFromInterestRecommendations
}

enum InterestTypes {
  received,
  sent,
  accepted,
  acceptedByMe,
  declined,
  declinedByMe
}

enum InterestAction { accept, decline }

enum ViewedBy { viewedByOthers, viewedByMe }

enum ShortListedBy { shortListedByOthers, shortListedByMe }

enum MatchesTypes {
  allMatchesNotViewed,
  allMatchesViewed,
  topMatchesNotViewed,
  topMatchesViewed,
  newProfileNotViewed,
  newProfileViewed,
  premiumProfilesNotViewed,
  premiumProfilesViewed,
  nearByMatchesNotViewed,
  nearByMatchesViewed
}

enum ServiceType { crmService, profileSuggestions }

enum DataCollectionTypes {
  addPhotos,
  addBasicDetails,
  addProfessionalInfo,
  addEducation,
  addPartnerPreference,
  addAddressDetails,
  addIdProof
}

enum PartnerPreferencesType {
  basicPreference,
  professionalPReference,
  religiousPreference,
  locationPreferences
}
