import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/widgets/image_upload_bottom_tile.dart';
import 'package:nest_matrimony/widgets/network_connectivity.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../models/profile_search_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../widgets/profile_image_view.dart';

class Profile extends StatefulWidget {
  final String? appbarTitle;
  const Profile({Key? key, this.appbarTitle}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PageController controller = PageController(initialPage: 0);
  DateFormat formater = DateFormat('dd-MM-yyyy');
  DateFormat formater2 = DateFormat('dd-MMM-yyyy');
  Widget imageBox({String? imageURL, String? gender}) {
    return Container(
        height: 443.h,
        width: double.maxFinite,
        color: Colors.white,
        child: imageURL != null
            ? ProfileImagePlaceHolder(
                height: double.maxFinite,
                isMale: (gender ?? '').toLowerCase() == 'male',
              )
            : ProfileImageView(
                image: (imageURL ?? '').fullImagePath(context),
                boxFit: BoxFit.cover,
                height: double.maxFinite,
                isMale: (gender ?? '').toLowerCase() == 'male',
              ));
  }

  void init() {
    Future.microtask(() {
      context.read<AccountProvider>().initProfile();
      context.read<AccountProvider>().fetchProfile(context);
      context.read<AppDataProvider>()
      ..getChildEducationCategories()
      ..getBodyTypeList()
      ..getComplexionList();
    });
  }

  Widget _mainView(BasicDetails? basicDetails) {
    List<UserImage>? imageList = basicDetails?.userImage ?? [];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 443.h,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                imageList.isEmpty
                    ? ProfileImagePlaceHolder(isMale: basicDetails?.isMale)
                    : PageView.builder(
                        controller: controller,
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          if (imageList[index].imageFile == null) {
                            return ProfileImagePlaceHolder(
                                isMale: basicDetails?.isMale);
                          }
                          return ProfileImageView(
                              isMale: basicDetails?.isMale,
                              image: imageList[index]
                                  .imageFile
                                  .fullImagePath(context));
                        }),
                if (imageList.length > 1)
                  Padding(
                    padding: EdgeInsets.only(bottom: 38.h),
                    child: SmoothPageIndicator(
                        controller: controller,
                        count: imageList.length,
                        effect: WormEffect(
                            spacing: 10.r,
                            radius: 8.r,
                            dotWidth: 8.0,
                            dotHeight: 8.0,
                            dotColor: Colors.white60,
                            activeDotColor: Colors.white),
                        onDotClicked: (index) {
                          controller.animateToPage(
                            index,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 200),
                          );
                        }),
                  ),
              ],
            ),
          ),
          gradientNameTag(
              name: basicDetails?.name ?? '',
              nestId: basicDetails?.registerId ?? ''),
          contents(profile: basicDetails)
        ],
      ),
    );
  }

  Widget _viewSwitcher(BasicDetails? basicDetails, LoaderState state) {
    switch (state) {
      case LoaderState.loading:
        return const SizedBox.shrink();
      case LoaderState.error:
        return CommonErrorView(
          error: Errors.serverError,
          onTap: () {
            Navigator.of(context).popUntil((route) {
              return route.settings.name != null
                  ? route.settings.name == RouteGenerator.routeMainScreen
                  : true;
            });
          },
        );
      case LoaderState.networkErr:
        return CommonErrorView(
          error: Errors.networkError,
          onTap: () {
            init();
          },
        );
      case LoaderState.noData:
        return CommonErrorView(
          error: Errors.noDatFound,
          onTap: () {
            init();
          },
        );

      default:
        return _mainView(basicDetails);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.5,
        shadowColor: Colors.black26,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: Selector<AccountProvider, Tuple2<BasicDetails?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.profile, provider.loaderState),
        builder: (context, value, child) {
          return NetworkConnectivity(
              inAsyncCall: value.item2.isLoading,
              onTap: () => init(),
              child: _viewSwitcher(value.item1, value.item2));
        },
      ),
    );
  }

  Widget gradientNameTag({String? name, String? nestId}) {
    return Transform.translate(
      offset: const Offset(0, -19),
      child: Container(
        height: 139.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19.r), topRight: Radius.circular(19.r)),
          gradient: LinearGradient(end: Alignment.topRight, stops: const [
            0.8,
            1.0
          ], colors: [
            HexColor("#FFF0E3"),
            HexColor("#F8D5FF"),
          ]),
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      35.verticalSpace,
                      Selector<AppDataProvider, BasicDetailModel?>(
                        selector: (context, provider) => provider.basicDetailModel,
                        builder: (context, basicDeatils, child) {
                          return  (basicDeatils?.basicDetail?.name == null || name == null)
                              ? SizedBox(
                                  width: 150.w,
                                  height: 20.h,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 20.h,
                                        width: 150.w,
                                        color: Colors.grey.shade200,
                                      )),
                                )
                              : Text(
                                  basicDeatils?.basicDetail?.name ?? name,
                                  style: FontPalette.white18Bold
                                      .copyWith(color: HexColor("#131A24")),
                                );
                        }),
                      7.94.verticalSpace,
                      Text(
                        nestId ?? "",
                        style: FontPalette.black13SemiBold
                            .copyWith(color: HexColor("#131A24")),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteGenerator.routeProfilePreview);
                  },
                  child: Container(
                    height: 38.h,
                    width: 102.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HexColor("#FEF4F3"),
                        borderRadius: BorderRadius.circular(19.r)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.iconsPreviewEye),
                        5.87.horizontalSpace,
                        Text(
                          "Preview",
                          style: FontPalette.black14Bold
                              .copyWith(fontSize: 13.sp)
                              .copyWith(color: HexColor("#131A24")),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget contents({BasicDetails? profile}) {
    return Transform.translate(
      offset: const Offset(0, -29),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19.r), topRight: Radius.circular(19.r)),
        ),
        child: Column(
          children: [
            19.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  roundedIconButton(
                      onTap: () => Navigator.pushNamed(
                              context, RouteGenerator.routeManagePhotos)
                          .then((value) => context
                              .read<AccountProvider>()
                              .fetchProfile(context)),
                      iconPath: Assets.iconsImageIcon,
                      text: "Manage photos"),
                  Flexible(
                    child: roundedIconButton(
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routeEditContact,
                            arguments: RouteArguments(basicDetails: profile)),
                        iconPath: Assets.iconsEditIcon,
                        text: "Edit contact"),
                  ),
                ],
              ),
            ),
            14.verticalSpace,
            WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
            18.92.verticalSpace,
            (profile?.isHindu ?? false) &&
                    (profile?.userHoroscopeImage ?? [])
                        .isEmpty // <-- changed originaly here isEmpty
                ? Column(
                    children: [
                      ReusableWidgets.commonAddIconButton(
                        onTap: () {
                          fileUpload(
                            context,
                          );
                          log("Add Horoscope");
                        },
                      ),
                      19.08.verticalSpace,
                      WidgetExtension.horizontalDivider(
                          color: HexColor("#F2F4F5")),
                      23.verticalSpace,
                    ],
                  )
                : const SizedBox(),
            profile?.userIntro != null && profile?.userIntro != ""
                ? aboutMe(basicDetails: profile)
                : Container(),
            basicDetail(profile),
            23.88.verticalSpace,
            WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
            23.verticalSpace,
            professionalInfo(profile),
            26.72.verticalSpace,
            WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
            23.verticalSpace,
            religionInfo(profile),
            29.8.verticalSpace,
            WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
            23.verticalSpace,
            locationInfo(profile),
            23.verticalSpace,
            WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
            23.verticalSpace,
            familyDetails(profile),
            23.verticalSpace,
            (profile != null && (profile.isHindu ?? false))
                ? horoscopeDetails(profile)
                : Container(),
            26.44.verticalSpace,
            (profile?.isHindu ?? false) &&
                    (profile?.userHoroscopeImage ?? [])
                        .isEmpty // <-- changed originaly here isEmpty
                ? Column(
                    children: [
                      ReusableWidgets.commonAddIconButton(
                        makeRoundedButton: true,
                        height: 42.h,
                        horizontalPadding: 16.w,
                        onTap: () {
                          fileUpload(
                            context,
                          );
                          log("Add Horoscope");
                        },
                      ),
                      context.sh(size: 0.1).verticalSpace,
                    ],
                  )
                : const SizedBox(),
            (profile?.isHindu ?? false) &&
                    (profile?.userHoroscopeImage ?? []).isNotEmpty
                ? Column(
                    children: [
                      ReusableWidgets.commonAddIconButton(
                          title: "Edit Horoscope",
                          makeRoundedButton: true,
                          height: 42.h,
                          horizontalPadding: 16.w,
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.routeEditHoroscope);
                            // fileUpload(
                            //   context,
                            // );
                          }),
                      context.sh(size: 0.1).verticalSpace,
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

