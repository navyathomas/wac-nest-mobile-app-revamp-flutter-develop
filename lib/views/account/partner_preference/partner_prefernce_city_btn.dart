import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/city_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/tuple.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceCityBtn extends StatefulWidget {
  const PartnerPreferenceCityBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceCityBtn> createState() =>
      _PartnerPreferenceCityBtnState();
}

class _PartnerPreferenceCityBtnState extends State<PartnerPreferenceCityBtn> {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context
          .read<PartnerPreferenceProvider>()
          .getLocationFromMultipleDistricts();
    });
    searchQuery = ValueNotifier('');
    super.initState();
  }

  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;
  Widget _mainListView(
      CityDataModel? cityDataModel, Map<int, String> cityDataType) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          CityData? cityData = cityDataModel!.cityData![index];
          return FilterCheckBoxTile(
            title: cityData.locationName ?? '',
            isChecked: cityDataType.containsKey(cityData.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context
                  .read<PartnerPreferenceProvider>()
                  .updateSelectedLocation(cityData.id, cityData.locationName);
            },
          );
        }, childCount: cityDataModel?.cityData?.length ?? 0))

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
          CityDataModel? cityDataModel = model.cityDataModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.city}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            // textEditingController: textEditingController,
            onClearTap: () {
              context
                  .read<PartnerPreferenceProvider>()
                  .clearLocationTempFilterData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (cityDataModel?.cityData ?? []).isEmpty,
              onTap: () => model.getLocationFromMultipleDistricts(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(
                              cityDataModel, model.tempSelectedFilterLocation);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToSelectedLocation()
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Selector<PartnerPreferenceProvider,
          Tuple2<Map<int, String>, Map<int, String>>>(
        selector: (context, provider) => Tuple2(
            provider.searchFilterValueModel?.selectedCity ?? {},
            provider.searchFilterValueModel?.selectedDistrict ?? {}),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.location,
            selectedValue: value.item1.isEmpty
                ? ''
                : context.loc.selected(value.item1.length),
            onTap: value.item2.isNotEmpty
                ? () {
                    // context
                    //     .read<PartnerPreferenceProvider>()
                    //     .reAssignTempJathakam();
                    ReusableWidgets.customBottomSheet(
                        context: context, child: _optionContainer(context));
                  }
                : null,
          );
        },
      ),
      Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    (model.searchFilterValueModel?.selectedCity?.values ?? [])
                        .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedCity ?? {})
                  .values
                  .isNotEmpty);
        },
      )
    ]);
  }
}
