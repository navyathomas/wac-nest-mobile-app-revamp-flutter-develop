import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class CommonButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;
  final double? width;
  final Widget? loaderWidget;
  final bool isLoading;
  final double? height;
  final double? borderRadiusUser;
  final TextStyle? fontStyle;
  final ButtonStyle? buttonStyle;
  const CommonButton(
      {Key? key,
      this.onPressed,
      this.width,
      this.height,
      this.title,
      this.loaderWidget,
      this.borderRadiusUser,
      this.fontStyle,
      this.buttonStyle,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52.h,
      width: width ?? context.sw(),
      child: ElevatedButton(
        style: buttonStyle ??
            ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return ColorPalette.primaryColor;
                  } else if (states.contains(MaterialState.disabled)) {
                    return ColorPalette.primaryColor.withOpacity(0.8);
                  }
                  return ColorPalette.primaryColor;
                },
              ),
            ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Center(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 20),
                  padding: const EdgeInsets.all(8.0),
                  child: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  ),
                ),
              )
            : Text(
                title ?? '',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: fontStyle ?? FontPalette.white16Bold,
              ),
      ),
    );
  }
}
