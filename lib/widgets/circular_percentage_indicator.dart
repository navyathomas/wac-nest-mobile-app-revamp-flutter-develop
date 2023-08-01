import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/widgets/custom_circular_progress.dart';

class CircularPercentageIndicator extends StatefulWidget {
  final double? height;
  final double? width;
  final Function(double)? onChange;
  final Color? outerColor;
  final Color? strokeColor;
  final double percentage;
  final bool enableAnimation;
  const CircularPercentageIndicator(
      {Key? key,
      this.height,
      this.width,
      this.onChange,
      this.outerColor,
      this.percentage = 100.0,
      this.enableAnimation = true,
      this.strokeColor})
      : super(key: key);

  @override
  State<CircularPercentageIndicator> createState() =>
      _CircularPercentageIndicatorState();
}

class _CircularPercentageIndicatorState
    extends State<CircularPercentageIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Tween<double> tween;

  @override
  Widget build(BuildContext context) {
    return widget.enableAnimation
        ? AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, _) {
              return CustomPaint(
                size: Size(widget.width ?? double.maxFinite,
                    widget.height ?? double.maxFinite),
                painter: CustomCircleProgress(
                    currentProgress: (animation.value / 100) * 360,
                    outerColor: HexColor('#E5E5E5')),
                child: widget.onChange.isNull
                    ? null
                    : widget.onChange!(animation.value),
              );
            },
          )
        : CustomPaint(
            size: Size(widget.width ?? double.maxFinite,
                widget.height ?? double.maxFinite),
            painter: CustomCircleProgress(
                currentProgress: (widget.percentage / 100) * 360,
                outerColor: HexColor('#E5E5E5')),
            child: widget.onChange.isNull
                ? null
                : widget.onChange!(widget.percentage),
          );
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    tween = Tween(begin: 0.0, end: widget.percentage);
    animation = tween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    if (widget.enableAnimation) {
      animationController.forward();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircularPercentageIndicator oldWidget) {
    if (oldWidget.percentage != widget.percentage) {
      tween.begin = oldWidget.percentage;
      tween.end = widget.percentage;
      animationController.reset();
      animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
