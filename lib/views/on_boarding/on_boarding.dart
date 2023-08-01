import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<String> onBoardingImages = [
    Assets.imagesOnBoarding1,
    Assets.imagesOnBoarding2,
    Assets.imagesOnBoarding3
  ];

  final PageController controller = PageController();
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  @override
  void initState() {
    appOpenedOnce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark),
          child: SizedBox(
            height: context.sh(),
            width: context.sw(),
            child: _buildScreen(onBoardingImage: onBoardingImages),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onForward,
          elevation: 0,
          child: SvgPicture.asset(
            Assets.iconsArrowRight,
            alignment: Alignment.center,
            width: 17.w,
            height: 17.h,
          ),
        ));
  }

//COMMON VIEW
  Widget _buildScreen({List<String>? onBoardingImage}) {
    return Stack(fit: StackFit.loose, children: [
      SizedBox(
        height: 452.h,
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) => currentIndex.value = value,
          children: List.generate(
            3,
            (index) => SizedBox(
                height: 452.h,
                width: context.sw(),
                child: onBoardingImage!.isNotEmpty
                    ? Image.asset(
                        onBoardingImage[index],
                        height: 452.h,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox()),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        height: 391.h,
        width: context.sw(),
        child: Container(
            padding: EdgeInsets.only(top: 22.h, left: 32.w, right: 32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.r),
                  topRight: Radius.circular(22.r)),
            ),
            width: context.sw(),
            height: 391.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _onSkipTap,
                  child: Container(
                    width: context.sw(),
                    alignment: Alignment.centerRight,
                    child: Text(
                      context.loc.skip,
                      style: FontPalette.color131A24_20Bold.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                ValueListenableBuilder<int>(
                  builder: (BuildContext context, int value, Widget? child) {
                    if (currentIndex.value == 0) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: value == 0 ? 1 : 0,
                        child: RichText(
                          text: TextSpan(
                            text: '${context.loc.findYour}\n',
                            style: FontPalette.color131A24_20Bold,
                            children: <TextSpan>[
                              TextSpan(
                                  text: context.loc.soulmate,
                                  style: FontPalette.color131A24_20Bold
                                      .copyWith(color: HexColor("#950553"))),
                            ],
                          ),
                        ),
                      );
                    }
                    if (currentIndex.value == 1) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: value == 1 ? 1 : 0,
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: FontPalette.color131A24_20Bold,
                            children: <TextSpan>[
                              TextSpan(
                                  text: context.loc.allcommunity,
                                  style: FontPalette.color131A24_20Bold
                                      .copyWith(color: HexColor("#950553"))),
                              TextSpan(
                                  text:
                                      '${context.loc.vast}\n${context.loc.profileCollection}'),
                            ],
                          ),
                        ),
                      );
                    }
                    if (currentIndex.value == 2) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: value == 2 ? 1 : 0.5,
                        child: RichText(
                          text: TextSpan(
                            text: '${context.loc.yourInfo}\n',
                            style: FontPalette.color131A24_20Bold,
                            children: <TextSpan>[
                              TextSpan(
                                  text: context.loc.hundredPercen,
                                  style: FontPalette.color131A24_20Bold
                                      .copyWith(color: HexColor("#950553"))),
                              TextSpan(text: context.loc.withUs),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  valueListenable: currentIndex,
                ),
                SizedBox(height: 20.h),
                ValueListenableBuilder(
                  builder: (context, value, child) {
                    if (currentIndex.value == 0) {
                      return Text(
                        context.loc.registerWithKeralasMostTrustedMatrimony,
                        style: FontPalette.color131A24_20Bold.copyWith(
                            fontSize: 19.sp, fontWeight: FontWeight.w400),
                      );
                    }
                    if (currentIndex.value == 1) {
                      return Text(
                        'Mediatory Customer Care Support upto Marriage',
                        style: FontPalette.color131A24_20Bold.copyWith(
                            fontSize: 19.sp, fontWeight: FontWeight.w400),
                      );
                    } else {
                      return Text(
                        'Kerala’s One and Only Service Assisted Matrimony With No Renewal Charge',
                        style: FontPalette.color131A24_20Bold.copyWith(
                            fontSize: 19.sp, fontWeight: FontWeight.w400),
                      );
                    }
                  },
                  valueListenable: currentIndex,
                ),
              ],
            )),
      ),

      // currentIndex.value == 0
      //     ? context.loc.registerWithKeralasMostTrustedMatrimony
      //     : currentIndex.value == 1
      //         ? context.loc.theMostTrustedMatrimonyBandInKerala
      //         : context.loc
      //             .registerForFreeWithTheLargestMatrimonyInKerala,

      Positioned(
        bottom: 50.h,
        left: 32.w,
        child: SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: WormEffect(
                spacing: 10.r,
                radius: 8.r,
                dotWidth: 8.0,
                dotHeight: 8.0,
                dotColor: HexColor('#D9D9D9'),
                activeDotColor: Colors.black),
            onDotClicked: (index) {
              currentIndex.value = index;
              controller.animateToPage(
                index,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
              );
            }),
      )
    ]);
  }

  void _onSkipTap() {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.routeAuthScreen, (route) => false);
  }

  _onForward() {
    if (currentIndex.value != onBoardingImages.length - 1) {
      controller.animateToPage(
        currentIndex.value + 1,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _onSkipTap();
    }
  }

  appOpenedOnce() async {
    await SharedPreferenceHelper.appOpenedOnce(true);
  }
}
