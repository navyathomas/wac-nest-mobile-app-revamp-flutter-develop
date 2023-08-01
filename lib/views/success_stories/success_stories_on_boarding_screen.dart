import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/models/testimonials_response_model.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';

import '../../common/extensions.dart';
import '../../generated/assets.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';

class SuccessStoriesOnBoardingScreen extends StatelessWidget {
  SuccessStoriesOnBoardingScreen({Key? key, required this.testimonialUserData})
      : super(key: key);

  TestimonialUserData testimonialUserData;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(alignment: Alignment.topCenter, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (p0, p1) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CommonImageView(
                              alignment: Alignment.topCenter,
                              image: (testimonialUserData.imageFile ?? '')
                                  .testimonialsImagePath(context),
                              // height: 371.h, <-- old height
                              height: 410.h,
                              width: 371.w,
                              boxFit: BoxFit.cover,
                            )),
                      );
                    },
                  ),
                  30.verticalSpace,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 11.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (testimonialUserData.groomName ?? '').isNotEmpty
                              ? '${testimonialUserData.groomName ?? ''} & ${testimonialUserData.brideName ?? ''}'
                              : '',
                          style: FontPalette.primary16Bold
                              .copyWith(fontSize: 18.sp),
                        ),
                        4.verticalSpace,
                        Text(
                          testimonialUserData.dateOfMarriage ?? '',
                          style: FontPalette.black14Medium.copyWith(
                              color: HexColor('#565F6C'), fontSize: 13.sp),
                        ),
                        20.verticalSpace,
                        Text(
                          testimonialUserData.feedback ?? '',
                          style: FontPalette.black14Regular.copyWith(
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
                          strutStyle: StrutStyle(height: 1.5.h),
                        ),
                        // 21.verticalSpace,
                        // Text(
                        //   'Duis aute irure dolor in reprehenderit in \nvoluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint. Cupidatat non \nproident, sunt in culpa qui officia deserunt \nmollit anim id est laborum. labore et.dolore magna aliqua.',
                        //   style: FontPalette.black14Regular.copyWith(
                        //       fontSize: 15.sp, fontWeight: FontWeight.w400),
                        //   strutStyle: StrutStyle(height: 1.5.h),
                        // ),
                        110.verticalSpace
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 350.h),
              child: LayoutBuilder(
                builder: (p0, p1) {
                  debugPrint('width ${p1.maxWidth}');
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r)),
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        Assets.imagesSuccessStoriesBoarderDesign,
                        height: 344.h,
                        width: 177.w,
                      ),
                    ),
                  );
                },
              ),
            ),
          ])
        ],
      ),
    );
  }
}
