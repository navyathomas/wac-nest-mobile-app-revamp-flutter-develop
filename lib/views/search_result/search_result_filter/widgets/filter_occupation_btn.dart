import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../models/job_data_model.dart';
import '../../../../providers/app_data_provider.dart';
import '../../../../providers/search_filter_provider.dart';
import '../../../../utils/tuple.dart';
import '../../../../widgets/bottom_response_view.dart';
import '../../../../widgets/reusable_widgets.dart';
import '../../../error_views/error_tile.dart';
import '../../../search_filter/widgets/apply_cancel_btn.dart';
import '../../../search_filter/widgets/custom_option_btn.dart';
import '../../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../../search_filter/widgets/filter_checkbox_tile.dart';

class FilterOccupationBtn extends StatefulWidget {
  const FilterOccupationBtn({Key? key}) : super(key: key);

  @override
  State<FilterOccupationBtn> createState() => _FilterOccupationBtnState();
}

class _FilterOccupationBtnState extends State<FilterOccupationBtn> {
  late final TextEditingController textEditingController;

  Widget _searchListView(Map<int, JobData?> selectedJObs) {
    return Selector<SearchFilterProvider, List<JobData>>(
        builder: (context, jobDataList, _) {
          return (jobDataList.isEmpty
                  ? const ErrorTile(
                      errors: Errors.searchResultError,
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: jobDataList.length,
                      itemBuilder: (context, index) {
                        JobData? jobData = jobDataList[index];
                        return FilterCheckBoxTile(
                          title: jobData.parentJobCategory ?? '',
                          isChecked: selectedJObs.containsKey(jobData.id ?? -1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 23.w, vertical: 12.h),
                          onTap: () {
                            context
                                .read<SearchFilterProvider>()
                                .updateSelectedOccupationFilterData(
                                    id: jobData.id, jobData: jobData);
                          },
                        );
                      }))
              .animatedSwitch();
        },
        selector: (context, provider) => provider.jobDataList ?? []);
  }

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider, Tuple2<JobDataModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.jobDataModel, provider.jobListLoader),
        builder: (context, value, child) {
          JobDataModel? jobDataModel = value.item1;

          return BottomResView(
              loaderState: value.item2,
              isEmpty: (jobDataModel?.jobData ?? []).isEmpty,
              onTap: () => context.read<AppDataProvider>().getOccupationList(),
              child: FilterBottomSheetContainer(
                title: '${context.loc.select} ${context.loc.occupation}',
                hideSearch: (jobDataModel?.jobData ?? []).isEmpty,
                hintText: '${context.loc.search} ${context.loc.occupation}',
                textEditingController: textEditingController,
                onClearTap: () => context
                    .read<SearchFilterProvider>()
                    .clearOccupationFilterData(),
                child: Expanded(
                  child: Selector<SearchFilterProvider, Map<int, JobData?>>(
                    selector: (context, provider) =>
                        provider.tempSelectedFilterOccupations,
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
                                  .assignTempToSelectedOccupationFilterData();
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
    return Selector<SearchFilterProvider, Map<int, JobData?>>(
      selector: (context, provider) =>
          provider.searchFilterValueModel?.selectedOccupations ?? {},
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.occupation,
          selectedValue:
              value.isEmpty ? '' : context.loc.selected(value.length),
          onTap: () {
            context
                .read<SearchFilterProvider>()
                .reAssignTempOccupationFilterData();
            ReusableWidgets.customBottomSheet(
                context: context, child: _optionContainer(context));
          },
        );
      },
    );
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<SearchFilterProvider>()
          .searchOccupationByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
