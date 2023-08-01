import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

class HelpCentre extends StatelessWidget {
  const HelpCentre({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Help centre',
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.0,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: Column(
        children: [
          helpTile(
            title: "Support",
            onTap: () => routeToSupport(context),
          ),
          helpTile(
            title: "Contact Us",
            onTap: () => routeToContactUs(context),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }

  Widget helpTile({String? icon, String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.sp, color: HexColor("#F3F3F8")))),
          height: 70.h,
          margin: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title ?? '',
                  style: FontPalette.black16SemiBold
                      .copyWith(color: HexColor("#132031"))),
              SizedBox(
                  // width: 5.48.w,
                  // height: 10.95.h,
                  child: SvgPicture.asset(Assets.iconsChevronRightGrey))
            ],
          )),
    );
  }

  routeToSupport(BuildContext context) {
    Navigator.pushNamed(context, RouteGenerator.routeSupport);
  }

  routeToContactUs(BuildContext context) {
    Navigator.pushNamed(context, RouteGenerator.routeToContactUs);
  }
}
