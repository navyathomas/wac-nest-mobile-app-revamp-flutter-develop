import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';

class CommonFloatingBtn extends StatelessWidget {
  final bool enableBtn;
  final bool enableLoader;
  final VoidCallback? onPressed;
  const CommonFloatingBtn(
      {Key? key,
      this.enableBtn = false,
      this.enableLoader = false,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: (enableBtn || enableLoader)
          ? ColorPalette.primaryColor
          : HexColor('#C1C9D2'),
      onPressed: !enableLoader && enableBtn ? onPressed : null,
      child: (enableLoader
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : SvgPicture.asset(
                  Assets.iconsArrowRight,
                  height: 17.r,
                  width: 17.r,
                ))
          .animatedSwitch(),
    );
  }
}
