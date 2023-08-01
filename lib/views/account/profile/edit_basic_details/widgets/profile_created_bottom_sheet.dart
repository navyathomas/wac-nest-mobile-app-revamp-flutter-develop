import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../auth_screens/registration/religion/custom_radio_tile.dart';
import '../../../../search_filter/widgets/custom_option_btn.dart';

class ProfileCreatedBottomSheet extends StatelessWidget {
  final BuildContext contexts;
  const ProfileCreatedBottomSheet({Key? key, required this.contexts})
      : super(key: key);

  Widget _optionContainer(BuildContext context) {
    List<String> options =
        context.read<SearchFilterProvider>().profileCreatedOptions(context);
    return SizedBox(
      height: context.sh(size: 0.5),
      child: Selector<AccountProvider, Tuple2<int, String>>(
        selector: (context, provider) => Tuple2(
            provider.selectedProfileCreatedIndex,
            (provider.profileCreated ?? '')),
        builder: (context, value, child) {
          int? initialIndex = options.indexOf(value.item2);
          return ListView.builder(
              itemCount: options.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemBuilder: (context, index) {
                return CustomRadioTile(
                  title: options[index],
                  isSelected: value.item1 == -1
                      ? index == initialIndex
                      : index == value.item1,
                  onTap: () async {
                    context.read<AccountProvider>()
                      ..updateProfileCreatedBy(options[index], index)
                      ..sendBasicInfoRequest(contexts, needPop: false);
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
    return Selector<AccountProvider, Tuple2<String?, int>>(
      selector: (context, provider) =>
          Tuple2(provider.profileCreated, provider.selectedProfileCreatedIndex),
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.profileCreatedFor,
          selectedValue: value.item2 == -1
              ? (value.item1 ?? '')
              : context
                  .read<SearchFilterProvider>()
                  .profileCreatedOptions(context)[value.item2],
          onTap: () => ReusableWidgets.singleSelectBottomSheet(
              context: context,
              child: _optionContainer(context),
              title: context.loc.profileCreatedFor),
        );
      },
    );
  }
}
