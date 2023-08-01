import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/views/alert_views/data_collection_alert.dart';
import 'package:nest_matrimony/services/widget_handler/partner_detail_btn_handler.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_sheets.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/basic_detail_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/mail_box_provider.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../providers/profile_handler_provider.dart';
import '../../../services/helpers.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_alert_view.dart';

class PartnerDetailBottomBtnView extends StatelessWidget {
  final BuildContext? buildContext;
  final ScrollController controller;
  final ValueNotifier<bool> enableBottomTile;
  final ValueNotifier<bool> respondBtnNotifier;
  final bool enableRespondTile;
  final NavFrom? navFrom;
  const PartnerDetailBottomBtnView(
      {Key? key,
      required this.enableBottomTile,
      this.enableRespondTile = false,
      this.buildContext,
      required this.respondBtnNotifier,
      required this.controller,
      this.navFrom})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
          valueListenable: enableBottomTile,
          builder: (cxt, value, _) {
            return AnimatedContainer(
                height: value ? ((context.sw() - 166.w) / 5) + 36.h : 0,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: value
                        ? Border(
                            top: BorderSide(
                                color: Colors.grey.shade200, width: 2))
                        : null),
                duration: const Duration(milliseconds: 300),
                child: enableRespondTile

                    ///Bottom button row with respond option for accepting or rejecting interest from others
                    ? _BottomInterestRespondTile(
                        buildContext: buildContext,
                        controller: controller,
                        respondBtnNotifier: respondBtnNotifier,
                      )

                    ///Bottom button row with all options
                    : _BottomTileIcons(
                        buildContext: buildContext,
                        controller: controller,
                        navFrom: navFrom,
                      ));
          }),
    );
  }
}

class _BottomTileIcons extends StatelessWidget {
  final BuildContext? buildContext;
  final ScrollController controller;
  final NavFrom? navFrom;
  _BottomTileIcons(
      {Key? key, this.buildContext, required this.controller, this.navFrom})
      : super(key: key);

