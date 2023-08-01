import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/widget_handler/partner_detail_btn_handler.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_sheets.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/basic_detail_model.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/mail_box_provider.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../providers/profile_handler_provider.dart';
import '../../../services/helpers.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/data_collection_alert.dart';
import 'partner_detail_card_button.dart';

class PartnerDetailCardBottomIcons extends StatelessWidget {
  final BuildContext? buildContext;
  final NavFrom? navFrom;
  const PartnerDetailCardBottomIcons(
      {Key? key, this.buildContext, this.navFrom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            Constants.partnerCardBtn.length,
            (index) => PartnerDetailCardButton(
                  icon: Constants.partnerCardBtn[index],
                  selectedIcon: Constants.partnerCardBtnSelected[index],
                  onTap: () {
                    BuildContext cxt = buildContext ?? context;
                    switch (index) {
                      case 0:
                        PartnerDetailBtnHandler.instance.fetchPhotos(cxt);
                        break;
                      case 1:
                        if (AppConfig.isAuthorized) {
                          if (navFrom != null &&
                              navFrom == NavFrom.navFromShortList) {
                            PartnerDetailBtnHandler.instance
                                .removeFromShortListAction(context);
                          } else {
                            PartnerDetailBtnHandler.instance
                                .skipProfileAction(cxt);
                          }
                          break;
                        } else {
                          context.read<AuthProvider>().updateNavFrom(
                              RouteGenerator.routePartnerSingleProfileDetail);
                          Navigator.pushNamed(
                              context, RouteGenerator.routeLogin);
                          break;
                        }
                      case 2:
                        if (AppConfig.isAuthorized) {
                          PartnerDetailBtnHandler.instance
                              .shortListProfileAction(cxt);
                          break;
                        } else {
                          context.read<AuthProvider>().updateNavFrom(
                              RouteGenerator.routePartnerSingleProfileDetail);
                          Navigator.pushNamed(
                              context, RouteGenerator.routeLogin);
                          break;
                        }
                      case 3:
                        if (AppConfig.isAuthorized) {
                          PartnerDetailBtnHandler.instance
                              .sendInterestAction(cxt);
                          break;
                        } else {
                          context.read<AuthProvider>().updateNavFrom(
                              RouteGenerator.routePartnerSingleProfileDetail);
                          Navigator.pushNamed(
                              context, RouteGenerator.routeLogin);
                          break;
                        }
                      case 4:
                        if (AppConfig.isAuthorized) {
                          PartnerDetailBtnHandler.instance
                              .addressBottomSheet(cxt);
                          break;
                        } else {
                          context.read<AuthProvider>().updateNavFrom(
                              RouteGenerator.routePartnerSingleProfileDetail);
                          Navigator.pushNamed(
                              context, RouteGenerator.routeLogin);
                          break;
                        }
                    }
                  },
                )),
      ),
    );
  }
}
