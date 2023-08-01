import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../views/alert_views/data_collection_alert.dart';
import '../../widgets/common_alert_view.dart';

class DataCollectionAlertHandler {
  static DataCollectionAlertHandler? _instance;

  static DataCollectionAlertHandler get instance {
    _instance ??= DataCollectionAlertHandler();
    return _instance!;
  }

  void openAddressAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addAddressDetails),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }

  void openBasicDetailAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addBasicDetails),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }

  void openAddPhotoAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addPhotos),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }

  void openAddPrfDetailsAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addProfessionalInfo),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }

  void openAddPartnerPreferenceAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addPartnerPreference),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }

  void openAddEduDetailsAlert(BuildContext context) {
    CommonAlertDialog.showDialogPopUp(
        context,
        const DataCollectionAlert(
            dataCollectionTypes: DataCollectionTypes.addEducation),
        routeName: Constants.dataCollectionAlert,
        barrierDismissible: false);
  }
}
