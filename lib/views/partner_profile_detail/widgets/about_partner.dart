import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_category_tile.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions.dart';
import '../../../models/profile_view_model.dart';

class AboutPartner extends StatelessWidget {
  const AboutPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerDetailProvider, PartnerDetailModel?>(
      selector: (context, provider) => provider.partnerDetailModel,
      builder: (context, value, child) {
        if ((value?.data?.basicDetails?.aboutMe ?? []).isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PartnerCategoryTile(
                    title: value?.data?.basicDetails?.isMale != null
                        ? value!.data!.basicDetails!.isMale!
                            ? context.loc.aboutHim
                            : context.loc.aboutHer
                        : context.loc.aboutPartner,
                    icon: Assets.iconsUserOctagon,
                  ),
                  6.verticalSpace,
                  Text(
                    value?.data?.basicDetails?.aboutMe
                            ?.map((e) => e.approveContent)
                            .join(',') ??
                        '',
                    strutStyle: const StrutStyle(height: 1.6),
                    style: FontPalette.f131A24_14Medium,
                  ),
                ],
              ),
            ),
            WidgetExtension.verticalDivider(
                height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h))
          ],
        );
      },
    );
  }
}
