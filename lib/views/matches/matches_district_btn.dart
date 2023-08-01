import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/district_data_model.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/matches_provider.dart';
import '../../utils/tuple.dart';
import '../../widgets/bottom_response_view.dart';
import '../../widgets/reusable_widgets.dart';
import '../error_views/error_tile.dart';
import '../search_filter/search_filter_screen.dart';
import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/custom_option_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../search_filter/widgets/filter_checkbox_tile.dart';

class MatchesDistrictBtn extends StatefulWidget {
  const MatchesDistrictBtn({Key? key}) : super(key: key);

  @override
  State<MatchesDistrictBtn> createState() => _MatchesDistrictBtnState();
}

class _MatchesDistrictBtnState extends State<MatchesDistrictBtn> {
  late final TextEditingController textEditingController;
  Widget _searchListView(Map<int, DistrictData?> selectedDistricts) {
    return Selector<MatchesProvider, List<DistrictData>>(
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
                                .read<MatchesProvider>()
                                .updateSelectedDistrictFilterData(
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
                onClearTap: () {
                  context.read<MatchesProvider>().clearDistrictTempFilterData();
                },
                child: Expanded(
                  child: Selector<MatchesProvider, Map<int, DistrictData?>>(
                    selector: (context, provider) =>
                        provider.tempSelectedFilterDistricts,
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
                                  .read<MatchesProvider>()
                                  .assignTempToSelectedDistrictFilterData();
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
      Selector<MatchesProvider, Tuple2<Map<int, DistrictData?>, int?>>(
        selector: (context, provider) => Tuple2(
            provider.searchFilterValueModel?.selectedDistricts ?? {},
            provider.searchFilterValueModel?.stateData?.id),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.district,
            selectedValue: value.item1.isEmpty
                ? ''
                : context.loc.selected(value.item1.length),
            onTap: value.item2 == null
                ? null
                : () {
                    context
                        .read<MatchesProvider>()
                        .reAssignTempDistrictFilterData();
                    ReusableWidgets.customBottomSheet(
                        context: context,
                        child: _optionContainer(context, value.item2 ?? -1));
                  },
          );
        },
      ),
      Selector<MatchesProvider, Map<int, DistrictData?>>(
        shouldRebuild: (previous, next) {
          return previous.keys != next.keys;
        },
        selector: (context, provider) =>
            provider.searchFilterValueModel?.selectedDistricts ?? {},
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    model.values.map((e) => e?.districtName ?? '').join(', '),
              ),
              value: model.values.isNotEmpty);
        },
      )
    ]);
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<MatchesProvider>()
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