  ValueNotifier<int> selectedIndex = ValueNotifier(-1);
  @override
  Widget build(BuildContext context) {
    final EdgeInsets edgeInsets =
        EdgeInsets.only(left: 11.w, right: 11.w, bottom: 18.h, top: 16.h);
    return Row(
      children: List.generate(
        Constants.partnerCardBtnSelected.length,
        (index) => Expanded(
          child: InkWell(
            onTap: () {
              BuildContext cxt = buildContext ?? context;
              selectedIndex.value = index;
              Future.delayed(const Duration(milliseconds: 300)).then((value) {
                switch (index) {
                  case 0:
                    PartnerDetailBtnHandler.instance.fetchPhotos(cxt);
                    break;
                  case 1:
                    if (AppConfig.isAuthorized) {
                      CommonFunctions.scrollToTop(controller);
                      CommonFunctions.addDelay(() {
                        if (navFrom != null &&
                            navFrom == NavFrom.navFromShortList) {
                          PartnerDetailBtnHandler.instance
                              .removeFromShortListAction(cxt);
                        } else {
                          PartnerDetailBtnHandler.instance
                              .skipProfileAction(cxt);
                        }
                      });
                      break;
                    } else {
                      context.read<AuthProvider>().updateNavFrom(
                          RouteGenerator.routePartnerSingleProfileDetail);
                      Navigator.pushNamed(context, RouteGenerator.routeLogin);
                      break;
                    }
                  case 2:
                    if (AppConfig.isAuthorized) {
                      CommonFunctions.scrollToTop(controller);
                      CommonFunctions.addDelay(() {
                        PartnerDetailBtnHandler.instance
                            .shortListProfileAction(cxt);
                      });
                      break;
                    } else {
                      context.read<AuthProvider>().updateNavFrom(
                          RouteGenerator.routePartnerSingleProfileDetail);
                      Navigator.pushNamed(context, RouteGenerator.routeLogin);
                      break;
                    }
                  case 3:
                    if (AppConfig.isAuthorized) {
                      PartnerDetailBtnHandler.instance
                          .sendInterestAction(cxt, controller: controller);
                      break;
                    } else {
                      context.read<AuthProvider>().updateNavFrom(
                          RouteGenerator.routePartnerSingleProfileDetail);
                      Navigator.pushNamed(context, RouteGenerator.routeLogin);
                      break;
                    }
                  case 4:
                    if (AppConfig.isAuthorized) {
                      PartnerDetailBtnHandler.instance.addressBottomSheet(cxt);
                      break;
                    } else {
                      context.read<AuthProvider>().updateNavFrom(
                          RouteGenerator.routePartnerSingleProfileDetail);
                      Navigator.pushNamed(context, RouteGenerator.routeLogin);
                      break;
                    }
                }
                selectedIndex.value = -1;
              });
            },
            child: Padding(
              padding: edgeInsets,
              child: LayoutBuilder(builder: (cxt, constraints) {
                return ValueListenableBuilder<int>(
                    valueListenable: selectedIndex,
                    builder: (cxt, value, _) {
                      return AnimatedCrossFade(
                          firstChild: SvgPicture.asset(
                            Constants.partnerCardBtnSelected[index],
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                          ),
                          secondChild: Container(
                            decoration: index == 1 || index == 3
                                ? null
                                : BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: HexColor('#DBE2EA'),
                                    )),
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                            child: SvgPicture.asset(
                              Constants.partnerCardBtn[index],
                              height: double.maxFinite,
                              width: double.maxFinite,
                            ),
                          ),
                          firstCurve: Curves.bounceInOut,
                          secondCurve: Curves.bounceInOut,
                          crossFadeState: value == index
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300));
                    });
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomInterestRespondTile extends StatefulWidget {
  final BuildContext? buildContext;
  final ScrollController controller;
  final ValueNotifier<bool> respondBtnNotifier;
  const _BottomInterestRespondTile(
      {Key? key,
      this.buildContext,
      required this.controller,
      required this.respondBtnNotifier})
      : super(key: key);

  @override
  State<_BottomInterestRespondTile> createState() =>
      _BottomInterestRespondTileState();
}

class _BottomInterestRespondTileState
    extends State<_BottomInterestRespondTile> {
  ValueNotifier<int> hovered = ValueNotifier(-1);

  List<String> partnerCardBtn = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedStar,
    Assets.iconsRoundedHeart,
    Assets.iconsRoundedCallYellow,
  ];

  List<String> partnerCardBtnSelected = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedStarSelected,
    Assets.iconsRoundedHeartSelected,
    Assets.iconsRoundedCallYellow,
  ];

  Widget _iconBtn(
      {bool asSelected = false,
      required double width,
      required int index,
      bool enableBorder = true,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        if (!asSelected) {
          hovered.value = index;
          Future.delayed(const Duration(milliseconds: 300)).then((value) {
            if (onTap != null) onTap();
            hovered.value = -1;
          });
        }
      },
      child: SizedBox(
        width: width,
        height: double.maxFinite,
        child: Padding(
          padding:
              EdgeInsets.only(left: 11.w, right: 11.w, bottom: 20.h, top: 16.h),
          child: ValueListenableBuilder<int>(
              valueListenable: hovered,
              builder: (cxt, value, _) {
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            !enableBorder ? Colors.white : HexColor('#DBE2EA'),
                      )),
                  child: value == index || asSelected
                      ? SvgPicture.asset(
                          partnerCardBtnSelected[index],
                          height: double.maxFinite,
                          width: double.maxFinite,
                        )
                      : SvgPicture.asset(
                          partnerCardBtn[index],
                          height: double.maxFinite,
                          width: double.maxFinite,
                        ),
                );
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: widget.respondBtnNotifier,
        builder: (context, value, _) {
          return LayoutBuilder(builder: (cxt, constraints) {
            double width = constraints.maxWidth / 5;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: value
                  ? [
                      _iconBtn(
                          width: width,
                          onTap: () => PartnerDetailBtnHandler.instance
                              .fetchPhotos(widget.buildContext ?? context),
                          // PartnerDetailBtnHandler.instance
                          //     .launchWtspAction(widget.buildContext ?? context),
                          index: 0,
                          asSelected: true),
                      _iconBtn(
                        index: 3,
                        width: width,
                        onTap: () => PartnerDetailBtnHandler.instance
                            .addressBottomSheet(widget.buildContext ?? context),
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          PartnerDetailBottomSheets.showInterestRespondSheet(
                            context,
                            isDismissible: false,
                            onButtonTap: (val) {
                              if (val ?? false) {
                                widget.respondBtnNotifier.value = false;
                              } else {
                                widget.respondBtnNotifier.value = true;
                              }
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 11.w, right: 11.w, bottom: 20.h, top: 16.h),
                          height: double.maxFinite,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28.r),
                                border: Border.all(
                                    color: HexColor('#DBE2EA'), width: 2.r)),
                            child: Text(
                              context.loc.respond,
                              textAlign: TextAlign.center,
                              style: FontPalette.black15SemiBold,
                            ),
                          ),
                        ),
                      ))
                    ]
                  : List.generate(
                      4,
                      (index) => _iconBtn(
                            index: index,
                            width: width,
                            enableBorder: index != 2,
                            asSelected: index == 2,
                            onTap: () {
                              if (AppConfig.isAuthorized) {
                                switch (index) {
                                  case 0:
                                    PartnerDetailBtnHandler.instance
                                        .fetchPhotos(
                                            widget.buildContext ?? context);
                                    // artnerDetailBtnHandler.instance
                                    //     .launchWtspAction(
                                    //         widget.buildContext ?? context);
                                    break;
                                  case 1:
                                    CommonFunctions.scrollToTop(
                                        widget.controller);
                                    CommonFunctions.addDelay(() {
                                      PartnerDetailBtnHandler.instance
                                          .shortListProfileAction(
                                              widget.buildContext ?? context);
                                    });
                                    break;
                                  case 3:
                                    PartnerDetailBtnHandler.instance
                                        .addressBottomSheet(
                                            widget.buildContext ?? context);
                                    break;
                                }
                              } else {
                                context.read<AuthProvider>().updateNavFrom(
                                    RouteGenerator
                                        .routePartnerSingleProfileDetail);
                                Navigator.pushNamed(
                                    context, RouteGenerator.routeLogin);
                              }
                            },
                          )),
            );
          });
        });
  }
}
