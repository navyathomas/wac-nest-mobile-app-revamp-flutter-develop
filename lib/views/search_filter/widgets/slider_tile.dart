import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../utils/font_palette.dart';
import 'custom_slider.dart';

class SliderTile extends StatelessWidget {
  final String leadingTxt;
  final Widget trailingText;
  final double minValue;
  final double maxValue;
  final RangeValues rangeValues;
  final Function(double, double) onChange;
  const SliderTile(
      {Key? key,
      required this.leadingTxt,
      required this.trailingText,
      required this.maxValue,
      required this.rangeValues,
      required this.minValue,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Row(
            children: [
              Text(leadingTxt, style: FontPalette.f131A24_16SemiBold)
                  .avoidOverFlow(),
              Expanded(child: trailingText)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 26.h),
          child: CustomSlider(
            minValue: minValue,
            maxValue: maxValue,
            rangeValues: rangeValues,
            onChange: (start, end) {
              onChange(start, end);
            },
          ),
        )
      ],
    );
  }
}
