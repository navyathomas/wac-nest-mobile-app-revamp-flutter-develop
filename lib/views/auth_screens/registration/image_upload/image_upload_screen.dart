import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../providers/app_data_provider.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/image_upload_bottom_tile.dart';
import '../../../../widgets/social_icon_btns.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Widget _socialBtnTile(BuildContext context,
      {required String icon, required String title}) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 34.h),
      decoration: BoxDecoration(
          border: Border.all(color: HexColor('#C1C9D2')),
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 32.r,
            width: 32.r,
            child: SvgPicture.asset(
              icon,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
          ),
          10.horizontalSpace,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontPalette.black14SemiBold
                      .copyWith(color: HexColor('#565F6C')),
                ).avoidOverFlow(),
                Text(
                  context.loc.connect,
                  style: FontPalette.black12semiBold
                      .copyWith(color: HexColor('#2995E5')),
                ).avoidOverFlow()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget fileUploadBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => fileUpload(context),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 50.h),
        decoration: BoxDecoration(
            border: Border.all(color: HexColor('#C1C9D2')),
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            SvgPicture.asset(
              Assets.iconsFileUpload,
              height: 27.r,
              width: 27.r,
            ),
            14.verticalSpace,
            Text(
              context.loc.upload,
              style: FontPalette.black14SemiBold
                  .copyWith(color: HexColor('#565F6C')),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                36.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    context.loc.imageUploadHeading,
                    style: FontPalette.black30Bold,
                  ),
                ),
                50.verticalSpace,
                SocialIconButtons(
                    secondaryTitle: "Connect",
                    iconSize: 31.52,
                    onTap: () => Navigator.pushNamed(
                        context, RouteGenerator.routeInstagramPhotos,
                        arguments: RouteArguments(isFromMangePhotos: false))),
                // onTap: () => Navigator.pushNamed(
                //     context, RouteGenerator.routeInstagram))//,
                14.verticalSpace,
                SocialIconButtons(
                    leadingIcon: Assets.iconsCameraUpload,
                    title: "Camera",
                    onTap: () => context.read<PhotoProvider>().pickFromCamera(
                          context,
                        )),
                14.verticalSpace,
                SocialIconButtons(
                    leadingIcon: Assets.iconsGallery,
                    title: "Gallery",
                    onTap: () =>
                        context.read<PhotoProvider>().pickFromGallery(context)),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            context.circularLoaderPopUp;
            context.read<RegistrationProvider>().registerUserData(
                context: context,
                onSuccess: () {
                  context.rootPop;
                  context.read<AppDataProvider>().getBasicDetails();
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteGenerator.routeMainScreen, (route) => false);
                },
                onFailure: (val) {
                  if (val) {
                    context.rootPop;
                  }
                });
          },
          child: Text(
            context.loc.skip,
            style: FontPalette.black16SemiBold
                .copyWith(color: HexColor('#131A24')),
          ),
        ),
        context.sh(size: 0.06).verticalSpace
      ],
    );
  }

  void fileUpload(BuildContext context) {
    ReusableWidgets.customBottomSheet(
        context: context, child: ImageUploadBottomSheet());
  }
}
