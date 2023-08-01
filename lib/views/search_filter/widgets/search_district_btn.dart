import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../error_views/error_tile.dart';
import '../search_filter_screen.dart';
import 'apply_cancel_btn.dart';
import 'custom_option_btn.dart';
import 'filter_bottom_sheet_container.dart';
import 'filter_checkbox_tile.dart';

class SearchDistrictBtn extends StatefulWidget {
  const SearchDistrictBtn({Key? key}) : super(key: key);

  @override
  State<SearchDistrictBtn> createState() => _SearchDistrictBtnState();
}

class _SearchDistrictBtnState extends State<SearchDistrictBtn> {
  late final TextEditingController textEditingController;
  Widget _searchListView(Map<int, DistrictData?> selectedDistricts) {
    return Selector<SearchFilterProvider, List<DistrictData>>(
        builder: (context, districtDataList, _) {
          return (districtDataList.isEmpty
                  ? const ErrorTile(
                      errors: Errors.searchResultError,
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: districtDataList.length,
                      itemBuilder: (context, index) {
                        DistrictData? districtData = districtDataList[index];
                        return FilterCheckBoxTile(
                          title: districtData.districtName ?? '',
                          isChecked: selectedDistricts
                              .containsKey(districtData.id ?? -1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 23.w, vertical: 12.h),
                          onTap: () {
                            context
                                .read<SearchFilterProvider>()
                                .updateSelectedDistrictData(
                                    id: districtData.id,
                                    districtData: districtData);
                          },
                        );
                      }))
              .animatedSwitch();
        },
        selector: (context, provider) => provider.districtDataList ?? []);
  }

  Widget _optionContainer(BuildContext context, int stateId) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider, Tuple2<DistrictDataModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.districtDataModel, provider.districtListLoader),
        builder: (context, value, child) {
          DistrictDataModel? districtDataModel = value.item1;
          return BottomResView(
              loaderState: value.item2,
              isEmpty: (districtDataModel?.districtData ?? []).isEmpty,
              onTap: () => context
                  .read<AppDataProvider>()
                  .getDistrictList(context, stateId),
              child: FilterBottomSheetContainer(
                title: '${context.loc.select} ${context.loc.district}',
                hintText: '${context.loc.search} ${context.loc.district}',
                hideSearch: (districtDataModel?.districtData ?? []).isEmpty,
                textEditingController: textEditingController,
                onClearTap: () => context
                    .read<SearchFilterProvider>()
                    .clearDistrictTempData(),
                child: Expanded(
                  child:
                      Selector<SearchFilterProvider, Map<int, DistrictData?>>(
                    selector: (context, provider) =>
                        provider.tempSelectedDistricts,
                    shouldRebuild: (previous, next) {
                      return previous.keys != next.keys;
                    },
                    builder: (context, selectedValue, child) {
                      return Column(
                        children: [
                          Expanded(
                            child: _searchListView(selectedValue),
                          ),
                          ApplyCancelBtn(
                            onApplyTap: () {
                              context
                                  .read<SearchFilterProvider>()
                                  .assignTempToSelectedDistrictData();
                              context.rootPop;
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<SearchFilterProvider, Tuple2<Map<int, DistrictData?>, int?>>(
          selector: (context, provider) => Tuple2(
              provider.searchValueModel?.selectedDistricts ?? {},
              provider.searchValueModel?.stateData?.id),
          shouldRebuild: (p0, p1) => p0.item1 != p1.item1,
          builder: (context, value, child) {
            return CustomOptionBtn(
              title: context.loc.district,
              selectedValue: value.item1.isEmpty
                  ? ''
                  : context.loc.selected(value.item1.length),
              onTap: value.item2 == null
                  ? null
                  : () {
                      final searchModel = context.read<SearchFilterProvider>();
                      searchModel.reAssignTempDistrictData();
                      context.read<AppDataProvider>().getDistrictList(context,
                          searchModel.searchValueModel?.stateData?.id ?? -1);
                      ReusableWidgets.customBottomSheet(
                          context: context,
                          child: _optionContainer(context, value.item2 ?? -1));
                    },
            );
          },
        ),
        Selector<SearchFilterProvider, Map<int, DistrictData?>>(
          shouldRebuild: (previous, next) {
            return previous.keys != next.keys;
          },
          selector: (context, provider) =>
              provider.searchValueModel?.selectedDistricts ?? {},
          builder: (context, model, child) {
            return WidgetExtension.crossSwitch(
                first: OptionSelectedText(
                  options:
                      model.values.map((e) => e?.districtName ?? '').join(', '),
                ),
                value: model.values.isNotEmpty);
          },
        )
      ],
    );
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<SearchFilterProvider>()
          .searchDistrictByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
