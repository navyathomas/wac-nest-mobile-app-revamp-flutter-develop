import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';

class RadioButtonTile extends StatelessWidget {
  const RadioButtonTile(
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
            CustomRadio(
              isSelected: isChecked,
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

class RadioSubButtonTile extends StatelessWidget {
  const RadioSubButtonTile(
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
            CustomRadio(
              isSelected: isChecked,
              height: 18.r,
              width: 18.r,
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
