import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';

class CommonOutlineBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final double? width;
  final Widget? loaderWidget;
  final double? height;
  final double? borderRadiusUser;
  final TextStyle? fontStyle;
  final ButtonStyle? buttonStyle;
  const CommonOutlineBtn(
      {Key? key,
      this.onPressed,
      this.width,
      this.height,
      this.title,
      this.loaderWidget,
      this.borderRadiusUser,
      this.fontStyle,
      this.buttonStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52.h,
      width: width ?? context.sw(),
      child: OutlinedButton(
        style: buttonStyle ??
            OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: HexColor('#131A24')),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.r))),
        onPressed: onPressed,
        child: Text(
          title ?? '',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: fontStyle,
        ),
      ),
    );
  }
}
