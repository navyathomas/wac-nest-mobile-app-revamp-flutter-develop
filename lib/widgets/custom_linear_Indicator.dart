import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLinearIndicator extends StatefulWidget {
  final double height;
  final double width;
  final AnimationController? animationController;
  final Animation? sizeAnimation;
  const CustomLinearIndicator(
      {Key? key,
      this.height = 3,
      required this.width,
      required this.sizeAnimation,
      required this.animationController})
      : super(key: key);

  @override
  State<CustomLinearIndicator> createState() => _CustomLinearIndicatorState();
}

class _CustomLinearIndicatorState extends State<CustomLinearIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation!,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.26),
              borderRadius: BorderRadius.circular(100.r)),
          child: FractionallySizedBox(
            widthFactor: sizeAnimation!.value / 100,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100.r)),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    animationController = widget.animationController;
    sizeAnimation = widget.sizeAnimation;
    super.initState();
  }
}
