import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class EditAboutMe extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditAboutMe({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditAboutMe> createState() => _EditAboutMeState();
}

class _EditAboutMeState extends State<EditAboutMe> {
  @override
  void initState() {
    CommonFunctions.afterInit(
        () => context.read<ProfileProvider>().changeDoneBtnActiveState(false));
    prefillAboutMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.loc.aboutMe,
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.5,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
        actions: [
          ValueListenableBuilder<bool>(
              valueListenable: profile.enableBtn,
              builder: (BuildContext context, bool value, Widget? child) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: value ? () => updateAboutMe() : null,
                  child: Padding(
                    padding: EdgeInsets.only(right: 21.w, left: 21.w),
                    child: Center(
                        child: Text("Done",
                            style: FontPalette.f565F6C16Bold.copyWith(
                                fontSize: 15.sp,
                                color: value
                                    ? ColorPalette.primaryColor
                                    : HexColor("#8695A7")))),
                  ),
                );
              }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProfileProvider>(builder: (context, value, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: StackLoader(
            inAsyncCall: value.loaderState == LoaderState.loading,
            child: SizedBox(
              width: context.sw(),
              height: context.sh(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      25.verticalSpace,
                      titles(title: context.loc.aboutMe),
                      10.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.aboutMe,
                        controller: value.aboutMeController,
                        isAddress: true,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            value.changeDoneBtnActiveState(true);
                          } else {
                            value.changeDoneBtnActiveState(false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget titles({String? title}) {
    return Text(title ?? "",
        style:
            FontPalette.f131A24_16Bold.copyWith(color: HexColor("##131A24")));
  }

  void prefillAboutMe() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    profile.aboutMeController.text =
        Helpers.capitaliseFirstLetter(widget.basicDetails?.userIntro ?? '');
  }

  void updateAboutMe() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());
    profile.updateAboutMe(profile.aboutMeController.text,
        widget.basicDetails?.id.toString() ?? '', context, onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
