import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/image_upload_bottom_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class AddHoroscope extends StatelessWidget {
  const AddHoroscope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void setImage({var image}) {
      context.read<AccountProvider>().setHoroscopeImage(context,
          filePicked: image, isFromHoroscopicScreen: true);
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

    void fileUpload(BuildContext context, bool isFromHoroscpeScreen) {
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

    Widget clipRectImage() {
      return Consumer<AccountProvider>(builder: (__, pro, _) {
        return pro.pickedFile != null
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.r),
                    border: Border.all(width: 2.w, color: HexColor("#E6E6E6"))),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.r),
                  child: Image.file(
                    File(pro.pickedFile!.path),
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                    height: 343.h,
                  ),
                ))
            : const SizedBox();
      });
    }

    Widget _commonButton(
        {String? iconPath,
        String? title,
        Color? borderColor,
        bool iconTrue = false,
        double? width,
        IconData? icon,
        VoidCallback? onTap,
        bool isUploading = false,
        Color? titleColor}) {
      return InkWell(
        onTap: onTap,
        child: Container(
            height: 46.h,
            width: width ?? 136.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(
                    width: 1.w, color: borderColor ?? HexColor("#2995E5"))),
            child: !isUploading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconTrue
                          ? Icon(icon ?? Icons.upload,
                              color: HexColor("#2995E5"))
                          : SvgPicture.asset(iconPath ?? ''),
                      5.53.horizontalSpace,
                      title != null
                          ? Text(title,
                              style: FontPalette.black14SemiBold.copyWith(
                                  color: titleColor ?? HexColor("#2995E5")))
                          : const SizedBox(),
                    ],
                  )
                : FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: HexColor("#2995E5")),
                      ),
                    ),
                  )),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Horoscope',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            16.verticalSpace,
            clipRectImage(),
            27.verticalSpace,
            //changed as per project cordinatator ----

            Consumer<PhotoProvider>(builder: (_, pro, __) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 46.w),
                child: InkWell(
                  onTap: () => pro.uploadAnyPhotos(
                      imageType: "1",
                      isFeatured: "0",
                      filesList: [
                        context.read<AccountProvider>().pickedFile
                      ]).then((value) {
                    Navigator.pop(context);
                    Future.microtask(() {
                      context.read<AccountProvider>().initProfile();
                      context.read<AccountProvider>().fetchProfile(context);
                      context
                          .read<AppDataProvider>()
                          .getChildEducationCategories();
                      context.read<AppDataProvider>().getBodyTypeList();
                      context.read<AppDataProvider>().getComplexionList();
                    }).then((value) {
                      context.read<AccountProvider>().clearImagePicked();
                    });
                  }),
                  child: _commonButton(
                      isUploading: pro.uploadButtonLoading,
                      iconTrue: true,
                      width: double.maxFinite,
                      title: "Upload"),
                ),
              );
            }),

            16.verticalSpace,

            //changed as per project cordinatator ---- close
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 46.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _commonButton(
                        onTap: (() {
                          print("replace ");
                          fileUpload(context, true);
                        }),
                        iconPath: Assets.iconsRefreshRightSquare,
                        title: "Replace"),
                  ),
                  11.horizontalSpace,
                  Flexible(
                    child: _commonButton(
                        onTap: () {
                          Future.microtask(() {
                            context.read<AccountProvider>().clearImagePicked();
                          }).then((value) => Navigator.pop(context));
                        },
                        borderColor: HexColor("#D9DCE0"),
                        titleColor: HexColor("#525B67"),
                        iconPath: Assets.iconsTrashIcon,
                        title: "Delete"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget progressIndicator({double? progressPercentage}) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          margin: EdgeInsets.only(
            bottom: 35..h,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          height: 30.h,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            child: LinearProgressIndicator(
              value: progressPercentage ?? 0.toDouble() / 100,
              color: Colors.grey.shade300,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 35..h,
          ),
          child: Text(
            "$progressPercentage %",
            style: FontPalette.black14Bold,
            maxLines: 1,
          ),
        )
      ],
    ),
  );
}

}
