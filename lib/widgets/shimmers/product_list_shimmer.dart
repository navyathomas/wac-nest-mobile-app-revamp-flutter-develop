import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';

class ProductListingShimmer extends StatelessWidget {
  const ProductListingShimmer({Key? key}) : super(key: key);

  Widget _loadTile({double? width, double? height}) {
    return Container(
      height: height ?? 14.h,
      width: width ?? double.maxFinite,
      decoration: BoxDecoration(
          color: HexColor('#EFF1F4'), borderRadius: BorderRadius.circular(3.r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HexColor('#F2F4F5'),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                height: 154.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9.r)),
                child: Row(
                  children: [
                    Container(
                      height: 142.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                          color: HexColor('#EFF1F4'),
                          borderRadius: BorderRadius.circular(9.r)),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loadTile(width: constraints.maxWidth * 0.7),
                            20.verticalSpace,
                            _loadTile(width: constraints.maxWidth * 0.8),
                            9.verticalSpace,
                            _loadTile(width: constraints.maxWidth * 0.5),
                            9.verticalSpace,
                            _loadTile(width: constraints.maxWidth * 0.8)
                          ],
                        );
                      }),
                    )
                  ],
                ).addShimmer,
              );
            },
            separatorBuilder: (_, __) => 9.verticalSpace,
            itemCount: 15));
  }
}
