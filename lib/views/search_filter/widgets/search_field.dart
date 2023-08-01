import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 47.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18.w),
                    child: SvgPicture.asset(
                      Assets.iconsSearch1,
                      height: 16.5.r,
                      width: 16.5.r,
                    ),
                  )
                ],
              ),
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 7.w),
              hintText: context.loc.searchByNestID,
              hintStyle: FontPalette.black16SemiBold
                  .copyWith(color: HexColor('#8695A7')),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(30.r))),
        ));
  }
}
