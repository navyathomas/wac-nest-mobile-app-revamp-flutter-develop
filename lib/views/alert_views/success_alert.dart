import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../generated/assets.dart';

class SuccessAlert extends AlertDialog {
  String? description;
  void Function()? onTap;
  SuccessAlert({super.key, this.description, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(
        description: description,
        onTap: onTap,
      ),
    );
  }
}

class _ContentView extends StatefulWidget {
  String? description;
  void Function()? onTap;
  _ContentView({Key? key, this.description, this.onTap}) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  late final ValueNotifier<double> _scaleValue;
  @override
  void initState() {
    _scaleValue = ValueNotifier(0.4);
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _scaleValue.value = 1.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270.h,
      width: double.maxFinite,
      child: Column(
        children: [
          43.verticalSpace,
          ValueListenableBuilder<double>(
              valueListenable: _scaleValue,
              builder: (context, value, child) {
                child = SvgPicture.asset(
                  Assets.iconsSuccess,
                  height: 67.h,
                  width: 61.w,
                );
                return AnimatedScale(
                  scale: value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: child,
                );
              }),
          17.verticalSpace,
          Text(
            context.loc.success,
            style: FontPalette.black18Bold,
          ),
          6.verticalSpace,
          Text(
            widget.description ?? '',
            textAlign: TextAlign.center,
            style:
                FontPalette.black14Medium.copyWith(color: HexColor('#525B67')),
            strutStyle: StrutStyle(height: 1.5.h),
          ),
          38.verticalSpace,
          InkWell(
              onTap: widget.onTap,
              child: Text(
                context.loc.ok,
                style: FontPalette.primary16Bold,
              )).removeSplash()
        ],
      ),
    );
  }
}
