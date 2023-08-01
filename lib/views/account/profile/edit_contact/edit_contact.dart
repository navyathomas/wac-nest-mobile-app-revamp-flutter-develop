// ignore_for_file: unrelated_type_equality_checks
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/place_suggestion_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/profile_request_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/map_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/account/profile/edit_contact/common_mobile_textfied.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/widgets/place_suggestion_shimmer.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/common_map_view.dart';
import '../../../../widgets/progress_indicator.dart';

class EditContact extends StatefulWidget {
  final BasicDetails? basicDetails;
  const EditContact({Key? key, this.basicDetails}) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final FocusNode focusNode = FocusNode();
  final RegistrationHandlerClass _instance = RegistrationHandlerClass();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> enableSearchClose = ValueNotifier<bool>(false);

  Color get dimBlackColor => const Color(0xFFE4E7E8);

  Color get darkGreyColor => const Color(0xFF565F6C);

  Color get btnGreyColor => const Color(0xFFC1C9D2);

  LocationProvider? model;
  final TextEditingController _searchController =
      TextEditingController(text: "");

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    _instance.initialize();
    CommonFunctions.afterInit(() {
      context.read<LocationProvider>().updateLoaderState(LoaderState.loaded);
      context.read<RegistrationProvider>().pageInit();
      context.read<ProfileProvider>().clearData();
      context.read<LocationProvider>().clearData();
      prefillData();
      checkPrimaryNoValid(enableDoneButton: false);
      checkAlternateNoValid(enableDoneButton: false);
    });
    _searchController.addListener(_onChanged);
  }

  void prefillData() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);
    if (widget.basicDetails != null) {
      RegistrationHandlerClass().whatsappNumberCtrl?.text =
          widget.basicDetails?.whatsappNo ?? '';
      profile.primaryNumberController.text = widget.basicDetails?.mobile ?? '';
      profile.alternateNumberController.text =
          widget.basicDetails?.phoneNo ?? '';

      profile.myAddress.text =
          widget.basicDetails?.userFamilyInfo?.houseAddress ?? '';
      location.selectedLoc = PlaceMarkSuggestion(
          placeName:
              "${(widget.basicDetails?.userFamilyInfo?.userLocation?.locationName ?? '').isNotEmpty ? '${widget.basicDetails?.userFamilyInfo?.userLocation?.locationName}, ' : ''}"
              "${(widget.basicDetails?.userFamilyInfo?.userDistrict?.districtName ?? '').isNotEmpty ? '${widget.basicDetails?.userFamilyInfo?.userDistrict?.districtName}, ' : ''}"
              "${widget.basicDetails?.userFamilyInfo?.userState?.stateName ?? ''}",
          lat: Helpers.convertToDouble(
              widget.basicDetails?.userFamilyInfo?.latitude),
          long: Helpers.convertToDouble(
              widget.basicDetails?.userFamilyInfo?.longitude));
    } else {
      CommonFunctions.afterInit(() {
        context.read<AccountProvider>().fetchProfile(context).then((value) {
          if (value) {
            RegistrationHandlerClass().whatsappNumberCtrl?.text =
                context.read<AccountProvider>().profile?.whatsappNo ?? '';
            profile.primaryNumberController.text =
                context.read<AccountProvider>().profile?.mobile ?? '';
            profile.alternateNumberController.text =
                context.read<AccountProvider>().profile?.phoneNo ?? '';
            profile.myAddress.text = context
                    .read<AccountProvider>()
                    .profile
                    ?.userFamilyInfo
                    ?.houseAddress ??
                '';
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _instance.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit contact info',
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
                  onTap: value ? () => editContact() : null,
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
      body: Consumer3<ProfileProvider, LocationProvider, AuthProvider>(
          builder: (context, profile, location, auth, child) {
        model = location;
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: StackLoader(
              inAsyncCall: profile.loaderState == LoaderState.loading ||
                  location.loaderState.isLoading,
              child: Selector<RegistrationProvider,
                      Tuple2<bool?, CountryData?>>(
                  selector: (context, provider) =>
                      Tuple2(provider.isNumberValid, provider.countryData),
                  builder: (context, value, child) {
                    return SizedBox(
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
                              titles(title: "WhatsApp number"),
                              10.verticalSpace,
                              CommonMobileTextField(
                                  labelText: "WhatsApp number",
                                  controller: RegistrationHandlerClass()
                                      .whatsappNumberCtrl,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                    LengthLimitingTextInputFormatter(
                                        value.item2?.maxLength ?? 10),
                                  ],
                                  showSuffix: true,
                                  isVerified: profile.isMobileVerified,
                                  onSuffixIconTap: () => verifyMobileNumber(),
                                  enableVerifyButton:
                                      profile.enableVerifyButton,
                                  onChanged: (val) {
                                    (value.item1 ?? false)
                                        ? profile.enableVerifyButtonState(true)
                                        : profile
                                            .enableVerifyButtonState(false);
                                    context.read<RegistrationProvider>()
                                      ..updatePhoneNumber(val)
                                      ..assignCountryDataIfNull(context)
                                      ..validatePhoneNumber(val);
                                    auth.updateMobileNo(mobile: val);
                                    profile.changeMobileVerifiedStatus(false);
                                  }),
                              21.verticalSpace,
                              titles(title: "Phone"),
                              10.verticalSpace,
                              CommonMobileTextField(
                                labelText: "Primary contact details",
                                isReadOnly: (widget.basicDetails?.mobile ?? '')
                                        .isNotEmpty
                                    ? true
                                    : false,
                                controller: profile.primaryNumberController,
                                keyboardType: TextInputType.number,
                                errorMsg: profile.isPrimaryValidatedErrorMsg,
                                errorBorder: profile.isPrimaryFieldValidated,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                  LengthLimitingTextInputFormatter(
                                      value.item2?.maxLength ?? 10),
                                ],
                                onChanged: (val) => checkPrimaryNoValid(),
                              ),
                              11.verticalSpace,
                              CommonMobileTextField(
                                labelText: "Alternate contact details",
                                controller: profile.alternateNumberController,
                                keyboardType: TextInputType.number,
                                errorMsg: profile.isAlternateValidatedErrorMsg,
                                errorBorder: profile.isAlternateFieldValidated,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                  LengthLimitingTextInputFormatter(
                                      value.item2?.maxLength ?? 10),
                                ],
                                onChanged: (val) => checkAlternateNoValid(),
                              ),
                              20.verticalSpace,
                              titles(title: "Address"),
                              11.verticalSpace,
                              CommonTextField(
                                labelText: "My address",
                                isAddress: true,
                                controller: profile.myAddress,
                                onChanged: (val) {
                                  profile.enableContactDoneButton(context);
                                },
                              ),
                              20.verticalSpace,
                              titles(title: "Location"),
                              11.verticalSpace,
                              (widget.basicDetails?.userFamilyInfo?.latitude !=
                                              null &&
                                          widget.basicDetails?.userFamilyInfo
                                                  ?.longitude !=
                                              null) ||
                                      location.residenceLocation != null
                                  ? _mapTile(location)
                                  : locationPickCard(),
                              20.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }),
    );
  }

  Widget locationPickCard() {
    return Container(
      height: 78.h,
      width: 343.w,
      padding: EdgeInsets.only(left: 23.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(width: 1.sp, color: HexColor("#D9DCE0"))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Residence location",
                  style: FontPalette.white16Bold
                      .copyWith(color: HexColor("#565F6C")),
                ),
              ),
              3.verticalSpace,
              Text(
                "No Location",
                style: FontPalette.black14Medium
                    .copyWith(color: HexColor("#8695A7")),
              ),
            ],
          ),
        ),
        ReusableWidgets.commonAddIconButton(
          color: Colors.amber,
          title: "Add location",
          width: 123.w,
          height: 41.h,
          onTap: () {
            (model?.isLocationEnabled ?? false)
                ? _addLocation()
                : Future.microtask(() => context
                    .read<LocationProvider>()
                    .checkLocationPermission(context,
                        requestService: true, openDeviceSetting: true));
          },
        )
      ]),
    );
  }

  Widget titles({String? title}) {
    return Text(title ?? "",
        style:
            FontPalette.f131A24_16Bold.copyWith(color: HexColor("##131A24")));
  }

  Widget currentLocation() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Future.microtask(() => context.read<LocationProvider>()
          ..clearData()
          ..clearFromSearch(false)
          ..checkLocationPermission(context));
        Navigator.pushNamed(context, RouteGenerator.routeMapScreen).then((val) {
          if ((val != null && val == true)) {
            context.rootPop;
          }
        });
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 26.41.w),
        child: Row(
          children: [
            SvgPicture.asset(Assets.iconsGpsLocation),
            10.41.horizontalSpace,
            Text(
              "Use current location",
              style: FontPalette.black16ExtraBold
                  .copyWith(fontSize: 14.sp, color: HexColor("#2995E5")),
            )
          ],
        ),
      ),
    );
  }

  Widget _mapTile(LocationProvider location) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: HexColor('#D9DCE0'))),
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 150.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(color: HexColor('#D9DCE0'))),
              child: CommonMapView(
                latitude: Helpers.convertToDouble(location.selectedLoc?.lat),
                longitude: Helpers.convertToDouble(location.selectedLoc?.long),
              )),
          Padding(
            padding: EdgeInsets.only(
                left: 15.w, right: 15.w, top: 11.5.h, bottom: 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.residenceLocation,
                  style: FontPalette.f565F6C16Bold,
                ),
                3.verticalSpace,
                Text(
                  location.selectedLoc?.placeName ?? '',
                  style: FontPalette.f131A24_14Medium,
                ),
                15.verticalSpace,
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<LocationProvider>().clearFromSearch(true);
                        Navigator.pushNamed(
                            context, RouteGenerator.routeMapScreen);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.loc.change,
                            style: FontPalette.f2995E5_13ExtraBold,
                          ).flexWrap,
                        ],
                      ),
                    ),
                    20.horizontalSpace,
                    InkWell(
                      onTap: () => CommonFunctions.launchMap(
                          location.selectedLoc?.lat?.toString() ?? '',
                          location.selectedLoc?.long.toString() ?? ''),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.loc.viewLocation,
                            style: FontPalette.f2995E5_13ExtraBold,
                          ).flexWrap,
                          SvgPicture.asset(
                            Assets.iconsChevronRightBlue,
                            height: 32.r,
                            width: 32.r,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _addLocation() {
    _searchController.text = "";
    ReusableWidgets.customBottomSheet(
        context: context,
        child: Consumer<LocationProvider>(builder: (context, model, child) {
          return SizedBox(
            height: context.sh(size: 0.738),
            child: Center(
              child: Column(
                children: [
                  10.verticalSpace,
                  Text("Search location",
                      style: FontPalette.black15Bold.copyWith(fontSize: 16.sp)),
                  16.5.verticalSpace,
                  searchTextField(),
                  19.5.verticalSpace,
                  currentLocation(),
                  20.5.verticalSpace,
                  ReusableWidgets.horizontalLine(),
                  9.5.verticalSpace,
                  (model.placeList ?? []).isNotEmpty
                      ? _searchController.text.isNotEmpty
                          ? model.loaderState == LoaderState.loading
                              ? const PlaceSuggestionShimmer()
                              : placeSuggestionList(model)
                          : Container()
                      : emptyPlaceSuggestion(model)
                ],
              ),
            ),
          );
        }));
  }

  Widget placeSuggestionList(LocationProvider model) {
    if ((model.placesSuggestionList ?? []).isNotEmpty) {
      return Expanded(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: model.placesSuggestionList?.length ?? 0,
            itemBuilder: (context, int index) {
              return locationCard(model.placesSuggestionList![index]);
            }),
      );
    }
    return Container();
  }

  Widget locationCard(PlaceMarkSuggestion placeMarkSuggestion) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        context.read<LocationProvider>()
          ..updateSearchedLocation(placeMarkSuggestion)
          ..clearFromSearch(true);
        Navigator.pushNamed(context, RouteGenerator.routeMapScreen).then((val) {
          if ((val != null && val == true)) {
            context.rootPop;
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: context.sw(),
            height: 58.h,
            padding: EdgeInsets.symmetric(horizontal: 25.1.w),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 20.5.w,
                        height: 20.5.w,
                        child: Center(
                            child:
                                SvgPicture.asset(Assets.iconsLinearLocation))),
                    2.verticalSpace,
                    Text(calculateDistance(placeMarkSuggestion.distance ?? ''),
                        style: FontPalette.black10Medium.copyWith(
                            fontSize: 8.sp, color: HexColor("#8695A7")))
                  ],
                ),
                16.9.horizontalSpace,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        placeMarkSuggestion.placeName ?? '',
                        style: FontPalette.black10Medium.copyWith(
                            fontSize: 14.sp, color: HexColor("#131A24")),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      3.verticalSpace,
                      Text(
                        placeMarkSuggestion.locality ?? '',
                        style: FontPalette.black12Medium
                            .copyWith(color: HexColor("#8695A7")),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ReusableWidgets.horizontalLine(
              density: 1.h, margin: EdgeInsets.symmetric(horizontal: 18.w)),
        ],
      ),
    );
  }

  Widget searchTextField() {
    return ValueListenableBuilder<bool>(
        valueListenable: enableSearchClose,
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
                color: HexColor("#F2F4F5")),
            width: context.sw(),
            height: 49.h,
            margin: EdgeInsets.symmetric(horizontal: 18.w),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                enableSearchCloseIcon();
              },
              autofocus: false,
              style: FontPalette.black16SemiBold
                  .copyWith(color: HexColor("#131A24")),
              decoration: InputDecoration(
                suffixIcon: value
                    ? GestureDetector(
                        onTap: () {
                          _searchController.text = "";
                          enableSearchClose.value = false;
                          context
                              .read<LocationProvider>()
                              .clearPlaceSuggestions();
                        },
                        child: SizedBox(
                            width: 16.48.w,
                            height: 16.48.h,
                            child: Center(
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                    child: SvgPicture.asset(
                                        Assets.iconsCloseCircle)))),
                      )
                    : null,
                prefixIcon: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: Center(
                        child: SvgPicture.asset(Assets.iconsFeatherSearch))),
                filled: true,
                fillColor: HexColor("#F2F4F5"),
                labelStyle: FontPalette.black16SemiBold
                    .copyWith(color: HexColor("#131A24")),
                hintText: 'Search for your residence location…',
                hintStyle: FontPalette.black16SemiBold
                    .copyWith(color: HexColor("#565F6C")),
                contentPadding:
                    EdgeInsets.only(left: 0.0, bottom: 10.0.h, top: 10.0.h),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
            ),
          );
        });
  }

  Widget emptyPlaceSuggestion(LocationProvider model) {
    if ((model.placeList ?? []).isEmpty &&
        _searchController.text.isNotEmpty &&
        model.loaderState == LoaderState.loaded) {
      return const Expanded(
          child: Center(child: Text('We could’t find any matches!')));
    }
    return Container();
  }

  void enableSearchCloseIcon() {
    _searchController.text == ""
        ? enableSearchClose.value = false
        : enableSearchClose.value = true;
  }

  void _onChanged() {
    final locationProvider = context.read<LocationProvider>();
    if (_searchController.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500)).then((_) =>
          locationProvider.fetchPlaceSuggestions(_searchController.text));
    } else {
      locationProvider.clearPlaceSuggestions();
    }
  }

  calculateDistance(String? distance) {
    String calculatedDistance = '';
    if (distance != null) {
      if (double.parse(distance) > 1000) {
        calculatedDistance =
            '${(double.parse(distance) / 1000).toStringAsFixed(2)}km';
      } else {
        calculatedDistance = '${double.parse(distance).toStringAsFixed(2)}m';
      }
    }
    return calculatedDistance;
  }

  void checkPrimaryNoValid({bool enableDoneButton = true}) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    context.read<RegistrationProvider>().assignCountryDataIfNull(context);
    profile.isPrimaryNumberValid(profile.primaryNumberController.text, context);
    if (enableDoneButton) profile.enableContactDoneButton(context);
  }

  void checkAlternateNoValid({bool enableDoneButton = true}) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    context.read<RegistrationProvider>().assignCountryDataIfNull(context);
    profile.isAlternateNumberValid(
        profile.alternateNumberController.text, context);
    if (enableDoneButton) profile.enableContactDoneButton(context);
  }

  void verifyMobileNumber() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final model = Provider.of<RegistrationProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    ChangeMobileRequest changeMobileRequest = ChangeMobileRequest(
        profileId: widget.basicDetails?.id,
        mobileNumber: model.phoneNumber,
        countryCode: model.countryData?.id ?? 0);
    profile.changeMobile(changeMobileRequest, context, onSuccess: () {
      Navigator.pushNamed(context, RouteGenerator.routeAuthOtpScreen,
              arguments: RouteArguments(navFrom: NavFrom.navFromContact))
          .then((value) => auth.clearErrorMsg());
    });
  }

  void editContact() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);
    final register = Provider.of<RegistrationProvider>(context, listen: false);
    final account = Provider.of<AccountProvider>(context, listen: false);
    profile.primaryDetailsValidation(isButtonTapped: true);
    profile.alternateDetailsValidation(isButtonTapped: true);
    LocationRequest locationRequest = LocationRequest(
        profileId: widget.basicDetails?.id.toString() ??
            account.profile?.id.toString() ??
            '',
        locationName: location.selectedLoc?.placeName ?? '',
        latitude: location.selectedLoc?.lat ?? 0,
        longitude: location.selectedLoc?.long ?? 0,
        whatsappNo: RegistrationHandlerClass().whatsappNumberCtrl?.text ?? '',
        phoneNo: profile.alternateNumberController.text,
        mobile: profile.primaryNumberController.text,
        houseAddress: profile.myAddress.text,
        dialCode: register.countryData?.dialCode);

    if (profile.myAddress.text.isNotEmpty ||
        profile.isMobileVerified ||
        location.residenceLocation == null) {
      updateLocationDetails(locationRequest);
    } else {
      updateLocationDetails(locationRequest);
    }
  }

  void updateLocationDetails(LocationRequest locationRequest) {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    if (profile.primaryNumberController.text.isNotEmpty &&
        profile.alternateNumberController.text.isNotEmpty) {
      if (profile.isPrimaryContactNumberValid &&
          profile.isAlternateContactNumberValid) {
        profile.updateLocationDetails(locationRequest, context, onSuccess: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        });
      }
    } else if (profile.isPrimaryContactNumberValid ||
        profile.isAlternateContactNumberValid) {
      profile.updateLocationDetails(locationRequest, context, onSuccess: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
      });
    } else {
      if (profile.primaryNumberController.text.isEmpty &&
          profile.alternateNumberController.text.isEmpty) {
        profile.updateLocationDetails(locationRequest, context, onSuccess: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        });
      }
    }
  }
}
