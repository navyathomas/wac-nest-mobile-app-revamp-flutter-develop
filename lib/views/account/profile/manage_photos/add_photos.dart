import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../providers/app_data_provider.dart';
import '../../../../widgets/social_icon_btns.dart';

class AddPhotos extends StatelessWidget {
  const AddPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PhotoProvider, AccountProvider>(
        builder: (__, photoProvider, provider, _) {
      return AbsorbPointer(
        absorbing:
            photoProvider.isUploading || photoProvider.uploadButtonLoading,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Text('Add photos',
                    style: FontPalette.white16Bold
                        .copyWith(color: HexColor("#131A24"))),
                elevation: 0.5,
                leading: ReusableWidgets.roundedBackButton(context),
                systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarIconBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness:
                        Platform.isIOS ? Brightness.light : Brightness.dark),
              ),
              body: Column(children: [
                34.verticalSpace,
                SocialIconButtons(
                    secondaryTitle: "Connect",
                    iconSize: 31.52,
                    onTap: () => Navigator.pushNamed(
                        context, RouteGenerator.routeInstagramPhotos,
                        arguments: RouteArguments(isFromMangePhotos: true))
                    // log("Insta")
                    ),
                14.verticalSpace,
                SocialIconButtons(
                    leadingIcon: Assets.iconsCameraUpload,
                    title: "Camera",
                    onTap: () =>
                        photoProvider.pickFromCamera(context, onResponse: () {
                          // todo
                          if (photoProvider.imageCategoryType == "2") {
                            log("House ");
                            photoProvider
                                .uploadAnyPhotos(
                                    imageType: "2",
                                    isFeatured: "0",
                                    filesList: photoProvider.croppedFileList)
                                .then((value) {
                              photoProvider.clearUploadAnyPhoto();
                              provider.clearHouseSection();
                              provider
                                  .getMyhousePhoto()
                                  .then((value) => Navigator.pop(context));
                            });
                          } else if (photoProvider.imageCategoryType == "3") {
                            log("id Proof id");
                            photoProvider
                                .uploadAnyPhotos(
                                    imageType: "3",
                                    isFeatured: "0",
                                    filesList: photoProvider.croppedFileList,
                                    onSuccess: (val) {
                                      if (val ?? false) {
                                        context
                                            .read<AppDataProvider>()
                                            .getBasicDetails();
                                      }
                                    })
                                .then((value) {
                              photoProvider.clearUploadAnyPhoto();
                              provider.clearIdProofSection();
                              provider
                                  .getIDproofPhotos()
                                  .then((value) => Navigator.pop(context));
                            });
                          } else {
                            log("my photos");
                            photoProvider.uploadPhotos(context,
                                onSuccess: (val) {
                              if (val ?? false) {
                                CommonFunctions.afterInit(() {
                                  Helpers.successToast(
                                      "profile Image Upload successfully");
                                  context
                                      .read<AppDataProvider>()
                                      .getBasicDetails();
                                  photoProvider.clearUploadAnyPhoto();
                                  provider.clearAllManagePhotoSections();
                                  provider
                                      .getMyOWnPhotos(context)
                                      .then((value) => Navigator.pop(context));
                                });
                              }
                            });
                          }
                        })),
                14.verticalSpace,
                SocialIconButtons(
                    leadingIcon: Assets.iconsGallery,
                    title: "Gallery",
                    onTap: () => context
                            .read<PhotoProvider>()
                            .pickFromGallery(context, onResponse: () {
                          //todo

                          if (photoProvider.imageCategoryType == "2") {
                            log("House ");
                            photoProvider
                                .uploadAnyPhotos(
                                    imageType: "2",
                                    isFeatured: "0",
                                    filesList: photoProvider.croppedFileList)
                                .then((value) {
                              photoProvider.clearUploadAnyPhoto();
                              provider.clearHouseSection();
                              provider.getMyhousePhoto();
                            }).then((value) => Navigator.pop(context));
                          } else if (photoProvider.imageCategoryType == "3") {
                            log("id Proof id");
                            photoProvider
                                .uploadAnyPhotos(
                                    imageType: "3",
                                    isFeatured: "0",
                                    filesList: photoProvider.croppedFileList,
                                    onSuccess: (val) {
                                      if (val ?? false) {
                                        context
                                            .read<AppDataProvider>()
                                            .getBasicDetails();
                                      }
                                    })
                                .then((value) {
                              photoProvider.clearUploadAnyPhoto();
                              provider.clearIdProofSection();
                              context.read<PhotoProvider>().clear();
                              provider
                                  .getIDproofPhotos()
                                  .then((value) => Navigator.pop(context));
                            });
                          } else {
                            log("my photos");
                            photoProvider.uploadPhotos(context,
                                onSuccess: (val) {
                              if (val ?? false) {
                                Helpers.successToast(
                                    "profile Image Upload successfully");
                                context
                                    .read<AppDataProvider>()
                                    .getBasicDetails();
                                photoProvider.clearUploadAnyPhoto();
                                provider.clearAllManagePhotoSections();
                                provider
                                    .getMyOWnPhotos(context)
                                    .then((value) => Navigator.pop(context));
                              }
                            });
                          }
                        })),
              ]),
            ),
            photoProvider.isUploading || photoProvider.uploadButtonLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }

/*  Widget chooseCards(
      {String? leadingIcon,
      String? title,
      String? secondaryTitle,
      double? spaceBetween,
      VoidCallback? onTap,
      double? iconSize}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85.h,
        width: 315.w,
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.sp, color: HexColor("#C1C9D2"))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 59.h,
              width: 59.w,
              child: Center(
                child: SvgPicture.asset(
                  leadingIcon ?? Assets.iconsInstagram,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            13.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "Instagram",
                  style: FontPalette.black15SemiBold
                      .copyWith(color: HexColor("#565F6C")),
                ),
                if (secondaryTitle != null) ...[
                  3.verticalSpace,
                  Text(
                    secondaryTitle,
                    style: FontPalette.black15SemiBold
                        .copyWith(color: HexColor("#2995E5"), fontSize: 11.sp),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }*/
}
