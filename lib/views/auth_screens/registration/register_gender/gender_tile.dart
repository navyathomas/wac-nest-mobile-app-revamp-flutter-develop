import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../generated/assets.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';

class GenderTile extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String title;
  const GenderTile(
      {Key? key,
      required this.isSelected,
      required this.icon,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth - 30.w;
      return Stack(
        children: [
          Container(
            height: width.w,
            width: width.w,
            margin: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color:
                        isSelected ? HexColor('#A2B2C9') : HexColor('#F2F4F5')),
                boxShadow: [
                  BoxShadow(
                      color: ColorPalette.pageBgColor,
                      blurRadius: 36.r,
                      spreadRadius: 15.r)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  height: width * 0.29,
                  width: width * 0.29,
                  color: isSelected ? ColorPalette.primaryColor : null,
                ),
                8.verticalSpace,
                Text(
                  title,
                  style: FontPalette.black15SemiBold,
                )
              ],
            ),
          ),
          Positioned(
            top: width * 0.12,
            right: width * 0.2,
            child: AnimatedContainer(
              alignment: Alignment.topCenter,
              curve: Curves.easeInOutBack,
              duration: const Duration(milliseconds: 300),
              height: isSelected ? width * 0.22 : 10.r,
              width: isSelected ? width * 0.22 : 10.r,
              child: SvgPicture.asset(
                Assets.iconsBlueTick,
                height: isSelected ? width * 0.22 : 0,
                width: isSelected ? width * 0.22 : 0,
              ),
            ),
          )
        ],
      );
    });
  }
}
