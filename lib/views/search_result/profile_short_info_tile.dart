import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../widgets/premium_tile.dart';
import '../../widgets/verified_tile.dart';

class ProfileShortInfoTile extends StatelessWidget {
  final int index;
  final String? name;
  final String? id;
  final String? basicDetails;
  final String? address;
  final List? userData;
  final bool isVerified;
  final bool isPremium;
  final String? viewedDate;
  const ProfileShortInfoTile(
      {Key? key,
      this.index = 0,
      this.name,
      this.basicDetails,
      this.address,
      this.id,
      this.isVerified = false,
      this.isPremium = false,
      this.userData,
      this.viewedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchFilterProvider, List<UserData>>(
      selector: (_, p1) => p1.userDataList,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isVerified)
                  Padding(
                    padding: EdgeInsets.only(right: 14.5.w),
                    child: VerifiedTile(
                      title: isVerified ? null : '',
                    ),
                  ),
                PremiumTile(
                  packageType: isPremium ? null : '',
                )
              ],
            ),
            5.verticalSpace,
            Text(
              name ?? '',
              style: FontPalette.f131A24_15Bold,
            ).avoidOverFlow(),
            4.verticalSpace,
            Text(
              id ?? '',
              style: FontPalette.black11semiBold
                  .copyWith(color: HexColor('#8695A7')),
            ).avoidOverFlow(),
            8.verticalSpace,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    basicDetails ?? '',
                    style: FontPalette.f131A24_12Medium,
                    strutStyle: StrutStyle(height: 1.4.h),
                  ).addEllipsis(maxLine: 2),
                ),
                Text(
                  address ?? '',
                  style: FontPalette.f131A24_12SemiBold,
                ).avoidOverFlow(),
                Text(
                  viewedDate ?? '',
                  style: FontPalette.f131A24_12SemiBold
                      .copyWith(color: HexColor('#8695A7')),
                ).avoidOverFlow(),
              ],
            ))
          ],
        );
      },
    );
  }
}
