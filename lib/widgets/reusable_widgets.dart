import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../common/route_generator.dart';
import '../models/notification_model.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

class ReusableWidgets {
  static void showInAppMsg(PushNotification notification) {
    showSimpleNotification(
      Text(notification.title ?? ""),
      subtitle: Text(notification.body ?? ''),
      background: Colors.cyan.shade700,
      duration: const Duration(seconds: 2),
    );
  }

  static void customBottomSheet(
      {required BuildContext context,
      required Widget? child,
      String? routeName}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      routeSettings: routeName == null ? null : RouteSettings(name: routeName),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(28.r), topLeft: Radius.circular(28.r))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.h,
            width: 50.w,
            margin: EdgeInsets.symmetric(vertical: 9.h),
            decoration: BoxDecoration(
                color: HexColor('#C1C9D2'),
                borderRadius: BorderRadius.circular(100.r)),
          ),
          child ?? const SizedBox.shrink()
        ],
      ),
    );
  }

  static void customMaterialBottomSheet(
      {required BuildContext context,
      required Widget? child,
      final String? name,
      required bool isDismissible}) {
    showMaterialModalBottomSheet(
      context: context,
      settings: name != null ? RouteSettings(name: name) : null,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(28.r), topLeft: Radius.circular(28.r))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.h,
            width: 50.w,
            margin: EdgeInsets.symmetric(vertical: 9.h),
            decoration: BoxDecoration(
                color: HexColor('#C1C9D2'),
                borderRadius: BorderRadius.circular(100.r)),
          ),
          child ?? const SizedBox.shrink()
        ],
      ),
    );
  }

  static Widget roundedBackButton(BuildContext context,
      {void Function()? onBackPressed}) {
    return IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: Container(
            margin: EdgeInsets.only(left: 5.w),
            height: 33.h,
            width: 33.w,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.5, 2),
                      blurRadius: 3.0),
                ],
                shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                Assets.iconsChevronLeft,
                fit: BoxFit.cover,
              ),
            )));
  }

  static Widget paginationLoader({bool isAsync = false}) {
    return (isAsync
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: const CircularProgressIndicator(),
                ),
              )
            : const SizedBox.shrink())
        .animatedSwitch();
  }

  static Widget roundedCloseBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 33.r,
        width: 33.r,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.5, 2),
                  blurRadius: 3.0),
            ]),
        child: SvgPicture.asset(
          Assets.iconsClose,
        ),
      ),
    );
  }

  static void singleSelectBottomSheet(
      {required BuildContext context,
      double? sheetHeight,
      required String title,
      required Widget? child}) {
    return customBottomSheet(
        context: context,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                title,
                style: FontPalette.white16Bold
                    .copyWith(color: HexColor('#131A24')),
              ),
            ),
            child ?? const SizedBox.shrink()
          ],
        ));
  }

//horizontalLine
  static Widget horizontalLine(
      {double? density,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding}) {
    return Container(
      height: density ?? 2.h,
      width: double.maxFinite,
      margin: margin,
      padding: padding,
      color: ColorPalette.pageBgColor,
    );
  }

  static Widget listGenerator(
      {var list, double? listHeight, Function(int)? onClick}) {
    return SizedBox(
      height: listHeight,
      width: double.maxFinite,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, int index) {
            return titleTile(
                title: list[index],
                onTap: () {
                  if (onClick != null) onClick(index);
                });
          }),
    );
  }

//titleTile
  static Widget titleTile({String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 70.h,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title ?? "title",
              style: FontPalette.black16SemiBold
                  .copyWith(color: HexColor("#132031")),
            ),
            SvgPicture.asset(Assets.iconsForwardPoint)
          ],
        ),
      ),
    ).removeSplash();
  }

//commonbutton white
  static Widget commonWhiteButton(
      {String? text,
      Color? buttonColor,
      void Function()? onTap,
      double? width,
      double? height,
      Color? textColor}) {
    return InkWell(
      borderRadius: BorderRadius.circular(9.r),
      // splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: onTap ?? () {},
      child: Container(
        height: height ?? 52.h,
        width: width ?? double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(width: 1.sp, color: HexColor("#DBE2EA"))),
        child: Text(
          text ?? "button_text",
          style: FontPalette.black16SemiBold
              .copyWith(color: textColor ?? Colors.black),
        ).avoidOverFlow(),
      ),
    );
  }

