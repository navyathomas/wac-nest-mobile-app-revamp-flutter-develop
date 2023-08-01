import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/auth_screens/forgot_password/password_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common_floating_btn.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ValueNotifier<bool> enablebtn = ValueNotifier<bool>(false);
  final ValueNotifier<String> errorMsg = ValueNotifier<String>('');
  Color get btnGreyColor => const Color(0xFFC1C9D2);
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController confirmpasswordcontroller =
      TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0, leading: ReusableWidgets.roundedBackButton(context)),
        floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: enablebtn,
            builder: (BuildContext context, bool value, Widget? child) {
              return Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return CommonFloatingBtn(
                    enableBtn: enableButton,
                    enableLoader: provider.btnLoader,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (passwordController.text !=
                          confirmpasswordcontroller.text) {
                        Helpers.successToast(context.loc.passwordShouldBeSame);
                      } else {
                        provider.resetPassword(context, onSuccess: () {
                          Navigator.popUntil(context,
                              ModalRoute.withName(RouteGenerator.routeLogin));
                        });
                      }
                    },
                  );
                },
              );
            }),
        body: SingleChildScrollView(
          child: Container(
            width: context.sw(),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Consumer<AuthProvider>(
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    37.verticalSpace,
                    Text(
                      "${context.loc.reset}\n${context.loc.password.toLowerCase()}",
                      style: FontPalette.black30Bold,
                    ),
                    26.verticalSpace,
                    26.verticalSpace,
                    PasswordTextField(
                      onChanged: (p0) {
                        enableButton;
                        value.passwordReset = p0.trim();
                        if (confirmpasswordcontroller.text.isNotEmpty &&
                            confirmpasswordcontroller.text != p0.trim()) {
                          errorMsg.value =
                              context.loc.confirmPasswordShouldBeSame;
                          value.updateErrorMessage(
                              context.loc.confirmPasswordShouldBeSame);
                        } else {
                          value.updateErrorMessage("");
                        }
                      },
                      onObscureTap: () => value.passWordObscureChange(),
                      obscureText: value.passwordObscured,
                      controller: passwordController,
                      showSuffix: true,
                      isPasswordField: true,
                      labelText: "Password",
                    ),
                    12.verticalSpace,
                    PasswordTextField(
                      onChanged: (p1) {
                        enableButton;
                        if (passwordController.text != p1.trim()) {
                          errorMsg.value =
                              context.loc.confirmPasswordShouldBeSame;
                          value.updateErrorMessage(
                              context.loc.confirmPasswordShouldBeSame);
                        } else {
                          value.updateErrorMessage("");
                        }
                        value.confirmPassword = p1.trim();
                      },
                      controller: confirmpasswordcontroller,
                      showSuffix: true,
                      isPasswordField: true,
                      labelText: "Confirm password",
                      obscureText: value.obscured,
                    ),
                    value.errorMsg != ""
                        ? Padding(
                            padding: EdgeInsets.all(3.r),
                            child: Text(
                              value.errorMsg,
                              style: FontPalette.black10Medium
                                  .copyWith(color: Colors.red),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              },
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  bool get enableButton {
    return passwordController.text == "" || confirmpasswordcontroller.text == ""
        ? enablebtn.value = false
        : enablebtn.value = true;
  }
}
