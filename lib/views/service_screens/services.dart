import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/services_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/service_screens/staff_profile_card.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../widgets/reusable_widgets.dart';
import '../error_views/common_error_view.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ScrollController controller;
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context
          .read<ServicesProvider>()
          .getServices(ServiceType.crmService, true);
    });
    controller = ScrollController()
      ..addListener(() {
        if (controller.offset >= (controller.position.maxScrollExtent * 0.05)) {
          loadMore(context.read<ServicesProvider>(), context);
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#F2F4F5"),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            context.loc.services,
            style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
          ),
          elevation: 0.3,
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
        ),
        body: Column(children: [
          Expanded(
            child: DefaultTabController(
                length: 2,
                initialIndex: context.read<ServicesProvider>().tabIndex,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 2),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ]),
                        height: 50.h,
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                              onTap: (value) {
                                context
                                    .read<ServicesProvider>()
                                    .updateTabIndex(value);
                                getServiceList(context, value);
                              },
                              indicatorColor: ColorPalette.primaryColor,
                              // Custom Indicator for TAB
                              indicator: MD2Indicator(
                                indicatorSize: MD2IndicatorSize.full,
                                indicatorHeight: 2.0,
                                indicatorColor: ColorPalette.primaryColor,
                              ),
                              labelStyle: FontPalette.black15SemiBold
                                  .copyWith(color: ColorPalette.primaryColor),
                              unselectedLabelStyle: FontPalette.black15SemiBold
                                  .copyWith(color: HexColor("#565F6C")),
                              physics: const BouncingScrollPhysics(),
                              indicatorPadding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                              labelColor: ColorPalette.primaryColor,
                              unselectedLabelColor: HexColor("#565F6C"),
                              tabs: [
                                context.loc.crmServices,
                                context.loc.profileSuggestions,
                              ]
                                  .map((e) => Tab(
                                          child: Text(
                                        e,
                                        textAlign: TextAlign.center,
                                      )))
                                  .toList()),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.h))),
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                switchView(context),
                                switchView(context),
                              ]),
                        ),
                      ),
                    ])),
          ),
        ]));
  }

  Widget switchView(BuildContext context) {
    return Consumer<ServicesProvider>(
      builder: (cxt, provider, __) {
        Widget child = const SizedBox.shrink();

        switch (provider.loaderState) {
          case LoaderState.loaded:
            child = crmServices(provider);
            break;
          case LoaderState.error:
            child = CommonErrorView(
                isTryAgainVisible: false,
                error: Errors.serverError,
                onTap: () => getServiceList(context, provider.tabIndex));
            break;
          case LoaderState.networkErr:
            child = CommonErrorView(
              error: Errors.networkError,
              onTap: () => getServiceList(context, provider.tabIndex),
            );
            break;
          case LoaderState.noData:
            child = CommonErrorView(
              isTryAgainVisible: false,
              error: Errors.noDatFound,
              onTap: () => getServiceList(context, provider.tabIndex),
            );
            break;
          case LoaderState.loading:
            child =
                const StackLoader(inAsyncCall: true, child: SizedBox.shrink());
            break;
        }
        return child;
      },
    );
  }

  Widget crmServices(ServicesProvider provider) {
    return Consumer<ServicesProvider>(
      builder: (context, value, child) {
        return StackLoader(
          inAsyncCall:
              provider.loaderState == LoaderState.loading ? true : false,
          child: value.loaderState == LoaderState.loading
              ? const SizedBox.shrink()
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollEnd) {
                    final metrics = scrollEnd.metrics;
                    if (metrics.atEdge) {
                      bool isTop = metrics.pixels == 0;
                      if (isTop) {
                      } else {
                        loadMore(context.read<ServicesProvider>(), context);
                      }
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: value.serviceDataListToday.isNotEmpty
                            ? greyTitleText(title: context.loc.today)
                            : const SizedBox.shrink(),
                      ),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 9.h),
                            child: Column(
                              children: [
                                StaffProfileCard(
                                  servicesData:
                                      provider.serviceDataListToday[index],
                                  removeStatus: provider.tabIndex == 1,
                                ),
                                5.verticalSpace
                              ],
                            ));
                      }, childCount: provider.serviceDataListToday.length)),
                      SliverToBoxAdapter(
                        child: value.serviceDataListThisWeek.isNotEmpty
                            ? greyTitleText(title: context.loc.thisWeek)
                            : const SizedBox.shrink(),
                      ),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 9.h),
                            child: Column(
                              children: [
                                StaffProfileCard(
                                  servicesData:
                                      value.serviceDataListThisWeek[index],
                                  removeStatus: value.tabIndex == 1,
                                ),
                                5.verticalSpace
                              ],
                            ));
                      }, childCount: value.serviceDataListThisWeek.length)),
                      SliverToBoxAdapter(
                        child: value.serviceDataListOlder.isNotEmpty
                            ? greyTitleText(title: context.loc.older)
                            : const SizedBox.shrink(),
                      ),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 9.h),
                            child: Column(
                              children: [
                                StaffProfileCard(
                                  servicesData:
                                      value.serviceDataListOlder[index],
                                  removeStatus: value.tabIndex == 1,
                                ),
                                5.verticalSpace
                              ],
                            ));
                      }, childCount: value.serviceDataListOlder.length)),
                      ReusableWidgets.sliverPaginationLoader(
                          value.paginationLoader)
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget profileSuggestions(ServicesProvider provider) {
    return Stack(children: [
      SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            provider.serviceDataListToday.isNotEmpty
                ? greyTitleText(title: context.loc.today)
                : const SizedBox.shrink(),
            ListView.builder(
              itemCount: provider.serviceDataListToday.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    StaffProfileCard(
                      servicesData: provider.serviceDataListToday[index],
                      removeStatus: true,
                    ),
                    5.verticalSpace
                  ],
                );
              },
            ),
            provider.serviceDataListThisWeek.isNotEmpty
                ? greyTitleText(title: context.loc.thisWeek)
                : const SizedBox.shrink(),
            ListView.builder(
              itemCount: provider.serviceDataListThisWeek.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    StaffProfileCard(
                      servicesData: provider.serviceDataListThisWeek[index],
                      removeStatus: true,
                    ),
                    5.verticalSpace
                  ],
                );
              },
            ),
            provider.serviceDataListOlder.isNotEmpty
                ? greyTitleText(title: context.loc.older)
                : const SizedBox.shrink(),
            ListView.builder(
              itemCount: provider.serviceDataListOlder.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    StaffProfileCard(
                      servicesData: provider.serviceDataListOlder[index],
                      removeStatus: true,
                    ),
                    5.verticalSpace
                  ],
                );
              },
            ),
          ],
        ),
      ),
      provider.paginationLoader
          ? Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: const CircularProgressIndicator(),
            )
          : const SizedBox.shrink()
    ]);
  }
}

