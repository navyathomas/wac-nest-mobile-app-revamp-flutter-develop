import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/hive_models/paymentDetails.dart';
import 'package:nest_matrimony/models/accept_terms_model.dart';
import 'package:nest_matrimony/models/build_version_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/login_via_otp_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/models/terms_check_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier with BaseProviderClass {
//VARIABLES

// -- login via otp section
/*  bool buttonLoading = false; // floating button loading
  bool otpLoading = false; // loading inside otp screen
  bool loginButtonLoading = false;*/
  String errorMsg = ""; // error on otpTextField
  CountryData? countryData;
  String mobileNo = "";
  String email = '';
  String otpValue = "";
  String? forgetPasswordMobileNo;
  String forgetPasswordErrorMsg = '';
  String confirmPassword = '';
  String passwordReset = '';
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int maxLength = 10;
  int minLength = 7;
  int countryId = 1;
  bool obscured = true;
  bool passwordObscured = true;
  String navFrom = RouteGenerator.routeMainScreen;
// login section
  String nestID = ""; // also used to store reg no.
  String password = "";
  bool paymentStatus = false;
  String playerId = '';
  bool isEmailValid = false;
  String? errorType;
  //VARIABLES CLOSE

  initAuthProvider() async {
    //delete account
    selectId = 0;
    reason;
    //

    errorMsg = "";
    countryData = null;
    btnLoader = false;
    maxLength = 10;
    minLength = 7;
    obscured = true;
    passwordObscured = true;
    forgetPasswordErrorMsg = '';
    confirmPassword = '';
    passwordReset = '';
    mobileNo = "";
    email = '';
    otpValue = "";
    nestID = "";
    password = "";
    notifyListeners();
  }

  updateErrorMessage(String msg) {
    errorMsg = msg;
    notifyListeners();
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

  // initLoginViaAuth() {
  //   errorMsg = "";
  //   countryData = null;
  //   buttonLoading = false;
  //   otpLoading = false;
  //   otpValue = "";
  //   notifyListeners();
  // }

  // initLogin() {
  //   loginButtonLoading = false;
  //   nestID = "";
  //   password = "";
  //   notifyListeners();
  // }

//---------------  MAIN FUNCTIONS ----------------------

//LOGIN VIA OTP
  Future<bool> postLoginViaOTP(BuildContext context,
      {Function? onSuccess}) async {
    updateBtnLoader(true);
    bool resFlag = false;
    errorMsg = "";
    var res = await serviceConfig.loginViaOtpPOST(
        mobile: mobileNo, countryID: countryData?.id.toString(), email: email);
    if (res.isValue) {
      LoginViaOtpModel model = res.asValue!.value;
      if (model.data != null) {
        updateEmailId(model.data['email']);
      }
      log("RES MESSAGE : ${model.message}");
      resFlag = true;
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess(true);
    } else {
      updateBtnLoader(false);
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        if ((errorRes.statusCode ?? 0) == 528) {
          if (onSuccess != null) onSuccess(false);
        } else {
          if (errorRes.errors?.mobile != null) {
            errorMsg = errorRes.errors?.mobile ?? '';
            updateErrorType(Constants.mobileErrorType);
          } else {
            errorMsg = errorRes.errors?.email ?? '';
            updateErrorType(Constants.emailErrorType);
          }
        }
      } else if (res.asError!.error is LoginViaOtpModel) {
        LoginViaOtpModel errorRes = res.asError!.error as LoginViaOtpModel;
        if ((errorRes.message ?? "").isNotEmpty) {
          Helpers.successToast(errorRes.message ?? '');
        }
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    return resFlag;
  }

// VERIFY LOGIN VIA OTP
  Future<bool> verifyLoginViaOTP(BuildContext context,
      {Function? onSuccess}) async {
    pinCodeController.text = '';
    updateBtnLoader(true);
    bool resFlag = false;
    errorMsg = "";
    var res = await serviceConfig.verifyLoginViaOtp(
        otp: otpValue, mobile: mobileNo, countryID: countryData?.id.toString());
    if (res.isValue) {
      updateBtnLoader(false);
      ResponseModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      String token = model.responseData?.accessToken ?? "";
      await SharedPreferenceHelper.saveToken(token);
      await Future.microtask(() {
        context.read<AppDataProvider>().getBasicDetails();
      });
      updatePlayerId();
      resFlag = true;
      if (onSuccess != null) onSuccess();
    } else {
      errorMsg = 'Wrong OTP entered';
      updateBtnLoader(false);
    }
    return resFlag;
  }

//LOGIN
  login(BuildContext context, {Function? onSuccess}) async {
    errorMsg = "";
    updateBtnLoader(true);
    var res = await serviceConfig.login(nestiD: nestID, password: password);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("RES MESSAGE : ${model.message}");
      String token = model.responseData?.accessToken ?? "";
      await SharedPreferenceHelper.saveToken(token);
      await Future.microtask(() {
        context.read<AppDataProvider>().getBasicDetails();
        updatePlayerId();
      });
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? 'Invalid Credentials');
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
  }

//CHANGE PASSWORD
  changePassword(
      {Function? onSuccess,
      String? current,
      String? newPass,
      String? confirmPass}) async {
    errorMsg = "";
    updateBtnLoader(true);
    var res = await serviceConfig.changePasswordPOST(
        current: current, newPass: newPass, confirmPass: confirmPass);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("RES MESSAGE : ${model.message}");
      Helpers.successToast(model.message ?? "");
      updateBtnLoader(false);
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(
            errorRes.errors?.password ?? errorRes.errors?.passcheck ?? "");
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
  }

  logout({
    Function? onSuccess,
    String? userId,
    Function? onException,
  }) async {
    errorMsg = "";

    updateBtnLoader(true);
    var res = await serviceConfig.logout(userID: userId);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("RES MESSAGE : ${model.message}");
      Helpers.successToast(model.message ?? "");
      updateBtnLoader(false);

      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        updateBtnLoader(false);
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        Helpers.successToast(errorRes.message ?? "");
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        if (onException != null) onException();
        //All exceptions
      }
    }
  }

  Future<bool> forgetPasswordOtpRequest(BuildContext context,
      {Function? onSuccess}) async {
    errorMsg = "";
    //pinCodeController.text = '';
    updateBtnLoader(true);
    bool resFlag = false;
    var res = await serviceConfig.forgetPasswordRequestOtp(
        mobileNo: mobileNo,
        countryID: countryData?.id.toString(),
        email: email);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      if (model.responseData != null) {
        updateEmailId(model.responseData?.email ?? '');
      }
      log("SUCCESS : ${model.message}");
      resFlag = true;
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;

        if (errorRes.errors != null) {
          if (errorRes.errors?.mobile != null) {
            errorMsg = errorRes.errors?.mobile ?? context.loc.invalidMobile;
            updateErrorType(Constants.mobileErrorType);
          } else {
            errorMsg = errorRes.errors?.email ?? context.loc.invalidEmail;
            updateErrorType(Constants.emailErrorType);
          }
        }
        updateBtnLoader(false);
        notifyListeners();
      } else {
        errorMsg = context.loc.invalidMobile;
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    notifyListeners();
    return resFlag;
  }

  forgotPasswordVerifyOtp(BuildContext context, {Function? onSuccess}) async {
    updateBtnLoader(true);
    errorMsg = "";
    var res = await serviceConfig.forgotPasswordVerifyOtp(
        mobile: mobileNo, countryID: countryData?.id.toString(), otp: otpValue);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      String token = model.responseData?.accessToken ?? "";
      await SharedPreferenceHelper.saveToken(token);
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? context.loc.wrongOtp;
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    notifyListeners();
  }

  resetPassword(BuildContext context, {Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.resetPassword(
        password: passwordReset, confirmPassword: confirmPassword);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? '';
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    notifyListeners();
  }

  updatePlayerId() async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.updatePlayerId({
      'player_id': osUserID,
      'device_type': Platform.isAndroid ? 'Android' : 'Ios'
    });
    if (res.isValue) {
      debugPrint('player id updated');
      updateLoaderState(LoaderState.loaded);
    } else {
      debugPrint('player id updates failed');
      updateLoaderState(LoaderState.error);
    }
  }

