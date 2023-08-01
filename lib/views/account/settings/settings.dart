import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer' as msg;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/hive_services.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_data_provider.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/common_alert_view.dart';
import '../../auth_screens/registration/religion/custom_radio_tile.dart';

class Settings extends StatelessWidget {
  final String? appbarTitle;

  const Settings({Key? key, this.appbarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    double constHeight = 70; //height of titleTile in reuseWidgets
    double accountListHeight = (Constants.accountList.length * constHeight).h;
    double legalListHeight = (Constants.legalList.length * constHeight).h;

    routeToChangePassword(context, index) {
      Navigator.pushNamed(context, RouteGenerator.routeChangePassword,
          arguments: RouteArguments(title: Constants.accountList[index]));
    }

    routeToBlockedUsers(context, index) {
      Navigator.pushNamed(context, RouteGenerator.routeBlockedUsers,
          arguments: RouteArguments(title: Constants.accountList[index]));
    }

    routeToTermsAndPolicy(context, index) {
      Navigator.pushNamed(context, RouteGenerator.routeTermsAndPolicy,
          arguments: RouteArguments(
              title: Constants.legalList[index], anyValue: index == 0));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appbarTitle ?? 'Settings',
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(left: 17.w, right: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              ReusableWidgets.titleText(titleText: 'Account'),
              6.verticalSpace,
              ReusableWidgets.listGenerator(
                  list: Constants.accountList,
                  listHeight: accountListHeight,
                  onClick: (value) {
                    switch (value) {
                      case 0:
                        routeToChangePassword(context, value);
                        break;
                      case 1:
                        routeToBlockedUsers(context, value);
                        break;
                    }
                  }),
              5.5.verticalSpace,
              ReusableWidgets.horizontalLine(density: 1.h),
              35.verticalSpace,
              ReusableWidgets.titleText(titleText: "Legal"),
              6.5.verticalSpace,
              ReusableWidgets.listGenerator(
                  list: Constants.legalList,
                  listHeight: legalListHeight,
                  onClick: (value) {
                    switch (value) {
                      case 0:
                        routeToTermsAndPolicy(context, value);
                        break;
                      case 1:
                        routeToTermsAndPolicy(context, value);
                        break;
                    }
                  }),
              32.verticalSpace,
              ReusableWidgets.commonWhiteButton(
                  text: context.loc.logout,
                  buttonColor: Colors.transparent,
                  onTap: () => logoutTap(context)),
              14.verticalSpace,
              ReusableWidgets.commonWhiteButton(
                  onTap: () {
                    Future.microtask(() async =>
                        await context.read<AuthProvider>().initAuthProvider());
                    ReusableWidgets.customBottomSheet(
                      context: context,
                      child: Consumer<AuthProvider>(
                          builder: (_, pro, child) => SizedBox(
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        10.verticalSpace,
                                        Text(
                                          "Delete account",
                                          style: FontPalette.f09274D_16Bold
                                              .copyWith(
                                                  color: HexColor('#09274D')),
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          "Choose reason for deactivating",
                                          style: FontPalette.black14SemiBold
                                              .copyWith(
                                                  color: HexColor('#8695A7')),
                                        ),
                                        21.verticalSpace,
                                        // SizedBox(
                                        //   height: (60.h) * 4,
                                        //   child:
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 4,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            // physics:
                                            //     const BouncingScrollPhysics(),

                                            itemBuilder: ((context, index) {
                                              List<String> reasonList = [
                                                "Marriage fixed",
                                                "Not getting enough matches",
                                                "Prepare to search later",
                                                "Other reasons"
                                              ];
                                              return CustomRadioTile(
                                                onTap: (() =>
                                                    pro.updateselectId(
                                                        id: index,
                                                        deleteReason:
                                                            reasonList[index])),
                                                title: reasonList[index],
                                                isSelected:
                                                    pro.selectId == index
                                                        ? true
                                                        : false,
                                              );
                                            })),

                                        // ),
                                        20.verticalSpace,
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 27.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Deleting your account",
                                                style: FontPalette
                                                    .black15SemiBold
                                                    .copyWith(
                                                        color: HexColor(
                                                            '#2B2B2B')),
                                              ),
                                              19.verticalSpace,
                                              deletePolicy(
                                                  title:
                                                      "If you confirm that you want to delete your account, we will process your request within 24 hrs."),
                                              20.verticalSpace,
                                              deletePolicy(
                                                  title:
                                                      "Once your driver account is deleted, we won’t be able to restore your data anymore."),
                                              20.verticalSpace,
                                              deletePolicy(
                                                  title:
                                                      "From this point onwards, you don’t need to do anything else."),
                                              15.verticalSpace,
                                            ],
                                          ),
                                        ),
                                        15.verticalSpace,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 27.w),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  child:
                                                      _commonButton(context)),
                                              9.horizontalSpace,
                                              Flexible(
                                                child: _commonButton(
                                                  context,
                                                  border: false,
                                                  buttonColor:
                                                      HexColor("#FF5C5C"),
                                                  textColor: Colors.white,
                                                  text: "Delete account",
                                                  onTap: () {
                                                    ReusableWidgets
                                                        .customBottomSheet(
                                                      context: context,
                                                      child: Consumer<
                                                          AuthProvider>(
                                                        builder:
                                                            (_, pro, child) =>
                                                                Container(
                                                          width: context.sw(),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      27.w),
                                                          color: Colors.white,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              25.verticalSpace,
                                                              SvgPicture.asset(
                                                                  Assets
                                                                      .iconsMetroWarning),
                                                              9.58.verticalSpace,
                                                              Text(
                                                                  "Are you sure you want to delete\nyour account?",
                                                                  style: FontPalette
                                                                      .black18Bold),
                                                              14.verticalSpace,
                                                              Text(
                                                                  "This action can’t be reverted",
                                                                  style: FontPalette
                                                                      .f131A24_14Medium
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black)),
                                                              32.verticalSpace,
                                                              CommonButton(
                                                                title: "Cancel",
                                                                fontStyle: FontPalette
                                                                    .black16Bold
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white),
                                                                onPressed: (() =>
                                                                    Navigator.pop(
                                                                        context)),
                                                              ),
                                                              31.verticalSpace,
                                                              Center(
                                                                child: SizedBox(
                                                                  height: 50.h,
                                                                  width: context
                                                                      .sw(),
                                                                  child: TextButton(
                                                                      onPressed: pro.btnLoader
                                                                          ? null
                                                                          : () {
                                                                              pro.deleteAccount(onSuccess: () async {
                                                                                ReusableWidgets.customCircularLoader(context);
                                                                                SharedPreferenceHelper.clearData();
                                                                                context.read<AppDataProvider>().updateBasicDetailModel(null);
                                                                                await HiveServices.removeDataFromLocal(HiveServices.basicDetails);
                                                                                Future.microtask(() {
                                                                                  context.rootPop;
                                                                                  Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.routeAuthScreen, (route) => false);
                                                                                });
                                                                              });
                                                                            },
                                                                      child: pro.btnLoader ? SizedBox(height: 25.h, width: 25.h, child: const Center(child: CircularProgressIndicator())) : Text("Yes, Delete my account", style: FontPalette.black10Bold.copyWith(color: HexColor("#131A24"), fontSize: 17.sp))),
                                                                ),
                                                              ),
                                                              // 32.verticalSpace,  // if any problem in UI please uncomment
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        63.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    );
                  },
                  text: "Delete account",
                  textColor: HexColor("#FF4E4E"),
                  buttonColor: Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }

  Widget deletePolicy({String? title}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 5.h,
              right: 12.w,
            ),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
                color: HexColor("#8695A7"), shape: BoxShape.circle),
          ),
          Flexible(
            child: Text(
              title ?? "",
              style: FontPalette.black14Medium
                  .copyWith(color: HexColor('#2B2B2B')),
            ),
          )
        ]);
  }

  Widget _commonButton(BuildContext context,
      {VoidCallback? onTap,
      String? text,
      Color? textColor,
      Color? buttonColor,
      bool border = true}) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 52.h,
        width: 157.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            border: border
                ? Border.all(width: 1, color: HexColor("#131A24"))
                : null,
            borderRadius: BorderRadius.circular(9.r)),
        child: Text(
          text ?? "Cancel",
          style: FontPalette.black17Bold
              .copyWith(color: textColor ?? Colors.black),
        ),
      ),
    ).removeSplash();
  }

  Future<void> logoutTap(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    CommonAlertDialog.showDialogPopUp(
        barrierDismissible: false,
        context,
        CommonAlertView(
          height: 190.h,
          buttonText: context.loc.logout,
          heading: context.loc.areYouSure,
          contents: context.loc.doYouWantLogoutNow,
          onTap: () async {
            bool isInternet = await Helpers.isInternetAvailable();
            msg.log("Is internet available $isInternet");
            final status = await OneSignal.shared.getDeviceState();
            final String? osUserID = status?.userId;
            if (isInternet) {
              msg.log("id $osUserID");
              auth.logout(
                userId: osUserID,
                onSuccess: () => startLogout(context),
                onException: () => startLogout(context),
              );
            }
          },
        ));
  }

  void startLogout(BuildContext context) async {
    ReusableWidgets.customCircularLoader(context);
    SharedPreferenceHelper.clearData();
    context.read<AppDataProvider>().updateBasicDetailModel(null);
    await HiveServices.removeDataFromLocal(HiveServices.basicDetails);
    Future.microtask(() {
      context.rootPop;
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.routeAuthScreen, (route) => false);
    });
  }
}