getServiceList(BuildContext context, int index) {
  context.read<ServicesProvider>().getServices(
      index == 0 ? ServiceType.crmService : ServiceType.profileSuggestions,
      true);
}

loadMore(ServicesProvider provider, BuildContext context) {
  provider.loadMore(
      context,
      provider.tabIndex == 0
          ? ServiceType.crmService
          : ServiceType.profileSuggestions);
}

Widget greyTitleText({String? title}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 12.h, bottom: 7.h),
    child: Text(
      title ?? "TODAY",
      style: FontPalette.black13SemiBold
          .copyWith(color: HexColor("#8695A7"), fontSize: 12.sp),
    ),
  );
}

// Custom Indicator for TAB
enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class MD2Indicator extends Decoration {
  final double? indicatorHeight;
  final Color? indicatorColor;
  final MD2IndicatorSize? indicatorSize;

  const MD2Indicator(
      {@required this.indicatorHeight,
      @required this.indicatorColor,
      @required this.indicatorSize});

  @override
  MDPainter createBoxPainter([VoidCallback? onChanged]) {
    return MDPainter(this, onChanged!);
  }
}

class MDPainter extends BoxPainter {
  final MD2Indicator decoration;

  MDPainter(this.decoration, VoidCallback onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    Rect? rect;
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight!);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(16, decoration.indicatorHeight ?? 3);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor ?? const Color(0xff1967d2);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect!,
            topRight: const Radius.circular(8),
            topLeft: const Radius.circular(8)),
        paint);
  }
}
