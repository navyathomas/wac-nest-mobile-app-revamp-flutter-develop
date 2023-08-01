import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/extensions.dart';
import '../../models/caste_list_model.dart';
import '../../models/religion_list_model.dart';
import '../../providers/matches_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/tuple.dart';
import '../../widgets/bottom_response_view.dart';
import '../../widgets/reusable_widgets.dart';
import '../error_views/error_tile.dart';
import '../search_filter/search_filter_screen.dart';
import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/custom_option_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../search_filter/widgets/filter_checkbox_tile.dart';

class MatchesCasteBtn extends StatefulWidget {
  const MatchesCasteBtn({Key? key}) : super(key: key);

  @override
  State<MatchesCasteBtn> createState() => _FilterCasteBtnState();
}

class _FilterCasteBtnState extends State<MatchesCasteBtn> {
  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;

  Widget _mainListView(
      CasteListModel? casteListModel, Map<int, String> selectedCaste) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        if ((casteListModel?.data?.mostUsedCaste ?? []).isNotEmpty) ...[
          SliverList(
              delegate: SliverChildBuilderDelegate((cxt, index) {
            CasteData? mostUsedCaste =
                casteListModel?.data!.mostUsedCaste![index];
            return FilterCheckBoxTile(
              title: mostUsedCaste?.casteName ?? '',
              isChecked: selectedCaste.containsKey(mostUsedCaste?.id ?? -1),
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
              onTap: () {
                context.read<MatchesProvider>().updateSelectedFilterCaste(
                    mostUsedCaste?.id, mostUsedCaste?.casteName);
              },
            );
          }, childCount: casteListModel!.data!.mostUsedCaste!.length)),
          SliverToBoxAdapter(
            child: WidgetExtension.horizontalDivider(
                color: HexColor('#E4E7E8'),
                margin: EdgeInsets.symmetric(horizontal: 27.w, vertical: 9.h)),
          )
        ],
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          CasteData? caste = casteListModel!.data!.castes![index];
          return FilterCheckBoxTile(
            title: caste.casteName ?? '',
            isChecked: selectedCaste.containsKey(caste.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context
                  .read<MatchesProvider>()
                  .updateSelectedFilterCaste(caste.id, caste.casteName);
            },
          );
        }, childCount: casteListModel?.data?.castes?.length ?? 0))

        ///TODO: need to change no data found
      ],
    );
  }

  Widget _searchListView(
      List<CasteData> casteDataList, Map<int, String> selectedCaste) {
    return (casteDataList.isEmpty
            ? const ErrorTile(
                errors: Errors.searchResultError,
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: casteDataList.length,
                itemBuilder: (context, index) {
                  CasteData? userCaste = casteDataList[index];
                  return FilterCheckBoxTile(
                    title: userCaste.casteName ?? '',
                    isChecked: selectedCaste.containsKey(userCaste.id ?? -1),
                    padding:
                        EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
                    onTap: () {
                      context.read<MatchesProvider>().updateSelectedFilterCaste(
                          userCaste.id, userCaste.casteName);
                    },
                  );
                }))
        .animatedSwitch();
  }

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Consumer<MatchesProvider>(
        builder: (context, model, child) {
          CasteListModel? casteListModel = model.casteListModel;
          List<CasteData>? casteDataList = model.casteDataList;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.caste}',
            hideSearch: (casteListModel?.data?.castes ?? []).isEmpty,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () =>
                context.read<MatchesProvider>().clearCasteTempFilterData(),
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (casteListModel?.data?.castes ?? []).isEmpty,
              onTap: () => model.getCasteDataList(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return (value.isEmpty
                                  ? _mainListView(casteListModel,
                                      model.tempSelectedFilterCaste)
                                  : _searchListView(casteDataList ?? [],
                                      model.tempSelectedFilterCaste))
                              .animatedSwitch();
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context
                          .read<MatchesProvider>()
                          .assignTempToSelectedFilterCaste();
                      context.rootPop;
                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Selector<MatchesProvider, Tuple2<ReligionListData?, Map<int, String>>>(
        selector: (context, provider) => Tuple2(
            provider.searchFilterValueModel?.religionListData,
            provider.searchFilterValueModel?.selectedCaste ?? {}),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.caste,
            selectedValue: value.item2.isEmpty
                ? ''
                : context.loc.selected(value.item2.length),
            onTap: value.item1 == null
                ? null
                : () {
                    context
                        .read<MatchesProvider>()
                        .reAssignTempFilterCasteData();
                    ReusableWidgets.customBottomSheet(
                        context: context, child: _optionContainer(context));
                  },
          );
        },
      ),
      Consumer<MatchesProvider>(
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    (model.searchFilterValueModel?.selectedCaste?.values ?? [])
                        .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedCaste ?? {})
                  .values
                  .isNotEmpty);
        },
      )
    ]);
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    searchQuery = ValueNotifier('');
    textEditingController.addListener(() {
      searchQuery.value = textEditingController.text;
      context
          .read<MatchesProvider>()
          .searchCasteByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    searchQuery.dispose();
    super.dispose();
  }
}
