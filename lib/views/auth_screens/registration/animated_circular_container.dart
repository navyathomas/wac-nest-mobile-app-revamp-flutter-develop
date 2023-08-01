import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/utils/color_palette.dart';

class GlowCircle extends StatelessWidget {
  final String icon;
  final bool flag;
  const GlowCircle({super.key, required this.icon, this.flag = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            shape: BoxShape.circle, //making box to circle
            color: flag ? HexColor('#FFDEF4') : HexColor('#C2CAD3')),
        height: flag ? 36.r : 5.r, //value from animation controller
        width: flag ? 36.r : 5.r,
        child: flag
            ? SvgPicture.asset(
                icon,
                height: double.maxFinite,
                width: double.maxFinite,
              )
            : const SizedBox());
  }
}
