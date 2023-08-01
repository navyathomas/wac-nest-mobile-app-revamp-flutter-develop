import 'package:flutter/cupertino.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_data_provider.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../auth_screens/registration/register_number/country_picker_container.dart';
import '../../search_filter/widgets/custom_option_btn.dart';

class PartnerPreferenceCountryBtn extends StatelessWidget {
  const PartnerPreferenceCountryBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerPreferenceProvider, String?>(
      selector: (context, provider) =>
          provider.searchFilterValueModel?.countryData?.countryName,
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.country,
          selectedValue: value ?? 'India',
          onTap:
              //null
              () => ReusableWidgets.customBottomSheet(
                  context: context,
                  child: CountryPickerContainer(
                    onChange: (val) {
                      context.read<PartnerPreferenceProvider>()
                        ..updateSelectedCountry(val, isFromSearch: false)
                        ..assignTempToSelectedState()
                        ..clearStateFilterData()
                        ..clearStateTempFilterData()
                        ..clearDistrictFilterData()
                        ..clearDistrictTempFilterData()
                        ..clearLocationFilterData()
                        ..clearLocationTempFilterData()
                        ..setLocationPreferenceParam(context)
                        ..saveLocationPreference(context).then((value) =>
                            context
                                .read<PartnerPreferenceProvider>()
                                .getStateList(val?.id ?? -1));
                    },
                  )),
        );
      },
    );
  }
}
