import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_sheets.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/basic_detail_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../services/widget_handler/data_collection_alert_handler.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/data_collection_alert.dart';
import 'partner_detail_card_button.dart';

class PartnerDetailBottomCardIcons extends StatelessWidget {
  final BuildContext? buildContext;
  const PartnerDetailBottomCardIcons({Key? key, this.buildContext})
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
                    final model = context.read<PartnerDetailProvider>();
                    switch (index) {
                      case 0:
                        break;
                      case 1:
                        model.skipAction(cxt);
                        break;
                      case 2:
                        model.checkPartnerDetailUpdated(cxt);
                        break;
                      case 3:
                        model.interestRequest(cxt);
                        break;
                      case 4:
                        bool res = cxt
                            .read<PartnerDetailProvider>()
                            .checkAddressDetailUpdated(cxt);
                        if (res) {
                          Navigator.popUntil(cxt, (route) {
                            if (route.settings.name !=
                                Constants.contactDetailAlert) {
                              PartnerDetailBottomSheets.showContactDetailAlert(
                                  cxt);
                            }
                            return true;
                          });
                        } else {
                          DataCollectionAlertHandler.instance
                              .openAddressAlert(context);
                        }
                        break;
                    }
                  },
                )),
      ),
    );
  }
}
