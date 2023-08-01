import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/profile_provider.dart';
import '../../../../../utils/tuple.dart';

class DistrictBottomSheet extends StatelessWidget {
  const DistrictBottomSheet({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context) {
    return Selector<MatchesProvider, List<DistrictData>>(
        selector: (context, provider) => provider.districtDataList ?? [],
        builder: (context, districtDataList, _) {
          return ListView.builder(
              itemCount: districtDataList.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemBuilder: (context, index) {
                DistrictData? districtData = districtDataList[index];
                return InkWell(
                  onTap: () {
                    context
                        .read<AccountProvider>()
                        .updateDistrict(districtData);
                    context
                        .read<AccountProvider>()
                        .getCityData(districtData.id ?? -1, context);
                    context.rootPop;
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          districtData.districtName ?? '',
                          style: FontPalette.f131A24_16SemiBold,
                        ).avoidOverFlow()),
                        Selector<AccountProvider, DistrictData?>(
                          selector: (context, provider) =>
                              provider.districtData,
                          builder: (context, selectedValue, _) {
                            return CustomRadio(
                              isSelected: (selectedValue?.id ?? -1) ==
                                  (districtDataList[index].id ?? -2),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MatchesProvider, Tuple2<Map<int, DistrictData?>, int?>>(
      selector: (context, provider) => Tuple2(
          provider.searchFilterValueModel?.selectedDistricts ?? {},
          provider.searchFilterValueModel?.stateData?.id),
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.district,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<DistrictDataModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.districtDataModel, provider.districtListLoader),
                  builder: (context, values, child) {
                    DistrictDataModel? districtDataModel = values.item1;
                    return BottomResView(
                        loaderState: values.item2,
                        onTap: () => context
                            .read<AppDataProvider>()
                            .getDistrictList(context, value.item2 ?? -1),
                        isEmpty:
                            (districtDataModel?.districtData ?? []).isEmpty,
                        child: _optionContainer(context));
                  },
                ),
              ),
            ],
          ),
        );
        return Selector<AccountProvider,
                Tuple3<CountryData?, StateData?, DistrictData?>>(
            selector: (context, provider) => Tuple3(provider.countryData,
                provider.stateData, provider.districtData),
            builder: (context, val, _) {
              return CustomOptionBtn(
                title: context.loc.district,
                selectedValue: val.item3?.districtName ?? '',
                onTap: val.item1?.id == null || val.item2?.id == null
                    ? null
                    : () {
                        context
                            .read<MatchesProvider>()
                            .reAssignTempDistrictFilterData();
                        ReusableWidgets.customBottomSheet(
                            context: context, child: childWidget);
                      },
              );
            });
      },
    );
  }
}
