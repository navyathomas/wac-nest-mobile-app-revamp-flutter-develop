import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/city_data_model.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/models/district_data_model.dart';
import 'package:nest_matrimony/models/state_data_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/tuple.dart';

class CityBottomSheet extends StatelessWidget {
  const CityBottomSheet({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context, List<CityData>? cityDataList) {
    return ListView.builder(
        itemCount: cityDataList?.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (cxt, index) {
          return InkWell(
            onTap: () {
              context.read<ProfileProvider>().changeDoneBtnActiveState(true);
              context
                  .read<AccountProvider>()
                  .updateCityData(cityDataList?[index]);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    cityDataList?[index].locationName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<AccountProvider, CityData?>(
                    selector: (context, provider) => provider.cityData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (cityDataList?[index].id ?? -2),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AccountProvider,
        Tuple4<CountryData?, StateData?, DistrictData?, CityData?>>(
      selector: (context, provider) => Tuple4(provider.countryData,
          provider.stateData, provider.districtData, provider.cityData),
      builder: (context, providerValue, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.8),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.city,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AccountProvider,
                    Tuple2<CityDataModel?, LoaderState>>(
                  selector: (context, provider) =>
                      Tuple2(provider.cityDataModel, provider.cityListLoader),
                  builder: (cxt, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () {
                          final model = context.read<AccountProvider>();
                          model.getCityData(
                              model.districtData?.id ?? -1, context);
                        },
                        isEmpty: (value.item1?.cityData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.cityData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.city,
          selectedValue: providerValue.item4?.locationName ?? '',
          onTap: providerValue.item1?.id == null ||
                  providerValue.item2?.id == null ||
                  providerValue.item3?.id == null
              ? null
              : () {
                  ReusableWidgets.customBottomSheet(
                      context: context, child: childWidget);
                },
        );
      },
    );
  }
}
