import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/views/account/add_horoscope/add_horoscope.dart';
import 'package:nest_matrimony/views/account/edit_horoscope/edit_horoscope.dart';
import 'package:nest_matrimony/views/account/help_centre/contact_us.dart';
import 'package:nest_matrimony/views/account/help_centre/help_centre.dart';
import 'package:nest_matrimony/views/account/help_centre/support.dart';
import 'package:nest_matrimony/views/account/my_profile.dart';
import 'package:nest_matrimony/views/account/partner_preference/edit_basic_preference.dart';
import 'package:nest_matrimony/views/account/partner_preference/edit_location_prefernce.dart';
import 'package:nest_matrimony/views/account/partner_preference/edit_professional_preference.dart';
import 'package:nest_matrimony/views/account/partner_preference/edit_religious_preference.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference.dart';
import 'package:nest_matrimony/views/account/plans/plan_detail.dart';
import 'package:nest_matrimony/views/account/plans/plan_see_all.dart';
import 'package:nest_matrimony/views/account/profile/edit_about_me/edit_about_me.dart';
import 'package:nest_matrimony/views/account/profile/edit_basic_details/edit_basic_details.dart';
import 'package:nest_matrimony/views/account/profile/edit_contact/edit_contact.dart';
import 'package:nest_matrimony/views/account/profile/edit_family_details/edit_family_details.dart';
import 'package:nest_matrimony/views/account/profile/edit_location/edit_location.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/edit_professional_details.dart';
import 'package:nest_matrimony/views/account/profile/edit_religion_info/edit_religion_info.dart';
import 'package:nest_matrimony/views/account/profile/manage_photos/add_photos.dart';
import 'package:nest_matrimony/views/account/profile/manage_photos/hide_photos.dart';
import 'package:nest_matrimony/views/account/profile/manage_photos/manage_photos.dart';
import 'package:nest_matrimony/views/account/profile/preview_profile/preview_profile_screen.dart';
import 'package:nest_matrimony/views/account/profile/profile.dart';
import 'package:nest_matrimony/views/account/settings/blocked_users/blocked_users.dart';
import 'package:nest_matrimony/views/account/settings/change_password/change_password.dart';
import 'package:nest_matrimony/views/account/settings/settings.dart';
import 'package:nest_matrimony/views/account/settings/terms_and_policy/terms_and_policy.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/auth_screens/auth_otp_screen.dart';
import 'package:nest_matrimony/views/auth_screens/auth_screen/auth_screen.dart';
import 'package:nest_matrimony/views/auth_screens/login/login.dart';
import 'package:nest_matrimony/views/auth_screens/login/login_via_otp.dart';
import 'package:nest_matrimony/views/auth_screens/registration/caste/search_caste_screen.dart';
import 'package:nest_matrimony/views/auth_screens/registration/crop_photo/instagram_photos.dart';
import 'package:nest_matrimony/views/auth_screens/registration/crop_photo/instagram_view.dart';
import 'package:nest_matrimony/views/daily_recommendation_screen.dart';
import 'package:nest_matrimony/views/easy_pay/ep_home.dart';
import 'package:nest_matrimony/views/easy_pay/common_form.dart';
import 'package:nest_matrimony/views/easy_pay/payment_init.dart';
import 'package:nest_matrimony/views/auth_screens/registration/crop_photo/photos_grid_view.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/interest_recomendation_screen.dart';
import 'package:nest_matrimony/views/main_screen/main_screen.dart';
import 'package:nest_matrimony/views/map_views/select_location_screen.dart';
import 'package:nest_matrimony/views/new_join_screen.dart';
import 'package:nest_matrimony/views/notifications/notifications_screen.dart';
import 'package:nest_matrimony/views/on_boarding/on_boarding.dart';
import 'package:nest_matrimony/views/auth_screens/registration/registration_screen.dart';
import 'package:nest_matrimony/views/partner_profile_detail/partner_similar_profile_detail_screen.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/full_screen_image.dart';
import 'package:nest_matrimony/views/partner_profile_detail/partner_profile_detail_screen.dart';
import 'package:nest_matrimony/views/premium_members_screen.dart';
import 'package:nest_matrimony/views/recently_viewed_screen.dart';
import 'package:nest_matrimony/views/search_filter/search_by_id/search_by_id_screen.dart';
import 'package:nest_matrimony/views/search_filter/search_filter_screen.dart';
import 'package:nest_matrimony/views/similar_profiles_screen.dart';
import 'package:nest_matrimony/views/success_stories/success_stories.dart';
import 'package:nest_matrimony/views/top_matches_screen.dart';
import '../models/authentication/login_arguments.dart';
import '../models/profile_detail_default_model.dart';
import '../models/route_arguments.dart';
import '../views/account/profile/edit_horoscope_details/edit_horoscope_details.dart';
import '../views/auth_screens/forgot_password/forgot_password.dart';
import '../views/auth_screens/forgot_password/reset_password.dart';
import '../views/partner_profile_detail/partner_single_profile_detail_screen.dart';
import '../views/search_result/search_result_screen.dart';
import '../views/service_screens/services.dart';
import '../views/splash/splash_screen.dart';

