import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../common/extensions.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/font_palette.dart';
import 'country_picker_container.dart';

class NumberTextTile extends StatelessWidget {
  final ValueChanged<String>? onChange;
  const NumberTextTile({Key? key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      width: double.maxFinite,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              context.read<AppDataProvider>().resetCountryList();
              ReusableWidgets.customBottomSheet(
                  context: context,
                  child: CountryPickerContainer(
                    onChange: (val) {
                      context.read<RegistrationProvider>()
                        ..validatePhoneNumber('')
                        ..updateCountryData(val);
                      RegistrationHandlerClass().registerNumberCtrl!.clear();
                    },
                  ));
            },
            child: Container(
              height: double.maxFinite,
              decoration: BorderExtension.underLineBorder(),
              child: Selector<RegistrationProvider, CountryData?>(
                selector: (context, provider) => provider.countryData,
                builder: (context, value, child) {
                  CountryData? countryData = value ??
                      ((context.read<AppDataProvider>().countryDataList ?? [])
                              .isNotEmpty
                          ? context
                              .read<AppDataProvider>()
                              .countryDataList!
                              .first
                          : null);
                  return Row(
                    children: [
                      SizedBox(
                        height: 18.h,
                        width: 26.w,
                        child: SvgPicture.network(
                          countryData?.countryFlag ?? '',
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        '+${countryData?.dialCode ?? ''}',
                        style: FontPalette.black20SemiBold,
                      ),
                      14.horizontalSpace,
                      SvgPicture.asset(
                        Assets.iconsChevronDown,
                        width: 7.w,
                        height: 3.5.h,
                      ),
                      5.horizontalSpace
                    ],
                  );
                },
              ),
            ),
          ),
          17.5.horizontalSpace,
          Expanded(
              child: Container(
                  height: double.maxFinite,
                  decoration: BorderExtension.underLineBorder(),
                  alignment: Alignment.centerLeft,
                  child: Selector<RegistrationProvider, CountryData?>(
                    selector: (context, provider) => provider.countryData,
                    builder: (context, value, child) {
                      return TextField(
                        controller:
                            RegistrationHandlerClass().registerNumberCtrl,
                        style: FontPalette.black20SemiBold,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          LengthLimitingTextInputFormatter(
                              value?.maxLength ?? 20),
                        ],
                        onChanged: onChange,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Mobile Number',
                            hintStyle: FontPalette.black20SemiBold
                                .copyWith(color: Colors.black26),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 9.h)),
                      );
                    },
                  )))
        ],
      ),
    );
  }
}
