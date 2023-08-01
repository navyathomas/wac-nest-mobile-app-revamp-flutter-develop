import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/color_palette.dart';

class CustomSlider extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final RangeValues rangeValues;
  final Function(double, double) onChange;

  const CustomSlider(
      {Key? key,
      required this.maxValue,
      required this.rangeValues,
      required this.minValue,
      required this.onChange})
      : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late ValueNotifier<RangeValues> _currentRangeValues;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RangeValues>(
        valueListenable: _currentRangeValues,
        builder: (context, value, _) {
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorPalette.primaryColor,
              inactiveTrackColor: HexColor('#DFE5EB'),
              trackHeight: 2.5.h,
              thumbColor: HexColor('#C1C9D2'),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 6),
              rangeThumbShape: CircleThumbShape(thumbRadius: 12.5.h),
            ),
            child: RangeSlider(
              key: widget.key,
              values: value,
              min: widget.minValue,
              max: widget.maxValue,
              labels: RangeLabels(
                value.start.round().toString(),
                value.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                _currentRangeValues.value = values;
                widget.onChange(values.start, values.end);
              },
            ),
          );
        });
  }

  @override
  void initState() {
    _currentRangeValues = ValueNotifier(widget.rangeValues);
    super.initState();
  }
}

class CircleThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  const CircleThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      bool? isDiscrete,
      bool? isEnabled,
      bool? isOnTop,
      bool? isPressed,
      required SliderThemeData sliderTheme,
      TextDirection? textDirection,
      Thumb? thumb}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..strokeWidth = 1.r
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
