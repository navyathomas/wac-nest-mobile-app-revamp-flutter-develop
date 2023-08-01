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
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_horoscope_details/widgets/dasa_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_horoscope_details/widgets/janma_sista_date_picker.dart';
import 'package:nest_matrimony/views/account/profile/edit_horoscope_details/widgets/birth_time_picker.dart';
import 'package:nest_matrimony/views/account/profile/edit_horoscope_details/widgets/star_bottom_sheet.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_provider.dart';

class EditHoroscopeDetails extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditHoroscopeDetails({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditHoroscopeDetails> createState() => _EditHoroscopeDetailsState();
}

class _EditHoroscopeDetailsState extends State<EditHoroscopeDetails> {
  @override
  void initState() {
    init();
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
          context.loc.horoscopeDetails,
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
                return IconButton(
                    iconSize: 55.w,
                    onPressed: value ? () => updateHoroscopeDetails() : null,
                    icon: Text("Done",
                        style: FontPalette.f565F6C16Bold.copyWith(
                            fontSize: 15.sp,
                            color: value
                                ? ColorPalette.primaryColor
                                : HexColor("#8695A7"))));
              })
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
                      30.verticalSpace,
                      const HoroscopeTimePicker(),
                      HoroscopeDatePicker(
                        onCancel: () {
                          context.rootPop;
                          context
                              .read<ProfileProvider>()
                              .changeDoneBtnActiveState(false);
                        },
                        onSuccess: () async {
                          context
                              .read<ProfileProvider>()
                              .updateJanmaSistaDasaDate(value.dateTime);
                          context.rootPop;
                          context
                              .read<ProfileProvider>()
                              .changeDoneBtnActiveState(true);
                        },
                      ),
                      const DasaBottomSheet(),
                      15.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.dobMalayalam,
                        controller: value.malayalmDobController,
                        onChanged: (val) {
                          profile.changeDoneBtnActiveState(true);
                        },
                      ),
                      const StarBottomSheet()
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

  void init() {
    CommonFunctions.afterInit(() {
      context.read<ProfileProvider>()
        ..clearData()
        ..changeDoneBtnActiveState(false)
        ..getDashaDataList()
        ..getStarsDataList();
      prefillData();
    });
  }

  void prefillData() {
    context.read<AccountProvider>()
      ..reAssignStarOnEditBtn(context)
      ..reAssignDasaOnEditBtn(context)
      ..reAssignDobMalayalamOnEditBtn(context)
      ..reAssignJanmaSistaOnEditBtn(context);
    context.read<ProfileProvider>().reAssignBirthTimeOnEditBtn(context);
  }

  void updateHoroscopeDetails() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());
    HoroscopeDetailsRequest horoscopeDetailsRequest = HoroscopeDetailsRequest(
        birthTime: profile.birthTimeSelected,
        janmaSistaDate: profile.janmaSistaDob,
        dasa: profile.dasaData?.id ?? 0,
        dobMalayalam: profile.malayalmDobController.text,
        starRasi: profile.starData?.id.toString());
    profile.updateHoroscopeDetails(horoscopeDetailsRequest, context,
        onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
