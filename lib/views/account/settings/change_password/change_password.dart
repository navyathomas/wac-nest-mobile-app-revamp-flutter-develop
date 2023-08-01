import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/auth_screens/forgot_password/password_textfield.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../services/hive_services.dart';

class ChangePassword extends StatelessWidget {
  final String? appbarTitle;
  const ChangePassword({Key? key, this.appbarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> enablebtn = ValueNotifier<bool>(false);
    TextEditingController? controllerCurrentPassword =
        TextEditingController(text: "");
    final TextEditingController passwordController =
        TextEditingController(text: "");
    final TextEditingController confirmpasswordcontroller =
        TextEditingController(text: "");
    void enableButton() {
      passwordController.text == "" ||
              confirmpasswordcontroller.text == "" ||
              controllerCurrentPassword.text == ""
          ? enablebtn.value = false
          : enablebtn.value = true;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appbarTitle ?? 'App_title',
            style: FontPalette.white16Bold
                .copyWith(color: const Color.fromARGB(255, 78, 64, 64)),
          ),
          elevation: 0.0,
          leading: ReusableWidgets.roundedBackButton(context),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
        ),
        body: SingleChildScrollView(
          child: ValueListenableBuilder<bool>(
              valueListenable: enablebtn,
              builder: (BuildContext context, bool value, Widget? child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      25.verticalSpace,
                      PasswordTextField(
                        onChanged: (p0) => enableButton(),
                        controller: controllerCurrentPassword,
                        showSuffix: false,
                        isPasswordField: true,
                        labelText: "Current password",
                      ),
                      12.verticalSpace,
                      PasswordTextField(
                        onChanged: (p1) => enableButton(),
                        controller: passwordController,
                        showSuffix: false,
                        isPasswordField: true,
                        labelText: "New password",
                      ),
                      12.verticalSpace,
                      PasswordTextField(
                        onChanged: (p2) => enableButton(),
                        controller: confirmpasswordcontroller,
                        showSuffix: true,
                        isPasswordField: true,
                        labelText: "Confirm password",
                      ),
                      21.verticalSpace,
                      Consumer<AuthProvider>(
                        builder: (context, provider, child) => CommonButton(
                          title: "Submit",
                          isLoading: provider.btnLoader,
                          onPressed: value
                              ? () {
                                  if (passwordController.text ==
                                      confirmpasswordcontroller.text) {
                                    context.read<AuthProvider>().changePassword(
                                        current: controllerCurrentPassword.text,
                                        newPass: passwordController.text,
                                        confirmPass:
                                            confirmpasswordcontroller.text,
                                        onSuccess: () async {
                                          ReusableWidgets.customCircularLoader(
                                              context);
                                          SharedPreferenceHelper.clearData();
                                          await HiveServices
                                              .removeDataFromLocal(
                                                  HiveServices.basicDetails);
                                          Future.microtask(() {
                                            context.rootPop;
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                RouteGenerator.routeAuthScreen,
                                                (route) => false);
                                          });
                                        });
                                  } else {
                                    Helpers.successToast(
                                        "New password and Confirm Password not matched");
                                  }
                                }
                              : null,
                          fontStyle: FontPalette.white16Bold,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
