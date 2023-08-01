import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import 'partner_category_tile.dart';
import 'partner_key_value_tile.dart';

class PartnerLocation extends StatelessWidget {
  const PartnerLocation({Key? key}) : super(key: key);

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
                    title: context.loc.location,
                    icon: Assets.iconsLocationPink,
                  ),
                  6.verticalSpace,
                  PartnerKeyValueTile(
                    leading: context.loc.country,
                    trailing: value?.data?.basicDetails?.countryData?.countryName,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.state,
                    trailing: value?.data?.basicDetails?.userFamilyInfo?.userState?.stateName,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.district,
                    trailing:value?.data?.basicDetails?.userFamilyInfo?.userDistrict?.districtName,
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
