import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/reusable_widgets.dart';
import '../../auth_screens/registration/register_number/country_picker_container.dart';
import 'custom_option_btn.dart';

class SearchCountryBtn extends StatelessWidget {
  const SearchCountryBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchFilterProvider, String?>(
      selector: (context, provider) =>
          provider.searchValueModel?.countryData?.countryName,
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.country,
          selectedValue: value ?? '',
          onTap: () => ReusableWidgets.customBottomSheet(
              context: context,
              child: CountryPickerContainer(
                onChange: (val) {
                  context.read<SearchFilterProvider>()
                    ..updateSelectedCountry(val)
                    ..updateSelectedState(null)
                    ..clearDistrictData()
                    ..clearDistrictTempData();

                  context.read<AppDataProvider>().getStatesList(val?.id ?? -1);
                },
              )),
        );
      },
    );
  }
}
