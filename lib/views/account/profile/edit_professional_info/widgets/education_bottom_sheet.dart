import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/education_cat_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/account/profile/edit_professional_info/widgets/radio_button_tile.dart';
import 'package:nest_matrimony/views/search_filter/widgets/filter_bottom_sheet_container.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_expansion_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants.dart';
import '../../../../search_filter/widgets/apply_cancel_btn.dart';
import '../../../../search_filter/widgets/custom_option_btn.dart';

class EducationBottomSheet extends StatefulWidget {
  const EducationBottomSheet({Key? key}) : super(key: key);

  @override
  State<EducationBottomSheet> createState() => _EducationBottomSheetState();
}

class _EducationBottomSheetState extends State<EducationBottomSheet> {
  late final TextEditingController textEditingController;

  Widget _optionContainer(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Selector<AppDataProvider,
          Tuple2<EducationCategoryModel?, LoaderState>>(
        selector: (context, provider) =>
            Tuple2(provider.educationCategoryModel, provider.loaderState),
        builder: (context, value, childWidget) {
          childWidget = FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.educationCategory}',
            hintText:
                "${context.loc.search} ${context.loc.education.toLowerCase()}",
            textEditingController: textEditingController,
            child: Expanded(
              child: Consumer2<SearchFilterProvider, AccountProvider>(
                builder: (context, provider, model, child) {
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
                                title: RadioButtonTile(
                                  title: categoryData.parentEducationCategory ??
                                      '',
                                  isChecked: model.tempSelectedEducation
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
                                      int idList = model.tempSelectedEducation[
                                              categoryData.id ?? -1] ??
                                          -1;
                                      return RadioSubButtonTile(
                                          title:
                                              childEduCat?.eduCategoryTitle ??
                                                  '',
                                          isChecked:
                                              idList == (childEduCat?.id ?? -1),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          onTap: () {
                                            context
                                                .read<AccountProvider>()
                                                .updateSelectedEduCatData(
                                                    parentId: categoryData.id,
                                                    childId: childEduCat?.id,
                                                    title: childEduCat
                                                            ?.eduCategoryTitle ??
                                                        '');
                                            context
                                                .read<ProfileProvider>()
                                                .educationCategoryOnChanged(
                                                    true);
                                            Navigator.of(context).pop();
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
            Tuple2(provider.profile, provider.tempSelectedEduCategories),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.educationCategory,
            selectedValue: value.item2 ?? '',
            marginTop: 0.h,
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
    updateSelectedEducationCatData();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      context
          .read<AccountProvider>()
          .searchEduByQuery(textEditingController.text, context);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void updateSelectedEducationCatData() {
    Future.microtask(() {
      final account = Provider.of<AccountProvider>(context, listen: false);
      account.updateSelectedEduCatData(
          parentId: account.profile?.educationParentId,
          childId: account.profile?.educationCategoryId,
          title: account.profile?.userEducationSubcategory?.eduCategoryTitle ??
              '');
    });
  }
}
