import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import 'partner_category_tile.dart';
import 'partner_key_value_tile.dart';

class PartnerProfessionalInfo extends StatelessWidget {
  const PartnerProfessionalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PartnerCategoryTile(
                    title: context.loc.professionalInfo,
                    icon: Assets.iconsBriefcase,
                  ),
                  6.verticalSpace,
                  PartnerKeyValueTile(
                    leading: context.loc.educationCategory,
                    trailing: value?.data?.basicDetails?.userEducationCategory
                        ?.eduCategoryTitle,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.educationDetail,
                    trailing: value?.data?.basicDetails?.educationInfo,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.jobCategory,
                    trailing: value
                        ?.data?.basicDetails?.userJobCategory?.categoryName,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.jobDetail,
                    trailing: value?.data?.basicDetails?.jobInfo,
                  ),
                ],
              );
            },
          ),
        ),
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h))
      ],
    );
  }
}
