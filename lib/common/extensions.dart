import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../generated/assets.dart';
import '../providers/app_data_provider.dart';
import '../utils/color_palette.dart';

extension FlavourTypeExtension on String {
  String getBaseUrl() {
    switch (this) {
      case 'dev':
        return 'http://nest-app.webc.in/api/v2/';
      case 'stage':
        return 'https://api.nestmatrimony.com/api/v2/';
      case 'prod':
        return 'https://api.nestmatrimony.com/api/v2/';
      default:
        return 'https://api.nestmatrimony.com/api/v2/';
    }
  }

  String getPublishableKEY() {
    switch (this) {
      case 'dev':
        return '';
      case 'stage':
        return '';
      case 'prod':
        return '';
      default:
        return '';
    }
  }

  String getSecretKEY() {
    switch (this) {
      case 'dev':
        return '';
      case 'stage':
        return '';
      case 'prod':
        return '';
      default:
        return '';
    }
  }

  String getFlavourName() {
    switch (this) {
      case 'dev':
        return 'Development';
      case 'stage':
        return 'Staging';
      case 'prod':
        return 'Production';
      default:
        return 'Production';
    }
  }

  String capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  void showToast() => Fluttertoast.showToast(
      msg: this,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

extension CheckNull on dynamic {
  bool get isNull => this == null ? true : false;
}

extension StringExtension on String? {
  String thumbImagePath(BuildContext context) =>
      '${context.read<AppDataProvider>().urlData?.thumbImage ?? ''}$this';

  String fullImagePath(BuildContext context) =>
      '${context.read<AppDataProvider>().urlData?.fullImage ?? ''}$this';

  String idProofImagePath(BuildContext context) =>
      '${context.read<AppDataProvider>().urlData?.idProofThumbImage ?? ''}$this';

  String houseImagePath(BuildContext context) =>
      '${context.read<AppDataProvider>().urlData?.houseThumbImage ?? ''}$this';

  String horoscopeImagePath(BuildContext context) {
    return '${context.read<AppDataProvider>().urlData?.horoscopeImage ?? ''}$this';
  }

  String testimonialsImagePath(BuildContext context) {
    return '${context.read<AppDataProvider>().urlData?.successStories}$this';
  }

  Widget get genderPlaceHolder => SvgPicture.asset(
        (this ?? '').toLowerCase() == 'male'
            ? Assets.iconsMalePlaceHolder
            : Assets.iconsFemalePlaceHolder,
        height: double.maxFinite,
        width: double.maxFinite,
        fit: BoxFit.cover,
      );
}

extension BoolExtension on bool? {
  Widget get genderPlaceHolder => this == null
      ? Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: ColorPalette.shimmerColor,
        )
      : SvgPicture.asset(
          this! ? Assets.iconsMalePlaceHolder : Assets.iconsFemalePlaceHolder,
          height: double.maxFinite,
          width: double.maxFinite,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        );
}

extension LoaderExtension on LoaderState {
  bool get isLoading => this == LoaderState.loading;
}

extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  void get rootPop => Navigator.of(this, rootNavigator: true).pop();

  Future get circularLoaderPopUp => showGeneralDialog(
        context: this,
        barrierColor: Colors.white.withOpacity(0.4),
        barrierDismissible: false,
        barrierLabel: "",
        useRootNavigator: true,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) {
          return WillPopScope(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 4.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorPalette.primaryColor),
                  )
                ],
              ),
            ),
            onWillPop: () async {
              Navigator.pop(this);
              return false;
            },
          );
        },
      );

  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension DoubleExtension on double? {
  String get roundTo2 {
    double val = this ?? 0.0;
    return val.toStringAsFixed(2);
  }

  SliverPadding get sliverSpace =>
      SliverPadding(padding: EdgeInsets.only(top: (this ?? 0).h));
}

extension WidgetExtension on Widget {
  Widget animatedSwitch(
      {Curve? curvesIn, Curve? curvesOut, int duration = 500}) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      switchInCurve: curvesIn ?? Curves.linear,
      switchOutCurve: curvesOut ?? Curves.linear,
      child: this,
    );
  }

  Flexible get flexWrap {
    if (this is Text) {
      return Flexible(child: (this as Text).avoidOverFlow());
    } else {
      return Flexible(child: this);
    }
  }

  static Container verticalDivider(
      {Color? color, double height = 0.0, double? width, EdgeInsets? margin}) {
    return Container(
      color: color ?? ColorPalette.pageBgColor,
      height: height.h,
      width: width ?? double.maxFinite,
      margin: margin,
    );
  }

  static Container horizontalDivider(
      {Color color = Colors.white,
      double height = 1.0,
      double width = double.maxFinite,
      EdgeInsets? margin}) {
    return Container(
      color: color,
      height: height.h,
      width: width.w,
      margin: margin,
    );
  }

  static Widget crossSwitch(
      {required Widget first,
      Widget second = const SizedBox.shrink(),
      required bool value,
      Curve curvesIn = Curves.linear,
      Curve curvesOut = Curves.linear}) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      crossFadeState:
          value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstCurve: curvesIn,
      secondCurve: curvesOut,
    );
  }

  Widget get addShimmer => Shimmer.fromColors(
        baseColor: ColorPalette.shimmerColor,
        highlightColor: Colors.white54,
        child: this,
      );
}

extension InkWellExtension on InkWell {
  InkWell removeSplash({Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      splashColor: color,
      highlightColor: color,
      child: child,
    );
  }

  Material applyRipple(
      {Color color = Colors.black12, double radius = 9, Color? btnColor}) {
    return Material(
      color: btnColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
      child: InkWell(
        onTap: onTap,
        splashColor: color,
        hoverColor: color,
        highlightColor: color,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.r),
        ),
        child: child,
      ),
    );
  }
}

extension BorderExtension on ShapeDecoration {
  static BoxDecoration underLineBorder({Color? colors, double? w}) {
    return BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: colors ?? Colors.black, width: w ?? 1.5.h)));
  }
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text addEllipsis({int maxLine = 1}) {
    return Text(
      (data ?? '').trim(),
      style: style,
      strutStyle: strutStyle,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension Log on Object {
  void log(String s, {String name = ''}) =>
      devtools.log(toString(), name: name);
}
