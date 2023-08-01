import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class EditFamilyDetails extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditFamilyDetails({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditFamilyDetails> createState() => _EditFamilyDetailsState();
}

class _EditFamilyDetailsState extends State<EditFamilyDetails> {
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherJobController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController motherJobController = TextEditingController();
  TextEditingController siblingDetailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  void initState() {
    CommonFunctions.afterInit(prefillDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.loc.familyDetails,
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.3,
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
                  onTap: value ? () => updateFamilyDetails() : null,
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
                      24.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.fathersName,
                        controller: fatherNameController,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            profile.fatherNameOnChanged(true);
                          } else {
                            profile.fatherNameOnChanged(false);
                          }
                        },
                      ),
                      21.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.fathersJob,
                        controller: fatherJobController,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            profile.fatherJobOnChanged(true);
                          } else {
                            profile.fatherJobOnChanged(false);
                          }
                        },
                      ),
                      21.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.mothersName,
                        controller: motherNameController,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            profile.motherNameOnChanged(true);
                          } else {
                            profile.motherNameOnChanged(false);
                          }
                        },
                      ),
                      21.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.mothersJob,
                        controller: motherJobController,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            profile.motherJobOnChanged(true);
                          } else {
                            profile.motherJobOnChanged(false);
                          }
                        },
                      ),
                      21.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.siblingDetails,
                        controller: siblingDetailController,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            profile.siblingOnChanged(true);
                          } else {
                            profile.siblingOnChanged(false);
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

  void prefillDetails() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    profile.changeDoneBtnActiveState(false);
    profile.clearStateButton();
    fatherNameController.text = Helpers.capitaliseFirstLetter(
        widget.basicDetails?.userFamilyInfo?.fatherName ?? '');
    fatherJobController.text = Helpers.capitaliseFirstLetter(
        widget.basicDetails?.userFamilyInfo?.fatherJob ?? '');
    motherNameController.text = Helpers.capitaliseFirstLetter(
        widget.basicDetails?.userFamilyInfo?.motherName ?? '');
    motherJobController.text = Helpers.capitaliseFirstLetter(
        widget.basicDetails?.userFamilyInfo?.motherJob ?? '');
    siblingDetailController.text = Helpers.capitaliseFirstLetter(
        widget.basicDetails?.userFamilyInfo?.sibilingsInfo ?? '');
  }

  void updateFamilyDetails() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());
    FamilyDetailsRequest familyDetailsRequest = FamilyDetailsRequest(
        profileId: widget.basicDetails?.id.toString() ?? '',
        fatherName: fatherNameController.text,
        fatherJob: fatherJobController.text,
        motherName: motherNameController.text,
        motherJob: motherJobController.text,
        siblingDetails: siblingDetailController.text);
    profile.updateFamilyDetails(familyDetailsRequest, context, onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
