import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../../../generated/assets.dart';

class HomeTopContainer extends StatelessWidget {
  const HomeTopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 157.h,
      //color: Colors.red,
      //alignment: Alignment.bottomCenter,
      // width: MediaQuery.of(context).size.width,
      // decoration: const BoxDecoration(
      //     image: DecorationImage(
      //   image: AssetImage(
      //     Assets.imagesHomeStatusBg,
      //   ),
      //   fit: BoxFit.cover,
      // )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                29.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getDayStatus(context),
                        style: FontPalette.black14SemiBold
                            .copyWith(color: Colors.white.withOpacity(0.6)),
                      ),
                      2.verticalSpace,
                      Selector<AppDataProvider, String?>(
                        selector: (context, provider) =>
                            provider.basicDetailModel?.basicDetail?.name,
                        builder: (context, value, child) {
                          return Text(
                            value ?? '',
                            style: FontPalette.white17Bold,
                          );
                        },
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeSearchFilter),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: SvgPicture.asset(
                      Assets.iconsSearchWhite,
                      height: 41.r,
                      width: 41.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeNotificationScreen),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: SvgPicture.asset(
                      Assets.iconsNotificationWhite,
                      height: 41.r,
                      width: 41.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                7.horizontalSpace
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDayStatus(BuildContext context) {
    var hour = DateTime.now().hour;
    if (hour > 5 && hour < 12) {
      return context.loc.gdMorning;
    } else if (hour < 17) {
      return context.loc.gdAfternoon;
    } else {
      return context.loc.gdEvening;
    }
  }
}
