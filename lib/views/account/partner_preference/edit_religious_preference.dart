import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_cast_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_religious_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_prefernce_jathakam_btn.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_textfield.dart';
import '../../../widgets/reusable_widgets.dart';

class EditReligiousPreference extends StatefulWidget {
  const EditReligiousPreference({Key? key}) : super(key: key);

  @override
  State<EditReligiousPreference> createState() =>
      _EditReligiousPreferenceState();
}

class _EditReligiousPreferenceState extends State<EditReligiousPreference> {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      getFilterValues();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Religious preference',
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
                      PartnerPreferenceReligionBtn(),
                      // 8.verticalSpace,
                      PartnerPreferenceCasteBtn(),
                      15.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.subCaste,
                        controller: value.subCasteController,
                        keyboardType: TextInputType.text,
                        onSubmitted: (p0) =>
                            context.read<PartnerPreferenceProvider>()
                              ..setReligiousPreferenceParam(context)
                              ..saveReligiousPreference(context),
                        // onChanged: (val) {
                        //   profile.familyDetailsEnableBtn();
                        // },
                      ),
                      value.searchFilterValueModel?.religionListData?.id == 2
                          ? PartnerPreferenceJathakamTypeBtn()
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<void> getFilterValues() async {
    var data = context.read<AccountProvider>().partnerPreferenceData?.data!;
    if (!context.read<PartnerPreferenceProvider>().isReligiousFilterApplied) {
      if (data!.casteUnserialize != null && data.casteUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.casteUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedFilterCaste(
              int.parse(data.casteUnserializeId![i]),
              data.casteUnserialize![i]);
        }
        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedFilterCaste();
      }
      if (data.preferJathakamTypeUnserialize != null &&
          data.preferJathakamTypeUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.preferJathakamTypeUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedJathakam(
              int.parse(data.preferJathakamTypeUnserializeId![i]),
              data.preferJathakamTypeUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToJathakam();
      }
      context.read<PartnerPreferenceProvider>()
        ..updateReligionData(data.religions, isFromSearch: false)
        ..getCasteDataList(isFromSearch: false);
      context.read<PartnerPreferenceProvider>().subCasteController.text =
          data.subCaste ?? '';
      context.read<PartnerPreferenceProvider>().isReligiousFilterApplied = true;
    }
  }
}
