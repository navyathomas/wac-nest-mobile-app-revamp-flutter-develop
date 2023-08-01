import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../providers/matches_provider.dart';
import '../../widgets/customRadioTile.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_filter/widgets/custom_option_btn.dart';

class MatchesProfileCreatedBtn extends StatelessWidget {
  const MatchesProfileCreatedBtn({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context, int selectedIndex) {
    List<String> options =
        context.read<MatchesProvider>().createdOnOptions(context);

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
              context.read<MatchesProvider>().updateProfileCreatedIndex(index);
              context.rootPop;
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MatchesProvider, int>(
      selector: (context, provider) => provider.profileCreatedIndex,
      builder: (context, value, widget) {
        widget = _optionContainer(context, value);
        return CustomOptionBtn(
          title: context.loc.profilesCreated,
          selectedValue:
              context.read<MatchesProvider>().createdOnOptions(context)[value],
          onTap: () => ReusableWidgets.singleSelectBottomSheet(
              context: context,
              child: widget,
              title: context.loc.profilesCreated),
        );
      },
    );
  }
}
