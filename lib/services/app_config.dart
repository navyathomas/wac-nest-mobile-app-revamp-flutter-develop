class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  static String baseUrl = "";
  static String appLocale = 'en';
  static String? accessToken;
  static String firebaseToken = '';
  static String currency = "";
  static String navFrom = "";
  static bool enableRating = false;
  static bool enableGoogleSignIn = false;
  static bool enableFacebookSignIn = false;
  static bool enableAppleSignIn = false;
  static bool enableForceButton = false;
  static String buildNumber = "";
  // static String razorPayKeyId = 'rzp_test_OrL6PH6kyBvnkE';
  // static String razorPayKeySecret = 'aHNADTXTEFZEXSF3TQNBapkA';
  //live
  static String razorPayKeyId = 'rzp_live_Zb8IpVRwnmawgg';
  static String razorPayKeySecret = 'ITM7c1LnjvJF67cAfrV7tqhl';
  static String mapApiKey = 'AIzaSyDpch7Mse62cy8eik0jtetBz841S023yeQ';
  static bool get isAuthorized => (AppConfig.accessToken ?? '').isNotEmpty;
}
