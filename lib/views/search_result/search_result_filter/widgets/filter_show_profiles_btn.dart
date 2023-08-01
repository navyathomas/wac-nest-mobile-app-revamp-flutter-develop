import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../../widgets/reusable_widgets.dart';
import '../../../search_filter/search_filter_screen.dart';
import '../../../search_filter/widgets/apply_cancel_btn.dart';
import '../../../search_filter/widgets/custom_option_btn.dart';
import '../../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../../search_filter/widgets/filter_checkbox_tile.dart';

class FilterShowProfileBtn extends StatelessWidget {
  FilterShowProfileBtn({Key? key}) : super(key: key);

  final ValueNotifier<int> _selected = ValueNotifier(-1);
  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: FilterBottomSheetContainer(
        title: context.loc.showProfiles,
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: 20,
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemBuilder: (context, index) {
                      return ValueListenableBuilder<int>(
                          valueListenable: _selected,
                          builder: (context, value, _) {
                            return FilterCheckBoxTile(
                              title: 'Premiun',
                              isChecked: value == index,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 23.w, vertical: 12.h),
                              onTap: () {
                                _selected.value = index;
                              },
                            );
                          });
                    }),
              ),
              ApplyCancelBtn(
                onApplyTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomOptionBtn(
          title: context.loc.showProfiles,
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: _optionContainer(context));
          },
        ),
        false
            ? OptionSelectedText(
                options: 'Premium',
              )
            : SizedBox()
      ],
    );
  }
}
