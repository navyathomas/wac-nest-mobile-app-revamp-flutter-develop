import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/views/auth_screens/registration/register_number/number_text_tile.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

import '../../../../providers/registration_provider.dart';
import '../../../../utils/font_palette.dart';

class RegisterNumberScreen extends StatelessWidget {
  const RegisterNumberScreen({Key? key}) : super(key: key);

  Widget _errorWidget() {
    return Selector<RegistrationProvider, String>(
      selector: (context, provider) => provider.registrationErrorMsg,
      builder: (context, value, child) {
        return WidgetExtension.crossSwitch(
            first: Padding(
              padding: EdgeInsets.only(top: 13.5.h),
              child: Text(
                value,
                style: FontPalette.black14Regular
                    .copyWith(color: HexColor('#FF0000')),
              ),
            ),
            value: value.isNotEmpty);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Consumer<RegistrationProvider>(
        builder: (context, registrationProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                36.verticalSpace,
                Text(
                  context.loc.whatsYourPhoneNumber,
                  style: FontPalette.black30Bold,
                ),
                46.verticalSpace,
                NumberTextTile(
                  onChange: (val) => registrationProvider
                    ..updatePhoneNumber(val)
                    ..assignCountryDataIfNull(context)
                    ..validatePhoneNumber(val),
                ),
                21.verticalSpace,
                if (registrationProvider.countryData == null ||
                    registrationProvider.countryData?.id == 1)
                  Text(
                    context.loc.nestWillSendText,
                    style: FontPalette.black13Regular
                        .copyWith(color: HexColor('#4D4D4D')),
                  ),
                if (registrationProvider.countryData != null &&
                    registrationProvider.countryData?.id != 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 40.h,
                          decoration: BorderExtension.underLineBorder(),
                          alignment: Alignment.centerLeft,
                          child: Selector<RegistrationProvider, CountryData?>(
                            selector: (context, provider) =>
                                provider.countryData,
                            builder: (context, value, child) {
                              return TextField(
                                controller: RegistrationHandlerClass()
                                    .registerEmailCtrl,
                                style: FontPalette.black20SemiBold,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                onChanged: (value) {
                                  registrationProvider
                                    ..validateEmailAddress(value)
                                    ..updateEmailId(value);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Email Address',
                                    hintStyle: FontPalette.black20SemiBold
                                        .copyWith(color: Colors.black26),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 9.h)),
                              );
                            },
                          )),
                      21.verticalSpace,
                      Text(
                        context.loc.nestWillSendEmail,
                        style: FontPalette.black13Regular
                            .copyWith(color: HexColor('#4D4D4D')),
                      ),
                    ],
                  ),
                _errorWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
