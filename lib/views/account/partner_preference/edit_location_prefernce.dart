import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_country_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_district_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_preference_education_categorry_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_prefernce_city_btn.dart';
import 'package:nest_matrimony/views/account/partner_preference/partner_prefernce_state_btn.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/partner_prefernce_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/reusable_widgets.dart';

class EditLocationPreference extends StatefulWidget {
  const EditLocationPreference({Key? key}) : super(key: key);

  @override
  State<EditLocationPreference> createState() => _EditLocationPreferenceState();
}

class _EditLocationPreferenceState extends State<EditLocationPreference> {
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
            'Location preferences',
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
                      const PartnerPreferenceCountryBtn(),
                      8.verticalSpace,
                      const PartnerPreferenceStateBtn(),
                      8.verticalSpace,
                      const PartnerPreferenceDistrictBtn(),
                      // 8.verticalSpace,
                      // const PartnerPreferenceCityBtn()
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
    if (!context.read<PartnerPreferenceProvider>().isLocationFilterApplied) {
      CountryData countryData = CountryData(
          id: data?.country?.id, countryName: data?.country?.countryName);
      context
          .read<PartnerPreferenceProvider>()
          .updateSelectedCountry(countryData, isFromSearch: false);

      context
          .read<PartnerPreferenceProvider>()
          .getStateList(data?.country != null ? data?.country?.id ?? 1 : 1);
      // context
      //     .read<PartnerPreferenceProvider>()
      //     .updateSelectedState(18, 'Kerala');
      // context.read<PartnerPreferenceProvider>().assignTempToSelectedState();
      if (data!.statesUnserialize != null &&
          data.statesUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.statesUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedState(
              int.parse(data.statesUnserializeId![i]),
              data.statesUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToSelectedState();
      }
      if (data.districtsUnserialize != null &&
          data.districtsUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.districtsUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedDistrict(
              int.parse(data.districtsUnserializeId![i]),
              data.districtsUnserialize![i]);
        }

        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedDistrict();
      }
      if (data.locationUnserialize != null &&
          data.locationUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.locationUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedLocation(
              int.parse(data.locationUnserializeId![i]),
              data.locationUnserialize![i]);
        }

        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedLocation();
      }

      context.read<PartnerPreferenceProvider>().isLocationFilterApplied = true;
    }
  }
}
