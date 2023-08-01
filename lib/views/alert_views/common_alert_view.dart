import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../utils/jumping_dots.dart';

class CommonAlertView extends AlertDialog {
  final String? heading;
  final String? contents;
  final String? buttonText;
  final bool buttonLoader;
  final VoidCallback? onTap;
  final double? height;
  const CommonAlertView(
      {Key? key,
      this.heading,
      this.contents,
      this.onTap,
      this.buttonText,
      this.buttonLoader = false,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(
        heading: heading,
        contents: contents,
        onTap: onTap,
        buttonText: buttonText,
        buttonLoader: buttonLoader,
        height: height,
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final String? heading;
  final String? contents;
  final VoidCallback? onTap;
  final String? buttonText;
  final bool buttonLoader;
  final double? height;
  const _ContentView(
      {Key? key,
      this.heading,
      this.contents,
      this.onTap,
      this.buttonText,
      required this.buttonLoader,
      this.height})
      : super(key: key);

  Widget upgradeNowButton(BuildContext context,
      {Color? buttonColor, String? buttonText, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        height: 35.h,
        width: 118.w,
        alignment: Alignment.center,
        child: Text(
          buttonText ?? '',
          style: onPressed == null
              ? FontPalette.f565F6C16Bold
              : FontPalette.primary16Bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 216.h,
      width: double.maxFinite,
      child: Column(
        children: [
          36.verticalSpace,
          Text(heading ?? '', style: FontPalette.black18Bold),
          13.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              contents ?? '',
              textAlign: TextAlign.center,
              style: FontPalette.black14Medium,
              strutStyle: StrutStyle(height: 1.5.h),
            ),
          ),
          32.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: upgradeNowButton(context,
                        buttonText: context.loc.cancel)),
                Expanded(
                    child: (buttonLoader
                            ? const JumpingDots(numberOfDots: 3)
                            : upgradeNowButton(context,
                                onPressed: onTap, buttonText: buttonText))
                        .animatedSwitch())
              ],
            ),
          )
        ],
      ),
    );
  }
}
