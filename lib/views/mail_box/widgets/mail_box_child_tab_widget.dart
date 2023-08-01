import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/custom_tab_indicator.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../widgets/sticky_tab_bar_delegate.dart';

class MailBoxChildTabWidget extends StatelessWidget {
  const MailBoxChildTabWidget(
      {Key? key,
      required this.tabController,
      required this.subTabControllerList})
      : super(key: key);
  final TabController? tabController;
  final List<TabController>? subTabControllerList;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyTabBarDelegate(
          minHeight: 51.h,
          maxHeight: 51.h,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1.h)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<MailBoxProvider>(
                  builder: (context, mailBoxProvider, child) {
                    return Expanded(
                      child: IgnorePointer(
                        ignoring:
                            mailBoxProvider.loaderState == LoaderState.loading,
                        child: TabBar(
                          controller: subTabControllerList?[
                              mailBoxProvider.selectedIndex],
                          labelColor: mailBoxProvider
                              .tabSelectedColors[mailBoxProvider.selectedIndex],
                          unselectedLabelColor: HexColor('#565F6C'),
                          labelStyle: FontPalette.f131A24_12Medium,
                          unselectedLabelStyle: FontPalette.f131A24_12Medium,
                          indicatorSize: TabBarIndicatorSize.label,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          indicator: CustomTabIndicator(
                            indicatorHeight: 2.0,
                            color: mailBoxProvider.tabSelectedColors[
                                mailBoxProvider.selectedIndex],
                          ),
                          onTap: (val) async {
                            debugPrint(
                                'loader state ${mailBoxProvider.loaderState}');
                            if (mailBoxProvider.loaderState ==
                                LoaderState.loading) {
                              return;
                            }
                            mailBoxProvider.updateSelectedChildIndex(val);
                            mailBoxProvider.clearPageLoader();
                            mailBoxProvider.updateDeclinedTabIndex(0);
                            mailBoxProvider.updateAcceptedTabIndex(0);

                            mailBoxProvider.interestUserDataList.clear();
                            await mailBoxProvider.getChildTabValues(
                                context, true);
                            mailBoxProvider.scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastLinearToSlowEaseIn);
                          },
                          labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
                          isScrollable: true,
                          tabs: <Widget>[
                            ...List.generate(
                                mailBoxProvider
                                    .mailBoxMenuList(
                                        context)[mailBoxProvider.selectedIndex]
                                    .tabBarTitles
                                    .length,
                                (index) => Tab(
                                      text: mailBoxProvider
                                          .mailBoxMenuList(context)[
                                              mailBoxProvider.selectedIndex]
                                          .tabBarTitles[index],
                                    ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
