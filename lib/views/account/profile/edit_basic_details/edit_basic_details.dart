import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_basic_details/widgets/body_type_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_basic_details/widgets/height_wheel_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_basic_details/widgets/marital_status_bottom_sheet.dart';
import 'package:nest_matrimony/views/account/profile/edit_basic_details/widgets/profile_created_bottom_sheet.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../common/constants.dart';
import 'widgets/complexion_bottom_sheet.dart';

class EditBasicDetails extends StatefulWidget {
  final BasicDetails? basicDetails;
  final bool isFromEdit;
  const EditBasicDetails({Key? key, this.basicDetails, this.isFromEdit = true})
      : super(key: key);

  @override
  State<EditBasicDetails> createState() => _EditBasicDetailsState();
}

class _EditBasicDetailsState extends State<EditBasicDetails> {
  FixedExtentScrollController controller =
      FixedExtentScrollController(initialItem: 0);
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  String? name;
  String? gender;
  String? dob;

  Widget shadowWidget({bool bottom = true}) {
    return Container(
      height: 120.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: bottom ? Alignment.bottomCenter : Alignment.topCenter,
              end: bottom ? Alignment.topCenter : Alignment.bottomCenter,
              colors: const [
            Colors.white,
            Colors.white10,
          ])),
    );
  }

  @override
  void initState() {
    prefillDetails();
    init();
    selectedIndex.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Basic Details',
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
      body: Consumer<AccountProvider>(
        builder: (context, value, child) {
          return StackLoader(
            inAsyncCall:
                value.loaderState == LoaderState.loading ? true : false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    CustomOptionBtn(
                      title: "Name",
                      selectedValue: Helpers.capitaliseFirstLetter(name ?? ''),
                      marginTop: 0.h,
                    ),
                    CustomOptionBtn(
                      title: "Gender",
                      selectedValue: gender ?? '',
                    ),
                    CustomOptionBtn(
                      title: "Date of birth",
                      selectedValue: dob ?? '',
                    ),
                    MaritalStatusBottomSheet(contexts: context),
                    HeightWheelBottomSheet(
                        selectedIndex: selectedIndex, contexts: context),
                    ProfileCreatedBottomSheet(contexts: context),
                    BodyTypeBottomSheet(contexts: context),
                    ComplexionBottomSheet(contexts: context),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void init() {
    Future.microtask(() {
      context.read<AppDataProvider>().getBodyTypeList();
      context.read<AppDataProvider>().getComplexionList();
    });
  }

  void prefillDetails() {
    if (widget.basicDetails != null) {
      name = widget.basicDetails?.name ?? '';
      gender = widget.basicDetails?.gender ?? '';
      dob = widget.basicDetails?.dateOfBirth != null
          ? formatter.format(widget.basicDetails!.dateOfBirth!)
          : "";
    } else {
      CommonFunctions.afterInit(() {
        context.read<AccountProvider>().fetchProfile(context).then((value) {
          if (value) {
            name = context.read<AccountProvider>().profile?.name ?? '';
            gender = context.read<AccountProvider>().profile?.gender ?? '';
            dob = context.read<AccountProvider>().profile?.dateOfBirth != null
                ? formatter.format(
                    context.read<AccountProvider>().profile!.dateOfBirth!)
                : "";
          }
        });
      });
    }
  }
}
