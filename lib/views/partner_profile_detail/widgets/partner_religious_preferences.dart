import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/font_palette.dart';
import 'partner_key_value_tile.dart';

class PartnerReligiousPreferences extends StatelessWidget {
  final bool enableIcon;
  const PartnerReligiousPreferences({Key? key, this.enableIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetExtension.verticalDivider(
            height: 3.h, margin: EdgeInsets.only(top: 17.h, bottom: 23.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              UserPartnerPreference? userPartnerPreference =
                  value?.data?.userPartnerPreference;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.religiousPreferences,
                    style: FontPalette.f8695A7_14Bold,
                  ),
                  10.verticalSpace,
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null : CommonFunctions.partnerKeyValueIcon(userPartnerPreference?.religions?.religionName),
                    leading: context.loc.religion,
                    trailing: userPartnerPreference?.religions?.religionName ?? '---',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null : CommonFunctions.partnerKeyValueIcon(userPartnerPreference?.casteUnserialize),
                    leading: context.loc.caste,
                    trailing: (userPartnerPreference?.casteUnserialize ?? ['---']).join(','),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null : CommonFunctions.partnerKeyValueIcon(userPartnerPreference?.subCaste),
                    leading: context.loc.subCaste,
                    trailing: userPartnerPreference?.subCaste ?? '---',
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
