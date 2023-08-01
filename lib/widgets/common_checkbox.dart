import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../utils/color_palette.dart';

class CommonCheckBox extends StatelessWidget {
  final bool isChecked;
  final double? size;
  final double? iconSize;
  final Function()? onTap;
  const CommonCheckBox(
      {Key? key, this.isChecked = false, this.size, this.iconSize, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 21.r,
      width: size ?? 21.r,
      decoration: BoxDecoration(
        color: isChecked ? ColorPalette.primaryColor : Colors.white,
        border: Border.all(
            color: isChecked ? ColorPalette.primaryColor : HexColor('#8695A7'),
            width: 1),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: (isChecked
              ? InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.check,
                    size: iconSize ?? 18.0.r,
                    color: Colors.white,
                  ),
                )
              : InkWell(
                  onTap: onTap,
                  child: const Icon(
                    null,
                  ),
                ))
          .animatedSwitch(),
    );
  }
}
