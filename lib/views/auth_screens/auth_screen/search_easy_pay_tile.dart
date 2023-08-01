import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';

import '../../../generated/assets.dart';
import '../../../utils/font_palette.dart';
import 'bottom_container.dart';

class SearchEasyPayTile extends StatelessWidget {
  const SearchEasyPayTile({Key? key}) : super(key: key);

  Widget customTile(BuildContext context,
      {required String icon, required String title, VoidCallback? onTap}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: SizedBox.expand(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 17.r,
              width: 17.r,
            ),
            13.0.horizontalSpace,
            Flexible(
                child: Text(
              title,
              style: FontPalette.white16Bold,
            ).avoidOverFlow())
          ],
        ),
      ),
    ).removeSplash());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.r), topRight: Radius.circular(22.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
        child: Container(
          width: double.maxFinite,
          color: const Color(0x1affffff),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 62.h,
                child: Row(
                  children: [
                    customTile(context,
                        title: context.loc.search,
                        icon: Assets.iconsSearch,
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routeSearchFilter)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.5.h),
                      child: WidgetExtension.verticalDivider(
                          height: 33.5.h,
                          width: 2,
                          color: const Color(0x78ffffff)),
                    ),
                    customTile(context,
                        title: context.loc.easyPay,
                        icon: Assets.iconsRupay,
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routeEasyPay)),
                  ],
                ),
              ),
              const BottomContainer()
            ],
          ),
        ),
      ),
    );
  }
}
