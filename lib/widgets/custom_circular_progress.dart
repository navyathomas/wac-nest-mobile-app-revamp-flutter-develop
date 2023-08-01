import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_palette.dart';

class CustomCircleProgress extends CustomPainter {
  final double currentProgress;
  final Color? outerColor;
  final Color? strokeColor;
  CustomCircleProgress(
      {this.currentProgress = 0.0, this.outerColor, this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 4.r
      ..color = outerColor ?? ColorPalette.pageBgColor
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 4.r
      ..color = strokeColor ?? HexColor('#00D394')
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, (size.height / 2));

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = currentProgress * (pi / 180);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / -2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
