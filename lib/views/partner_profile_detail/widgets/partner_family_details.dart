import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import 'partner_category_tile.dart';
import 'partner_key_value_tile.dart';

class PartnerFamilyDetails extends StatelessWidget {
  const PartnerFamilyDetails({Key? key}) : super(key: key);

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
                    title: context.loc.familyDetails,
                    icon: Assets.iconsPeople,
                  ),
                  6.verticalSpace,
                  PartnerKeyValueTile(
                    leading: context.loc.fathersName,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.fatherName,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.fathersJob,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.fatherJob,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.mothersName,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.motherName,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.mothersJob,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.motherJob,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.siblingDetails,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.sibilingsInfo,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
