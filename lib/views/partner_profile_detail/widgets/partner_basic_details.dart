import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_key_value_tile.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import 'partner_category_tile.dart';

class PartnerBasicDetails extends StatelessWidget {
  const PartnerBasicDetails({Key? key}) : super(key: key);

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
                    title: context.loc.basicDetails,
                    icon: Assets.iconsTagUser,
                  ),
                  6.verticalSpace,
                  PartnerKeyValueTile(
                    leading: context.loc.name,
                    trailing: value?.data?.basicDetails?.name,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.gender,
                    trailing: value?.data?.basicDetails?.gender,
                  ),
                  if (value?.data?.basicDetails?.age != null)
                    PartnerKeyValueTile(
                      leading: context.loc.age,
                      trailing:
                          '${value?.data?.basicDetails?.age}${(value?.data?.basicDetails?.dateOfBirth ?? '').isNotEmpty ? ' - (${value!.data!.basicDetails!.dateOfBirth})' : ''}',
                    ),
                  PartnerKeyValueTile(
                    leading: context.loc.maritalStatus,
                    trailing:
                        value?.data?.basicDetails?.maritalStatus?.maritalStatus,
                  ),
                  if ((value?.data?.basicDetails?.maritalStatus?.haveChildren ??
                          0) ==
                      1)
                    PartnerKeyValueTile(
                      leading: context.loc.noOfChildren,
                      trailing:
                          '${value?.data?.basicDetails?.noOfChildren ?? 'Nil'}',
                    ),
                  PartnerKeyValueTile(
                    leading: context.loc.height,
                    trailing: value?.data?.basicDetails?.userHeight?.height,
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.bodyType,
                    trailing:
                        value?.data?.basicDetails?.physicalStatus?.bodyType ??
                            'Not Mentioned',
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.complexion,
                    trailing: value
                            ?.data?.basicDetails?.complexion?.complexionTitle ??
                        'Not Mentioned',
                    // .userPartnerPreference?.complexionUnserialize?.join(','),
                  ),
                  PartnerKeyValueTile(
                    leading: context.loc.profileCreatedFor,
                    trailing: value?.data?.basicDetails?.profileCreated,
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
