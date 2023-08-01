import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_age_slider.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_country_btn.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_district_btn.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_education_btn.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_occupation_btn.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_religion_btn.dart';
import 'package:nest_matrimony/views/search_result/search_result_filter/widgets/filter_state_btn.dart';
import 'package:nest_matrimony/widgets/custom_expansion_tile.dart';
import 'package:provider/provider.dart';

import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/search_height_slider.dart';
import 'widgets/filter_caste_btn.dart';
import 'widgets/filter_marital_status.dart';
import 'widgets/filter_profile_created_btn.dart';
import 'widgets/filter_profile_created_by_btn.dart';

class SearchResultFilter extends StatefulWidget {
  const SearchResultFilter({Key? key}) : super(key: key);

  @override
  State<SearchResultFilter> createState() => _SearchResultFilterState();
}

class _SearchResultFilterState extends State<SearchResultFilter> {
  late final SearchFilterProvider searchModel;

  ValueNotifier<RangeValues>? _heightSlider;
  ValueNotifier<RangeValues>? _ageSlider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.87),
      child: FilterBottomSheetContainer(
          hideSearch: true,
          title: context.loc.filters,
          onClearTap: () {
            context.read<SearchFilterProvider>().clearFilterTempValues();
            setState(() {
              _heightSlider!.value =
                  RangeValues(searchModel.minHeight, searchModel.maxHeight);
              _ageSlider!.value =
                  RangeValues(searchModel.minAge, searchModel.maxAge);
            });
          },
          child: Expanded(
            child: Column(
              children: [
                WidgetExtension.horizontalDivider(color: HexColor('#E4E7E8')),
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    _CustomExpansionTile(
                      title: context.loc.profileType,
                      children: [
                        const FilterProfileCreatedBtn(),
                        const FilterProfileCreatedByBtn(),
                        13.verticalSpace,
                      ],
                    ),
                    _CustomExpansionTile(
                      title: context.loc.basicDetails,
                      children: [
                        const FilterMaritalStatusBtn(),
                        25.verticalSpace,
                        SearchHeightSlider(
                          heightSliderRange: _heightSlider,
                        ),
                        WidgetExtension.horizontalDivider(
                            color: HexColor('#E4E7E8'),
                            margin: EdgeInsets.symmetric(horizontal: 2.w)),
                        SearchAgeSlider(
                          ageSliderRange: _ageSlider,
                        ),
                      ],
                    ),
                    _CustomExpansionTile(
                      title: context.loc.religiousDetails,
                      padding: EdgeInsets.only(top: 12.h, bottom: 3.h),
                      children: [
                        const FilterReligionBtn(),
                        const FilterCasteBtn(),
                        10.verticalSpace,
                      ],
                    ),
                    if ((AppConfig.accessToken ?? '').isNotEmpty) ...[
                      _CustomExpansionTile(
                        title: context.loc.professionalDetails,
                        children: [
                          const FilterEducationBtn(),
                          const FilterOccupationBtn(),
                          10.verticalSpace,
                        ],
                      ),
                      _CustomExpansionTile(
                        title: context.loc.locationDetails,
                        children: const [
                          FilterCountryBtn(),
                          FilterStateBtn(),
                          FilterDistrictBtn()
                        ],
                      ),
                    ],
                    20.verticalSpace
                  ],
                )),
                ApplyCancelBtn(
                  onApplyTap: () {
                    context.read<SearchFilterProvider>()
                      ..updateBtnLoader(true)
                      ..updateSelectedHeight(_heightSlider?.value.start ?? 0.0,
                          _heightSlider?.value.end ?? 0.0)
                      ..updateSelectedAge(_ageSlider?.value.start ?? 0.0,
                          _ageSlider?.value.end ?? 0.0)
                      ..clearValues(fromSearch: false)
                      ..setSearchFilterParam()
                      ..assignSearchFilterToReqPram()
                      ..advancedSearchRequest(
                        context: context,
                      );
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    searchModel = context.read<SearchFilterProvider>();
    _heightSlider = ValueNotifier(RangeValues(
        searchModel.selectedFromHeight ?? searchModel.minHeight,
        searchModel.selectedToHeight ?? searchModel.maxHeight));
    _ageSlider = ValueNotifier(RangeValues(
        searchModel.selectedFromAge ?? searchModel.minAge,
        searchModel.selectedToAge ?? searchModel.maxAge));
    super.initState();
  }
}

class _CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  final EdgeInsets? padding;
  final Function(bool)? onExpansionChanged;
  const _CustomExpansionTile(
      {Key? key,
      required this.title,
      this.children,
      this.onExpansionChanged,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      initiallyExpanded: true,
      onExpansionChanged: onExpansionChanged,
      title: Text(
        title,
        style: FontPalette.black14Bold.copyWith(color: HexColor('#565F6C')),
      ),
      tilePadding: padding ?? EdgeInsets.only(top: 17.h, bottom: 3.h),
      trailingExpand: Icon(
        Icons.add,
        color: HexColor('#8695A7'),
      ),
      trailingExpanded: Icon(Icons.remove, color: HexColor('#8695A7')),
      childrenPadding: EdgeInsets.symmetric(horizontal: 1.w),
      children: children ?? [],
    );
  }
}
