import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_palette.dart';

class CustomRadio extends StatelessWidget {
  final bool isSelected;
  final double? height;
  final double? width;
  const CustomRadio(
      {Key? key, this.isSelected = false, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 20.r,
      width: width ?? 20.r,
      decoration: BoxDecoration(
          border: isSelected
              ? null
              : Border.all(color: HexColor('#D9DCE0'), width: 2.r),
          color: isSelected ? ColorPalette.primaryColor : Colors.white,
          shape: BoxShape.circle),
      alignment: Alignment.center,
      child: AnimatedCrossFade(
        firstChild: Container(
          height: 5.r,
          width: 5.r,
          decoration:
              BoxDecoration(color: HexColor('#FFDEF4'), shape: BoxShape.circle),
        ),
        secondChild: const SizedBox(),
        crossFadeState:
            isSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        firstCurve: Curves.bounceIn,
        secondCurve: Curves.bounceOut,
      ),
    );
  }
}
