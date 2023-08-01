import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../generated/assets.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../widgets/common_button.dart';

class ErrorTile extends StatelessWidget {
  final Errors errors;
  final VoidCallback? onTap;
  final bool enableBtn;
  const ErrorTile(
      {Key? key,
      this.errors = Errors.serverError,
      this.enableBtn = true,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String>? errorType = Constants.errorType(context)[errors];
    return SizedBox(
      height: context.sh(size: 0.5),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              errorType?[Constants.icon] ?? Assets.iconsServerError,
              height: 115.34.h,
              width: 117.6.w,
            ),
            (constraints.maxHeight * 0.05).verticalSpace,
            Text(
              errorType?[Constants.title] ?? '',
              style:
                  FontPalette.black18Bold.copyWith(color: HexColor('#525B67')),
            ),
            (constraints.maxHeight * 0.03).verticalSpace,
            Text(
              errorType?[Constants.desc] ?? '',
              textAlign: TextAlign.center,
              style: FontPalette.black14Medium.copyWith(
                color: HexColor('#525B67'),
              ),
              strutStyle: StrutStyle(height: 1.5.h),
            ),
            (constraints.maxHeight * 0.08).verticalSpace,
            if (errors != Errors.searchResultError && enableBtn)
              CommonButton(
                width: 157.w,
                title: errorType?[Constants.btnTitle] ?? context.loc.tryAgain,
                fontStyle:
                    FontPalette.white13SemiBold.copyWith(fontSize: 16.sp),
                onPressed: onTap,
              )
          ],
        );
      }),
    );
  }
}
