import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:shimmer/shimmer.dart';

class PlaceSuggestionShimmer extends StatelessWidget {
  const PlaceSuggestionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 10,
          itemBuilder: (context, int index) {
            return Shimmer.fromColors(
              baseColor: HexColor("#F4F7F7"),
              highlightColor: Colors.white.withOpacity(0.8),
              child: Column(
                children: [
                  Container(
                    width: context.sw(),
                    height: 58.h,
                    padding: EdgeInsets.symmetric(horizontal: 25.1.w),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 20.5.w,
                                height: 20.5.w,
                                child: Center(
                                    child: SvgPicture.asset(
                                        Assets.iconsLinearLocation))),
                          ],
                        ),
                        16.9.horizontalSpace,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(height: 10.h, color: Colors.white),
                              7.verticalSpace,
                              Container(
                                  height: 7.h,
                                  width: 75.w,
                                  color: Colors.white),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