class RouteGenerator {
  static RouteGenerator? _instance;
  static RouteGenerator get instance {
    _instance ??= RouteGenerator();
    return _instance!;
  }

  static const String routeInitial = "/";
  static const String routeAuthScreen = "/authScreen";
  static const String routeRegistrationScreen = "/registrationScreen";
  static const String routeLogin = "/login";
  static const String routeError = "/error";
  static const String routeSignUp = "/signup";
  static const String routeOnBoarding = "/onBoarding";
  static const String routeLoginViaOTP = "/loginViaOtp";
  static const String routeLoginOTPVerification = "/loginOTPVerification";
  static const String routeForgotPassword = "/forgotPassword";
  static const String routeResetPassword = "/resetPassword";
  static const String routeSearchCaste = "/searchCasteScreen";
  static const String routeSearchFilter = "/searchFilterScreen";
  static const String routeSearchById = "/searchByIdScreen";
  static const String routeSearchResult = "/searchResultScreen";
  static const String routePartnerProfileDetail = "/partnerProfileDetailScreen";
  static const String routeFullScreenImage = "/fullScreenImage";
  static const String routeEasyPay = "/easyPay";
  static const String routeCommonEasyPayForm = "/freeForReg";
  static const String routePaymentInit = "/paymentInit";
  static const String routeMyProfile = "/myProfile";
  static const String routeSettings = "/settings";
  static const String routeChangePassword = "/changePassword";
  static const String routePhotoGridView = "/searchPhotoGridView";
  static const String routeBlockedUsers = "/blockedUsers";
  static const String routeTermsAndPolicy = "/routeTermsAndPolicy";
  static const String routeProfile = "/routeProfile";
  static const String routeManagePhotos = "/routeManagePhotos";
  static const String routeAddPhotos = "/routeAddPhotos";
  static const String routeEditContact = "/routeEditContact";
  static const String routeEditAboutMe = "/routeEditAboutMe";
  static const String routeEditBasicDetail = "/routeEditBasicDetail";
  static const String routeEditProfessionalInfo = "/routeEditProfessionalInfo";
  static const String routeEditReligionInfo = "/routeEditReligionInfo";
  static const String routeEditHoroscopeDetail = "/routeEditHoroscopeDetail";
  static const String routeEditLocationDetail = "/routeEditLocationDetail";
  static const String routeEditFamilyDetail = "/routeEditFamilyDetail";
  static const String routeAddHoroscope = "/routeAddHoroscope";
  static const String routeEditHoroscope = "/routeEditHoroscope";
  static const String routeHelpCentre = "/routeHelpCentre";
  static const String routeSupport = "/routeSupport";
  static const String routeToContactUs = "/routeContactUs";
  static const String routeMainScreen = "/routeMainScreen";
  static const String routePartnerPreference = "/routePartnerPreference";
  static const String routeEditBasicPreference = "/routeEditBasicPreference";
  static const String routeAuthOtpScreen = "/routeAuthOtpScreen";
  static const String routePlanSeeAll = "/routePlanSeeAll";
  static const String routePlanDetail = "/routePlanDetail";
  static const String routeServiceScreen = "/routeServiceScreen";
  static const String routeErrorScreen = "/routeDeclinesErrorScreen";
  static const String routeSuccessStoriesScreen = "/routeSuccessStoriesScreen";
  static const String routeInstagramPhotos = "/routeInstagramPhotos";
  static const String routeInstagram = "/routeInstagram";
  static const String routeDailyRecommendations = "/routeDailyRecommendations";
  static const String routeTopMatches = "/routeTopMatches";
  static const String routePremiumMembers = "/routePremiumMembers";
  static const String routeNewJoins = "/routeNewJoins";
  static const String routeHidePhotos = "/routeHidePhotos";
  static const String routeRecentlyViewed = "/routeRecentlyViewed";
  static const String routeInterestRecommendation =
      "/routeInterestRecommendation";
  static const String routeNotificationScreen = '/routeNotification';
  static const String routeSimilarProfiles = "/routeSimilarProfiles";
  static const String routePartnerSingleProfileDetail =
      "/partnerSingleProfileDetailScreen";
  static const String routeMapScreen = "/routeMapView";
  static const String routeProfilePreview = "/routeProfilePreview";
  static const String routeEditProfessionalPreference =
      "/routeEditProfessionalPreference";
  static const String routeEditReligiousPreference =
      "/routeReligiousPreference";
  static const String routeEditLocationPreference =
      "/routeEditLocationPreference";
  static const String routePartnerSimilarProfileDetail =
      "/partnerSimilarProfileDetailScreen";
  static const String routeForcePopupDialog =
      "/routeForcePopupDialog";

