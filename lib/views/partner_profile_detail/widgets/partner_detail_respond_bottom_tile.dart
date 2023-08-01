import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/widget_handler/partner_detail_btn_handler.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../models/basic_detail_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/data_collection_alert.dart';
import 'partner_detail_bottom_sheets.dart';

class PartnerDetailRespondCardBottomTile extends StatelessWidget {
  final BuildContext? buildContext;
  final ValueNotifier<bool> respondBtnNotifier;
  const PartnerDetailRespondCardBottomTile(
      {Key? key, this.buildContext, required this.respondBtnNotifier})
      : super(key: key);

  static const List<String> partnerCardBtn = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedStar,
    Assets.iconsRoundedHeart,
    Assets.iconsRoundedCallYellow,
    ''
  ];

  static const List<String> partnerCardBtnSelected = [
    Assets.iconsRoundedWhatsapp,
    Assets.iconsRoundedStarSelected,
    Assets.iconsRoundedHeartSelected,
    Assets.iconsRoundedCallYellow,
    ""
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ValueListenableBuilder<bool>(
        valueListenable: respondBtnNotifier,
        builder: (context, value, _) {
          return value
              ? _RespondBtnTile(
                  buildContext: buildContext,
                  onButtonTap: (val) {
                    if (val ?? false) {
                      respondBtnNotifier.value = false;
                    } else {
                      respondBtnNotifier.value = true;
                    }
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      partnerCardBtn.length,
                      (index) => _PartnerDetailRespondCardButton(
                            icon: (index == 2 && !value)
                                ? partnerCardBtnSelected[index]
                                : partnerCardBtn[index],
                            selectedIcon: partnerCardBtnSelected[index],
                            onTap: () {
                              BuildContext cxt = buildContext ?? context;
                              switch (index) {
                                case 0:
                                 PartnerDetailBtnHandler.instance.fetchPhotos(cxt);
                                  // artnerDetailBtnHandler.instance
                                  //     .launchWtspAction(cxt);
                                  break;
                                case 1:
                                  PartnerDetailBtnHandler.instance
                                      .shortListProfileAction(cxt);
                                  break;
                                case 3:
                                  PartnerDetailBtnHandler.instance
                                      .addressBottomSheet(cxt);
                                  break;
                              }
                            },
                          )),
                );
        },
      ),
    );
  }
}

class _RespondBtnTile extends StatelessWidget {
  final Function onButtonTap;
  final BuildContext? buildContext;
  const _RespondBtnTile(
      {Key? key, required this.onButtonTap, this.buildContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cxt, constraints) {
      double width = constraints.maxWidth / 5;
      return Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Row(
          children: [
            InkWell(
              onTap: () =>
                  // artnerDetailBtnHandler.instance.launchWtspAction(context),
                   PartnerDetailBtnHandler.instance.fetchPhotos(cxt),
              child: Container(
                height: width,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: SvgPicture.asset(
                  Assets.iconsRoundedWhatsapp,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                PartnerDetailBtnHandler.instance.addressBottomSheet(context);
              },
              child: Container(
                height: width,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: SvgPicture.asset(
                  Assets.iconsRoundedCallYellow,
                ),
              ),
            ),
            Expanded(
                child: InkWell(
              onTap: () {
                PartnerDetailBottomSheets.showInterestRespondSheet(context,
                    isDismissible: false, onButtonTap: onButtonTap);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                height: width,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28.r),
                      border:
                          Border.all(color: HexColor('#707070'), width: 2.r)),
                  child: Text(
                    context.loc.respond,
                    textAlign: TextAlign.center,
                    style: FontPalette.black15SemiBold
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ))
          ],
        ),
      );
    });
  }
}

class _PartnerDetailRespondCardButton extends StatefulWidget {
  final String icon;
  final String selectedIcon;
  final VoidCallback onTap;
  final bool asSelected;
  final EdgeInsets? padding;
  const _PartnerDetailRespondCardButton(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.asSelected = false,
      this.padding,
      required this.selectedIcon})
      : super(key: key);

  @override
  State<_PartnerDetailRespondCardButton> createState() =>
      _PartnerDetailRespondCardButtonState();
}

class _PartnerDetailRespondCardButtonState
    extends State<_PartnerDetailRespondCardButton> {
  ValueNotifier<bool> hovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return InkWell(
          onTap: () {
            hovered.value = true;
            if (!widget.asSelected) {
              Future.delayed(const Duration(milliseconds: 300)).then((value) {
                widget.onTap();
                hovered.value = false;
              });
            }
          },
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            child: ValueListenableBuilder<bool>(
                valueListenable: hovered,
                builder: (context, value, _) {
                  if (widget.icon.isEmpty) {
                    return SizedBox(
                      height: constraints.maxWidth,
                      width: constraints.maxWidth,
                    );
                  }
                  return AnimatedCrossFade(
                      firstChild: SvgPicture.asset(
                        widget.selectedIcon,
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                      ),
                      secondChild: SvgPicture.asset(
                        widget.icon,
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                      ),
                      firstCurve: Curves.bounceInOut,
                      secondCurve: Curves.bounceInOut,
                      crossFadeState: value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300));
                }),
          ),
        );
      }),
    );
  }
}
