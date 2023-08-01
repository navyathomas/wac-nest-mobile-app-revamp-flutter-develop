import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/font_palette.dart';
import 'partner_key_value_tile.dart';

class PartnerProfessionalPreferences extends StatelessWidget {
  final bool enableIcon;
  const PartnerProfessionalPreferences({Key? key, this.enableIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 2.h, bottom: 23.h)),
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
                    context.loc.professionalPreferences,
                    style: FontPalette.f8695A7_14Bold,
                  ),
                  10.verticalSpace,
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference
                                ?.educationCategoryUnserialize),
                    leading: context.loc.educationCategory,
                    trailing:
                        (userPartnerPreference?.educationCategoryUnserialize ??
                                ['---'])
                            .join(', '),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.educationInfo),
                    leading: context.loc.educationDetail,
                    trailing: userPartnerPreference?.educationInfo ?? '---',
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.jobCategoryUnserialize),
                    leading: context.loc.jobCategory,
                    trailing: (userPartnerPreference?.jobCategoryUnserialize ??
                            ['---'])
                        .join(", "),
                  ),
                  PartnerKeyValueTile(
                    leadingIcon: !enableIcon
                        ? null
                        : CommonFunctions.partnerKeyValueIcon(
                            userPartnerPreference?.jobInfo),
                    leading: context.loc.jobDetail,
                    trailing: userPartnerPreference?.jobInfo ?? '---',
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
