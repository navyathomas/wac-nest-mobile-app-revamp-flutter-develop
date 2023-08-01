import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/matches/matches_age_slider.dart';
import 'package:nest_matrimony/views/matches/matches_cast_btn.dart';
import 'package:nest_matrimony/views/matches/matches_country_btn.dart';
import 'package:nest_matrimony/views/matches/matches_education_btn.dart';
import 'package:nest_matrimony/views/matches/matches_height_slider.dart';
import 'package:nest_matrimony/views/matches/matches_martial_status_btn.dart';
import 'package:nest_matrimony/views/matches/matches_occupation_btn.dart';
import 'package:nest_matrimony/views/matches/matches_profile_create_btn.dart';
import 'package:nest_matrimony/views/matches/matches_prrofile_created_by.dart';
import 'package:nest_matrimony/views/matches/mathces_religion_btn.dart';
import 'package:nest_matrimony/views/matches/sort_by.dart';
import 'package:nest_matrimony/widgets/custom_expansion_tile.dart';
import 'package:provider/provider.dart';

import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';
import 'matches_district_btn.dart';
import 'matches_state_btn.dart';

class MatchesFilter extends StatefulWidget {
  const MatchesFilter({Key? key}) : super(key: key);

  @override
  State<MatchesFilter> createState() => _MatchesFilterState();
}

class _MatchesFilterState extends State<MatchesFilter> {
  late final MatchesProvider searchModel;

