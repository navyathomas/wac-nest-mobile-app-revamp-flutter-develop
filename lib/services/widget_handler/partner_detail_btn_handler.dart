import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/services/widget_handler/data_collection_alert_handler.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_sheets.dart';
import 'package:provider/provider.dart';

import '../../common/common_functions.dart';
import '../../common/constants.dart';
import '../../models/profile_view_model.dart';
import '../../providers/mail_box_provider.dart';
import '../../providers/partner_detail_provider.dart';
import '../../providers/profile_handler_provider.dart';
import '../helpers.dart';

class PartnerDetailBtnHandler {
  static PartnerDetailBtnHandler? _instance;

  static PartnerDetailBtnHandler get instance {
    _instance ??= PartnerDetailBtnHandler();
    return _instance!;
  }

  void shortListProfileAction(BuildContext context) {
    context.read<PartnerDetailProvider>().checkPartnerDetailUpdated(context);
  }

  void skipProfileAction(BuildContext context) {
    context.read<PartnerDetailProvider>().skipAction(context);
  }

  void sendInterestAction(BuildContext context,
      {ScrollController? controller}) {
    bool res = context
        .read<PartnerDetailProvider>()
        .checkProfessionalDetailUpdated(context);
    if (res) {
      Navigator.popUntil(context, (route) {
        if (route.settings.name != Constants.sendInterestAlert) {
          PartnerDetailBottomSheets.showInterestedSheet(context,
              routeName: Constants.sendInterestAlert, onTap: () {
            final model = context.read<ProfileHandlerProvider>();
            if (model.selectedInterestId == -1) {
              Helpers.successToast(context.loc.pleaseChooseAnOption);
            } else {
              context.read<PartnerDetailProvider>().interestRequest(context,
                  onSuccess: () {
                Navigator.pop(context);
                if (controller != null) {
                  CommonFunctions.scrollToTop(controller);
                  CommonFunctions.addDelay(() {
                    context
                        .read<PartnerDetailProvider>()
                        .interestedAction(context);
                  });
                } else {
                  CommonFunctions.addDelay(() {
                    context
                        .read<PartnerDetailProvider>()
                        .interestedAction(context);
                  });
                }
              }, onFailure: () {
                Navigator.pop(context);
              });
            }
          });
        }
        return true;
      });
    } else {
      DataCollectionAlertHandler.instance.openAddPrfDetailsAlert(context);
    }
  }

  void addressBottomSheet(BuildContext context) {
    bool res = context
        .read<PartnerDetailProvider>()
        .checkAddressDetailUpdated(context);
    if (res) {
      Navigator.popUntil(context, (route) {
        if (route.settings.name != Constants.contactDetailAlert) {
          PartnerDetailBottomSheets.showContactDetailAlert(context);
        }
        return true;
      });
    } else {
      DataCollectionAlertHandler.instance.openAddressAlert(context);
    }
  }

  void removeFromShortListAction(BuildContext context) {
    context.read<ProfileHandlerProvider>().removerFromShortList(context,
        onSuccess: (val) {
      if (val ?? false) {
        context.read<MailBoxProvider>().getShortList(context,
            enableLoader: true,
            page: 1,
            length: 10,
            shortListedBy: ShortListedBy.shortListedByMe);
        Navigator.pop(context);
      }
    });
  }

  void launchWtspAction(BuildContext context) {
    context.read<PartnerDetailProvider>().launchWhatsapp();
  }

  void fetchPhotos(BuildContext context) async {
    Future.microtask(() {
      final List<UserImage> imageList = context
              .read<PartnerDetailProvider>()
              .partnerDetailModel
              ?.data
              ?.basicDetails
              ?.userImage ??
          [];

      Navigator.popUntil(context, (route) {
        if (route.settings.name != Constants.fullImageScreen) {
          if (imageList.isNotEmpty) {
            Navigator.pushNamed(context, RouteGenerator.routeFullScreenImage,
                arguments: imageList
                    .map((e) => (e.imageFile ?? '').toString())
                    .toList());
          }
        }
        return true;
      });
    });
  }
}
