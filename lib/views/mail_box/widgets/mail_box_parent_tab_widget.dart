import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../models/custom_tab_model.dart';
import '../../../providers/mail_box_provider.dart';
import '../../../utils/font_palette.dart';

class MailBoxParentTabWidget extends StatelessWidget {
  const MailBoxParentTabWidget(
      {Key? key,
      required this.mailBoxProvider,
      required this.customModelList,
      required this.subTabControllerList})
      : super(key: key);
  final MailBoxProvider mailBoxProvider;
  final List<CustomTabModel> customModelList;
  final List<TabController>? subTabControllerList;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      pinned: true,
      snap: false,
      floating: true,
      elevation: 0,
      toolbarHeight: 35.h,
      expandedHeight: context.sw(size: 0.3),
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        bool isExpanded = constraints.maxHeight >
            (kToolbarHeight + MediaQuery.of(context).viewPadding.top);
        final double width = (constraints.maxWidth - 68.w) * 0.28;
        return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            titlePadding: EdgeInsets.zero,
            background: Container(
              //height: width,
              width: width,
              margin: EdgeInsets.only(top: 9.h, bottom: 4.h),
              child: Theme(
                data: ThemeData().copyWith(
                    splashColor: Colors.white, highlightColor: Colors.white),
                child: ListView.builder(
                  itemCount: customModelList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _TopMenuOption(
                      width: width,
                      index: index,
                      isSelected: index == mailBoxProvider.selectedIndex,
                      mailBoxProvider: mailBoxProvider,
                      subTabControllerList: subTabControllerList,
                    );
                  },
                ),
              ),
            ),
            title: (isExpanded
                ? const SizedBox.shrink()
                : ListView.builder(
                    itemCount: customModelList.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Selector<MailBoxProvider, int>(
                        selector: (context, mailBoxProvider) =>
                            mailBoxProvider.selectedIndex,
                        builder: (context, value, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 10.w : 0,
                                right: index == 4 ? 18.w : 8.w),
                            child: InkWell(
                              onTap: () {
                                if (mailBoxProvider.loaderState ==
                                    LoaderState.loading) {
                                  return;
                                }
                                mailBoxProvider.updateSelectedIndex(index);
                                mailBoxProvider.updateSelectedChildIndex(0);
                                mailBoxProvider.pageViewController
                                    .animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linearToEaseOut);
                                subTabControllerList?[index].animateTo(0);
                                mailBoxProvider.clearPageLoader();
                                mailBoxProvider.scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastLinearToSlowEaseIn);
                                mailBoxProvider.interestUserDataList.clear();
                                mailBoxProvider.getTabValues(context);
                              },
                              child: Container(
                                height: 30.h,
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
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
                                  mailBoxProvider
                                      .matchesMenuTitleList(context)[index],
                                  textAlign: TextAlign.center,
                                  style: index == value
                                      ? FontPalette.f131A24_12Medium
                                          .copyWith(color: Colors.white)
                                      : FontPalette.f131A24_12Medium
                                          .copyWith(color: HexColor('#565F6C')),
                                ).avoidOverFlow(maxLine: 2),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )));
      }),
    );
  }
}

class _TopMenuOption extends StatelessWidget {
  final double width;
  final int index;
  final bool isSelected;
  final MailBoxProvider mailBoxProvider;
  final List<TabController>? subTabControllerList;
  const _TopMenuOption(
      {Key? key,
      required this.width,
      required this.index,
      this.isSelected = false,
      required this.mailBoxProvider,
      required this.subTabControllerList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomTabModel customTabModel =
        context.read<MailBoxProvider>().mailBoxMenuList(context)[index];
    return Padding(
      padding: EdgeInsets.only(
          left: index == 0 ? 10.w : 0, right: index == 4 ? 18.w : 8.w),
      child: InkWell(
        onTap: () {
          if (mailBoxProvider.loaderState == LoaderState.loading) {
            return;
          }
          mailBoxProvider.updateSelectedIndex(index);
          mailBoxProvider.updateSelectedChildIndex(0);
          mailBoxProvider.pageViewController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linearToEaseOut);
          subTabControllerList?[index].animateTo(0);
          mailBoxProvider.clearPageLoader();
          mailBoxProvider.scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastLinearToSlowEaseIn);
          mailBoxProvider.interestUserDataList.clear();
          mailBoxProvider.getTabValues(context);
        },
        child: Container(
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
          height: double.maxFinite,
          width: width,
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
        ),
      ),
    );
  }
}
