import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../models/religion_list_model.dart';

class ReligionBottomSheet extends StatelessWidget {
  const ReligionBottomSheet({Key? key}) : super(key: key);

  Widget _optionContainer(
      BuildContext context, List<ReligionListData>? religionListData) {
    return ListView.builder(
        itemCount: religionListData?.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<ProfileProvider>().changeDoneBtnActiveState(false);
              context.read<AccountProvider>()
                ..updateReligionOnChanged(religionListData?[index], context)
                ..getCasteDataList(context: context);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    religionListData?[index].religionName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<AccountProvider, ReligionListData?>(
                    selector: (context, provider) => provider.religionListData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (religionListData?[index].id ?? -2),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AccountProvider, ReligionListData?>(
      selector: (context, provider) => provider.religionListData,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.religion,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<ReligionListModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.religionListModel, provider.religionListLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () =>
                            context.read<AppDataProvider>().getReligionList(),
                        isEmpty: (value.item1?.data ?? []).isEmpty,
                        child:
                            _optionContainer(context, value.item1?.data ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.religion,
          selectedValue: value?.religionName ?? '',
          marginTop: 0.h,
          onTap: (value?.religionName ?? '') != ''
              ? null
              : () {
                  ReusableWidgets.customBottomSheet(
                      context: context, child: childWidget);
                },
        );
      },
    );
  }
}