//----------- SECTIONS -----------

//BASIC DETAILS
  Widget basicDetail(BasicDetails? profile) {
    return Column(
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "Basic Details",
            onEditTap: (() {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Name",
            trailingText:
                (profile?.name ?? '').isNotEmpty ? profile?.name : null),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Gender",
            trailingText: (profile?.gender ?? '').isNotEmpty
                ? profile?.gender ?? ''
                : null),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
          leadingText: "Age",
          trailingText: profile?.dateOfBirth != null && profile?.age != null
              ? "${profile?.age ?? ''}, ${formater.format(profile!.dateOfBirth!)}"
              : null,
        ),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Marital status",
            trailingText:
                (profile?.maritalStatus?.maritalStatus ?? '').isNotEmpty
                    ? profile?.maritalStatus?.maritalStatus ?? ''
                    : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        /*ReusableWidgets.keyValueText(
            leadingText: "No of children",
            trailingText: profile?.noOfChildren != null
                ? profile!.noOfChildren.toString()
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),*/
        // 13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Height",
            trailingText: (profile?.userHeightList?.height ?? '').isNotEmpty
                ? profile?.userHeightList?.height ?? ''
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Body Type",
            trailingText: (profile?.physicalStatus?.bodyType ?? '').isNotEmpty
                ? profile?.physicalStatus?.bodyType ?? ''
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Complexion",
            trailingText:
                (profile?.complexion?.complexionTitle ?? '').isNotEmpty
                    ? profile?.complexion?.complexionTitle ?? ''
                    : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: context.loc.profileCreatedFor,
            // leadingText: "Profile created for",
            trailingText: (profile?.profileCreated ?? '').isNotEmpty
                ? profile?.profileCreated
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditBasicDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
      ],
    );
  }

