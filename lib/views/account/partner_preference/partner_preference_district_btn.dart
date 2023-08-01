import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/district_data_model.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/app_data_provider.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../error_views/error_tile.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/custom_option_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceDistrictBtn extends StatefulWidget {
  const PartnerPreferenceDistrictBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceDistrictBtn> createState() =>
      _PartnerPreferenceDistrictBtnState();
}

class _PartnerPreferenceDistrictBtnState
    extends State<PartnerPreferenceDistrictBtn> {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context
          .read<PartnerPreferenceProvider>()
          .getDistrictsFromMultipleStates();
    });
    searchQuery = ValueNotifier('');
    super.initState();
  }

  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;
  Widget _mainListView(
      DistrictDataModel? districtDataModel, Map<int, String> districtDataType) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          DistrictData? districtData = districtDataModel!.districtData![index];
          return FilterCheckBoxTile(
            title: districtData.districtName ?? '',
            isChecked: districtDataType.containsKey(districtData.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context.read<PartnerPreferenceProvider>()
                ..clearLocationFilterData()
                ..clearLocationTempFilterData()
                ..updateSelectedDistrict(
                    districtData.id, districtData.districtName);
            },
          );
        }, childCount: districtDataModel?.districtData?.length ?? 0))

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
          DistrictDataModel? districtDataModel = model.districtDataModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.district}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            // textEditingController: textEditingController,
            onClearTap: () {
              context.read<PartnerPreferenceProvider>()
                ..clearDistrictTempFilterData()
                ..clearLocationFilterData()
                ..clearLocationTempFilterData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (districtDataModel?.districtData ?? []).isEmpty,
              onTap: () => model.getDistrictsFromMultipleStates(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(districtDataModel,
                              model.tempSelectedFilterDistricts);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToSelectedDistrict()
                        ..setLocationPreferenceParam(context)
                        //..getLocationFromMultipleDistricts()
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
          Tuple3<DistrictData?, Map<int, String>, Map<int, String>>>(
        selector: (context, provider) => Tuple3(
            provider.searchFilterValueModel?.districtData,
            provider.searchFilterValueModel?.selectedDistrict ?? {},
            provider.searchFilterValueModel?.selectedState ?? {}),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.district,
            selectedValue: value.item2.isEmpty
                ? ''
                : context.loc.selected(value.item2.length),
            onTap: value.item3.isNotEmpty
                ? () {
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
                    (model.searchFilterValueModel?.selectedDistrict?.values ??
                            [])
                        .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedDistrict ?? {})
                  .values
                  .isNotEmpty);
        },
      )
    ]);
  }
}