// DELETE ACCOUNT

  int selectId = 0;
  String? reason;
  updateselectId({int? id, String? deleteReason}) {
    selectId = id ?? 0;
    reason = deleteReason;
    notifyListeners();
  }

  deleteAccount({Function? onSuccess}) async {
    updateBtnLoader(true);
    var res = await serviceConfig.deleteAccount(
        id: selectId.toString(), reason: reason);
    if (res.isValue) {
      ResponseModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      Helpers.successToast(model.message.toString());
      if (onSuccess != null) onSuccess();
      updateBtnLoader(false);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? '';
        log(errorMsg);
        updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        updateBtnLoader(false);
        //All exceptions
      }
    }
    notifyListeners();
  }

// DELETE ACCOUNT CLOSE

//CHECK TERMS OF USE ACCEPTED

  Future<bool> checkTermsofUse({Function? onSuccess}) async {
    bool agreementStatus = false;
    var res = await serviceConfig.getTermsStatusCheck();
    if (res.isValue) {
      TermsCheckModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      log("TERMS OF USE STATUS AGGREMENT : ${model.data?.termsOfUseStatus}");
      agreementStatus = model.data?.termsOfUseStatus ?? false;
      notifyListeners();
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? '';
        log(errorMsg);
      } else {
        debugPrint('Exceptions');
      }
    }
    notifyListeners();
    return agreementStatus;
  }

  Future<bool> agreeTermsofUse({Function? onSuccess}) async {
    bool agree = false;
    updateBtnLoader(true);
    var res = await serviceConfig.agreeTermsOfuse();
    if (res.isValue) {
      updateBtnLoader(false);
      AcceptTermsModel model = res.asValue!.value;
      log("SUCCESS : ${model.message}");
      log("TERMS OF USE ACCEPTED : ${model.data?.isAccepted}");
      if (model.data?.isAccepted == 1) {
        agree = true;
      } else {
        agree = false;
      }
      if (onSuccess != null) onSuccess();
    } else {
      updateBtnLoader(false);
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? '';
        Helpers.successToast('something went wrong in server');
        log(errorMsg);
      } else {
        updateBtnLoader(false);
        debugPrint('Exceptions');
      }
    }
    notifyListeners();
    return agree;
  }