//PROFILE INFO
  Widget professionalInfo(BasicDetails? profile) {
    return Column(
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "Professional info",
            onEditTap: (() {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditProfessionalInfo,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Education category",
            trailingText:
                (profile?.userEducationSubcategory?.eduCategoryTitle ?? '')
                        .isNotEmpty
                    ? profile?.userEducationSubcategory?.eduCategoryTitle
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditProfessionalInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Education detail",
            trailingText: (profile?.educationalInfo ?? '').isNotEmpty
                ? profile?.educationalInfo
                : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditProfessionalInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Job category",
            trailingText: (profile?.userJobSubCategory?.parentJobCategory ?? '')
                    .isNotEmpty
                ? profile?.userJobSubCategory?.parentJobCategory
                : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditProfessionalInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Job detail",
            trailingText:
                (profile?.jobInfo ?? '').isNotEmpty ? profile?.jobInfo : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditProfessionalInfo,
                  arguments: RouteArguments(basicDetails: profile));
            })
      ],
    );
  }

//RELIGION INFO
  Widget religionInfo(BasicDetails? profile) {
    return Column(
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "Religion info",
            onEditTap: (() {
              context.read<AccountProvider>()
                ..reAssignReligionOnEditBtn()
                ..reAssignCasteOnEditBtn();
              Navigator.pushNamed(context, RouteGenerator.routeEditReligionInfo,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Religion",
            trailingText: (profile?.userReligion?.religionName ?? '').isNotEmpty
                ? profile?.userReligion?.religionName
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditReligionInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        // leadingText: "Religion", trailingText: "Hindu"),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Division / caste",
            trailingText: (profile?.userCaste?.casteName ?? '').isNotEmpty
                ? profile?.userCaste?.casteName
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditReligionInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "SubCaste",
            trailingText:
                (profile?.subCaste ?? '').isNotEmpty ? profile?.subCaste : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditReligionInfo,
                  arguments: RouteArguments(basicDetails: profile));
            }),
      ],
    );
  }

