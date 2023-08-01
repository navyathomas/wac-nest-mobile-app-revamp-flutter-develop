import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_map_view.dart';

class MapViewTile extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
  const MapViewTile(
      {Key? key, required this.latitude, required this.longitude, this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: HexColor('#D9DCE0'))),
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 150.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(color: HexColor('#D9DCE0'))),
              child: CommonMapView(longitude: longitude, latitude: latitude)),
          InkWell(
            onTap: () => CommonFunctions.launchMap(
                latitude.toString(), longitude.toString()),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, top: 11.5.h, bottom: 13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.loc.residenceLocation,
                    style: FontPalette.f565F6C16Bold,
                  ),
                  3.verticalSpace,
                  Text(
                    address ?? '',
                    style: FontPalette.f131A24_14Medium,
                  ),
                  15.verticalSpace,
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.loc.viewLocation,
                            style: FontPalette.f2995E5_13ExtraBold,
                          ).flexWrap,
                          SvgPicture.asset(
                            Assets.iconsChevronRightBlue,
                            height: 32.r,
                            width: 32.r,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