//COMMON ADD ICON BUTTON
  static Widget commonAddIconButton({
    String? title,
    String? iconPath,
    VoidCallback? onTap,
    bool makeRoundedButton = false,
    bool centerTitle = true,
    double? horizontalPadding,
    double? height,
    double? width,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // color:  Colors.red,
          width: width ?? double.maxFinite,
          height: height,
          decoration: makeRoundedButton
              ? BoxDecoration(
                  color: color ?? Colors.white,
                  border: Border.all(width: 1.w, color: HexColor("#2995E5")),
                  borderRadius: BorderRadius.circular(21.r))
              : null,
          child: Row(
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(iconPath ?? Assets.iconsSmallBlueAdd),
              4.horizontalSpace,
              Text(title ?? "Add horoscope",
                  style: FontPalette.black16ExtraBold
                      .copyWith(fontSize: 13.sp, color: HexColor("#2995E5"))),
            ],
          ),
        ),
      ),
    );
  }

  static Widget titleText({String? titleText}) {
    return Text(titleText ?? 'titleText',
            style: FontPalette.black16SemiBold
                .copyWith(color: HexColor("#8695A7")))
        .avoidOverFlow();
  }

  //TITLE HEADS
  static Widget titleHeads({String? titleHead, VoidCallback? onEditTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleHead ?? 'titleHead',
            style: FontPalette.black16SemiBold
                .copyWith(color: HexColor("#131A24")),
          ),
          InkWell(
            onTap: onEditTap,
            child: SizedBox(
                height: 32.h,
                width: 62.w,
                child: SvgPicture.asset(Assets.iconsEditIconButton)),
          )
        ],
      ),
    );
  }

//KEY VALUE
  static Widget keyValueText(
      {String? leadingText,
      String? trailingText,
      String? firstHalf,
      String? secondHalf,
      VoidCallback? onTap}) {
    if (trailingText != null) {
      if (trailingText.length > 100) {
        firstHalf = trailingText.substring(0, 100);
        secondHalf = trailingText.substring(100, trailingText.length);
      } else {
        firstHalf = trailingText;
        secondHalf = "";
      }
    }
    ValueNotifier<bool> viewMore = ValueNotifier(false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Text(
              leadingText ?? 'leadingText',
              maxLines: 3,
              style: FontPalette.black14Medium
                  .copyWith(color: HexColor("#565F6C")),
              textAlign: TextAlign.left,
            ),
          ),
          15.horizontalSpace,
          trailingText != null && trailingText != ""
              ? Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<bool>(
                          valueListenable: viewMore,
                          builder: (context, value, _) {
                            return Text(
                              !value
                                  ? ("$firstHalf")
                                  : (firstHalf! + secondHalf!),
                              textAlign: TextAlign.left,
                              style: FontPalette.black14Medium
                                  .copyWith(color: HexColor("#131A24")),
                            );
                          }),
                      secondHalf!.isNotEmpty
                          ? InkWell(
                              onTap: () => viewMore.value = !viewMore.value,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: viewMore,
                                    builder: (context, value, _) {
                                      return (value
                                              ? Text(
                                                  context.loc.viewLess,
                                                  style: FontPalette.black14Bold
                                                      .copyWith(
                                                          color: HexColor(
                                                              '#2995E5')),
                                                )
                                              : Text(context.loc.viewMore,
                                                  style: FontPalette.black14Bold
                                                      .copyWith(
                                                          color: HexColor(
                                                              '#2995E5'))))
                                          .animatedSwitch();
                                    }),
                              ))
                          : const SizedBox()
                    ],
                  ),
                )
              : Flexible(
                  fit: FlexFit.tight,
                  flex: 6,
                  child: ReusableWidgets.commonAddIconButton(
                      title: "Add details", centerTitle: false, onTap: onTap))
        ],
      ),
    );
  }

  static void customCircularLoader(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierDismissible: false,
      barrierLabel: "",
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return WillPopScope(
          child: SizedBox.expand(
            // makes widget fullscreen
            child: circularIndicator(),
          ),
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
        );
      },
    );
  }

  static Widget circularProgressIndicator() => SizedBox.expand(
        child: circularIndicator(),
      );

  static Widget circularIndicator() => Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
            ),
          ),
        ),
      );

  static Widget sliverPaginationLoader(bool async) {
    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: const Duration(microseconds: 300),
        child: async
            ? SizedBox(
                height: 70.h,
                child: circularIndicator(),
              )
            : const SizedBox(),
      ),
    );
  }

// show alert message
  static Future<void> showTerms(
    BuildContext context, {
    String? title,
    void Function()? onPressed,
    bool normalUpdate = false,
    String? dialog,
    String? titleHead,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.r))),
          title: Text(
            titleHead ?? "Terms Of Use",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10.h),
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      title ?? "നെസ്റ്റ് മാട്രിമോണിയിലേക്ക് സ്വാഗതം",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(dialog ??
                        "വിവാഹന്വേഷണത്തിനായി നെസ്റ്റ് മാട്രിമോണിയിൽ നൽകിയിരിക്കുന്ന ഡാറ്റ പൂർണമായും ശരിയാണ്. നെസ്റ്റ് മാട്രിമോണി വെബ് സൈറ്റ് വഴിയോ, കസ്റ്റമർ കെയർ സർവീസിലൂടെയോ വിവാഹം ശരിയാകുമ്പോൾ രജിസ്ട്രേഷൻ താരിഫ് അനുസരിച്ച് ഉള്ള സർവീസ് ചാർജ്ജ് നൽകുന്നതിന് എനിക്ക് സമ്മതമാണ് ."),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Consumer<AuthProvider>(
              builder: (__, data, _) {
                return CommonButton(
                  onPressed: onPressed,
                  title: "Accept",
                  isLoading: data.btnLoader,
                );
              },
            ),
            SizedBox(
              height: 2.h,
            )
          ],
        );
      },
    );
  }
}
