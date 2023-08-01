import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/views/auth_screens/registration/crop_photo/instagram_photos.dart';
import 'package:provider/provider.dart';

class ImageUploadBottomSheet extends StatelessWidget {
  final bool? noInstagram;
  final VoidCallback? onTapCamera;
  final VoidCallback? onTapGallery;
  final VoidCallback? onTapInsta;
  final Function? onResponse;
   bool isFromManagePhotos=false;
   ImageUploadBottomSheet({
    Key? key,
    this.onTapCamera,
    this.onTapGallery,
    this.onTapInsta,
    this.noInstagram = false,
    this.onResponse,
    this.isFromManagePhotos=false
  }) : super(key: key);

  Widget _uploadOptionBtn(
      {required String title,
      required String icon,
      double? height,
      double? width,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: height ?? 59.r,
              width: width ?? 59.r,
            ),
            22.horizontalSpace,
            Expanded(child: Text(title))
          ],
        ),
      ),
    );
  }

  Widget _uploadInstBtn(
      {required String title,
      required String icon,
      double? height,
      double? width,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              height: 59.r,
              width: 59.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor("EFF2F5"),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  height: height ?? 59.r,
                  width: width ?? 59.r,
                ),
              ),
            ),
            22.horizontalSpace,
            Expanded(child: Text(title))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _uploadOptionBtn(
          icon: Assets.iconsCameraUpload,
          title: context.loc.camera,
          onTap: onTapCamera ??
              () {
                context.read<PhotoProvider>().pickFromCamera(context, onResponse: onResponse);
              },
        ),
        Container(
          height: 1.h,
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          width: double.maxFinite,
          color: HexColor('#E4E7E8'),
        ),
        _uploadOptionBtn(
            icon: Assets.iconsGallery,
            title: context.loc.gallery,
            onTap: onTapGallery ??
                () {
                  context.read<PhotoProvider>().pickFromGallery(context, onResponse: onResponse);
                }),
        !noInstagram!
            ? Column(
                children: [
                  Container(
                    height: 1.h,
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    width: double.maxFinite,
                    color: HexColor('#E4E7E8'),
                  ),
                  _uploadInstBtn(
                      height: 28.h,
                      width: 28.h,
                      icon: Assets.iconsInstagram,
                      title: "Instagram",
                      onTap: onTapInsta ??
                          () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const InstagramPhotos();
                            // }));
                            Navigator.pushNamed(
                                context, RouteGenerator.routeInstagramPhotos,arguments: RouteArguments(isFromMangePhotos: isFromManagePhotos));
                          }),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
