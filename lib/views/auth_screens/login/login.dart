import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/firebase_analytics_services.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';

class Login extends StatefulWidget {
  final NavFrom? navFrom;
  const Login({Key? key, this.navFrom}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color get loginViaTextColor => const Color(0xFF131A24);
  Color get forgetTextColor => const Color(0xFF131A24);
  final TextEditingController _controllerNESTID =
      TextEditingController(text: "");
  final TextEditingController _controllerPASS = TextEditingController(text: "");
  @override
  void initState() {
    Future.microtask(() => context.read<AuthProvider>().initAuthProvider());
    super.initState();
  }

  @override
  void dispose() {
    _controllerNESTID.dispose();
    _controllerPASS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0, leading: ReusableWidgets.roundedBackButton(context)),
        backgroundColor: Colors.white,
        body: Consumer<AuthProvider>(builder: ((context, provider, child) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  27.h.verticalSpace,
                  Text(
                    context.loc.login,
                    style: FontPalette.black30Bold,
                  ),
                  26.verticalSpace,
                  CommonTextField(
                      controller: _controllerNESTID,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[A-Z0-9]"))
                      ],
                      labelText: context.loc.registeredNumber,
                      onChanged: (val) {
                        provider.updateNestID(
                          regID: val,
                        );
                      },
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      textInputAction: TextInputAction.next),
                  12.verticalSpace,
                  CommonTextField(
                    controller: _controllerPASS,
                    isPasswordField: true,
                    labelText: context.loc.password,
                    onChanged: (val) {
                      provider.updatePassword(pass: val);
                    },
                    textInputAction: TextInputAction.go,
                    onEditingComplete: provider.nestID != "" &&
                            provider.password != ""
                        ? () {
                            FocusScope.of(context).unfocus(); // go login
                            provider.login(context, onSuccess: () {
                              provider.navFrom != RouteGenerator.routeMainScreen
                                  ? Navigator.of(context).popUntil((route) {
                                      return route.settings.name != null
                                          ? route.settings.name ==
                                              provider.navFrom
                                          : true;
                                    })
                                  : Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteGenerator.routeMainScreen,
                                      (route) => false,
                                    );
                            });
                          }
                        : null,
                  ),
                  10.verticalSpace,
                  Container(
                    width: context.sw(),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.routeForgotPassword);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                        child: Text(
                          context.loc.forgotPassword,
                          style: FontPalette.white16Bold
                              .copyWith(color: Colors.black)
                              .copyWith(color: forgetTextColor),
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  CommonButton(
                    title: context.loc.login,
                    isLoading: provider.btnLoader,
                    fontStyle:
                        FontPalette.black16Bold.copyWith(color: Colors.white),
                    onPressed: provider.nestID != "" && provider.password != ""
                        ? () {
                            // go login
                            debugPrint("login");
                            FocusScope.of(context).unfocus();
                            provider.login(context, onSuccess: () {
                              provider.navFrom != RouteGenerator.routeMainScreen
                                  ? Navigator.of(context).popUntil((route) {
                                      return route.settings.name != null
                                          ? route.settings.name ==
                                              provider.navFrom
                                          : true;
                                    })
                                  : Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteGenerator.routeMainScreen,
                                      (route) => false,
                                    );
                              FirebaseAnalyticsService.instance
                                  .loginUser("Normal Login");
                            });
                          }
                        : null,
                  ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      context
                          .read<RegistrationProvider>()
                          .updateCountryData(indianData);
                      Navigator.pushNamed(
                          context, RouteGenerator.routeRegistrationScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      width: context.sw(),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: context.loc.newUser,
                          style: FontPalette.black16SemiBold,
                          children: <TextSpan>[
                            TextSpan(
                                text: " ${context.loc.registerNowItsFree}",
                                style: FontPalette.black16SemiBold.copyWith(
                                    color: ColorPalette.primaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  53.verticalSpace,
                  Container(
                    width: context.sw(),
                    alignment: Alignment.center,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _controllerNESTID.clear();
                        _controllerPASS.clear();
                        Navigator.pushNamed(
                            context, RouteGenerator.routeLoginViaOTP);
                      },
                      child: Padding(
                        //extra height added here ⬇️ , total height 73 (now : 63+10) => for tap efficiency
                        padding: EdgeInsets.all(10.h),
                        child: Text(
                          context.loc.loginViaOTP,
                          style: FontPalette.white16Bold.copyWith(
                            color: loginViaTextColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        })));
  }
}
