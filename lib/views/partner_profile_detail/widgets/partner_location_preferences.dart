import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/font_palette.dart';
import 'partner_key_value_tile.dart';

class PartnerLocationPreferences extends StatelessWidget {
  final bool enableIcon;
  const PartnerLocationPreferences({Key? key, this.enableIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerDetailProvider, PartnerDetailModel?>(
      selector: (context, provider) => provider.partnerDetailModel,
      builder: (context, value, child) {
        UserPartnerPreference? userPartnerPreference =
            value?.data?.userPartnerPreference;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetExtension.verticalDivider(
                height: 2.h, margin: EdgeInsets.only(top: 17.h, bottom: 23.h)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.locationPreferences,
                    style: FontPalette.f8695A7_14Bold,
                  ),
                  10.verticalSpace,
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.countryData?.countryName),
                    leading: context.loc.country,
                    trailing: userPartnerPreference?.countryData?.countryName ??
                        '---',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.statesUnserialize),
                    leading: context.loc.state,
                    trailing:
                        (userPartnerPreference?.statesUnserialize ?? ["---"])
                            .join(", "),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.districtsUnserialize),
                    leading: context.loc.district,
                    trailing:
                        (userPartnerPreference?.districtsUnserialize ?? ["---"])
                            .join(", "),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.locationUnserialize),
                    leading: context.loc.location,
                    trailing:
                        (userPartnerPreference?.locationUnserialize ?? ["---"])
                            .join(", "),
                  ),
                  23.verticalSpace,
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
