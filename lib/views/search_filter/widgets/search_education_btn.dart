import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/widget_handler/data_collection_alert_handler.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/custom_expansion_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/education_cat_model.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../search_filter_screen.dart';
import 'apply_cancel_btn.dart';
import 'custom_option_btn.dart';
import 'filter_bottom_sheet_container.dart';
import 'filter_checkbox_tile.dart';

class SearchEducationBtn extends StatefulWidget {
  const SearchEducationBtn({Key? key}) : super(key: key);

  @override
  State<SearchEducationBtn> createState() => _SearchEducationBtnState();
}

class _SearchEducationBtnState extends State<SearchEducationBtn> {
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
            onClearTap: () =>
                context.read<SearchFilterProvider>().clearEduCategoryData(),
            child: Expanded(
              child: Consumer<SearchFilterProvider>(
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
                                  isChecked: provider.tempSelectedEducation
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
                                          provider.tempSelectedEducation[
                                                  categoryData.id ?? -1] ??
                                              [];
                                      return FilterSubCheckBoxTile(
                                        title:
                                            childEduCat?.eduCategoryTitle ?? '',
                                        isChecked: idList
                                            .contains(childEduCat?.id ?? -1),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        onTap: () => context
                                            .read<SearchFilterProvider>()
                                            .updateSelectedEduCatData(
                                                parentId: categoryData.id,
                                                childId: childEduCat?.id,
                                                title: childEduCat
                                                        ?.eduCategoryTitle ??
                                                    ''),
                                      );
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
                              .read<SearchFilterProvider>()
                              .assignTempToSelectedEduCatDat();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<SearchFilterProvider, List<String>>(
          selector: (context, provider) =>
              provider.searchValueModel?.selectedEduCategories ?? [],
          shouldRebuild: (p0, p1) => p0 != p1,
          builder: (context, value, child) {
            return CustomOptionBtn(
              title: context.loc.education,
              selectedValue:
                  value.isEmpty ? '' : context.loc.selected(value.length),
              onTap: () async {
                bool res = await context
                    .read<SearchFilterProvider>()
                    .checkEducationDataUpdated(context);
                if (res) {
                  textEditingController.clear();
                  context.read<SearchFilterProvider>().reAssignTempEduCatData();
                  ReusableWidgets.customBottomSheet(
                      context: context, child: _optionContainer(context));
                } else {
                  DataCollectionAlertHandler.instance
                      .openAddEduDetailsAlert(context);
                }
              },
            );
          },
        ),
        Consumer<SearchFilterProvider>(
          builder: (context, model, child) {
            return WidgetExtension.crossSwitch(
                first: OptionSelectedText(
                  options: (model.searchValueModel?.selectedEduCategories ?? [])
                      .join(', '),
                ),
                value: (model.searchValueModel?.selectedEducation ?? {})
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
    textEditingController.addListener(() {
      context
          .read<SearchFilterProvider>()
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
