import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_address.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interests.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_shortlist.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_viewed.dart';
import 'package:nest_matrimony/views/mail_box/widgets/mail_box_child_tab_widget.dart';
import 'package:nest_matrimony/views/mail_box/widgets/mail_box_interest_screen.dart';
import 'package:nest_matrimony/views/mail_box/widgets/mail_box_parent_tab_widget.dart';
import 'package:provider/provider.dart';

import '../../models/custom_tab_model.dart';
import '../../providers/mail_box_provider.dart';

class MailBoxSampleScreen extends StatefulWidget {
  const MailBoxSampleScreen({Key? key}) : super(key: key);

  @override
  State<MailBoxSampleScreen> createState() => _MailBoxSampleScreenState();
}

class _MailBoxSampleScreenState extends State<MailBoxSampleScreen>
    with TickerProviderStateMixin {
  bool isExpand = false;
  TabController? tabController;
  List<TabController>? subTabControllerList;
  TabController? mailBoxViewedTabController;
  TabController? mailBoxInterestTabController;
  TabController? mailBoxAddressTabController;
  TabController? mailBoxShortListTabController;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (tabController == null) {
      List<CustomTabModel> customModelList =
          context.read<MailBoxProvider>().mailBoxMenuList(context);
      tabController = TabController(
          length: customModelList.length,
          vsync: this,
          initialIndex: context.read<MailBoxProvider>().tabControllerIndex);
      mailBoxViewedTabController = TabController(length: 2, vsync: this);
      mailBoxInterestTabController = TabController(length: 4, vsync: this);
      mailBoxAddressTabController = TabController(length: 2, vsync: this);
      mailBoxShortListTabController = TabController(length: 2, vsync: this);
      subTabControllerList = List.generate(
          customModelList.length,
          (index) => TabController(
              length: customModelList[index].tabBarTitles.length,
              vsync: this,
              initialIndex: customModelList[index].tabBarTitles.length > 2
                  ? context.read<MailBoxProvider>().subControllerIndex
                  : context.read<MailBoxProvider>().childTabControllerIndex));
    }
    super.didChangeDependencies();
  }

  initFunction() {
    CommonFunctions.afterInit(() {
      MailBoxProvider mailBoxProvider = context.read<MailBoxProvider>();
      mailBoxProvider.clearValues();
      mailBoxProvider.getChildTabValues(context, true);

      mailBoxProvider.scrollController.addListener(() {
        if (mailBoxProvider.scrollController.offset >=
            (mailBoxProvider.scrollController.position.maxScrollExtent *
                0.75)) {
          if (!context.isNull) {
            mailBoxProvider.loadChildTabValues(context, false);
          }
        }
      });
      debugPrint('tab control index ${mailBoxProvider.tabControllerIndex}');
      debugPrint('sub tab control index ${mailBoxProvider.subControllerIndex}');
      debugPrint('selected index ${mailBoxProvider.selectedIndex}');
      debugPrint('selected child index ${mailBoxProvider.selectedChildIndex}');
      debugPrint(
          'child tab controller index ${mailBoxProvider.childTabControllerIndex}');
      if (mailBoxProvider.updatePageIndex != -1) {
        mailBoxProvider.pageViewController.animateToPage(
            mailBoxProvider.updatePageIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
        mailBoxProvider.updatePageIndexValue(-1);
      } else {
        mailBoxProvider.updateSelectedChildIndex(0);
        mailBoxProvider.updateSubTabControllerIndex(0);
        mailBoxProvider.updateSelectedIndex(0);
        mailBoxProvider.pageViewController.animateToPage(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MailBoxProvider>(
        builder: (context, mailBoxProvider, child) {
          return NestedScrollView(
              controller: mailBoxProvider.scrollController,
              physics: const ScrollPhysics(parent: PageScrollPhysics()),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  MailBoxParentTabWidget(
                    mailBoxProvider: mailBoxProvider,
                    customModelList: mailBoxProvider.mailBoxMenuList(context),
                    subTabControllerList: subTabControllerList,
                  ),
                  MailBoxChildTabWidget(
                      tabController: tabController,
                      subTabControllerList: subTabControllerList)
                ];
              },
              body: PageView(
                controller: mailBoxProvider.pageViewController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MailBoxInterestScreen(
                      tabController: mailBoxInterestTabController),
                  MailBoxViewed(tabController: mailBoxViewedTabController),
                  MailBoxAddress(
                    tabController: mailBoxAddressTabController,
                  ),
                  MailBoxShortList(
                    tabController: mailBoxShortListTabController,
                  )
                ],
              ));
        },
      ),
    );
  }
}
