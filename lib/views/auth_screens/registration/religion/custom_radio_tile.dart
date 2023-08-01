import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/custom_radio.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final double horizontalSpacing;
  final bool isSelected;
  final VoidCallback? onTap;
  const CustomRadioTile(
      {Key? key,
      this.isSelected = false,
      this.title = '',
      this.onTap,
      this.horizontalSpacing = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? HexColor('#FFDEF4') : null,
        padding: EdgeInsets.symmetric(
            vertical: 20.h, horizontal: horizontalSpacing.w),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: FontPalette.black16SemiBold
                  .copyWith(color: HexColor('#131A24')),
            ).avoidOverFlow()),
            CustomRadio(isSelected: isSelected)
          ],
        ),
      ),
    );
  }
}
