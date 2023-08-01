import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_floating_btn.dart';
import 'package:nest_matrimony/widgets/image_upload_bottom_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../providers/app_data_provider.dart';

class PhotoGridView extends StatefulWidget {
  const PhotoGridView({Key? key}) : super(key: key);

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  Color get btnGreyColor => const Color(0xFFC1C9D2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading:
              ReusableWidgets.roundedBackButton(context, onBackPressed: () {
            debugPrint("On back");

            context.read<PhotoProvider>().clearUploadAnyPhoto();

            // Navigator.of(context).popUntil((route) {
            //     return route.settings.name != null
            //         ? route.settings.name == RouteGenerator.routeRegistrationScreen
            //         : true;
            //   });

            Navigator.popUntil(context,
                ModalRoute.withName(RouteGenerator.routeRegistrationScreen));
          }),
        ),
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            width: context.sw(),
            height: context.sh(),
            child: Consumer<PhotoProvider>(
              builder: (context, provider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text(
                      context.loc.morePhotos,
                      style: FontPalette.black30Bold,
                    ),
                    47.verticalSpace,
                    _photoGridbuild(),
                    provider.isUploading
                        ? Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                    bottom: 35..h,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.r))),
                                  height: 30.h,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.r)),
                                    child: LinearProgressIndicator(
                                      value: provider.progressPercentage
                                              .toDouble() /
                                          100,
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
                                    "${provider.progressPercentage} %",
                                    style: FontPalette.black14Bold,
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox()
                    // provider.isUploading
                    //     ? Center(
                    //         child: Container(
                    //             margin: EdgeInsets.only(bottom: 25.h),
                    //             height: 30.h,
                    //             width: 100.w,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(30.r),
                    //               color: Colors.grey.shade200,
                    //             ),
                    //             child: Center(
                    //                 child: Text(
                    //               "${provider.progressPercentage} %",
                    //               style: FontPalette.black14Bold,
                    //               maxLines: 1,
                    //             ))))
                    //     : const SizedBox()
                  ],
                );
              },
            )),
        floatingActionButton:
            Consumer<PhotoProvider>(builder: ((context, provider, child) {
          return CommonFloatingBtn(
            enableBtn: provider.croppedFileList.isNotEmpty,
            enableLoader: provider.isUploading,
            onPressed: () async {
              provider.uploading(true);
              context.read<RegistrationProvider>().registerUserData(
                  context: context,
                  onSuccess: () {
                    provider.uploadPhotos(context, onSuccess: (val) {
                      if (val ?? false) {
                        context.read<AppDataProvider>().getBasicDetails();
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteGenerator.routeMainScreen, (route) => false);
                      }
                    });
                  },
                  onFailure: (val) {
                    provider.uploading(false);
                  });
            },
          );
        })));
  }

  Widget _photoGridbuild() {
    return Consumer<PhotoProvider>(builder: ((_, provider, child) {
      return Expanded(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == provider.croppedFileList.length) {
                      return photoUploadCard();
                    }
                    return provider.croppedFileList.isNotEmpty
                        ? _photoCard(
                            filePath: provider.croppedFileList[index].path,
                            index: index)
                        : const SizedBox();
                  },
                  childCount: provider.croppedFileList.length + 1,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 13.h,
                    mainAxisExtent: 155.h,
                    mainAxisSpacing: 13.h,
                    crossAxisCount: 3),
              ),
            ),
          ],
        ),
      );
    }));
  }

  Widget _photoCard({var filePath, int? index}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: 155.h,
            width: 96.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(11.r))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11.r),
              child: Image.file(
                File(filePath),
                fit: BoxFit.cover,
              ),
            )),
        InkWell(
          onTap: () {
            log("$filePath");
            context.read<PhotoProvider>().remove(index: index);
          },

          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
                height: 23.w,
                width: 23.w,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.5, 2),
                      blurRadius: 3.0),
                ], shape: BoxShape.circle),
                child: SvgPicture.asset(Assets.iconsManagePhotoClose)),
            // child: SvgPicture.asset(Assets.iconsCloseIcon)),
          ),
          //  Padding(
          //   padding: EdgeInsets.all(8.r),
          //   child: SvgPicture.asset(Assets.iconsCloseIcon),
          // ),
        )
      ],
    );
  }

  Widget photoUploadCard() {
    return InkWell(
      onTap: () {
        fileUpload(context);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 155.h,
            width: 96.w,
            decoration: BoxDecoration(
                color: HexColor("#F7F7F7"),
                border: Border.all(
                  color: HexColor('#E6E6E6'),
                ),
                borderRadius: BorderRadius.all(Radius.circular(11.r))),
            child: SizedBox(
                width: 27.57.w,
                height: 22.4.h,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsMetroCamera,
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.r, bottom: 1.r),
            child: SvgPicture.asset(Assets.iconsPhotoAdd),
          )
        ],
      ),
    );
  }

  // Widget _floatingActionButton() {
  //   return Consumer<PhotoProvider>(
  //     builder: ((context, provider, child) {
  //       return FloatingActionButton(
  //         onPressed: () {
  //           provider.uploadPhotos();
  //           // Navigator.pushNamedAndRemoveUntil(
  //           //     context, RouteGenerator.routeMainScreen, (route) => false);
  //         },
  //         backgroundColor:
  //             context.read<PhotoProvider>().croppedFileList.isNotEmpty
  //                 ? ColorPalette.primaryColor
  //                 : btnGreyColor,
  //         elevation: 0,
  //         child: SvgPicture.asset(
  //           Assets.iconsArrowRight,
  //           alignment: Alignment.center,
  //           width: 17.w,
  //           height: 17.h,
  //         ),
  //       );
  //     }),
  //   );
  // }

  void fileUpload(BuildContext context) {
    ReusableWidgets.customBottomSheet(
        context: context, child: ImageUploadBottomSheet());
  }
}
