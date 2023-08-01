import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../utils/font_palette.dart';
import 'custom_radio.dart';

class CustomRadioTile extends StatelessWidget {
  final EdgeInsets? padding;
  final String? title;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? horizontalPadding;
  const CustomRadioTile(
      {Key? key,
      this.padding,
      this.title,
      this.onTap,
      this.isSelected = false,
      this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
                vertical: 15.h, horizontal: horizontalPadding ?? 27.w),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title ?? '',
              style: FontPalette.f131A24_16SemiBold,
            ).avoidOverFlow()),
            CustomRadio(
              isSelected: isSelected,
            )
          ],
        ),
      ),
    );
  }
}
