import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/widgets/education_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/widgets/occupation_bottom_sheet.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class EditProfessionalDetails extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditProfessionalDetails({Key? key, this.basicDetails})
      : super(key: key);

  @override
  State<EditProfessionalDetails> createState() =>
      _EditProfessionalDetailsState();
}

class _EditProfessionalDetailsState extends State<EditProfessionalDetails> {
  TextEditingController educationDetailController = TextEditingController();
  TextEditingController jobDetailController = TextEditingController();

  @override
  void initState() {
    fetchData();
    prefillDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.loc.professionalInfo,
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
          Consumer<ProfileProvider>(builder: (context, value, child) {
            return ValueListenableBuilder<bool>(
                valueListenable: value.enableBtn,
                builder: (BuildContext context, bool value, Widget? child) {
                  return IconButton(
                    iconSize: 55.w,
                    onPressed:
                        value ? () => updateProfessionalInfoInfo() : null,
                    icon: Text("Done",
                        style: FontPalette.f565F6C16Bold.copyWith(
                            fontSize: 15.sp,
                            color: value
                                ? ColorPalette.primaryColor
                                : HexColor("#8695A7"))),
                  );
                });
          }),
        ],
      ),
      body: Consumer2<ProfileProvider, AccountProvider>(
          builder: (context, value, account, child) {
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
                      const EducationBottomSheet(),
                      12.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.educationDetail,
                        controller: educationDetailController,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            value.educationDetailOnChanged(true);
                          } else {
                            value.educationDetailOnChanged(false);
                          }
                        },
                      ),
                      const OccupationBottomSheet(),
                      12.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.jobDetail,
                        controller: jobDetailController,
                        keyboardType: TextInputType.text,
                        isPasswordField: false,
                        onChanged: (val) {
                          if (val.trim().isNotEmpty) {
                            value.jobDetailOnChanged(true);
                          } else {
                            value.jobDetailOnChanged(false);
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

  void fetchData() {
    CommonFunctions.afterInit(() {
      context.read<SearchFilterProvider>()
        ..pageInit()
        ..fetchFromAppData(context);
      context.read<ProfileProvider>()
        ..changeDoneBtnActiveState(false)
        ..clearEducationStateButton();
      context.read<AccountProvider>()
        ..clearTempSelectedData()
        ..reAssignTempToEducationCatData()
        ..reAssignTempToJobCatData();
    });
  }

  void prefillDetails() {
    if (widget.basicDetails != null) {
      educationDetailController.text = Helpers.capitaliseFirstLetter(
          widget.basicDetails?.educationalInfo ?? '');
      jobDetailController.text =
          Helpers.capitaliseFirstLetter(widget.basicDetails?.jobInfo ?? '');
    } else {
      CommonFunctions.afterInit(() {
        context.read<AccountProvider>().fetchProfile(context).then((value) {
          if (value) {
            educationDetailController.text = Helpers.capitaliseFirstLetter(
                context.read<AccountProvider>().profile?.educationalInfo ?? '');
            jobDetailController.text = Helpers.capitaliseFirstLetter(
                context.read<AccountProvider>().profile?.jobInfo ?? '');
          }
        });
      });
    }
  }

  void updateProfessionalInfoInfo() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final account = Provider.of<AccountProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());
    ProfessionalInfoRequest professionalRequest = ProfessionalInfoRequest(
        profileId: widget.basicDetails?.id ?? account.profile?.id ?? 0,
        educationCategory: account.tempSelectedEducation.isNotEmpty
            ? account.tempSelectedEducation.values.first
            : null,
        educationDetail: educationDetailController.text,
        jobCategory: account.tempSelectedChildParentJob.isNotEmpty
            ? account.tempSelectedChildParentJob.values.first
            : null,
        jobDetail: jobDetailController.text,
        educationParentId: account.tempSelectedEducation.isNotEmpty
            ? account.tempSelectedEducation.keys.first
            : null,
        jobParentId: account.tempSelectedChildParentJob.isNotEmpty
            ? account.tempSelectedChildParentJob.keys.first
            : null);
    profile.updateProfessionalInfo(professionalRequest, context, onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
