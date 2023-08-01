import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/matching_stars_model.dart';
import 'package:nest_matrimony/models/search_value_model.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
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

class SearchMatchingStars extends StatefulWidget {
  const SearchMatchingStars({Key? key}) : super(key: key);

  @override
  State<SearchMatchingStars> createState() => _SearchMatchingStarsState();
}

class _SearchMatchingStarsState extends State<SearchMatchingStars> {
  late final TextEditingController textEditingController;
  Widget _searchListView(Map<int, MatchingStarsData?> selectedMatchingStars) {
    return Selector<SearchFilterProvider, List<MatchingStarsData>>(
        builder: (context, matchingStarsData, _) {
          return (matchingStarsData.isEmpty
                  ? const ErrorTile(
                      errors: Errors.searchResultError,
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: matchingStarsData.length,
                      itemBuilder: (context, index) {
                        MatchingStarsData? matchingStarData =
                            matchingStarsData[index];
                        return FilterCheckBoxTile(
                          title: matchingStarData.starName ?? '',
                          isChecked: selectedMatchingStars
                              .containsKey(matchingStarData.id ?? -1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 23.w, vertical: 12.h),
                          onTap: () {
                            context
                                .read<SearchFilterProvider>()
                                .updateSelectedMatchingStarData(
                                    id: matchingStarData.id,
                                    matchingStarsData: matchingStarData);
                          },
                        );
                      }))
              .animatedSwitch();
        },
        selector: (context, provider) => provider.matchingStarsList ?? []);
  }

  Widget _optionContainer(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<SearchFilterProvider,
          Tuple2<MatchingStarsModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.matchingStarsModel, provider.matchingStarsLoader),
        builder: (context, value, child) {
          MatchingStarsModel? matchingStarsModel = value.item1;
          return BottomResView(
              loaderState: value.item2,
              errors: Errors.noMatchingStars,
              isEmpty: (matchingStarsModel?.data ?? []).isEmpty,
              onTap: () {
                if (value.item2 == LoaderState.noData) {
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteGenerator.routeMainScreen, (route) => false);
                } else {
                  context.read<SearchFilterProvider>().getMatchingStarsData();
                }
              },
              child: FilterBottomSheetContainer(
                title: '${context.loc.select} ${context.loc.matchingStars}',
                hintText: '${context.loc.search} ${context.loc.matchingStars}',
                hideSearch: (matchingStarsModel?.data ?? []).isEmpty,
                textEditingController: textEditingController,
                onClearTap: () => context
                    .read<SearchFilterProvider>()
                    .clearMatchingStarsTempData(),
                child: Expanded(
                  child: Selector<SearchFilterProvider,
                      Map<int, MatchingStarsData?>>(
                    selector: (context, provider) =>
                        provider.tempSelectedMatchingStars,
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
                                  .assignTempToSelectedMatchingStarData();
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
    return Selector<SearchFilterProvider, SearchValueModel?>(
        selector: (context, provider) => provider.searchValueModel,
        builder: (context, searchValue, child) {
          child = Selector<SearchFilterProvider, Map<int, MatchingStarsData?>>(
            shouldRebuild: (previous, next) {
              return previous.keys != next.keys;
            },
            selector: (context, provider) =>
                provider.searchValueModel?.selectedMatchingStars ?? {},
            builder: (context, model, child) {
              return WidgetExtension.crossSwitch(
                  first: OptionSelectedText(
                    options:
                        model.values.map((e) => e?.starName ?? '').join(', '),
                  ),
                  second: 12.verticalSpace,
                  value: model.values.isNotEmpty);
            },
          );
          return ((searchValue?.religionListData?.religionName ?? '')
                  .toLowerCase()
                  .contains(context.loc.hindu.toLowerCase()))
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomOptionBtn(
                      title: context.loc.matchingStars,
                      selectedValue:
                          (searchValue?.selectedMatchingStars ?? {}).isEmpty
                              ? ''
                              : context.loc.selected(
                                  (searchValue?.selectedMatchingStars ?? {})
                                      .length),
                      onTap: () {
                        context.read<SearchFilterProvider>()
                          ..getMatchingStarsData()
                          ..reAssignTempMatchingStarData();
                        ReusableWidgets.customBottomSheet(
                            context: context, child: _optionContainer(context));
                      },
                    ),
                    child
                  ],
                )
              : const SizedBox.shrink();
        });
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<SearchFilterProvider>()
          .searchMatchingStarByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