//LOCATION INFO
  Widget locationInfo(BasicDetails? profile) {
    return Column(
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "Location",
            onEditTap: (() {
              context.read<AccountProvider>()
                ..reAssignCountryOnEditBtn()
                ..reAssignStateOnEditBtn()
                ..reAssignDistrictOnEditBtn()
                ..reAssignCityOnEditBtn();
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditLocationDetail,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Country",
            trailingText: (profile?.userCountry?.countryName ?? '').isNotEmpty
                ? profile?.userCountry?.countryName
                : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditLocationDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "State",
            trailingText:
                (profile?.userFamilyInfo?.userState?.stateName ?? '').isNotEmpty
                    ? profile?.userFamilyInfo?.userState?.stateName
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditLocationDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "District",
            trailingText:
                (profile?.userFamilyInfo?.userDistrict?.districtName ?? '')
                        .isNotEmpty
                    ? profile?.userFamilyInfo?.userDistrict?.districtName
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditLocationDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "City",
            trailingText:
                (profile?.userFamilyInfo?.userLocation?.locationName ?? '')
                        .isNotEmpty
                    ? profile?.userFamilyInfo?.userLocation?.locationName
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditLocationDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
      ],
    );
  }

//FAMILY DETAILS
  Widget familyDetails(BasicDetails? profile) {
    return Column(
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "Family details",
            onEditTap: (() {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Father’s name",
            trailingText: (profile?.userFamilyInfo?.fatherName ?? '').isNotEmpty
                ? profile?.userFamilyInfo?.fatherName
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Father’s job",
            trailingText: (profile?.userFamilyInfo?.fatherJob ?? '').isNotEmpty
                ? profile?.userFamilyInfo?.fatherJob
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Mother’s name",
            trailingText: (profile?.userFamilyInfo?.motherName ?? '').isNotEmpty
                ? profile?.userFamilyInfo?.motherName
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Mother’s job",
            trailingText: (profile?.userFamilyInfo?.motherJob ?? '').isNotEmpty
                ? profile?.userFamilyInfo?.motherJob
                : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Sibling details",
            trailingText:
                (profile?.userFamilyInfo?.sibilingsInfo ?? '').isNotEmpty
                    ? profile?.userFamilyInfo?.sibilingsInfo
                    : null,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeEditFamilyDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
      ],
    );
  }

//HOROSCOPE DETAILS
  Widget horoscopeDetails(BasicDetails? profile) {
    return Column(
      children: [
        WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
        23.verticalSpace,
        ReusableWidgets.titleHeads(
            titleHead: "Horoscope Details",
            onEditTap: (() {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            })),
        25.88.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Birth time",
            trailingText:
                (profile?.userReligiousInfo?.timeOfBirth ?? '').isNotEmpty
                    ? profile?.userReligiousInfo?.timeOfBirth
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Janma sista dasa end",
            trailingText:
                (profile?.userReligiousInfo?.sistaDasaDay ?? '').isNotEmpty &&
                        (profile?.userReligiousInfo?.sistaDasaMonth ?? '')
                            .isNotEmpty &&
                        (profile?.userReligiousInfo?.sistaDasaMonth ?? '')
                            .isNotEmpty
                    ? '${profile?.userReligiousInfo?.sistaDasaDay}'
                        '-${profile?.userReligiousInfo?.sistaDasaMonth}'
                        '-${profile?.userReligiousInfo?.sistaDasaYear}'
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Dasa",
            trailingText:
                (profile?.userReligiousInfo?.dhasaName ?? '').isNotEmpty
                    ? profile?.userReligiousInfo?.dhasaName
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "DOB (Malayalam)",
            trailingText:
                (profile?.userReligiousInfo?.malayalamDob ?? '').isNotEmpty
                    ? profile?.userReligiousInfo?.malayalamDob
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        13.verticalSpace,
        // ReusableWidgets.keyValueText(
        //     leadingText: "DOB (English)",
        //     trailingText: profile?.dateOfBirth != null
        //         ? formater2.format(profile!.dateOfBirth!)
        //         : null),
        // 13.verticalSpace,
        ReusableWidgets.keyValueText(
            leadingText: "Star/ Rasi",
            trailingText:
                (profile?.userReligiousInfo?.userStars?.starName ?? '')
                        .isNotEmpty
                    ? profile?.userReligiousInfo?.userStars?.starName
                    : null,
            onTap: () {
              Navigator.pushNamed(
                  context, RouteGenerator.routeEditHoroscopeDetail,
                  arguments: RouteArguments(basicDetails: profile));
            }),
        // leadingText: "Star/ Rasi", trailingText: "Vishagam"),
        13.verticalSpace,
      ],
    );
  }

//----------- SECTIONS CLOSE -----------

//

//COMMON WIDGETS
  Widget aboutMe({BasicDetails? basicDetails}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableWidgets.titleHeads(
            titleHead: "About me",
            onEditTap: (() => Navigator.pushNamed(
                context, RouteGenerator.routeEditAboutMe,
                arguments: RouteArguments(basicDetails: basicDetails)))),
        25.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            basicDetails?.userIntro ?? '',
            style:
                FontPalette.black14Medium.copyWith(color: HexColor("#131A24")),
            textAlign: TextAlign.left,
          ),
        ),
        30.verticalSpace,
        WidgetExtension.horizontalDivider(color: HexColor("#F2F4F5")),
        23.verticalSpace,
      ],
    );
  }

  Widget roundedIconButton(
      {String? iconPath,
      String? text,
      double? height,
      double? width,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 42.h,
        width: width ?? 163.w,
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: HexColor("#565F6C")),
          borderRadius: BorderRadius.circular(21.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconPath != null ? SvgPicture.asset(iconPath) : const SizedBox(),
            8.66.horizontalSpace,
            Text(text ?? "", style: FontPalette.black14Bold),
          ],
        ),
      ),
    );
  }

  void fileUpload(BuildContext context) {
    ReusableWidgets.customBottomSheet(
        context: context,
        child: ImageUploadBottomSheet(
          noInstagram: true,
          onTapCamera: () {
            uploadImageCamera();
            log("Camera");
          },
          onTapGallery: () {
            uploadImageGallery();
            log("Gallery");
          },
        ));
  }

  Future<void> uploadImageGallery() async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImage(image: pickedFile);
    }
  }

  Future<void> uploadImageCamera() async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setImage(image: pickedFile);
    }
  }

  void setImage({var image}) {
    context.read<AccountProvider>().setHoroscopeImage(context,
        filePicked: image, isFromHoroscopicScreen: false);
  }
  //COMMON WIDGETS CLOSE
}
