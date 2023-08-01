import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_location/widgets/city_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_location/widgets/country_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_location/widgets/district_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_location/widgets/states_bottom_sheet.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_provider.dart';

class EditLocation extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditLocation({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.loc.location,
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
                  onTap: value ? () => editLocation() : null,
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
      body: Consumer<AccountProvider>(builder: (context, value, child) {
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
                      const CountryBottomSheet(),
                      const StatesBottomSheet(),
                      const DistrictBottomSheet(),
                      const CityBottomSheet()
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

  void initData() {
    final account = Provider.of<AccountProvider>(context, listen: false);
    CountryData countryData = CountryData(id: 1, countryName: "India");
    StateData stateData = StateData(id: 18, stateName: 'Kerala');
    Future.microtask(() {
      context.read<ProfileProvider>().changeDoneBtnActiveState(false);
      if (account.countryData == null) {
        context.read<AccountProvider>().updateCountry(countryData);
        context.read<AccountProvider>().updateState(stateData);
      }
      context.read<AppDataProvider>()
        ..getStatesList(account.countryData?.id ?? 1)
        ..getDistrictList(context, account.stateData?.id ?? 18);
      context
          .read<AccountProvider>()
          .getCityData(account.districtData?.id ?? -1, context);
    });
  }

  void editLocation() {
    final profile = context.read<ProfileProvider>();
    final model = context.read<AccountProvider>();
    LocationRequest locationRequest = LocationRequest(
        profileId: widget.basicDetails?.id.toString() ?? '',
        country: model.countryData?.id ?? 0,
        state: model.stateData?.id ?? 0,
        district: model.districtData?.id ?? 0,
        location: model.cityData?.id ?? 0);
    profile.updateLocationDetails(locationRequest, context, onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
