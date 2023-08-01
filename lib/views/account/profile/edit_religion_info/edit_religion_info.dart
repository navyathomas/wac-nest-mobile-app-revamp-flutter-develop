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
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_religion_info/widgets/caste_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_religion_info/widgets/religion_bottom_sheet.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../utils/color_palette.dart';

class EditReligionInfo extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditReligionInfo({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditReligionInfo> createState() => _EditReligionInfoState();
}

class _EditReligionInfoState extends State<EditReligionInfo> {
  @override
  void initState() {
    initData();
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
          context.loc.religionInfo,
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
                  onTap: value ? () => updateReligionInfo() : null,
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
                      const ReligionBottomSheet(),
                      const CasteBottomSheet(),
                      12.verticalSpace,
                      CommonTextField(
                        labelText: context.loc.subCaste,
                        controller: account.subCasteController,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          account.changeReligionButtonState(context);
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

  void initData() {
    CommonFunctions.afterInit(() {
      final appData = Provider.of<AppDataProvider>(context, listen: false);
      final accountData = Provider.of<AccountProvider>(context, listen: false);
      final profileData = Provider.of<ProfileProvider>(context, listen: false);
      profileData.changeDoneBtnActiveState(false);
      accountData.subCasteController.text = widget.basicDetails?.subCaste ?? '';
      appData.getReligionList();
      accountData.getCasteDataList(context: context);
    });
  }

  void updateReligionInfo() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final account = Provider.of<AccountProvider>(context, listen: false);
    ReligionInfoRequest religionInfoRequest = ReligionInfoRequest(
        profileId: widget.basicDetails?.id ?? 0,
        caste: account.casteData?.id,
        religion: account.religionListData?.id,
        subCaste: account.subCasteController.text);
    profile.updateReligionInfo(religionInfoRequest, context, onSuccess: () {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    });
  }
}