////CHECK TERMS OF USE ACCEPTED CLOSE

//---------------------------------  MAIN FUNCTIONS CLOSE -----------------------

//---- MINI FUNCTIONS ----

//login

  updateNestID({String? regID}) {
    nestID = regID ?? '';
    log("NEST ID / REG NO : $nestID");
    notifyListeners();
  }

  updatePassword({String? pass}) {
    password = pass ?? '';
    log("PASSWORD : $password");
    notifyListeners();
  }

//login close

// login via opt section ----------
  updateOtpValue({String otp = ""}) {
    otpValue = otp;
    log(otpValue);
    notifyListeners();
  }

  updateMobileNo({String mobile = ""}) {
    mobileNo = mobile;
    log(mobileNo);
    notifyListeners();
  }

  updateEmailId(String emailId) {
    email = emailId;
    notifyListeners();
  }

  updateCountryData(val) {
    countryData = val;

    maxLength = countryData?.maxLength ?? 30;
    minLength = countryData?.minLength ?? 5;
    countryId = countryData?.id ?? 1;
    notifyListeners();
  }

  int currentIndex = 0;

  void updateCurrentIndex(int val) {
    currentIndex = val;
    notifyListeners();
  }

  void validateEmailAddress(String val) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(val)) {
      isEmailValid = true;
    } else {
      isEmailValid = false;
    }
    notifyListeners();
  }

  void updateErrorType(String value) {
    errorType = value;
    notifyListeners();
  }

  clearErrorMsg() {
    errorMsg = "";
    // forgetPasswordErrorMsg = '';
    notifyListeners();
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
    super.updateBtnLoader(val);
  }

  /* updateButtonState(bool val) {
    buttonLoading = val;
    notifyListeners();
  }  

  updateLoginButtonState(bool val) {
    loginButtonLoading = val;
    notifyListeners();
  }

  updateOtploadingState(bool val) {
    otpLoading = val;
    notifyListeners();
  }*/
// login via opt section close ----------

//build version
  BuildVersionModel? buildversionData;
  Future<void> getBuildVersion({Function? onSuccess}) async {
    // updateBtnLoader(true);
    var res = await serviceConfig.getBuildVersionDetails();
    if (res.isValue) {
      buildversionData = res.asValue?.value;
      log("SUCCESS : ${buildversionData?.data?.latestAndroidVersion}");
      if (onSuccess != null) onSuccess();
      // updateBtnLoader(false);
    } else {
      if (res.asError?.error is ResponseModel) {
        ResponseModel errorRes = res.asError?.error as ResponseModel;
        errorMsg = errorRes.errors?.mobile ?? '';
        log(errorMsg);
        // updateBtnLoader(false);
      } else {
        debugPrint('Exceptions');
        // updateBtnLoader(false);
        //All exceptions
      }
    }
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {}

  obscureChange() {
    obscured = !obscured;
    notifyListeners();
  }

  passWordObscureChange() {
    passwordObscured = !passwordObscured;
    notifyListeners();
  }

  void updateNavFrom(String? val) {
    navFrom = val ?? RouteGenerator.routeMainScreen;
    notifyListeners();
  }
  // MINI FUNCTIONS CLOSE
}
