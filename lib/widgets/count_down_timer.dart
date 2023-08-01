import 'dart:async';

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final TextStyle? textStyle;
  const CountDownTimer({Key? key, this.textStyle}) : super(key: key);

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer? countdownTimer;
  late ValueNotifier<Duration> myDuration;

  @override
  void initState() {
    myDuration = ValueNotifier(Duration(seconds: currentTimeInSeconds));
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    myDuration.dispose();
    if (countdownTimer!.isActive) {
      countdownTimer!.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondBy = 1;
    final seconds = myDuration.value.inSeconds - reduceSecondBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
      myDuration.value = Duration(seconds: currentTimeInSeconds);
      startTimer();
    } else {
      myDuration.value = Duration(seconds: seconds);
    }
  }

  static int get currentTimeInSeconds {
    DateTime now = DateTime.now();
    int seconds = (now.hour * 3600) + now.minute * 60 + now.second;
    return 86400 - seconds;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
        valueListenable: myDuration,
        builder: (context, value, _) {
          return Text(
            _timerText(value),
            style: widget.textStyle ??
                const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24),
          );
        });
  }

  String _timerText(Duration myDuration) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    String defValue = '$hours : $minutes : $seconds';

    return defValue;
  }
}
