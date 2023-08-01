import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class AwaitAlertDialog extends AlertDialog {
  AwaitAlertDialog({Key? key, required this.count}) : super(key: key);
  int count;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(8.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(count: count),
    );
  }
}

class _ContentView extends StatefulWidget {
  _ContentView({Key? key, required this.count}) : super(key: key);
  int count;
  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  late final ValueNotifier<double> _scaleValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275.h,
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                5.verticalSpace,
                ValueListenableBuilder<double>(
                    valueListenable: _scaleValue,
                    builder: (context, value, child) {
                      child = SvgPicture.asset(
                        Assets.iconsInterestedHeart,
                        height: 56.h,
                        width: 49.w,
                      );
                      return AnimatedScale(
                        scale: value,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: child,
                      );
                    }),
                12.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    context.loc.membersAwaitUrResponse(widget.count),
                    textAlign: TextAlign.center,
                    style: FontPalette.black18Bold,
                  ),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    context.loc.theWaitIsOverRespondNow,
                    strutStyle: StrutStyle(height: 1.5.h),
                    textAlign: TextAlign.center,
                    style: FontPalette.f131A24_14Medium,
                  ),
                )
              ],
            ),
          ),
          WidgetExtension.horizontalDivider(
              color: HexColor('#E5EEF8'), height: 1.5.h),
          SizedBox(
            width: double.maxFinite,
            child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 19.h),
                  child: Text(
                    context.loc.ok,
                    textAlign: TextAlign.center,
                    style: FontPalette.primary16Bold,
                  ),
                )).removeSplash(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _scaleValue = ValueNotifier(0.4);
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _scaleValue.value = 1.0;
    });
    super.initState();
  }
}

// void showAwaitInterestDialog(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     pageBuilder: (ctx, a1, a2) {
//       return Container();
//     },
//     transitionBuilder: (ctx, a1, a2, child) {
//       var curve = Curves.easeInOut.transform(a1.value);
//       return Transform.scale(
//         scale: curve,
//         child:  AwaitAlertDialog(),
//       );
//     },
//     transitionDuration: const Duration(milliseconds: 300),
//   );
// }
