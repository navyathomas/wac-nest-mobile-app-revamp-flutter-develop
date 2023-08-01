import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/education_cat_model.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/matches_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/tuple.dart';
import '../../widgets/bottom_response_view.dart';
import '../../widgets/custom_expansion_tile.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_filter/search_filter_screen.dart';
import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/custom_option_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../search_filter/widgets/filter_checkbox_tile.dart';

class MatchesEducationBtn extends StatefulWidget {
  const MatchesEducationBtn({Key? key}) : super(key: key);

  @override
  State<MatchesEducationBtn> createState() => _MatchesEducationBtnState();
}

class _MatchesEducationBtnState extends State<MatchesEducationBtn> {
  late final TextEditingController textEditingController;

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider,
          Tuple2<EducationCategoryModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.educationCategoryModel, provider.loaderState),
        builder: (context, value, childWidget) {
          childWidget = FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.education}',
            hintText:
                "${context.loc.search} ${context.loc.education.toLowerCase()}",
            textEditingController: textEditingController,
            onClearTap: () {
              context.read<MatchesProvider>().clearFilterEduCategoryData();
            },
            child: Expanded(
              child: Consumer<MatchesProvider>(
                builder: (context, provider, child) {
                  List<EducationCategoryData>? eduListData =
                      provider.eduCatDataList;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: eduListData?.length ?? 0,
                            padding: EdgeInsets.only(bottom: 12.h),
                            itemBuilder: (context, index) {
                              EducationCategoryData? categoryData =
                                  eduListData?[index];
                              if (categoryData == null) {
                                return const SizedBox.shrink();
                              }
                              return CustomExpansionTile(
                                tilePadding: EdgeInsets.symmetric(
                                    horizontal: 23.w, vertical: 12.h),
                                title: FilterCheckBoxTile(
                                  title: categoryData.parentEducationCategory ??
                                      '',
                                  isChecked: provider
                                      .tempSelectedFilterEducation
                                      .containsKey(categoryData.id ?? -1),
                                ),
                                trailingExpand: Icon(
                                  Icons.add,
                                  color: HexColor('#8695A7'),
                                ),
                                trailingExpanded: Icon(Icons.remove,
                                    color: HexColor('#8695A7')),
                                childrenPadding: EdgeInsets.only(
                                    left: context.sw(size: 0.13),
                                    right: context.sw(size: 0.08),
                                    top: 5.h,
                                    bottom: 5.h),
                                children: [
                                  ListView.builder(
                                    itemBuilder: (context, subIndex) {
                                      ChildEducationCategory? childEduCat =
                                          categoryData.childEducationCategory?[
                                              subIndex];
                                      List<int> idList =
                                          provider.tempSelectedFilterEducation[
                                                  categoryData.id ?? -1] ??
                                              [];
                                      return FilterSubCheckBoxTile(
                                          title:
                                              childEduCat?.eduCategoryTitle ??
                                                  '',
                                          isChecked: idList
                                              .contains(childEduCat?.id ?? -1),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          onTap: () {
                                            context
                                                .read<MatchesProvider>()
                                                .updateSelectedEducation(
                                                    childEduCat?.id,
                                                    childEduCat
                                                        ?.eduCategoryTitle);
                                            context
                                                .read<MatchesProvider>()
                                                .updateSelectedFilterEduCatData(
                                                    parentId: categoryData.id,
                                                    childId: childEduCat?.id,
                                                    title: childEduCat
                                                            ?.eduCategoryTitle ??
                                                        '');
                                          });
                                    },
                                    itemCount: categoryData
                                            .childEducationCategory?.length ??
                                        0,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  )
                                ],
                              );
                            }),
                      ),
                      ApplyCancelBtn(
                        onApplyTap: () {
                          context
                              .read<MatchesProvider>()
                              .assignTempToSelectedFilterEduCatDat();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          );
          return BottomResView(
            loaderState: value.item2,
            isEmpty: (value.item1?.data ?? []).isEmpty,
            onTap: () => context.read<AppDataProvider>().getEduCatListData(),
            child: childWidget,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Selector<MatchesProvider, List<String>>(
        selector: (context, provider) =>
            provider.searchFilterValueModel?.selectedEduCategories ?? [],
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.education,
            selectedValue:
                value.isEmpty ? '' : context.loc.selected(value.length),
            onTap: () {
              textEditingController.clear();
              context.read<MatchesProvider>().reAssignTempEduCatFilterData();
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
                    (model.searchFilterValueModel?.selectedEduCategories ?? [])
                        .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedEducation ?? {})
                  .values
                  .isNotEmpty);
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
          .searchEduByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
