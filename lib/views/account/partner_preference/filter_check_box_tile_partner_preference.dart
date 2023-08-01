import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_checkbox.dart';

class FilterCheckBoxTilePartnerPreference extends StatelessWidget {
  const FilterCheckBoxTilePartnerPreference(
      {Key? key,
      this.padding,
      this.title,
      this.isChecked = false,
      this.onTap,
      this.checkBoxOnTap})
      : super(key: key);
  final EdgeInsets? padding;
  final String? title;
  final bool isChecked;
  final Function? onTap;
  final Function()? checkBoxOnTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          CommonCheckBox(
            isChecked: isChecked,
            onTap: checkBoxOnTap,
          ),
          14.horizontalSpace,
          Expanded(
              child: InkWell(
            onTap: checkBoxOnTap,
            child: Text(
              title ?? '',
              textAlign: TextAlign.start,
              style: FontPalette.black16Medium
                  .copyWith(color: HexColor('#09274D')),
            ).addEllipsis(maxLine: 2),
          ))
        ],
      ),
    );
  }
}

class FilterSubCheckBoxTilePartnerPreference extends StatelessWidget {
  const FilterSubCheckBoxTilePartnerPreference(
      {Key? key, this.padding, this.title, this.isChecked = false, this.onTap})
      : super(key: key);
  final EdgeInsets? padding;
  final String? title;
  final bool isChecked;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
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
