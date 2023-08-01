import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../models/basic_detail_model.dart';

class DataCollectionAlert extends AlertDialog {
  final DataCollectionTypes dataCollectionTypes;

  const DataCollectionAlert({Key? key, required this.dataCollectionTypes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(
        dataCollectionTypes: dataCollectionTypes,
      ),
    );
  }
}

class _ContentView extends StatefulWidget {
  final DataCollectionTypes dataCollectionTypes;

  const _ContentView({super.key, required this.dataCollectionTypes});

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  late final ValueNotifier<double> _scaleValue;

  @override
  void initState() {
    _scaleValue = ValueNotifier(0.4);
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _scaleValue.value = 1.0;
    });
    super.initState();
  }

  Map<DataCollectionTypes, String> btnTexts(BuildContext context) => {
        DataCollectionTypes.addBasicDetails: context.loc.addBasicDetails,
        DataCollectionTypes.addPhotos: context.loc.addPhoto,
        DataCollectionTypes.addProfessionalInfo:
            context.loc.addProfessionalDetails,
        DataCollectionTypes.addEducation: context.loc.addEducationalDetails,
        DataCollectionTypes.addPartnerPreference:
            context.loc.addPartnerPreferences,
        DataCollectionTypes.addAddressDetails: context.loc.addAddressDetails,
      };

  Map<DataCollectionTypes, String> descText(BuildContext context) => {
        DataCollectionTypes.addBasicDetails: context.loc.addBasicDetailDesc,
        DataCollectionTypes.addPhotos: context.loc.ofTheMembersPreferToContact,
        DataCollectionTypes.addProfessionalInfo: context.loc.addProfDetailDesc,
        DataCollectionTypes.addEducation: context.loc.addEduDetailDesc,
        DataCollectionTypes.addPartnerPreference:
            context.loc.addPartnerDetailDesc,
        DataCollectionTypes.addAddressDetails: context.loc.addAddressDesc,
      };

  Map<DataCollectionTypes, String> footerText(BuildContext context) => {
        DataCollectionTypes.addBasicDetails:
            context.loc.addBasicDetailsToGetNoticed,
        DataCollectionTypes.addPhotos: context.loc.addAClearPhotoToGetNoticed,
        DataCollectionTypes.addProfessionalInfo:
            context.loc.addProfDetailsToGetNoticed,
        DataCollectionTypes.addEducation: context.loc.addEduDetailsToGetNoticed,
        DataCollectionTypes.addPartnerPreference:
            context.loc.addPartnerPreferenceToGetNoticed,
        DataCollectionTypes.addAddressDetails:
            context.loc.addAddressDetailsToGetNoticed,
      };

  Map<DataCollectionTypes, String> get images => {
        DataCollectionTypes.addBasicDetails: Assets.iconsAddBasicDetails,
        DataCollectionTypes.addPhotos: Assets.iconsAddPhoto,
        DataCollectionTypes.addProfessionalInfo: Assets.iconsAddProfession,
        DataCollectionTypes.addEducation: Assets.iconsAddEducation,
        DataCollectionTypes.addPartnerPreference:
            Assets.iconsAddPartnerPreference,
        DataCollectionTypes.addAddressDetails: Assets.iconsAddContact,
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 322.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              33.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    ValueListenableBuilder<double>(
                        valueListenable: _scaleValue,
                        builder: (context, value, child) {
                          child = SvgPicture.asset(
                            images[widget.dataCollectionTypes] ??
                                Assets.iconsAddPhoto,
                            height: 67.h,
                            width: 61.w,
                          );
                          return AnimatedScale(
                            scale: value,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: child,
                          );
                        }),
                    10.verticalSpace,
                    Selector<AppDataProvider, BasicDetailModel?>(
                      selector: (context, provider) =>
                          provider.basicDetailModel,
                      builder: (context, value, child) {
                        return Text(
                          value?.basicDetail?.name ?? '',
                          style: FontPalette.black18Bold,
                        ).avoidOverFlow();
                      },
                    ),
                    13.verticalSpace,
                    Text(
                      descText(context)[widget.dataCollectionTypes] ?? '',
                      textAlign: TextAlign.center,
                      style: FontPalette.black14Medium
                          .copyWith(fontWeight: FontWeight.w500),
                      strutStyle: StrutStyle(height: 1.5.h),
                    ),
                    10.verticalSpace,
                    TextButton.icon(
                        onPressed: onAddTap,
                        icon: SvgPicture.asset(
                          Assets.iconsAdd,
                          height: 10.43.h,
                          width: 10.43.w,
                          color: HexColor('#950053'),
                        ),
                        label: Text(
                          btnTexts(context)[widget.dataCollectionTypes] ?? '',
                          style: FontPalette.primary16Bold,
                        )),
                    10.verticalSpace,
                    Text(
                      footerText(context)[widget.dataCollectionTypes] ?? '',
                      textAlign: TextAlign.center,
                      style: FontPalette.black11semiBold
                          .copyWith(color: HexColor('#8695A7')),
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.maybePop(context),
                child: Padding(
                  padding: EdgeInsets.all(25.r),
                  child: SvgPicture.asset(
                    Assets.iconsCloseGrey,
                    height: 13.42.h,
                    width: 13.42.w,
                  ),
                ),
              ).removeSplash(color: Colors.transparent)),
        ],
      ),
    );
  }

  void onAddTap() {
    switch (widget.dataCollectionTypes) {
      case DataCollectionTypes.addPhotos:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routeManagePhotos);
        break;
      case DataCollectionTypes.addBasicDetails:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routeEditBasicDetail);
        break;
      case DataCollectionTypes.addProfessionalInfo:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routeEditProfessionalInfo);
        break;
      case DataCollectionTypes.addEducation:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routeEditProfessionalInfo);
        break;
      case DataCollectionTypes.addAddressDetails:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routeEditContact);
        break;
      case DataCollectionTypes.addPartnerPreference:
        Navigator.pushReplacementNamed(
            context, RouteGenerator.routePartnerPreference);
        break;
      default:
        Navigator.pushReplacementNamed(context, RouteGenerator.routeProfile);
    }
  }
}
