import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/extensions.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: HexColor("#EFF1F4"),
            highlightColor: Colors.white,
            child: Container(
              height: 443.h,
              width: double.maxFinite,
              color: HexColor("#EFF1F4"),
            ),
          ),
          gradientNameTag(),
          Transform.translate(
              offset: const Offset(0, -29),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r)),
                ),
                child: Column(
                  children: [
                    19.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          roundedIconButton(),
                          Flexible(
                            child: roundedIconButton(),
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,
                    WidgetExtension.horizontalDivider(
                        color: HexColor("#F2F4F5")),
                    18.92.verticalSpace,
                    titleHeads(),
                    25.verticalSpace,
                    aboutMe(),
                    30.verticalSpace,
                    WidgetExtension.horizontalDivider(
                        color: HexColor("#F2F4F5")),
                    23.verticalSpace,
                    basicDetail(),
                    23.88.verticalSpace,
                    WidgetExtension.horizontalDivider(
                        color: HexColor("#F2F4F5")),
                    23.verticalSpace,
                  ],
                ),
              ))
        ],
      ),
    );
  }

  //TITLE HEADS
  static Widget titleHeads() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: HexColor("#EFF1F4"),
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100.w,
              height: 15.h,
              color: Colors.white,
            ),
            SizedBox(
                height: 32.h,
                width: 62.w,
                child: SvgPicture.asset(Assets.iconsEditIconButton))
          ],
        ),
      ),
    );
  }

//BASIC DETAILS
  Widget basicDetail() {
    return Column(
      children: [
        titleHeads(),
        25.88.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
        13.verticalSpace,
        keyValueText(),
      ],
    );
  }

  Widget keyValueText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: HexColor("#EFF1F4"),
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                width: 50,
                height: 20.h,
                color: Colors.white,
              ),
            ),
            15.horizontalSpace,
            Flexible(
                fit: FlexFit.tight,
                flex: 6,
                child: Container(
                  width: 50,
                  height: 20.h,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

//COMMON WIDGETS
  Widget aboutMe() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
          baseColor: HexColor("#EFF1F4"),
          highlightColor: Colors.white,
          child: Container(
            width: double.maxFinite,
            height: 100.h,
            color: Colors.white,
          )),
    );
  }

  Widget roundedIconButton({
    String? iconPath,
    String? text,
    double? height,
    double? width,
  }) {
    return Shimmer.fromColors(
      baseColor: HexColor("#EFF1F4"),
      highlightColor: Colors.white,
      child: Container(
        height: height ?? 42.h,
        width: width ?? 163.w,
        decoration: BoxDecoration(
          color: Colors.white,
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

  Widget gradientNameTag({
    String? name,
    String? nestId,
  }) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    35.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: HexColor("#EFF1F4"),
                        highlightColor: Colors.white,
                        child: Container(
                          height: 20.h,
                          width: 150.w,
                          color: Colors.white,
                        )),
                    7.94.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 20.h,
                          width: 110.w,
                          color: Colors.white,
                        )),
                  ],
                ),
                SizedBox(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.white,
                      child: Container(
                        height: 38.h,
                        width: 102.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: HexColor("#FEF4F3"),
                            borderRadius: BorderRadius.circular(19.r)),
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
