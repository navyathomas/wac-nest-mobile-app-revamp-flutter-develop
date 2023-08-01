import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/error_views/error_tile.dart';
import 'package:provider/provider.dart';
import '../../../models/caste_list_model.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../search_filter_screen.dart';
import 'apply_cancel_btn.dart';
import 'custom_option_btn.dart';
import 'filter_bottom_sheet_container.dart';
import 'filter_checkbox_tile.dart';

class SearchCasteBtn extends StatefulWidget {
  const SearchCasteBtn({Key? key}) : super(key: key);

  @override
  State<SearchCasteBtn> createState() => _SearchCasteBtnState();
}

class _SearchCasteBtnState extends State<SearchCasteBtn> {
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
                context.read<SearchFilterProvider>().updateSelectedCaste(
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
                  .read<SearchFilterProvider>()
                  .updateSelectedCaste(caste.id, caste.casteName);
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
                      context.read<SearchFilterProvider>().updateSelectedCaste(
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
      child: Consumer<SearchFilterProvider>(
        builder: (context, model, child) {
          CasteListModel? casteListModel = model.casteListModel;
          List<CasteData>? casteDataList = model.casteDataList;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.caste}',
            hideSearch: (casteListModel?.data?.castes ?? []).isEmpty,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () =>
                context.read<SearchFilterProvider>().clearCasteTempData(),
            disableBtn: model.tempSelectedCaste.isEmpty,
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
                                  ? _mainListView(
                                      casteListModel, model.tempSelectedCaste)
                                  : _searchListView(casteDataList ?? [],
                                      model.tempSelectedCaste))
                              .animatedSwitch();
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context
                          .read<SearchFilterProvider>()
                          .assignTempToSelectedCaste();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<SearchFilterProvider,
            Tuple2<ReligionListData?, Map<int, String>>>(
          selector: (context, provider) => Tuple2(
              provider.searchValueModel?.religionListData,
              provider.searchValueModel?.selectedCaste ?? {}),
          builder: (context, value, child) {
            return CustomOptionBtn(
              title: context.loc.caste,
              selectedValue: value.item2.isEmpty
                  ? ''
                  : context.loc.selected(value.item2.length),
              onTap: value.item1?.id == null || (value.item1?.id ?? -1) == 3
                  ? null
                  : () {
                      context
                          .read<SearchFilterProvider>()
                          .reAssignTempCasteData();
                      ReusableWidgets.customBottomSheet(
                          context: context, child: _optionContainer(context));
                    },
            );
          },
        ),
        Consumer<SearchFilterProvider>(
          builder: (context, model, child) {
            return WidgetExtension.crossSwitch(
                first: OptionSelectedText(
                  options: (model.searchValueModel?.selectedCaste ?? {})
                      .values
                      .join(', '),
                ),
                second: 12.verticalSpace,
                value: (model.searchValueModel?.selectedCaste ?? {})
                    .values
                    .isNotEmpty);
          },
        )
      ],
    );
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    searchQuery = ValueNotifier('');
    textEditingController.addListener(() {
      searchQuery.value = textEditingController.text;
      context
          .read<SearchFilterProvider>()
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
