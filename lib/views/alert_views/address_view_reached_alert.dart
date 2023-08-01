import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/providers/address_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../generated/assets.dart';

class AddressViewReachedAlert extends AlertDialog {
  final String? msg;
  const AddressViewReachedAlert( {Key? key,this.msg,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(
        msg: msg,
      ),
    );
  }
}

class _ContentView extends StatefulWidget {
  final String? msg;

  const _ContentView({super.key, this.msg});
  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
  late final ValueNotifier<double> _scaleValue;
  bool isFirstContainer = true;
  bool isSecondContainer = false;
  bool isThirdContainer = false;
  final ValueNotifier<int> index = ValueNotifier(-1);

  final List<int> optionValues = [5, 20, 25];

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
    return Container(
      height: 380.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: HexColor('#950053'),
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Column(
        children: [
          Container(
            height: 215.h,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18.r))),
            child: Column(
              children: [
                21.verticalSpace,
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.only(right: 18.w),
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
                        Assets.iconsAddressLimitReached,
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
                15.verticalSpace,
                Text(
                  widget.msg ?? "",
                  // context.loc.limitReached,
                  style: FontPalette.black10Bold
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  strutStyle: StrutStyle(height: 1.5.h),
                ),
                13.verticalSpace,
                Text(
                  context.loc.yourMaximumNumberOfAddressViewHasBeenReached,
                  style: FontPalette.black14Medium
                      .copyWith(fontWeight: FontWeight.w500),
                  strutStyle: StrutStyle(height: 1.5.h),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Text(
            context.loc.wantToExtendYourLimit,
            style: FontPalette.white13SemiBold
                .copyWith(fontWeight: FontWeight.w700),
            strutStyle: StrutStyle(height: 1.5.h),
          ),
          10.verticalSpace,
          ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    optionValues.length,
                    (currentIndex) => InkWell(
                          onTap: () {
                            index.value = currentIndex;
                          },
                          child: ValueListenableBuilder<int>(
                            valueListenable: index,
                            builder: (context, value, child) {
                              return Container(
                                height: 36.h,
                                width: 45.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 5.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: index.value == currentIndex
                                        ? HexColor('#FFFFFF')
                                        : HexColor('#FFFFFF').withOpacity(.22)),
                                child: Text(
                                  '${optionValues[currentIndex]}',
                                  style: index.value == currentIndex
                                      ? FontPalette.black13SemiBold
                                      : FontPalette.white13SemiBold,
                                ),
                              );
                            },
                          ),
                        )),
              );
            },
          ),
          20.verticalSpace,
          buyNowButton()
        ],
      ),
    );
  }

  Widget buyNowButton() {
    return Selector<AddressProvider, bool>(
      selector: (context, provider) => provider.btnLoader,
      builder: (context, value, child) {
        BasicDetailModel? model =
            context.read<AppDataProvider>().basicDetailModel;
        return InkWell(
          onTap: value
              ? null
              : () {
                  context.read<AddressProvider>().requestContactCount(
                      model?.basicDetail?.id ?? -1,
                      limit: index.value != -1
                          ? optionValues[index.value]
                          : null, onSuccess: (val) {
                    if (val) {
                      Navigator.pop(context);
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 35.h,
            width: value ? 35.w : 118.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: HexColor('#6C013D')),
            child: value
                ? SizedBox(
                    height: 35.h,
                    width: 35.w,
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Text(
                    context.loc.upgradeNow,
                    style:
                        FontPalette.white13SemiBold.copyWith(fontSize: 14.sp),
                  ),
          ),
        );
      },
    );
  }
}
