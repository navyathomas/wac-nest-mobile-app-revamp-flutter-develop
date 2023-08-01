import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_age_wheel_from.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_body_type_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_complexion_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_height_wheel_to.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_prefernce_age_wheel_to.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_prefernce_height_wheel_from.dart';
import 'package:nest_matrimony/views/account/partner_preference/partrner_preferences_maritial_status_buton.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_marital_status_btn.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';

class EditBasicPreference extends StatefulWidget {
  const EditBasicPreference({Key? key}) : super(key: key);

  @override
  State<EditBasicPreference> createState() => _EditBasicPreferenceState();
}

class _EditBasicPreferenceState extends State<EditBasicPreference> {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  @override
  void initState() {
    selectedIndex.value = 0;
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
            'Basic preference',
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
                      PartnerPreferenceAgeWheelFrom(
                          context: context,
                          selectedIndex: selectedIndex,
                          title: 'Partner’s age from'),
                      PartnerPreferenceAgeWheelTo(
                        context: context,
                        selectedIndex: selectedIndex,
                        title: 'Partner’ age to',
                      ),
                      PartnerPreferenceHeightWheelFrom(
                        context: context,
                        selectedIndex: selectedIndex,
                        title: 'Partner’ height from',
                      ),
                      PartnerPreferenceHeightWheelTo(
                        context: context,
                        selectedIndex: selectedIndex,
                        title: 'Partner’ height to',
                      ),
                      PartnerPreferenceBodyTypeBtn(),
                      PartnerPreferenceComplexionTypeBtn(),
                      PartnerPreferenceMaritalStatusBtn(),
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
    if (!context.read<PartnerPreferenceProvider>().isFilterApplied) {
      if (data!.bodyTypesUnserialize != null &&
          data.bodyTypesUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.bodyTypesUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedBodyType(
              int.parse(data.bodyTypesUnserializeId![i]),
              data.bodyTypesUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToBodyType();
      }
      if (data.complexionUnserialize != null &&
          data.complexionUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.complexionUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedComplexion(
              int.parse(data.complexionUnserializeId![i]),
              data.complexionUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToComplexion();
      }
      if (data.maritalStatusUnserialize != null &&
          data.maritalStatusUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.maritalStatusUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedMaritalStatus(
              int.parse(data.maritalStatusUnserializeId![i]),
              data.maritalStatusUnserialize![i]);
        }
        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedMartialStatus();
      }
      context.read<PartnerPreferenceProvider>().isFilterApplied = true;
    }
  }
}
