import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_search_field.dart';

class FilterBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final bool hideSearch;
  final String? hintText;
  final VoidCallback? onClearTap;
  final String? title;
  final TextEditingController? textEditingController;
  final bool disableBtn;
  const FilterBottomSheetContainer(
      {Key? key,
      required this.child,
      this.hideSearch = false,
      this.onClearTap,
      this.title,
      this.textEditingController,
      this.hintText,
      this.disableBtn = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        5.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              ReusableWidgets.roundedCloseBtn(context),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                    right: 33.r, left: onClearTap != null ? 60.w : 0),
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: FontPalette.white16Bold
                      .copyWith(color: HexColor('#09274D')),
                ),
              )),
              if (onClearTap != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClearTap,
                    highlightColor: Colors.grey.shade200,
                    splashColor: Colors.grey.shade300,
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Container(
                      width: 60.w,
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(context.loc.reset,
                            style: FontPalette.white16Bold.copyWith(
                                color: disableBtn
                                    ? Colors.grey
                                    : HexColor('#1183D8'))),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        12.verticalSpace,
        if (!hideSearch)
          CommonSearchField(
            hintText: hintText ?? '',
            textEditingController: textEditingController,
          ),
        child
      ],
    );
  }
}
