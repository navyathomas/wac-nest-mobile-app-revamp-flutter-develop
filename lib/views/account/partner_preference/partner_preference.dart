import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/partner_preference_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../error_views/common_error_view.dart';

class PartnerPreferenceScreen extends StatefulWidget {
  const PartnerPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceScreen> createState() =>
      _PartnerPreferenceScreenState();
}

class _PartnerPreferenceScreenState extends State<PartnerPreferenceScreen> {
  Data? data;
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    Future.microtask(() {
      String userID = context
              .read<AppDataProvider>()
              .basicDetailModel
              ?.basicDetail
              ?.id
              ?.toString() ??
          "";
      context
          .read<AccountProvider>()
          .getPartnerPreference(context, profileId: userID);
    });
    CommonFunctions.afterInit(() {
      context.read<PartnerPreferenceProvider>().fetchFromAppData(context);
      context
          .read<PartnerPreferenceProvider>()
          .getMaritalStatusDataList(isFromSearch: false);
      context
          .read<PartnerPreferenceProvider>()
          .getBodyType(isFromSearch: false);
      context
          .read<PartnerPreferenceProvider>()
          .getComplexion(isFromSearch: false);
      context
          .read<PartnerPreferenceProvider>()
          .getJathakam(isFromSearch: false);
    });
  }

  basicPreferenceFunction() {
    context.read<PartnerPreferenceProvider>().clearBasicPreference();
    context.read<PartnerPreferenceProvider>().isFilterApplied = false;
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().getPartnerPreference(context);
    });
  }

  professionalPreference() {
    context.read<PartnerPreferenceProvider>().clearProfessionalPreference();
    context.read<PartnerPreferenceProvider>().isProfessionalFilterApplied =
        false;
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().getPartnerPreference(context);
    });
  }

  religiousPreferenceFunction() {
    context.read<PartnerPreferenceProvider>().clearReligiousPreference();
    context.read<PartnerPreferenceProvider>().isReligiousFilterApplied = false;
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().getPartnerPreference(context);
    });
  }

  locationPreferenceFunction() {
    context.read<PartnerPreferenceProvider>().clearLocationPreference();
    context.read<PartnerPreferenceProvider>().isLocationFilterApplied = false;
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().getPartnerPreference(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Partner Preference',
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
        builder: (context, pro, child) {
          return switchView(pro);
        },
      ),
    );
  }

  switchView(AccountProvider provider) {
    print(provider.loaderState);
    Widget child = const SizedBox.shrink();
    switch (provider.loaderState) {
      case LoaderState.loaded:
        data = provider.partnerPreferenceData?.data;
        child = _mainView();
        break;
      case LoaderState.loading:
        child = Center(child: ReusableWidgets.circularIndicator());
        break;
      case LoaderState.error:
        child = CommonErrorView(
          error: Errors.serverError,
          onTap: () => init(),
        );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => init(),
        );
        break;
      case LoaderState.noData:
        child = CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => init(),
        );
        break;
    }
    return child;
  }

  _mainView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          25.24.verticalSpace,
          ReusableWidgets.titleHeads(
              titleHead: "Basic Preference",
              onEditTap: () => Navigator.pushNamed(
                          context, RouteGenerator.routeEditBasicPreference)
                      .then((value) {
                    basicPreferenceFunction();
                  })),
          25.88.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Partner’s age from",
              trailingText: (data?.fromAge?.age.toString() ?? '').isNotEmpty
                  ? data?.fromAge?.age.toString() ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Partner’ age to",
              trailingText: (data?.toAge?.age.toString() ?? '').isNotEmpty
                  ? data?.toAge?.age.toString() ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Partner’ height from",
              trailingText:
                  (data?.fromHeight?.height.toString() ?? '').isNotEmpty
                      ? data?.fromHeight?.height.toString() ?? ''
                      : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Partner’ height to",
              trailingText: (data?.toHeight?.height.toString() ?? '').isNotEmpty
                  ? data?.toHeight?.height.toString() ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Body Type",
              trailingText: (data?.bodyTypesUnserialize != null) &&
                      (data!.bodyTypesUnserialize!.isNotEmpty)
                  ? data?.bodyTypesUnserialize?.join(", ") ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Complexion",
              trailingText: (data?.complexionUnserialize != null) &&
                      (data!.complexionUnserialize!.isNotEmpty)
                  ? data?.complexionUnserialize?.join(", ") ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditBasicPreference)
                    .then((value) => basicPreferenceFunction());
              },
              leadingText: "Marital Status",
              trailingText: (data?.maritalStatusUnserialize != null) &&
                      (data!.maritalStatusUnserialize!.isNotEmpty)
                  ? data?.maritalStatusUnserialize?.join(", ") ?? ''
                  : null),
          22.88.verticalSpace,
          ReusableWidgets.horizontalLine(),
          21.verticalSpace,
          ReusableWidgets.titleHeads(
            titleHead: "Professional Preferences",
            onEditTap: () => Navigator.pushNamed(
                    context, RouteGenerator.routeEditProfessionalPreference)
                .then((value) {
              professionalPreference();
            }),
          ),
          25.88.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditProfessionalPreference)
                    .then((value) => professionalPreference());
              },
              leadingText: "Education Category",
              trailingText: (data?.educationCategoryUnserialize != null) &&
                      (data!.educationCategoryUnserialize!.isNotEmpty)
                  ? data?.educationCategoryUnserialize?.join(", ") ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditProfessionalPreference)
                    .then((value) => professionalPreference());
              },
              leadingText: "Education Detail",
              trailingText: (data?.educationInfo?.toString() ?? '').isNotEmpty
                  ? data?.educationInfo ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditProfessionalPreference)
                    .then((value) => professionalPreference());
              },
              leadingText: "Job Category",
              trailingText: (data?.jobCategoryUnserialize != null) &&
                      (data!.jobCategoryUnserialize!.isNotEmpty)
                  ? data?.jobCategoryUnserialize?.join(",") ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () {
                Navigator.pushNamed(
                        context, RouteGenerator.routeEditProfessionalPreference)
                    .then((value) => professionalPreference());
              },
              leadingText: "Job Detail",
              trailingText: (data?.jobInfo?.toString() ?? '').isNotEmpty
                  ? data?.jobInfo ?? ''
                  : null),
          23.verticalSpace,
          ReusableWidgets.horizontalLine(),
          20.88.verticalSpace,
          ReusableWidgets.titleHeads(
            titleHead: "Religious Preferences",
            onEditTap: () => Navigator.pushNamed(
                    context, RouteGenerator.routeEditReligiousPreference)
                .then((value) {
              religiousPreferenceFunction();
            }),
          ),
          25.88.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditReligiousPreference)
                  .then((value) => religiousPreferenceFunction()),
              leadingText: "Religion",
              trailingText:
                  (data?.religions?.religionName?.toString() ?? '').isNotEmpty
                      ? data?.religions?.religionName ?? ''
                      : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditReligiousPreference)
                  .then((value) => religiousPreferenceFunction()),
              leadingText: "Caste",
              trailingText: (data?.casteUnserialize != null) &&
                      (data!.casteUnserialize!.isNotEmpty)
                  ? data?.casteUnserialize?.join(", ") ?? ''
                  : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditReligiousPreference)
                  .then((value) => religiousPreferenceFunction()),
              leadingText: "Sub Caste",
              trailingText: (data?.subCaste?.toString() ?? '').isNotEmpty
                  ? data?.subCaste ?? ''
                  : null),
          13.verticalSpace,
          data?.religionsId == 2
              ? ReusableWidgets.keyValueText(
                  onTap: () => Navigator.pushNamed(
                          context, RouteGenerator.routeEditReligiousPreference)
                      .then((value) => religiousPreferenceFunction()),
                  leadingText: "Jathakam",
                  trailingText: (data?.preferJathakamTypeUnserialize != null) &&
                          (data!.preferJathakamTypeUnserialize!.isNotEmpty)
                      ? data?.preferJathakamTypeUnserialize?.join(", ") ?? ''
                      : null)
              : const SizedBox.shrink(),
          22.88.verticalSpace,
          ReusableWidgets.horizontalLine(),
          20.88.verticalSpace,
          ReusableWidgets.titleHeads(
            titleHead: "Location Preferences",
            onEditTap: () => Navigator.pushNamed(
                    context, RouteGenerator.routeEditLocationPreference)
                .then((value) {
              locationPreferenceFunction();
            }),
          ),
          25.88.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditLocationPreference)
                  .then((value) => locationPreferenceFunction()),
              leadingText: "Country",
              trailingText:
                  (data?.country?.countryName?.toString() ?? '').isNotEmpty
                      ? data?.country?.countryName?.toString() ?? ''
                      : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditLocationPreference)
                  .then((value) => locationPreferenceFunction()),
              leadingText: "State",
              trailingText:
                  (data?.statesUnserialize.toString() ?? '').isNotEmpty
                      ? data?.statesUnserialize?.join(", ") ?? ''
                      : null),
          13.verticalSpace,
          ReusableWidgets.keyValueText(
              onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeEditLocationPreference)
                  .then((value) => locationPreferenceFunction()),
              leadingText: "District",
              trailingText:
                  (data?.districtsUnserialize.toString() ?? '').isNotEmpty
                      ? data?.districtsUnserialize?.join(", ") ?? ''
                      : null),
          // 13.verticalSpace,
          // ReusableWidgets.keyValueText(
          //     onTap: () => Navigator.pushNamed(
          //             context, RouteGenerator.routeEditLocationPreference)
          //         .then((value) => locationPreferenceFunction()),
          //     leadingText: "Location",
          //     trailingText:
          //         (data?.locationUnserialize.toString() ?? '').isNotEmpty
          //             ? data?.locationUnserialize?.join(", ") ?? ''
          //             : null),
          50.verticalSpace,
        ],
      ),
    );
  }
}
