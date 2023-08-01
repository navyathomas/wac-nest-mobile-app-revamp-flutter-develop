import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/firebase_analytics_services.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/views/auth_screens/registration/otp_verification/otp_verification_screen.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../widgets/reusable_widgets.dart';

class AuthOtpScreen extends StatefulWidget {
  final NavFrom navFrom;
  const AuthOtpScreen({Key? key, this.navFrom = NavFrom.navFromLogin})
      : super(key: key);

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0, leading: ReusableWidgets.roundedBackButton(context)),
        body: Consumer2<AuthProvider, ProfileProvider>(
          builder: (_, provider, profile, child) {
            return OtpVerificationScreen(
              onTap: (BuildContext context) {
                Navigator.pop(context);
              },
              enableLoader: provider.btnLoader,
              mobileNumber: provider.countryData?.dialCode != null
                  ? "${provider.countryData!.dialCode} ${provider.mobileNo}"
                  : "+91 ${provider.mobileNo}",
              email: provider.email,
              enableError: provider.errorMsg != "" ? true : false,
              onComplete: (context, val) {
                widget.navFrom == NavFrom.navFromContact
                    ? profile.changeMobileVerify(context, onSuccess: () {
                        Navigator.of(context).pop();
                      })
                    : widget.navFrom == NavFrom.navFromForgot
                        ? provider.forgotPasswordVerifyOtp(context,
                            onSuccess: () {
                            Navigator.pushReplacementNamed(
                                    context, RouteGenerator.routeResetPassword)
                                .then((value) {
                              provider.updateErrorMessage('');
                              SharedPreferenceHelper.clearData();
                            });
                          })
                        : provider.verifyLoginViaOTP(context, onSuccess: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteGenerator.routeMainScreen,
                                (route) => false,
                                arguments: RouteArguments(tabIndex: 0));
                            FirebaseAnalyticsService.instance
                                .loginUser("Login Via OTP");
                          });
              },
              onResendTap: () {
                widget.navFrom == NavFrom.navFromForgot
                    ? provider.forgetPasswordOtpRequest(context)
                    : provider.postLoginViaOTP(context);
              },
              onChange: (val) {
                provider
                  ..updateErrorMessage('')
                  ..updateOtpValue(otp: val);
              },
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            );
          },
        ));
  }
}
