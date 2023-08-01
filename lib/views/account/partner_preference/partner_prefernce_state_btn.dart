import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/countries_data_model.dart';
import '../../../models/state_data_model.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/matches_provider.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/custom_radio.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/custom_option_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceStateBtn extends StatefulWidget {
  const PartnerPreferenceStateBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceStateBtn> createState() =>
      _PartnerPreferenceStateBtnState();
}

class _PartnerPreferenceStateBtnState extends State<PartnerPreferenceStateBtn> {
  @override
  void initState() {
    searchQuery = ValueNotifier('');
    super.initState();
  }

  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;
  Widget _mainListView(
      StateDataModel? stateDataModel, Map<int, String> bodyTypeData) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          StateData? stateData = stateDataModel!.stateData![index];
          return FilterCheckBoxTile(
            title: stateData.stateName ?? '',
            isChecked: bodyTypeData.containsKey(stateData.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context.read<PartnerPreferenceProvider>()
                ..clearDistrictFilterData()
                ..clearDistrictTempFilterData()
                ..clearLocationFilterData()
                ..clearLocationTempFilterData()
                ..updateSelectedState(stateData.id, stateData.stateName);
            },
          );
        }, childCount: stateDataModel?.stateData?.length ?? 0))

        ///TODO: need to change no data found
      ],
    );
  }

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          StateDataModel? stateDataModel = model.stateDataModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.state}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            // textEditingController: textEditingController,
            onClearTap: () {
              context.read<PartnerPreferenceProvider>()
                ..clearStateTempFilterData()
                ..clearDistrictFilterData()
                ..clearDistrictTempFilterData()
                ..clearLocationFilterData()
                ..clearLocationTempFilterData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (stateDataModel?.stateData ?? []).isEmpty,
              onTap: () => model.getStateList(model.countryId ?? 0),
              // model.getStateList(context
              //         .read<AccountProvider>()
              //         .partnerPreferenceData
              //         ?.data!
              //         .country !=
              //     null
              // ? context
              //         .read<AccountProvider>()
              //         .partnerPreferenceData
              //         ?.data!
              //         .country!
              //         .id ??
              //     1
              // : 0),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(
                              stateDataModel, model.tempSelectedState);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToSelectedState()
                        ..clearDistrictFilterData()
                        ..clearDistrictTempFilterData()
                        ..getDistrictsFromMultipleStates()
                        ..clearLocationFilterData()
                        ..clearLocationTempFilterData()
                        ..setLocationPreferenceParam(context)
                        ..saveLocationPreference(context);
                      // ..setBasicPreferenceParam(context)
                      // ..saveBasicPreference(context);
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
    var data = context.read<AccountProvider>().partnerPreferenceData?.data!;
    return Consumer<PartnerPreferenceProvider>(
      builder: (context, value, child) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomOptionBtn(
            title: context.loc.state,
            selectedValue: value.isLocationFilterApplied
                ? value.searchFilterValueModel?.selectedState != null
                    ? value.searchFilterValueModel!.selectedState!.values
                            .isNotEmpty
                        ? context.loc.selected(value.searchFilterValueModel!
                            .selectedState!.values.length)
                        : ''
                    : ''
                : (data!.statesUnserialize ?? []).isNotEmpty
                    ? context.loc.selected(data.statesUnserialize?.length ?? 0)
                    : '',
            onTap:
                //null
                () {
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          ),
          //   },
          // ),
          WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    (value.searchFilterValueModel?.selectedState?.values ?? [])
                        .join(', '),
              ),
              value: (value.searchFilterValueModel?.selectedState ?? {})
                  .values
                  .isNotEmpty)
        ]);
      },
    );
  }
}
