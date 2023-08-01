import 'package:flutter/cupertino.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../providers/app_data_provider.dart';
import '../../providers/matches_provider.dart';
import '../../widgets/reusable_widgets.dart';
import '../auth_screens/registration/register_number/country_picker_container.dart';
import '../search_filter/widgets/custom_option_btn.dart';

class MatchesCountryBtn extends StatelessWidget {
  const MatchesCountryBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MatchesProvider, String?>(
      selector: (context, provider) =>
          provider.searchFilterValueModel?.countryData?.countryName,
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.country,
          selectedValue: value ?? '',
          onTap: () => ReusableWidgets.customBottomSheet(
              context: context,
              child: CountryPickerContainer(
                onChange: (val) {
                  context.read<MatchesProvider>()
                    ..updateSelectedCountry(val, isFromSearch: false)
                    ..updateSelectedState(null, isFromSearch: false)
                    ..clearDistrictFilterData()
                    ..clearDistrictTempFilterData();

                  context.read<AppDataProvider>().getStatesList(val?.id ?? -1);
                },
              )),
        );
      },
    );
  }
}
