import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

import '../../generated/assets.dart';

class AddHoroScopeAlert extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.all(0.r),
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: const _ContentView(),
    );
  }
}

class _ContentView extends StatefulWidget {
  const _ContentView({Key? key}) : super(key: key);

  @override
  State<_ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<_ContentView> {
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
    return Container(
      height: 350.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: HexColor('#950053'),
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 260.h,
                decoration: BoxDecoration(
                    color: HexColor('#FFFFFF'),
                    borderRadius: BorderRadius.all(Radius.circular(18.r))),
                child: Selector<AppDataProvider, BasicDetailModel?>(
                  selector: (context, provider) => provider.basicDetailModel,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        30.verticalSpace,
                        Row(
                          children: [
                            22.horizontalSpace,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.r),
                              child: ProfileImageView(
                                  height: 60.r,
                                  width: 60.r,
                                  isCircular: true,
                                  isMale: value?.basicDetail?.isMale,
                                  image: value
                                          ?.basicDetail?.profileImage?.imageFile
                                          ?.thumbImagePath(context) ??
                                      ''),
                            ),
                            16.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value?.basicDetail?.name ?? '',
                                  style: FontPalette.black14Bold,
                                ),
                                6.verticalSpace,
                                Text(
                                  value?.basicDetail?.registerId ?? '',
                                  style: FontPalette.black14Medium.copyWith(
                                      color: HexColor('#565F6C'),
                                      fontSize: 13.sp,
                                      letterSpacing: 1.w),
                                )
                              ],
                            )
                          ],
                        ),
                        19.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.5.h),
                          child: WidgetExtension.horizontalDivider(
                              color: HexColor('#DBE2EA')),
                        ),
                        22.verticalSpace,
                        Text(
                          context.loc.addYourHoroscopeAndViewHerHoroscopeFree,
                          textAlign: TextAlign.center,
                          style: FontPalette.black14Medium
                              .copyWith(color: HexColor('#525B67')),
                          strutStyle: StrutStyle(height: 1.5.h),
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.iconsAdd,
                              height: 10.43.h,
                              width: 10.43.w,
                              color: HexColor('#950053'),
                            ),
                            10.horizontalSpace,
                            Text(
                              context.loc.addHoroscope,
                              style: FontPalette.primary16Bold,
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              23.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.h, right: 5.w),
                        child: Text(
                          context.loc.unlimitedHoroscopesByGoingPremium,
                          style: FontPalette.white13SemiBold,
                          strutStyle: StrutStyle(height: 1.h),
                        ),
                      ),
                    ),
                    upgradeNowButton()
                  ],
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.maybePop(context),
                child: Padding(
                  padding: EdgeInsets.all(25.r),
                  child: SvgPicture.asset(
                    Assets.iconsCloseGrey,
                    height: 13.42.h,
                    width: 13.42.w,
                  ),
                ),
              ).removeSplash(color: Colors.transparent)),
        ],
      ),
    );
  }

  upgradeNowButton() {
    return Container(
      height: 35.h,
      width: 118.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: HexColor('#6C013D')),
      child: Text(
        context.loc.upgradeNowSmall,
        style: FontPalette.white13SemiBold.copyWith(fontSize: 14.sp),
      ).avoidOverFlow(),
    );
  }
}
