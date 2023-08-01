import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/job_child_categories_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/widgets/radio_button_tile.dart';
import 'package:nest_matrimony/views/search_filter/widgets/apply_cancel_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/filter_bottom_sheet_container.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_expansion_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class OccupationBottomSheet extends StatefulWidget {
  const OccupationBottomSheet({Key? key}) : super(key: key);

  @override
  State<OccupationBottomSheet> createState() => _OccupationBottomSheetState();
}

class _OccupationBottomSheetState extends State<OccupationBottomSheet> {
  late final TextEditingController textEditingController;

  Widget _optionContainer(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider,
          Tuple2<JobChildCategoryListModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.jobChildCategoryListModel, provider.loaderState),
        builder: (context, value, childWidget) {
          childWidget = FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.jobCategory}',
            hintText: "${context.loc.search} ${context.loc.job.toLowerCase()}",
            textEditingController: textEditingController,
            child: Expanded(
              child: Consumer2<SearchFilterProvider, AccountProvider>(
                builder: (context, provider, model, child) {
                  List<JobDataCategoryModel>? joListData =
                      provider.jobChildCategoryList;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: joListData?.length ?? 0,
                            padding: EdgeInsets.only(bottom: 12.h),
                            itemBuilder: (context, index) {
                              JobDataCategoryModel? categoryData =
                                  joListData?[index];
                              if (categoryData == null) {
                                return const SizedBox.shrink();
                              }
                              return CustomExpansionTile(
                                tilePadding: EdgeInsets.symmetric(
                                    horizontal: 23.w, vertical: 12.h),
                                title: RadioButtonTile(
                                  title: categoryData.parentJobCategory ?? '',
                                  isChecked: model.tempSelectedChildParentJob
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
                                      int idList =
                                          model.tempSelectedChildParentJob[
                                                  categoryData.id ?? -1] ??
                                              -1;
                                      return RadioSubButtonTile(
                                          title: childJobCat?.subcategoryName ??
                                              '',
                                          isChecked:
                                              idList == (childJobCat?.id ?? -1),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          onTap: () {
                                            context
                                                .read<AccountProvider>()
                                                .updateSelectedParentChildJobCatData(
                                                    parentId: categoryData.id,
                                                    childId: childJobCat?.id,
                                                    title: childJobCat
                                                            ?.subcategoryName ??
                                                        '');
                                            context
                                                .read<ProfileProvider>()
                                                .jobCategoryOnChanged(true);
                                            Navigator.of(context).pop();
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
      Selector<AccountProvider, Tuple2<BasicDetails?, String?>>(
        selector: (context, provider) =>
            Tuple2(provider.profile, provider.tempSelectedJobCategories),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.jobCategory,
            selectedValue: value.item2 ?? '',
            onTap: () {
              textEditingController.clear();
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          );
        },
      ),
    ]);
  }

  @override
  void initState() {
    updateSelectedJobCatData();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<AccountProvider>()
          .searchJobByQuery(textEditingController.text, context);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void updateSelectedJobCatData() {
    Future.microtask(() {
      final account = Provider.of<AccountProvider>(context, listen: false);
      account.updateSelectedParentChildJobCatData(
          parentId: account.profile?.jobParentId,
          childId: account.profile?.jobCategoryId,
          title: account.profile?.userJobSubCategory?.parentJobCategory ?? '');
    });
  }
}
