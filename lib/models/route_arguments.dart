import 'package:nest_matrimony/models/profile_model.dart';
import '../common/constants.dart';

class RouteArguments {
  String? title;
  String? id;
  int index;
  int? profileId;
  bool enableFullScreen;
  dynamic anyValue;
  NavFrom? navFrom;
  bool defaultTransition;
  Errors errorType;
  String? descriptions;
  String? anyText;
  bool isUpgradePlan;
  int? planId;
  int? planAmount;
  int? tabIndex;
  bool? isFromNotificationScreen;
  double? latitude;
  double? longitude;
  String? apartmentSelected;
  BasicDetails? basicDetails;
  bool isFromMangePhotos;
  bool showUpgradePlan;
  String? productId;
  String? inAppTitle;
  RouteArguments(
      {this.title,
      this.anyValue,
      this.index = 0,
      this.profileId,
      this.navFrom,
      this.descriptions,
      this.anyText,
      this.defaultTransition = false,
      this.enableFullScreen = false,
      this.errorType = Errors.searchResultError,
      this.isUpgradePlan = false,
      this.planId,
      this.planAmount,
      this.tabIndex,
      this.isFromNotificationScreen,
      this.latitude,
      this.longitude,
      this.apartmentSelected,
      this.isFromMangePhotos = false,
      this.basicDetails,
      this.showUpgradePlan = true,
      this.productId,
      this.inAppTitle});
}
