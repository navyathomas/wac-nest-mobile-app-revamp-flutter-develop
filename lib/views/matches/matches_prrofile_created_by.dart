import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../providers/matches_provider.dart';
import '../../widgets/customRadioTile.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_filter/widgets/custom_option_btn.dart';

class MatchesProfileCreatedByBtn extends StatelessWidget {
  const MatchesProfileCreatedByBtn({Key? key}) : super(key: key);

  Widget _optionContainer(
    BuildContext context,
  ) {
    List<String> options =
        context.read<MatchesProvider>().profileCreatedOptions(context);
    return SizedBox(
      height: context.sh(size: 0.5),
      child: Selector<MatchesProvider, int>(
        selector: (context, provider) => provider.selectedProfileCreatedIndex,
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: options.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemBuilder: (context, index) {
                return CustomRadioTile(
                  title: options[index],
                  isSelected: index == value,
                  onTap: () {
                    context
                        .read<MatchesProvider>()
                        .updateProfileCreatedBy(index);
                    context.rootPop;
                  },
                );
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MatchesProvider, int>(
      selector: (context, provider) => provider.selectedProfileCreatedIndex,
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.profileCreatedFor,
          selectedValue: value == -1
              ? ''
              : context
                  .read<MatchesProvider>()
                  .profileCreatedOptions(context)[value],
          onTap: () => ReusableWidgets.singleSelectBottomSheet(
              context: context,
              child: _optionContainer(context),
              title: context.loc.profileCreatedFor),
        );
      },
    );
  }
}
