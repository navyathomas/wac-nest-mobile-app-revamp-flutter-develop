import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class ApplyCancelBtn extends StatelessWidget {
  const ApplyCancelBtn(
      {Key? key, this.onApplyTap, this.padding, this.onCancelTap})
      : super(key: key);
  final VoidCallback? onApplyTap;
  final VoidCallback? onCancelTap;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.maxFinite,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: HexColor('#E4E7E8'), width: 1.5.h))),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                    maximumSize: const Size.fromWidth(double.maxFinite),
                    shape: const RoundedRectangleBorder(side: BorderSide.none)),
                onPressed: onCancelTap ?? () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    context.loc.cancel,
                    style: FontPalette.white16Bold
                        .copyWith(color: HexColor('#131A24')),
                  ),
                )),
          ),
          Expanded(
            child: TextButton(
                style: TextButton.styleFrom(
                    maximumSize: const Size.fromWidth(double.maxFinite),
                    shape: const RoundedRectangleBorder(side: BorderSide.none)),
                onPressed: onApplyTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    context.loc.apply,
                    style: FontPalette.white16Bold
                        .copyWith(color: ColorPalette.primaryColor),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
