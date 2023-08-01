import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class CommonPlanCard extends StatelessWidget {
  final List<Color>? gradientColour;
  final List<Color>? bottomColors;
  final String? title;
  final String? rupees;
  final String? perMontOrDate;
  final String? backgroudNestLogo;
  final String? bottomTagTitle;
  final VoidCallback ? onTap;

  const CommonPlanCard(
      {Key? key,
      this.gradientColour,
      this.bottomColors,
      this.title,
      this.rupees,
      this.perMontOrDate,
      this.backgroudNestLogo,
      this.bottomTagTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
              height: 126.h,
              width: 258.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    // stops: const [
                    //   0.5,
                    //   0.,
                    // ],
                    begin: Alignment.centerLeft,
                    end: Alignment.topRight,
                    colors: gradientColour ??
                        [
                          HexColor('#950053'),
                          HexColor('#E664AA'),
                        ],
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 17.w, right: 7.w, top: 19.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  title ?? "Royal Delight",
                                  maxLines: 1,
                                  style: FontPalette.black16SemiBold.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(Assets.iconsForwardWhite)
                            ],
                          ),
                        ),
                        9.5.verticalSpace,
                        Padding(
                          padding: EdgeInsets.only(left: 17.w, right: 7.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 15.66.h,
                                  width: 12.55.w,
                                  child:
                                      SvgPicture.asset(Assets.iconsRupeeWhite)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(rupees ?? "13,000",
                                    style: FontPalette.black16ExtraBold
                                        .copyWith(
                                            fontSize: 21.sp,
                                            color: Colors.white)),
                              ),
                              perMontOrDate != null
                                  ? Text(
                                    "/ $perMontOrDate",
                                    // "/ $perMontOrDate month",
                                      // "/ 6month"
                                      style: FontPalette.black13SemiBold
                                          .copyWith(
                                              fontSize: 12.sp,
                                              color: Colors.white70))
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomTagTitle != null ? bottomTag() : const SizedBox()
                ],
              )),
          Image.asset(
            backgroudNestLogo ?? Assets.imagesNestLogoCommonGrey,
          )
          // Container(
          //     height: 67.h,
          //     width: 100.w,
          //     alignment: Alignment.centerRight,
          //     child:
          //     Image.asset(
          //       backgroudNestLogo ?? Assets.imagesNestLogoCommonGrey,
          //     )
          //     ),
        ],
      ),
    );
  }

  Widget bottomTag() {
    return Container(
      width: 170.w,
      height: 28.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.topRight,
            colors: bottomColors ??
                [
                  HexColor('#CBB478'),
                  HexColor('#F0E49F'),
                ],
          ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Text(bottomTagTitle ?? "",
            // CR Manager support
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                FontPalette.black14SemiBold.copyWith(color: HexColor("#131A24"))
            // style:
            //     FontPalette.black14SemiBold.copyWith(color: HexColor("#6A5300"))
            ),
      ),
    );
  }
}
