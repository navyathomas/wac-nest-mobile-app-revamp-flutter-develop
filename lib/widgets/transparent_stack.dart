import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';

class TransparentStack extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final Color color;
  const TransparentStack(
      {Key? key,
      required this.child,
      this.inAsyncCall = false,
      this.color = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        (inAsyncCall
                ? Stack(
                    children: [
                      ModalBarrier(dismissible: false, color: color),
                    ],
                  )
                : const SizedBox())
            .animatedSwitch()
      ],
    );
  }
}