  ValueNotifier<RangeValues>? _heightSlider;
  ValueNotifier<RangeValues>? _ageSlider;
  List<String> sortOptions = [];
  @override
  void didChangeDependencies() {
    if (sortOptions.isEmpty) {
      sortOptions = [
        context.loc.recentlyCreated,
        context.loc.profileRelevancy,
        context.loc.boostedProfiles
      ];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: context.sh(size: 0.87),
          child: FilterBottomSheetContainer(
              hideSearch: true,
              onClearTap: () {
                context.read<MatchesProvider>().clearFilterTempValues();
                setState(() {
                  _heightSlider!.value =
                      RangeValues(searchModel.minHeight, searchModel.maxHeight);
                  _ageSlider!.value =
                      RangeValues(searchModel.minAge, searchModel.maxAge);
                });
              },
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetExtension.horizontalDivider(
                        color: HexColor('#E4E7E8')),
                    Expanded(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      children: [
                        5.verticalSpace,
                        SortByButtonsMatches(sortOptions: sortOptions),
                        WidgetExtension.horizontalDivider(
                            color: HexColor('#E4E7E8')),
                        18.verticalSpace,
                        Text(
                          'Filter by',
                          style: FontPalette.white13SemiBold
                              .copyWith(color: Colors.black, fontSize: 16.sp),
                        ),
                        _CustomExpansionTile(
                          title: context.loc.profileType,
                          children: [
                            const MatchesProfileCreatedBtn(),
                            const MatchesProfileCreatedByBtn(),
                            13.verticalSpace,
                          ],
                        ),
                        _CustomExpansionTile(
                          title: context.loc.basicDetails,
                          children: [
                            const MatchesMartialStatusBtn(),
                            // 5.verticalSpace,
                            // provider.martialStatusValues != ''
                            //     ? Text(provider.martialStatusValues)
                            //     : const SizedBox.shrink(),
                            25.verticalSpace,
                            MatchesHeightSlider(
                              heightSliderRange: _heightSlider,
                            ),
                            WidgetExtension.horizontalDivider(
                                color: HexColor('#E4E7E8'),
                                margin: EdgeInsets.symmetric(horizontal: 2.w)),
                            MatchesAgeSlider(
                              ageSliderRange: _ageSlider,
                            ),
                          ],
                        ),
                        _CustomExpansionTile(
                          title: context.loc.religiousDetails,
                          padding: EdgeInsets.only(top: 12.h, bottom: 3.h),
                          children: [
                            const MatchesReligionBtn(),
                            const MatchesCasteBtn(),
                            5.verticalSpace,
                            provider.casteValues != ''
                                ? Text(provider.casteValues)
                                : const SizedBox.shrink(),
                            10.verticalSpace,
                          ],
                        ),
                        if ((AppConfig.accessToken ?? '').isNotEmpty) ...[
                          _CustomExpansionTile(
                            title: context.loc.professionalDetails,
                            children: [
                              const MatchesEducationBtn(),
                              //5.verticalSpace,
                              // WidgetExtension.crossSwitch(
                              //     first: OptionSelectedText(
                              //       options: (provider.educationValues),
                              //     ),
                              //     value: (provider.searchFilterValueModel
                              //                 ?.selectedEducation ??
                              //             {})
                              //         .values
                              //         .isNotEmpty),
                              // provider.educationValues != ''
                              //     ? Text(provider.educationValues)
                              //     : const SizedBox.shrink(),
                              const MatchesOccupationBtn(),
                              // 5.verticalSpace,
                              // provider.occupationalValues != ''
                              //     ? Text(provider.occupationalValues)
                              //     : const SizedBox.shrink(),
                              10.verticalSpace,
                            ],
                          ),
                          _CustomExpansionTile(
                            title: context.loc.locationDetails,
                            children: const [
                              MatchesCountryBtn(),
                              MatchesStateBtn(),
                              MatchesDistrictBtn(),
                              // 5.verticalSpace,
                              // provider.districtValues != ''
                              //     ? Text(provider.districtValues)
                              //     : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                        20.verticalSpace
                      ],
                    )),
                    ApplyCancelBtn(
                      onApplyTap: () async {
                        MatchesProvider provider =
                            context.read<MatchesProvider>();
                        context.read<MatchesProvider>()
                          ..updateBtnLoader(true)
                          ..updateSelectedHeight(
                              _heightSlider?.value.start ?? 0.0,
                              _heightSlider?.value.end ?? 0.0)
                          ..updateSelectedAge(_ageSlider?.value.start ?? 0.0,
                              _ageSlider?.value.end ?? 0.0)
                          ..clearValues()
                          ..setSearchFilterParam()
                          ..assignSearchFilterToReqPram().then(
                              (value) => _getMatchesList(context, provider));
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  @override
  void initState() {
    searchModel = context.read<MatchesProvider>();

    _heightSlider = ValueNotifier(RangeValues(
        searchModel.heightFromId ?? searchModel.minHeight,
        searchModel.heightToId ?? searchModel.maxHeight));
    _ageSlider = ValueNotifier(RangeValues(
        searchModel.ageFromId ?? searchModel.minAge,
        searchModel.ageToId ?? searchModel.maxAge));
    CommonFunctions.afterInit(() {
      searchModel.getMaritalStatusDataList();
      searchModel.fetchFromAppData(context);
    });
    super.initState();
  }

  _getMatchesList(BuildContext context, MatchesProvider provider) {
    switch (provider.selectedIndex) {
      case 0:
        if (provider.selectedChildIndex == 0 &&
            provider.allMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.allMatchesNotViewed);
        } else if (provider.selectedChildIndex == 1 &&
            provider.allMatchesViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.allMatchesViewed);
        }

        break;
      case 1:
        if (provider.selectedChildIndex == 0 &&
            provider.topMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.topMatchesNotViewed);
        } else if (provider.selectedChildIndex == 1 &&
            provider.topMatchesViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.topMatchesViewed);
        }
        break;
      case 2:
        if (provider.selectedChildIndex == 0 &&
            provider.newProfileMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.newProfileNotViewed);
        } else if (provider.selectedChildIndex == 1 &&
            provider.newProfileMatchesViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.newProfileViewed);
        }
        break;
      case 3:
        if (provider.selectedChildIndex == 0 &&
            provider.premiumProfilesMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.premiumProfilesNotViewed);
        } else if (provider.selectedChildIndex == 1 &&
            provider.premiumProfilesMatchesViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.premiumProfilesViewed);
        }
        break;
      case 4:
        if (provider.selectedChildIndex == 0 &&
            provider.nearByMatchesNotViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.nearByMatchesNotViewed);
        } else if (provider.selectedChildIndex == 1 &&
            provider.nearByMatchesViewedUserDataList.isEmpty) {
          provider.advancedSearchRequest(
              context: context,
              enableLoader: true,
              matchesTypes: MatchesTypes.nearByMatchesViewed);
        }
        break;
    }
  }

  // getMatchesList(MatchesProvider provider) {
  //   switch (provider.selectedIndex) {
  //     case 0:
  //       provider.advancedSearchRequest(
  //           context: context,
  //           enableLoader: true,
  //           matchesTypes: provider.selectedChildIndex == 0
  //               ? MatchesTypes.allMatchesNotViewed
  //               : MatchesTypes.allMatchesViewed);
  //       break;
  //     case 1:
  //       provider.advancedSearchRequest(
  //           context: context,
  //           enableLoader: true,
  //           matchesTypes: provider.selectedChildIndex == 0
  //               ? MatchesTypes.topMatchesNotViewed
  //               : MatchesTypes.topMatchesViewed);
  //       break;
  //     case 2:
  //       provider.advancedSearchRequest(
  //           context: context,
  //           enableLoader: true,
  //           matchesTypes: provider.selectedChildIndex == 0
  //               ? MatchesTypes.newProfileNotViewed
  //               : MatchesTypes.newProfileViewed);
  //       break;
  //     case 3:
  //       provider.advancedSearchRequest(
  //           context: context,
  //           enableLoader: true,
  //           matchesTypes: provider.selectedChildIndex == 0
  //               ? MatchesTypes.premiumProfilesNotViewed
  //               : MatchesTypes.premiumProfilesViewed);
  //       break;
  //     case 4:
  //       provider.advancedSearchRequest(
  //           context: context,
  //           enableLoader: true,
  //           matchesTypes: provider.selectedChildIndex == 0
  //               ? MatchesTypes.nearByMatchesNotViewed
  //               : MatchesTypes.nearByMatchesViewed);
  //       break;
  //   }
  // }
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
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
