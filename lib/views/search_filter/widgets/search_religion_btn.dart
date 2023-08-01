import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/custom_radio.dart';
import '../../../widgets/reusable_widgets.dart';
import 'custom_option_btn.dart';

class SearchReligionBtn extends StatelessWidget {
  const SearchReligionBtn({Key? key}) : super(key: key);

  Widget _optionContainer(
      BuildContext context, List<ReligionListData>? religionListData) {
    return ListView.builder(
        itemCount: religionListData!.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<SearchFilterProvider>()
                ..updateReligionData(religionListData[index])
                ..clearCasteTempData()
                ..clearCasteData()
                ..clearMatchingStarsData()
                ..clearMatchingStarsTempData()
                ..getCasteDataList();
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    religionListData[index].religionName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<SearchFilterProvider, ReligionListData?>(
                    selector: (context, provider) =>
                        provider.searchValueModel?.religionListData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (religionListData[index].id ?? -2),
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
    return Selector<SearchFilterProvider, ReligionListData?>(
      selector: (context, provider) =>
          provider.searchValueModel?.religionListData,
      shouldRebuild: (p0, p1) => p0 != p1,
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
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }
}
