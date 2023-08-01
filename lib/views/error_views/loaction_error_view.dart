import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';

class LocationErrorView extends StatefulWidget {
  final String? subTitle;
  final String? description;
  final String? buttonText;
  final VoidCallback? onTap;

  const LocationErrorView(
      {Key? key, this.subTitle, this.description, this.buttonText, this.onTap})
      : super(key: key);

  @override
  State<LocationErrorView> createState() => _LocationErrorViewState();
}

class _LocationErrorViewState extends State<LocationErrorView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.iconsServerError,
            height: 115.34.h,
            width: 117.6.w,
          ),
          16.verticalSpace,
          Text(
            widget.subTitle ?? '',
            style: FontPalette.black18Bold.copyWith(color: HexColor('#525B67')),
          ),
          13.verticalSpace,
          Text(
            widget.description ?? '',
            textAlign: TextAlign.center,
            style: FontPalette.black14Medium.copyWith(
              color: HexColor('#525B67'),
            ),
            strutStyle: StrutStyle(height: 1.5.h),
          ),
          40.verticalSpace,
          CommonButton(
            width: 157.w,
            title: widget.buttonText ?? context.loc.backToHome,
            fontStyle: FontPalette.white13SemiBold.copyWith(fontSize: 16.sp),
            onPressed: widget.onTap,
          )
        ],
      ),
    );
  }
}
