import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeaderShimmer extends StatelessWidget {
  const HomeHeaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 4.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 50.w),
              height: 22.h,
            ),
          ),
          Container(
            color: Colors.white,
            height: 32.r,
            width: 50.r,
          )
        ],
      ),
    );
  }
}