  Route generateRoute(RouteSettings settings, {var routeBuilders}) {
    var args = settings.arguments;
    RouteArguments? _routeArguments;
    switch (settings.name) {
      case routeInitial:
        return _buildRoute(routeInitial, const SplashScreen());
      case routeAuthScreen:
        return _buildRoute(routeAuthScreen, const AuthScreen());
      case routeOnBoarding:
        return _buildRoute(routeInitial, const OnBoarding());
      case routeRegistrationScreen:
        LoginArguments? loginArguments =
            (args != null && args is LoginArguments) ? args : null;
        return _buildRoute(
            routeRegistrationScreen,
            RegistrationScreen(
              loginArguments: loginArguments,
            ));
      case routeLogin:
        return _buildRoute(routeLogin, const Login());
      case routeLoginViaOTP:
        LoginArguments? loginArguments =
            (args != null && args is LoginArguments) ? args : null;
        return _buildRoute(
            routeLoginViaOTP,
            LoginViaOTP(
              loginArguments: loginArguments,
            ));
      case routeForgotPassword:
        return _buildRoute(routeForgotPassword, const ForgotPassword());
      case routeResetPassword:
        return _buildRoute(routeResetPassword, const ResetPassword());

      case routeSearchFilter:
        return _buildRoute(routeSearchFilter, const SearchFilterScreen());
      case routePartnerProfileDetail:
        return _buildRoute(
            routePartnerProfileDetail,
            PartnerProfileDetailScreen(
              profileDetailArguments:
                  args != null ? args as ProfileDetailArguments : null,
            ));
      case routeSearchResult:
        bool resVal = args != null ? args as bool : false;
        return _buildRoute(
            routeSearchResult,
            SearchResultScreen(
              isFromSearchId: resVal,
            ));
      case routeSearchById:
        return _buildRoute(routeSearchById, const SearchByIdScreen(),
            enableFullScreen: true);
      case routePhotoGridView:
        return _buildRoute(routePhotoGridView, const PhotoGridView(),
            enableFullScreen: true);
      case routeEasyPay:
        return _buildRoute(routeEasyPay, const EasyPayHome());
      case routeMyProfile:
        return _buildRoute(routeMyProfile, const MyProfile());
      case routeHidePhotos:
        return _buildRoute(routeHidePhotos, const HidePhotos());
      case routeInstagramPhotos:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeInstagramPhotos,
            InstagramView(isFromManage: routeArgs.isFromMangePhotos));
      case routeInstagram:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeInstagram,
            InstagramPhotos(
              isFromManage: routeArgs.isFromMangePhotos,
            ));
      case routeServiceScreen:
        return _buildRoute(routeServiceScreen, const ServiceScreen());
      case routePlanDetail:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routePlanDetail,
            PlanDetail(
              planId: '${routeArgs.index}',
              planName: '${routeArgs.title}',
              mont: '${routeArgs.anyText}',
              description: '${routeArgs.descriptions}',
              planAmount: '${routeArgs.anyValue}',
              showUpgradePlan: routeArgs.showUpgradePlan,
              inAppTitle: routeArgs.inAppTitle ?? '',
            ));
      case routePlanSeeAll:
        return _buildRoute(routePlanSeeAll, const PlanSeeAll());
      case routeEditBasicPreference:
        return _buildRoute(
            routeEditBasicPreference, const EditBasicPreference());
      case routePartnerPreference:
        return _buildRoute(
            routePartnerPreference, const PartnerPreferenceScreen());
      case routeToContactUs:
        return _buildRoute(routeToContactUs, const ContactUs());
      case routeSupport:
        return _buildRoute(routeSupport, const Support());
      case routeHelpCentre:
        return _buildRoute(routeHelpCentre, const HelpCentre());
      case routeManagePhotos:
        int? index = (args != null && args is int) ? args : null;
        return _buildRoute(
            routeManagePhotos,
            ManagePhotos(
              intialIndex: index,
            ));
      case routeCommonEasyPayForm:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeCommonEasyPayForm,
            CommonForm(
              appbarTitle: routeArgs.title ?? '',
              epayNav: routeArgs.anyValue as EPnav,
            ));
      case routeSearchCaste:
        return _buildRoute(routeSearchCaste, const SearchCasteScreen(),
            enableFullScreen: true);
      case routeFullScreenImage:
        List<String> images = args.isNull ? [] : args as List<String>;
        return ScaleRoute(
            route: routeFullScreenImage, page: FullScreenImage(images: images));
      case routePaymentInit:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routePaymentInit,
            PaymentInit(
              isUpgradePlan: routeArgs.isUpgradePlan,
              planAmount: routeArgs.planAmount,
              planId: routeArgs.planId,
            ),
            enableFullScreen: true);
      case routeSettings:
        return _buildRoute(routeSettings, const Settings());
      case routeEditBasicDetail:
        RouteArguments? routeArgs =
            args == null ? null : args as RouteArguments;
        return _buildRoute(routeEditBasicDetail,
            EditBasicDetails(basicDetails: routeArgs?.basicDetails));
      case routeEditProfessionalInfo:
        RouteArguments? routeArgs =
            args == null ? null : args as RouteArguments;
        return _buildRoute(routeEditProfessionalInfo,
            EditProfessionalDetails(basicDetails: routeArgs?.basicDetails));
      case routeEditReligionInfo:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeEditReligionInfo,
            EditReligionInfo(basicDetails: routeArgs.basicDetails));
      case routeEditHoroscopeDetail:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeEditHoroscopeDetail,
            EditHoroscopeDetails(basicDetails: routeArgs.basicDetails));
      case routeEditAboutMe:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeEditAboutMe,
            EditAboutMe(basicDetails: routeArgs.basicDetails));
      case routeEditLocationDetail:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeEditLocationDetail,
            EditLocation(basicDetails: routeArgs.basicDetails));
      case routeEditFamilyDetail:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(routeEditFamilyDetail,
            EditFamilyDetails(basicDetails: routeArgs.basicDetails));
      case routeChangePassword:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeChangePassword,
            ChangePassword(
              appbarTitle: routeArgs.title ?? '',
            ));
      case routeBlockedUsers:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeBlockedUsers,
            BlockedUsers(
              appbarTitle: routeArgs.title ?? '',
            ));
      case routeAddPhotos:
        return _buildRoute(routeAddPhotos, const AddPhotos());
      case routeAddHoroscope:
        return _buildRoute(routeAddHoroscope, const AddHoroscope());
      case routeEditHoroscope:
        return _buildRoute(routeEditHoroscope, const EditHoroscope());
      case routeTermsAndPolicy:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeTermsAndPolicy,
            CommonTermsAndConditions(
              appbarTitle: routeArgs.title ?? '',
              isTerms: routeArgs.anyValue ?? false,
            ));
      case routeEditContact:
        RouteArguments? routeArgs =
            args != null ? args as RouteArguments : null;
        return _buildRoute(routeEditContact,
            EditContact(basicDetails: routeArgs?.basicDetails));
      case routeProfile:
        // RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeProfile,
            Profile(
              appbarTitle: '',
            ));
      case routeMainScreen:
        RouteArguments routeArgs =
            args == null ? RouteArguments() : args as RouteArguments;
        return routeArgs.defaultTransition
            ? _buildRoute(
                routeMainScreen,
                MainScreen(
                  tabIndex: routeArgs.tabIndex,
                ))
            : SlideRightRoute(
                route: routeMainScreen,
                page: MainScreen(
                  tabIndex: routeArgs.tabIndex,
                ));
      case routeAuthOtpScreen:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeAuthOtpScreen,
            AuthOtpScreen(
              navFrom: routeArgs.navFrom ?? NavFrom.navFromLogin,
            ));
      case routeErrorScreen:
        RouteArguments routeArgs = args as RouteArguments;
        return _buildRoute(
            routeErrorScreen,
            CommonErrorView(
              error: routeArgs.errorType,
            ));
      case routeSuccessStoriesScreen:
        return _buildRoute(routeSuccessStoriesScreen, SuccessStoriesScreen());
      case routeTopMatches:
        return _buildRoute(routeTopMatches, const TopMatchesScreen());
      case routePremiumMembers:
        return _buildRoute(routePremiumMembers, const PremiumMembersScreen());
      case routeDailyRecommendations:
        return _buildRoute(
            routeDailyRecommendations, const DailyRecommendationScreen());
      case routeNewJoins:
        return _buildRoute(routeNewJoins, const NewJoinScreen());
      case routeInterestRecommendation:
        return _buildRoute(
            routeInterestRecommendation, const InterestRecommendationScreen());
      case routeRecentlyViewed:
        return _buildRoute(routeRecentlyViewed, const RecentlyViewedScreen());
      case routeSimilarProfiles:
        return _buildRoute(routeSimilarProfiles,
            SimilarProfilesScreen(profileId: (args ?? -1) as int));
      case routePartnerSingleProfileDetail:
        return _buildRoute(
            routePartnerSingleProfileDetail,
            PartnerSingleProfileDetailScreen(
              routeArguments: args != null ? args as RouteArguments : null,
            ));
      case routeNotificationScreen:
        return _buildRoute(
            routeNotificationScreen, const NotificationsScreen());
      case routeMapScreen:
        return _buildRoute(routeMapScreen, const SelectLocationScreen());
      case routeProfilePreview:
        return _buildRoute(routeProfilePreview, const ProfilePreviewScreen());
      case routeEditProfessionalPreference:
        return _buildRoute(routeEditProfessionalPreference,
            const EditProfessionalPreference());
      case routeEditReligiousPreference:
        return _buildRoute(
            routeEditReligiousPreference, const EditReligiousPreference());
      case routeEditLocationPreference:
        return _buildRoute(
            routeEditLocationPreference, const EditLocationPreference());
      case routePartnerSimilarProfileDetail:
        return _buildRoute(
            routePartnerSimilarProfileDetail,
            PartnerSimilarProfileDetailScreen(
              similarProfileDetailArguments:
                  args != null ? args as SimilarProfileDetailArguments : null,
            ));
      default:
        return _buildRoute(routeError, const ErrorView());
    }
  }

  Route _buildRoute(String route, Widget widget,
      {bool enableFullScreen = false, bool popTransition = false}) {
    return MaterialPageRoute(
        fullscreenDialog: enableFullScreen,
        settings: RouteSettings(name: route),
        builder: (_) => widget);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Error View")),
        body: const Center(child: Text('Page not found')));
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  final String route;
  ScaleRoute({required this.page, this.route = ''})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: RouteSettings(name: route),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  final String route;
  SlideRightRoute({required this.page, this.route = ''})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
