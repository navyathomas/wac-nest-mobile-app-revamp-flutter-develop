import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/widgets/shimmers/home_header_shimmer.dart';

import '../../generated/assets.dart';

class PartnerHorizontalTileShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final bool enableCrown;
  const PartnerHorizontalTileShimmer(
      {Key? key, this.enableCrown = false, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lWidth = context.sw(size: 0.24);
    double lHeight = lWidth + (lWidth * 0.6);
    return Column(
      children: [
        const HomeHeaderShimmer(),
        SizedBox(
          height: height ?? lHeight,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      height: double.maxFinite,
                      width: width ?? lWidth,
                      margin: EdgeInsets.only(
                          left: index == 0 ? 16.w : 0,
                          right: index == 5 ? 16.w : 0,
                          top: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7.r)),
                          )),
                          5.verticalSpace,
                          Container(
                            color: Colors.white,
                            height: 20.h,
                          ),
                          1.verticalSpace,
                          Container(
                            color: Colors.white,
                            height: 16.h,
                          )
                        ],
                      ),
                    ),
                    if (enableCrown)
                      Positioned(
                          right: 0,
                          top: 1.h,
                          child: SvgPicture.asset(Assets.iconsCrown))
                  ],
                );
              },
              separatorBuilder: (_, __) => 11.horizontalSpace,
              itemCount: 6),
        ),
      ],
    ).addShimmer;
  }
}
