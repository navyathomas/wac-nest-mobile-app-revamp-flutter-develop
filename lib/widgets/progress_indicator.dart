import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

class StackLoader extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  const StackLoader({
    Key? key,
    required this.child,
    this.inAsyncCall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        (inAsyncCall
                ? Stack(
                    children: [
                      const Opacity(
                        opacity: 0.3,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.white),
                      ),
                      ReusableWidgets.circularProgressIndicator()
                    ],
                  )
                : const SizedBox())
            .animatedSwitch()
      ],
    );
  }
}
