import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class Countdown extends StatefulWidget {
  final int seconds;
  final Duration interval;
  final VoidCallback? onTap;

  const Countdown({
    Key? key,
    required this.seconds,
    this.onTap,
    this.interval = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  final int _secondsFactor = 1000000;
  late ValueNotifier<int> _currentMicroSeconds;
  // Timer
  Timer? _timer;

  bool _onFinishedExecuted = false;

  @override
  void initState() {
    _currentMicroSeconds = ValueNotifier(widget.seconds * _secondsFactor);

    _startTimer();

    super.initState();
  }

  @override
  void didUpdateWidget(Countdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _currentMicroSeconds.value = widget.seconds * _secondsFactor;
    }
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _currentMicroSeconds,
        builder: (context, value, _) {
          int count = value ~/ _secondsFactor;
          return count != 0
              ? Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Text(
                    "0:${count.toString().padLeft(2, '0')}",
                    style: count < 10
                        ? FontPalette.black16Medium
                            .copyWith(color: HexColor('#FF0000'))
                        : FontPalette.black16Medium,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    _onTimerRestart();
                    if (widget.onTap != null) widget.onTap!();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Text(
                      context.loc.didNtGetCode,
                      style: FontPalette.black14SemiBold
                          .copyWith(color: HexColor('#2995E5')),
                    ),
                  ),
                );
        });
  }

  void _onTimerRestart() {
    _onFinishedExecuted = false;
    _currentMicroSeconds.value = widget.seconds * _secondsFactor;
    _startTimer();
  }

  void _startTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }

    if (_currentMicroSeconds.value != 0) {
      _timer = Timer.periodic(
        widget.interval,
        (Timer timer) {
          if (_currentMicroSeconds.value <= 0) {
            timer.cancel();
            _onFinishedExecuted = true;
          } else {
            _currentMicroSeconds.value =
                _currentMicroSeconds.value - widget.interval.inMicroseconds;
          }
        },
      );
    } else if (!_onFinishedExecuted) {
      _onFinishedExecuted = true;
    }
  }
}
