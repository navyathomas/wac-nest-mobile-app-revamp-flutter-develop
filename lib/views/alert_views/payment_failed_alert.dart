import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

import '../../generated/assets.dart';

class PaymentFailedAlert extends AlertDialog {
  const PaymentFailedAlert({super.key, this.onTap, required this.onCancel,this.showTryAgain=true});
  final void Function()? onTap;
  final void Function() onCancel;
  final bool showTryAgain;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: ContentView(
        tryAgain:showTryAgain,
        onTap: onTap,
        onCancel: onCancel,
      ),
    );
  }
}

class ContentView extends StatefulWidget {
  const ContentView({Key? key, this.onTap, this.onCancel,this.tryAgain=true}) : super(key: key);
  final void Function()? onTap;
  final void Function()? onCancel;
  final bool tryAgain;
  @override
  State<ContentView> createState() => ContentViewState();
}

class ContentViewState extends State<ContentView> {
  late final ValueNotifier<double> _scaleValue;
  @override
  void initState() {
    _scaleValue = ValueNotifier(0.4);
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      _scaleValue.value = 1.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 284.h,
      width: double.maxFinite,
      child: Column(
        children: [
          27.verticalSpace,
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.onCancel,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: SvgPicture.asset(
                    Assets.iconsCloseGrey,
                    height: 13.42.h,
                    width: 13.42.w,
                  ),
                ),
              ).removeSplash()),
          ValueListenableBuilder<double>(
              valueListenable: _scaleValue,
              builder: (context, value, child) {
                child = SvgPicture.asset(
                  Assets.iconsPaymentFailed,
                  height: 70.h,
                  width: 75.w,
                );
                return AnimatedScale(
                  scale: value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: child,
                );
              }),
          15.verticalSpace,
          Text(
            context.loc.paymentFailed,
            style: FontPalette.black18Bold,
          ),
          6.verticalSpace,
          Text(
            context.loc.somethingWentWrongPayment,
            textAlign: TextAlign.center,
            style:
                FontPalette.black14Medium.copyWith(color: HexColor('#525B67')),
            strutStyle: StrutStyle(height: 1.5.h),
          ),
          41.verticalSpace,
          if(widget.tryAgain)
          InkWell(
              onTap: widget.onTap,
              child: Text(
                context.loc.tryAgain,
                style: FontPalette.primary16Bold,
              )).removeSplash()
        ],
      ),
    );
  }
}
