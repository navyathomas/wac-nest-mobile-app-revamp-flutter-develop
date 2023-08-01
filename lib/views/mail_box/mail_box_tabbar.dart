import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_tab_indicator.dart';
import '../../utils/font_palette.dart';

class MailBoxTabBar extends StatelessWidget {
  final List<String> titleList;
  final List<Widget> children;
  final Color? selectedColor;
  final bool disableElevation;
  final TabController? tabController;
  final bool hideActions;
  const MailBoxTabBar(
      {Key? key,
      required this.titleList,
      required this.children,
      this.selectedColor,
      this.tabController,
      this.hideActions = true,
      this.disableElevation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(titleList.length == children.length,
        'Title and children should be same length');
    return DefaultTabController(
      initialIndex: 0,
      length: titleList.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: disableElevation ? 0 : 1.h)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: tabController,
                    labelColor: selectedColor ?? HexColor('#354DFF'),
                    unselectedLabelColor: HexColor('#565F6C'),
                    labelStyle: FontPalette.f131A24_13Bold,
                    unselectedLabelStyle: FontPalette.f131A24_13Bold,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: EdgeInsets.zero,
                    indicator: CustomTabIndicator(
                      indicatorHeight: 2.0,
                      color: selectedColor ?? HexColor('#384FFF'),
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
                    isScrollable: true,
                    tabs: List.generate(
                        titleList.length,
                        (index) => Tab(
                              text: titleList[index],
                            )),
                  ),
                ),
                hideActions
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 37.w,
                            width: 37.w,
                            margin: EdgeInsets.all(5.r),
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.iconsFilter,
                              ),
                            )),
                      )
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children:
                List.generate(children.length, (index) => children[index]),
          ))
        ],
      ),
    );
  }
}
