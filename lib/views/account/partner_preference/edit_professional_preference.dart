import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_age_wheel_from.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_education_categorry_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_occupation_btn.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../../providers/partner_prefernce_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_textfield.dart';
import '../../../widgets/reusable_widgets.dart';

class EditProfessionalPreference extends StatefulWidget {
  const EditProfessionalPreference({Key? key}) : super(key: key);

  @override
  State<EditProfessionalPreference> createState() =>
      _EditProfessionalPreferenceState();
}

class _EditProfessionalPreferenceState
    extends State<EditProfessionalPreference> {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      getFilterValues();
    });
    selectedIndex.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Professional preference',
            style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
          ),
          elevation: 0.3,
          leading: ReusableWidgets.roundedBackButton(context),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
        ),
        body: Consumer<PartnerPreferenceProvider>(
          builder: (context, value, child) {
            return StackLoader(
              inAsyncCall:
                  value.loaderState == LoaderState.loading ? true : false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      8.verticalSpace,
                      const PartnerPreferenceEducationBtn(),
                      20.verticalSpace,
                      CommonTextField(
                          labelText: context.loc.educationDetail,
                          controller: value.educationDetailController,
                          keyboardType: TextInputType.text,
                          onSubmitted: (p0) =>
                              context.read<PartnerPreferenceProvider>()
                                ..setProfessionalPreferenceParam(context)
                                ..saveProfessionalPreference(context)
                          // onChanged: (val) {
                          //   profile.familyDetailsEnableBtn();
                          // },
                          ),
                      8.verticalSpace,
                      const PartnerPreferenceOccupationBtn(),
                      20.verticalSpace,
                      CommonTextField(
                          labelText: 'Job detail',
                          controller: value.jobDetailController,
                          keyboardType: TextInputType.text,
                          onSubmitted: (p0) =>
                              context.read<PartnerPreferenceProvider>()
                                ..setProfessionalPreferenceParam(context)
                                ..saveProfessionalPreference(context)
                          // onChanged: (val) {
                          //   profile.familyDetailsEnableBtn();
                          // },
                          ),
                      20.verticalSpace
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  getFilterValues() {
    var data = context.read<AccountProvider>().partnerPreferenceData?.data!;
    if (!context
        .read<PartnerPreferenceProvider>()
        .isProfessionalFilterApplied) {
      if (data!.preferredEducation != null &&
          data.preferredEducation!.isNotEmpty) {
        for (int i = 0; i < data.preferredEducation!.length; i++) {
          for (int j = 0;
              j < data.preferredEducation![i].childEducationCategory!.length;
              j++) {
            context.read<PartnerPreferenceProvider>().updateSelectedEducation(
                data.preferredEducation![i].childEducationCategory![j].id,
                data.preferredEducation![i].childEducationCategory![j]
                    .eduCategoryTitle);
            context
                .read<PartnerPreferenceProvider>()
                .updateSelectedFilterEduCatData(
                    parentId: data.preferredEducation![i].id,
                    childId: data
                        .preferredEducation![i].childEducationCategory![j].id,
                    title: data.preferredEducation![i]
                            .childEducationCategory![j].eduCategoryTitle ??
                        '');
          }
        }
        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedFilterEduCatDat();
      }
      if (data.preferedJob != null && data.preferedJob!.isNotEmpty) {
        for (int i = 0; i < data.preferedJob!.length; i++) {
          for (int j = 0;
              j < data.preferedJob![i].childJobCategory!.length;
              j++) {
            context.read<PartnerPreferenceProvider>().updateSelectedJobParent(
                data.preferedJob![i].childJobCategory![j].id,
                data.preferedJob![i].childJobCategory![j].subcategoryName);
            context
                .read<PartnerPreferenceProvider>()
                .updateSelectedFilterJobParentData(
                    parentId: data.preferedJob![i].id,
                    childId: data.preferedJob![i].childJobCategory![j].id,
                    title: data.preferedJob![i].childJobCategory![j]
                            .subcategoryName ??
                        '');
          }
        }
        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedFilterJobParentCatDat();
      }
      context.read<PartnerPreferenceProvider>().isProfessionalFilterApplied =
          true;
    }
  }
}
