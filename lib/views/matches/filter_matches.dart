import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';

import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';

class FilterMatches extends StatelessWidget {
  const FilterMatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetContainer(
      hideSearch: true,
      child: Container(
        height: context.sh(size: 0.86).h,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: HexColor('#E4E7E8')))),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [],
              ),
            ),
            ApplyCancelBtn(
              onApplyTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
