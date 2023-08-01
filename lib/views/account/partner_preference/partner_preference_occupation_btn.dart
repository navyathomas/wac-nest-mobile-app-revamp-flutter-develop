import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/job_category_model.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/views/account/partner_preference/filter_check_box_tile_partner_preference.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/job_data_model.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/app_data_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/custom_expansion_tile.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../error_views/error_tile.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/custom_option_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceOccupationBtn extends StatefulWidget {
  const PartnerPreferenceOccupationBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceOccupationBtn> createState() =>
      _PartnerPreferenceOccupationBtnState();
}

class _PartnerPreferenceOccupationBtnState
    extends State<PartnerPreferenceOccupationBtn> {
  late final TextEditingController textEditingController;

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider, Tuple2<JobCategoryModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.jobCategoryModel, provider.loaderState),
        builder: (context, value, childWidget) {
          childWidget = FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.occupation}',
            hintText:
                "${context.loc.search} ${context.loc.occupation.toLowerCase()}",
            textEditingController: textEditingController,
            onClearTap: () {
              context
                  .read<PartnerPreferenceProvider>()
                  .clearFilterJobParentCategoryData();
            },
            child: Expanded(
              child: Consumer<PartnerPreferenceProvider>(
                builder: (context, provider, child) {
                  List<JobCategoryData>? jobListData = provider.jobCatDataList;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: jobListData?.length ?? 0,
                            padding: EdgeInsets.only(bottom: 12.h),
                            itemBuilder: (context, index) {
                              JobCategoryData? categoryData =
                                  jobListData?[index];
                              if (categoryData == null) {
                                return const SizedBox.shrink();
                              }
                              return CustomExpansionTile(
                                tilePadding: EdgeInsets.symmetric(
                                    horizontal: 23.w, vertical: 12.h),
                                title: FilterCheckBoxTilePartnerPreference(
                                  checkBoxOnTap: () {
                                    provider.updateRemoveAllSelectedJob(provider
                                            .tempSelectedFilterJobParents
                                            .containsKey(categoryData.id ?? -1)
                                        ? true
                                        : false);
                                    if ((categoryData.childJobCategory ?? [])
                                        .isNotEmpty) {
                                      provider
                                          .updateAllSelectedFilterJobParentData(
                                              parentId: categoryData.id,
                                              childJobCategory: categoryData
                                                  .childJobCategory);
                                      provider.updateAllSelectedJobParent(
                                          categoryData.childJobCategory);
                                    }
                                  },
                                  title: categoryData.parentJobCategory ?? '',
                                  isChecked: provider
                                      .tempSelectedFilterJobParents
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
                                      ChildJobCategory? childJobCat =
                                          categoryData
                                              .childJobCategory?[subIndex];
                                      List<int> idList =
                                          provider.tempSelectedFilterJobParents[
                                                  categoryData.id ?? -1] ??
                                              [];
                                      return FilterSubCheckBoxTile(
                                          title: childJobCat?.subcategoryName ??
                                              '',
                                          isChecked: idList
                                              .contains(childJobCat?.id ?? -1),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          onTap: () {
                                            context
                                                .read<
                                                    PartnerPreferenceProvider>()
                                                .updateSelectedJobParent(
                                                    childJobCat?.id,
                                                    childJobCat
                                                        ?.subcategoryName);
                                            context
                                                .read<
                                                    PartnerPreferenceProvider>()
                                                .updateSelectedFilterJobParentData(
                                                    parentId: categoryData.id,
                                                    childId: childJobCat?.id,
                                                    title: childJobCat
                                                            ?.subcategoryName ??
                                                        '');
                                          });
                                    },
                                    itemCount:
                                        categoryData.childJobCategory?.length ??
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
                        onCancelTap: () {
                          context
                              .read<PartnerPreferenceProvider>()
                              .reAssignTempJobParentFilterData();
                          Navigator.pop(context);
                        },
                        onApplyTap: () {
                          context.read<PartnerPreferenceProvider>()
                            ..assignTempToSelectedFilterJobParentCatDat()
                            ..setProfessionalPreferenceParam(context)
                            ..saveProfessionalPreference(context);
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
            onTap: () => context.read<AppDataProvider>().getJobParentListData(),
            child: childWidget,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Selector<PartnerPreferenceProvider, List<String>>(
        selector: (context, provider) =>
            provider.searchFilterValueModel?.selectedOccupationCategories ?? [],
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.occupation,
            selectedValue:
                value.isEmpty ? '' : context.loc.selected(value.length),
            onTap: () {
              textEditingController.clear();
              // context
              //     .read<PartnerPreferenceProvider>()
              //     .reAssignTempJobParentFilterData();
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          );
        },
      ),
      Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options: (model.searchFilterValueModel
                            ?.selectedOccupationCategories ??
                        [])
                    .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedJobParent ?? {})
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
          .read<PartnerPreferenceProvider>()
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
