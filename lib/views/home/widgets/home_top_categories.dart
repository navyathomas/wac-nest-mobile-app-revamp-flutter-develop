import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../../common/route_generator.dart';
import '../../../models/route_arguments.dart';

class HomeTopCategories extends StatelessWidget {
  const HomeTopCategories({Key? key}) : super(key: key);

  static const List<String> _categoryIcons = [
    Assets.iconsSearchUser,
    Assets.iconsMessageReceive,
    Assets.iconsHeartTickOutline,
    Assets.iconsPhoneSearch
  ];

  static List<String> _categoryTitles(BuildContext context) => [
        context.loc.viewedU,
        context.loc.interestReceived,
        context.loc.interestAccepted,
        context.loc.addressView
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.r), topRight: Radius.circular(22.r)),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_categoryIcons.length, (index) {
            return _IconTitle(
              icon: _categoryIcons[index],
              title: _categoryTitles(context)[index],
              onTap: () => switchTabs(context, index),
              width: constraints.maxWidth * 0.25,
              index: index,
            );
          }),
        );
      }),
    );
  }

  switchTabs(BuildContext context, int index) {
    MailBoxProvider mailBoxProvider = context.read<MailBoxProvider>();
    switch (index) {
      case 0:
        mailBoxProvider.updateTabControllerIndex(1);
        mailBoxProvider.updateSubTabControllerIndex(0);
        mailBoxProvider.updateSelectedIndex(1);
        mailBoxProvider.updateSelectedChildIndex(0);
        mailBoxProvider.updateChildTabControllerIndex(0);
        mailBoxProvider.updatePageIndexValue(1);
        mailBoxProvider.updateIsFromHomeScreen(true);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments: RouteArguments(tabIndex: 2));

        break;
      case 1:
        mailBoxProvider.updateTabControllerIndex(0);
        mailBoxProvider.updateSubTabControllerIndex(0);
        mailBoxProvider.updateSelectedIndex(0);
        mailBoxProvider.updateSelectedChildIndex(0);
        mailBoxProvider.updateChildTabControllerIndex(0);
        mailBoxProvider.updatePageIndexValue(0);
        mailBoxProvider.updateIsFromHomeScreen(true);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments: RouteArguments(tabIndex: 2));
        break;
      case 2:
        mailBoxProvider.updateTabControllerIndex(0);
        mailBoxProvider.updateSubTabControllerIndex(2);
        mailBoxProvider.updateSelectedIndex(0);
        mailBoxProvider.updateSelectedChildIndex(2);
        mailBoxProvider.updateChildTabControllerIndex(1);
        mailBoxProvider.updateAcceptedTabIndex(1);
        mailBoxProvider.updatePageIndexValue(0);
        mailBoxProvider.updateIsFromHomeScreen(true);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments: RouteArguments(tabIndex: 2));
        break;
      case 3:
        mailBoxProvider.updateTabControllerIndex(2);
        mailBoxProvider.updateSubTabControllerIndex(1);
        mailBoxProvider.updateSelectedIndex(2);
        mailBoxProvider.updateSelectedChildIndex(1);
        mailBoxProvider.updateChildTabControllerIndex(1);
        mailBoxProvider.updatePageIndexValue(2);
        mailBoxProvider.updateIsFromHomeScreen(true);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments: RouteArguments(tabIndex: 2));
        break;
    }
  }
}

class _IconTitle extends StatelessWidget {
  _IconTitle(
      {Key? key,
      required this.icon,
      required this.title,
      this.onTap,
      required this.index,
      required this.width})
      : super(key: key);

  final String icon;
  final String title;
  final double width;
  final int index;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: double.maxFinite,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                7.verticalSpace,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: FontPalette.f565F6C_12Bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            if (index == 0)
              Positioned(
                top: width * 0.1,
                right: width * 0.28,
                child: Selector<MailBoxProvider, int>(
                  selector: (context, provider) => provider.totalViewedCount,
                  builder: (context, value, child) {
                    return (value != 0
                            ? Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5.r),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2, color: Colors.white)),
                                    child: Text(
                                      '$value',
                                      style: FontPalette.black10Bold
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink())
                        .animatedSwitch();
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
