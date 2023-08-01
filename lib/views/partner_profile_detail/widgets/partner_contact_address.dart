import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/widget_handler/data_collection_alert_handler.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../generated/assets.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/data_collection_alert.dart';
import 'partner_category_tile.dart';
import 'partner_detail_bottom_sheets.dart';

class PartnerContactAddress extends StatelessWidget {
  const PartnerContactAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
            selector: (context, provider) => provider.partnerDetailModel,
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PartnerCategoryTile(
                    title: context.loc.contactAddress,
                    icon: Assets.iconsTelephone,
                  ),
                  InkWell(
                    onTap: () {
                      if (AppConfig.isAuthorized) {
                        bool res = context
                            .read<PartnerDetailProvider>()
                            .checkAddressDetailUpdated(context);
                        if (res) {
                          Navigator.popUntil(context, (route) {
                            if (route.settings.name !=
                                Constants.contactDetailAlert) {
                              PartnerDetailBottomSheets.showContactDetailAlert(
                                  context);
                            }
                            return true;
                          });
                        } else {
                          DataCollectionAlertHandler.instance
                              .openAddressAlert(context);
                        }
                      } else {
                        context.read<AuthProvider>().updateNavFrom(
                            RouteGenerator.routePartnerSingleProfileDetail);
                        Navigator.pushNamed(context, RouteGenerator.routeLogin);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((value?.data?.basicDetails?.phoneNo ??
                                value?.data?.basicDetails?.mobile) !=
                            null)
                          Padding(
                            padding: EdgeInsets.only(top: 29.h),
                            child: _IconTile(
                              icon: Assets.iconsOutlineMobileGrey,
                              titles: [
                                if (value?.data?.basicDetails?.phoneNo != null)
                                  value!.data!.basicDetails!.phoneNo!,
                                value?.data?.basicDetails?.mobile ?? ''
                              ],
                              enableNumber: false,
                            ),
                          ),
                        if ((value?.data?.basicDetails?.whatsappNo ?? '')
                            .isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: _IconTile(
                              icon: Assets.iconsWhatsappGrey,
                              titles: [
                                value!.data!.basicDetails!.whatsappNo!,
                              ],
                              enableNumber: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                  (value?.data?.basicDetails?.premiumAccount ?? false) == true
                      ? const SizedBox.shrink()
                      : const _UpgradeToUnlockTile()
                ],
              );
            },
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}

class _UpgradeToUnlockTile extends StatelessWidget {
  const _UpgradeToUnlockTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(AppConfig.isAuthorized){
          Navigator.pushNamed(context, RouteGenerator.routePlanSeeAll);
        }else{
          context.read<AuthProvider>().updateNavFrom(RouteGenerator.routePartnerSingleProfileDetail);
          Navigator.pushNamed(context, RouteGenerator.routeLogin);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 32.h),
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 11.w),
        decoration: BoxDecoration(
            color: ColorPalette.pageBgColor,
            borderRadius: BorderRadius.circular(15.r)),
        child: Row(
          children: [
            3.horizontalSpace,
            SvgPicture.asset(
              Assets.iconsHexagonUnlock,
              height: 39.h,
              width: 34.w,
            ),
            12.horizontalSpace,
            Expanded(
                child: Text(
              context.loc.upgrade2UnlockMoreFeatures,
              style: FontPalette.f131A24_13Bold,
            )),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.loc.upgradeNow,
                  style: FontPalette.f2995E5_13ExtraBold,
                ),
                SvgPicture.asset(
                  Assets.iconsChevronRightBlue,
                  height: 32.r,
                  width: 32.r,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final String icon;
  final bool enableNumber;
  final List<String> titles;

  const _IconTile(
      {Key? key,
      required this.icon,
      required this.enableNumber,
      required this.titles})
      : super(key: key);

  Widget _textWidget({required String text, required bool enableText}) {
    String firstText = text.length >= 5 ? text.substring(0, 5) : '';
    String lastText = text.length >= 5 ? text.substring(5, text.length) : '';
    return RichText(
        text: TextSpan(
            text: firstText,
            style: FontPalette.f131A24_14Medium,
            children: [
          WidgetSpan(
              child: !enableText
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 5),
                      child: Text(
                        lastText,
                        style: FontPalette.f131A24_14Medium,
                      ),
                    )
                  : Text(
                      lastText,
                      style: FontPalette.f131A24_14Medium,
                    ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: 20.r,
          width: 20.r,
        ),
        9.horizontalSpace,
        Expanded(
          child: Wrap(
            runSpacing: 7.h,
            spacing: 7.w,
            children: List.generate(
                titles.length,
                (index) =>
                    _textWidget(text: titles[index], enableText: enableNumber)),
          ),
        )
      ],
    );
  }
}
