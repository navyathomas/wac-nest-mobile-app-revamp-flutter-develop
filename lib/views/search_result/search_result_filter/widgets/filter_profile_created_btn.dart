import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/customRadioTile.dart';
import '../../../search_filter/widgets/custom_option_btn.dart';

class FilterProfileCreatedBtn extends StatelessWidget {
  const FilterProfileCreatedBtn({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context, int selectedIndex) {
    List<String> options =
        context.read<SearchFilterProvider>().createdOnOptions(context);

    return ListView.builder(
        itemCount: options.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
        itemBuilder: (context, index) {
          return CustomRadioTile(
            title: options[index],
            isSelected: selectedIndex == index,
            onTap: () {
              context
                  .read<SearchFilterProvider>()
                  .updateProfileCreatedIndex(index);
              context.rootPop;
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SearchFilterProvider, int>(
      selector: (context, provider) => provider.profileCreatedIndex,
      builder: (context, value, widget) {
        widget = _optionContainer(context, value);
        return CustomOptionBtn(
          title: context.loc.profilesCreated,
          selectedValue: context
              .read<SearchFilterProvider>()
              .createdOnOptions(context)[value],
          onTap: () => ReusableWidgets.singleSelectBottomSheet(
              context: context,
              child: widget,
              title: context.loc.profilesCreated),
        );
      },
    );
  }
}
