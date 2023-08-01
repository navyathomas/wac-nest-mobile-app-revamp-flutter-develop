import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_checkbox.dart';

class FilterCheckBoxTile extends StatelessWidget {
  const FilterCheckBoxTile(
      {Key? key, this.padding, this.title, this.isChecked = false, this.onTap})
      : super(key: key);
  final EdgeInsets? padding;
  final String? title;
  final bool isChecked;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            CommonCheckBox(
              isChecked: isChecked,
            ),
            14.horizontalSpace,
            Expanded(
                child: Text(
              title ?? '',
              textAlign: TextAlign.start,
              style: FontPalette.black16Medium
                  .copyWith(color: HexColor('#09274D')),
            ).addEllipsis(maxLine: 2))
          ],
        ),
      ),
    );
  }
}

class FilterSubCheckBoxTile extends StatelessWidget {
  const FilterSubCheckBoxTile(
      {Key? key, this.padding, this.title, this.isChecked = false, this.onTap})
      : super(key: key);
  final EdgeInsets? padding;
  final String? title;
  final bool isChecked;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            CommonCheckBox(
              isChecked: isChecked,
              size: 18.r,
              iconSize: 14.r,
            ),
            14.horizontalSpace,
            Expanded(
                child: Text(
              title ?? '',
              textAlign: TextAlign.start,
              style: FontPalette.black16Medium
                  .copyWith(color: HexColor('#09274D')),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ))
          ],
        ),
      ),
    );
  }
}
