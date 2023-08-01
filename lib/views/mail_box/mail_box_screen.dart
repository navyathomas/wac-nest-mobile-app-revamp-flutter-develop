import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/custom_tab_model.dart';
import '../../utils/custom_tab_indicator.dart';
import '../../utils/font_palette.dart';
import '../../utils/tuple.dart';
import '../../widgets/common_alert_view.dart';
import '../../widgets/sticky_tab_bar_delegate.dart';
import 'await_alert_tile.dart';

class MailBoxScreen extends StatefulWidget {
  const MailBoxScreen({Key? key}) : super(key: key);

  @override
  State<MailBoxScreen> createState() => _MailBoxScreenState();
}

class _MailBoxScreenState extends State<MailBoxScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  List<TabController>? subTabControllerList;
  late ScrollController controller;
  late MailBoxProvider mailBoxProvider;
  @override
  void initState() {
    mailBoxProvider = context.read<MailBoxProvider>();
    controller = ScrollController()
      ..addListener(() {
        if (controller.offset >= (controller.position.maxScrollExtent * 0.5)) {
          loadChildTabValues(mailBoxProvider.selectedIndex,
              mailBoxProvider.selectedChildIndex, false);
        }
      });
    CommonFunctions.afterInit(() {
      getChildTabValues(context.read<MailBoxProvider>().selectedIndex,
          context.read<MailBoxProvider>().selectedChildIndex, true);
    });

    //getInitialList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MailBoxProvider, Tuple2<int, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.selectedIndex, provider.paginationLoader),
      builder: (context, data, child) {
        final model = context.read<MailBoxProvider>();
        return NestedScrollView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                expandedAppbar(),

                ///TODO:Need to check transform value
                childTabBar(data.item1),
              ];
            },
            body: Stack(children: [
              TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                    model.mailBoxMenuList(context).length,
                    (index) => model
                        .mailBoxMenuList(context,
                            tabController: subTabControllerList?[index])[index]
                        .tabBarChild),
              ),
            ]));
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (tabController == null) {
      List<CustomTabModel> customModelList =
          mailBoxProvider.mailBoxMenuList(context);
      tabController = TabController(
          length: customModelList.length,
          vsync: this,
          initialIndex: context.read<MailBoxProvider>().tabControllerIndex);
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

  @override
  void dispose() {
    if (tabController != null) tabController!.dispose();
    if (subTabControllerList != null) {
      for (var ctrl in subTabControllerList!) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  Widget scrolledTabView(
      bool isExpanded, List<CustomTabModel> customModelList) {
    return isExpanded
        ? const SizedBox.shrink()
        : Selector<MailBoxProvider, int>(
            selector: (context, provider) => provider.selectedIndex,
            builder: (context, value, child) {
              return Container(
                height: kToolbarHeight,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                child: Row(
                  children: List.generate(customModelList.length, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (mailBoxProvider.loaderState !=
                              LoaderState.loading) {
                            changePageView(index);
                            mailBoxProvider.updateSelectedIndex(index);
                            mailBoxProvider.updateSelectedChildIndex(0);
                            subTabControllerList?[index].animateTo(0);
                            mailBoxProvider.clearPageLoader();
                            controller.animateTo(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastLinearToSlowEaseIn);
                            mailBoxProvider.interestUserDataList.clear();
                            getTabValues(index, value);
                          }
                        },
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 10.h),
                          margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: HexColor('#F5F5F5'),
                              gradient: index == value
                                  ? LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: customModelList[index]
                                          .buttonStyleModel
                                          .gradiantColor)
                                  : null),
                          child: Text(
                            customModelList[index].buttonStyleModel.title,
                            textAlign: TextAlign.center,
                            style: index == value
                                ? FontPalette.f131A24_12Medium
                                    .copyWith(color: Colors.white)
                                : FontPalette.f131A24_12Medium,
                          ).avoidOverFlow(),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
  }

  Widget expandedAppbar() {
    double width = (context.sw() - 47.w) * 0.25;
    return SliverAppBar(
      expandedHeight: width * 1.21,
      backgroundColor: Colors.white,
      pinned: true,
      snap: false,
      floating: true,
      elevation: 0,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        bool isExpanded = constraints.maxHeight >
            (kToolbarHeight + MediaQuery.of(context).viewPadding.top);
        final model = context.read<MailBoxProvider>();
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: EdgeInsets.zero,
          title: scrolledTabView(isExpanded, model.mailBoxMenuList(context)),
          background: Padding(
            padding: EdgeInsets.only(
                left: 13.5.w, right: 13.5.w, top: 9.h, bottom: 3.h),
            child: Selector<MailBoxProvider, int>(
              selector: (context, provider) => provider.selectedIndex,
              builder: (context, value, child) {
                return Theme(
                  data: ThemeData().copyWith(
                      splashColor: Colors.white, highlightColor: Colors.white),
                  child: TabBar(
                    controller: tabController,
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.zero,
                    indicatorWeight: 0,
                    physics: const NeverScrollableScrollPhysics(),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.transparent,
                    ),
                    onTap: (val) {
                      if (mailBoxProvider.loaderState != LoaderState.loading) {
                        mailBoxProvider.updateSelectedIndex(val);
                        mailBoxProvider.updateSelectedChildIndex(0);
                        subTabControllerList?[val].animateTo(0);
                        mailBoxProvider.clearPageLoader();
                        controller.animateTo(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastLinearToSlowEaseIn);
                        mailBoxProvider.interestUserDataList.clear();
                        getTabValues(val, value);
                      }
                    },
                    labelStyle: FontPalette.f131A24_12Medium,
                    unselectedLabelStyle: FontPalette.f131A24_12Medium,
                    unselectedLabelColor: Colors.black,
                    tabs: List.generate(
                        model.mailBoxMenuList(context).length,
                        (index) => _TopMenuOption(
                              width: width,
                              index: index,
                              isSelected: index == value,
                            )),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget childTabBar(int selectedIndex) {
    final model = context.read<MailBoxProvider>();
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
              border: bottomBorder(model),
            ),
            child: TabBar(
              controller: subTabControllerList?[selectedIndex],
              labelColor: model.tabSelectedColors[selectedIndex],
              unselectedLabelColor: HexColor('#565F6C'),
              labelStyle: FontPalette.f131A24_12Medium
                  .copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: FontPalette.f131A24_12Medium
                  .copyWith(fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.label,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              indicator: CustomTabIndicator(
                indicatorHeight: 2.0,
                color: model.tabSelectedColors[selectedIndex],
              ),
              onTap: (val) {
                model.updateSelectedChildIndex(val);
                model.clearPageLoader();
                model.updateDeclinedTabIndex(0);
                model.updateAcceptedTabIndex(0);
                controller.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastLinearToSlowEaseIn);
                mailBoxProvider.interestUserDataList.clear();
                getChildTabValues(selectedIndex, val, true);
              },
              labelPadding: EdgeInsets.symmetric(horizontal: 13.w),
              isScrollable: true,
              tabs: <Widget>[
                ...List.generate(
                    model
                        .mailBoxMenuList(context)[selectedIndex]
                        .tabBarTitles
                        .length,
                    (index) => Tab(
                          text: model
                              .mailBoxMenuList(context)[selectedIndex]
                              .tabBarTitles[index],
                        ))
              ],
            ),
          )),
    );
  }

  getInitialList() {
    CommonFunctions.afterInit(() {
      mailBoxProvider.pageInit();
      mailBoxProvider.clearPageLoader();
      mailBoxProvider
          .getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.received)
          .then((value) {
        if (value != null && mailBoxProvider.interestUserDataList.isNotEmpty) {
          CommonAlertDialog.showDialogPopUp(
              barrierDismissible: false,
              context,
              AwaitAlertDialog(
                count: mailBoxProvider.totalRecords ?? 0,
              ));
        }
      });
    });
  }

  getTabValues(int mainTabIndex, int childTabIndex) {
    switch (mainTabIndex) {
      case 0:
        mailBoxProvider.getInterestList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            interestTypes: InterestTypes.received);
        break;
      case 1:
        mailBoxProvider.getProfileViewedList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            profileViewedBy: ViewedBy.viewedByOthers);
        break;
      case 2:
        mailBoxProvider.getAddressViewedList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            addressViewedBy: ViewedBy.viewedByOthers);
        break;
      case 3:
        mailBoxProvider.getShortList(context,
            enableLoader: true,
            page: 1,
            length: 20,
            shortListedBy: ShortListedBy.shortListedByOthers);
    }
  }

  getChildTabValues(int mainTabIndex, int childTabIndex, bool enableLoader) {
    switch (mainTabIndex) {
      case 0:
        getInterestLists(childTabIndex, enableLoader);
        break;
      case 1:
        getProfileValueLists(childTabIndex, enableLoader);
        break;
      case 2:
        getAddressValueLists(childTabIndex, enableLoader);
        break;
      case 3:
        getShortlist(enableLoader, childTabIndex);
        break;
    }
  }

  loadChildTabValues(int mainTabIndex, int childTabIndex, bool enableLoader) {
    switch (mainTabIndex) {
      case 0:
        //loadInterestLists(childTabIndex);
        break;
      case 1:
        // loadProfileValueList(childTabIndex);
        break;
      case 2:
        // loadMoreAddressValueLists(childTabIndex);
        break;
      case 3:
        //loadMoreShortListValueLists(childTabIndex);
        break;
    }
  }

  getInterestLists(int index, bool enableLoader) {
    switch (index) {
      case 0:
        CommonFunctions.afterInit(() {
          mailBoxProvider
              .getInterestList(context,
                  enableLoader: enableLoader,
                  page: 1,
                  length: 20,
                  interestTypes: InterestTypes.received)
              .then((value) {
            if (value != null &&
                mailBoxProvider.interestUserDataList.isNotEmpty) {
              CommonAlertDialog.showDialogPopUp(
                  barrierDismissible: false,
                  context,
                  AwaitAlertDialog(
                    count: mailBoxProvider.totalRecords ?? 0,
                  ));
            }
          });
        });
        break;
      case 1:
        CommonFunctions.afterInit(() {
          mailBoxProvider.getInterestList(context,
              enableLoader: enableLoader,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.sent);
        });
        break;
      case 2:
        CommonFunctions.afterInit(() {
          mailBoxProvider.getInterestList(context,
              enableLoader: enableLoader,
              page: 1,
              length: 20,
              interestTypes: mailBoxProvider.childTabControllerIndex == 0
                  ? InterestTypes.accepted
                  : InterestTypes.acceptedByMe);
        });
        break;
      case 3:
        CommonFunctions.afterInit(() {
          mailBoxProvider.getInterestList(context,
              enableLoader: enableLoader,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.declined);
        });
        break;
    }
  }

  // loadInterestLists(int index) {
  //   MailBoxProvider provider = context.read<MailBoxProvider>();
  //   switch (index) {
  //     case 0:
  //       provider.loadMoreInterests(context, InterestTypes.received);
  //       break;
  //     case 1:
  //       provider.loadMoreInterests(context, InterestTypes.sent);
  //       break;
  //     case 2:
  //       provider.loadMoreInterests(
  //           context,
  //           provider.acceptedTabIndex == 0
  //               ? InterestTypes.accepted
  //               : InterestTypes.acceptedByMe);
  //       break;
  //     case 3:
  //       provider.loadMoreInterests(
  //           context,
  //           provider.declinedTabIndex == 0
  //               ? InterestTypes.declined
  //               : InterestTypes.declinedByMe);
  //       break;
  //   }
  // }

  getProfileValueLists(int index, bool enableLoader) {
    mailBoxProvider.getProfileViewedList(context,
        enableLoader: enableLoader,
        page: 1,
        length: 20,
        profileViewedBy:
            index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe);
  }

  // loadProfileValueList(int index) {
  //   mailBoxProvider.loadMoreProfile(
  //       context, index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe);
  // }

  getAddressValueLists(int index, bool enableLoader) {
    MailBoxProvider provider = context.read<MailBoxProvider>();
    provider.getAddressViewedList(context,
        enableLoader: enableLoader,
        page: 1,
        length: 20,
        addressViewedBy:
            index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe);
  }

  // loadMoreAddressValueLists(int index) {
  //   mailBoxProvider.loadMoreAddress(
  //       context, index == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe);
  // }

  getShortlist(bool enableLoader, int index) {
    context.read<MailBoxProvider>().getShortList(context,
        enableLoader: enableLoader,
        shortListedBy: index == 0
            ? ShortListedBy.shortListedByOthers
            : ShortListedBy.shortListedByMe);
  }

  // loadMoreShortListValueLists(int index) {
  //   mailBoxProvider.loadMoreShortList(
  //       context,
  //       index == 0
  //           ? ShortListedBy.shortListedByOthers
  //           : ShortListedBy.shortListedByMe);
  // }

  Border? bottomBorder(MailBoxProvider model) {
    Border side =
        Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.h));
    switch (model.selectedIndex) {
      case 0:
        return (model.selectedChildIndex == 2 || model.selectedChildIndex == 3)
            ? null
            : side;
      default:
        return side;
    }
  }

  void changePageView(int page) {
    context.read<MailBoxProvider>().updateSelectedIndex(page);
    tabController!.animateTo(page);
  }
}

class _TopMenuOption extends StatelessWidget {
  final double width;
  final int index;
  final bool isSelected;

  const _TopMenuOption(
      {Key? key,
      required this.width,
      required this.index,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomTabModel customTabModel =
        context.read<MailBoxProvider>().mailBoxMenuList(context)[index];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: HexColor('#F5F5F5'),
          gradient: isSelected
              ? LinearGradient(
                  colors: customTabModel.buttonStyleModel.gradiantColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              : null),
      // margin: EdgeInsets.symmetric(horizontal: 2.5.w),
      height: 200,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: width * 0.46,
              width: width * 0.46,
              child: Center(
                child: SvgPicture.asset(
                  customTabModel.buttonStyleModel.icon,
                  fit: BoxFit.contain,
                  color: isSelected ? Colors.white : HexColor('#565F6C'),
                ),
              )),
          8.verticalSpace,
          Text(
            customTabModel.buttonStyleModel.title,
            textAlign: TextAlign.center,
            style: isSelected
                ? FontPalette.f131A24_12Medium.copyWith(color: Colors.white)
                : FontPalette.f131A24_12Medium
                    .copyWith(color: HexColor('#565F6C')),
          ).avoidOverFlow(maxLine: 1)
        ],
      ),
    );
  }
}
