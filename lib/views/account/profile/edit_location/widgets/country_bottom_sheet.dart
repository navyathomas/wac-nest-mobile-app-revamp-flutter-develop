import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/views/auth_screens/registration/register_number/country_picker_container.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class CountryBottomSheet extends StatelessWidget {
  const CountryBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AccountProvider, String?>(
      selector: (context, provider) => provider.countryData?.countryName,
      builder: (context, value, child) {
        return CustomOptionBtn(
          title: context.loc.country,
          selectedValue: value ?? '',
          marginTop: 0.h,
          onTap: () => ReusableWidgets.customBottomSheet(
              context: context,
              child: CountryPickerContainer(
                onChange: (val) {
                  context.read<AccountProvider>()
                    ..updateCountry(val)
                    ..updateState(null);
                  context
                      .read<ProfileProvider>()
                      .changeDoneBtnActiveState(false);
                  context.read<AppDataProvider>().getStatesList(val?.id ?? 1);
                },
              )),
        );
      },
    );
  }
}
