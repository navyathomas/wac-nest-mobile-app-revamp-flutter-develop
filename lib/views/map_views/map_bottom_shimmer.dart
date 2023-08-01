import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:shimmer/shimmer.dart';

class MapBottomShimmer extends StatelessWidget {
  const MapBottomShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: HexColor("#F4F7F7"),
      highlightColor: HexColor('#EDF5F5'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: context.sw(size: 0.2),
            height: 10.h,
          ),
          14.verticalSpace,
          Row(
            children: [
              SvgPicture.asset(Assets.iconsCheckMarkCircle,
                  width: 15.r, height: 15.r),
              10.horizontalSpace,
              Expanded(
                child: Container(
                  height: 10.h,
                  width: 115.w,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 30.h,
                  width: 50.w,
                  margin: EdgeInsets.only(left: 8.w, right: 6.h),
                  padding: EdgeInsets.all(2.w),
                  color: Colors.white,
                ),
              )
            ],
          ),
          23.verticalSpace,
          CommonButton(
            width: MediaQuery.of(context).size.width,
            title: "",
            onPressed: () {},
          ),
          6.verticalSpace,
        ],
      ),
    );
  }
}
