import 'package:flutter/material.dart';

import '../utils/font_palette.dart';

class CommonTextBtn extends StatelessWidget {
  final Widget? titleWidget;
  final String? text;
  final VoidCallback? onTap;
  const CommonTextBtn({Key? key, this.titleWidget, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        onPressed: onTap,
        child: titleWidget ??
            Text(
              text ?? '',
              style: FontPalette.black14MediumUnderLine,
            ));
  }
}
