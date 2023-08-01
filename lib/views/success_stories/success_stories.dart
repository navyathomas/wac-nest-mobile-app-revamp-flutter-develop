import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/testimonials_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/views/success_stories/success_stories_on_boarding_screen.dart';
import 'package:nest_matrimony/widgets/common_app_bar.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common/common_functions.dart';
import '../../common/constants.dart';
import '../error_views/common_error_view.dart';

class SuccessStoriesScreen extends StatefulWidget {
  SuccessStoriesScreen({Key? key}) : super(key: key);

  @override
  State<SuccessStoriesScreen> createState() => _SuccessStoriesScreenState();
}

class _SuccessStoriesScreenState extends State<SuccessStoriesScreen> {
  final PageController controller = PageController();

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context.read<TestimonialsProvider>().getTestimonials();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: 'Success stories',
      ),
      body: SafeArea(
        child: Consumer<TestimonialsProvider>(
          builder: (context, provider, child) {
            return StackLoader(
                inAsyncCall:
                    provider.loaderState == LoaderState.loading ? true : false,
                child: provider.loaderState == LoaderState.loading
                    ? const SizedBox.shrink()
                    : switchView(provider.loaderState, provider, context));
          },
        ),
      ),
    );
  }

  Widget switchView(LoaderState loaderState, TestimonialsProvider provider,
      BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = provider.testimonialsList.isEmpty
            ? CommonErrorView(
                error: Errors.noDatFound,
                onTap: () => CommonFunctions.afterInit(() {
                  provider.getTestimonials();
                }),
              )
            : _mainView(provider);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError, onTap: () => provider.getTestimonials());
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
          error: Errors.networkError,
          onTap: () => provider.getTestimonials(),
        );
        break;
      case LoaderState.noData:
        CommonErrorView(
          error: Errors.noDatFound,
          onTap: () => provider.getTestimonials(),
        );
        break;
      case LoaderState.loading:
        child = provider.testimonialsList.isEmpty
            ? const SizedBox.shrink()
            : _mainView(provider);
        break;
    }
    return child;
  }

  _mainView(TestimonialsProvider provider) {
    return Stack(children: [
      PageView.builder(
        controller: controller,
        onPageChanged: (value) => currentIndex.value = value,
        itemCount: provider.pageLength,
        itemBuilder: (context, index) => SuccessStoriesOnBoardingScreen(
          testimonialUserData: provider.testimonialsList[index],
        ),
      ),
      Positioned(
          bottom: 0.h,
          left: 0.w,
          right: 0.w,
          child: Container(
              height: 140.h,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    Colors.white.withOpacity(0.5),
                  ])))),
      if (provider.testimonialsList.length > 1)
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90.h,
              color: Colors.white,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(top: 25.h),
                  //   child: SmoothPageIndicator(
                  //       controller: controller,
                  //       count: provider.testimonialsList.length > 5
                  //           ? 5
                  //           : provider.testimonialsList.length,
                  //       effect: WormEffect(
                  //           spacing: 10.r,
                  //           radius: 8.r,
                  //           dotWidth: 8.0,
                  //           dotHeight: 8.0,
                  //           dotColor: HexColor('#D9D9D9'),
                  //           activeDotColor: Colors.black),
                  //       onDotClicked: (index) {
                  //         currentIndex.value = index;
                  //         controller.animateToPage(
                  //           index,
                  //           curve: Curves.easeIn,
                  //           duration: const Duration(milliseconds: 200),
                  //         );
                  //       }),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _onBackward(),
                          child: ValueListenableBuilder<int>(
                            valueListenable: currentIndex,
                            builder: (context, value, child) {
                              return AnimatedContainer(
                                height: 50.r,
                                width: 50.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: currentIndex.value != 0
                                            ? ColorPalette.primaryColor
                                            : HexColor('#D9D9D9'),
                                        width: 1.w)),
                                duration: const Duration(milliseconds: 300),
                                child: SvgPicture.asset(
                                  Assets.iconsIosArrowLeft,
                                  color: currentIndex.value != 0
                                      ? ColorPalette.primaryColor
                                      : Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        13.horizontalSpace,
                        InkWell(
                          onTap: () => _onForward(provider.pageLength),
                          child: ValueListenableBuilder<int>(
                            valueListenable: currentIndex,
                            builder: (context, value, child) {
                              return AnimatedContainer(
                                height: 50.r,
                                width: 50.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: currentIndex.value !=
                                                provider.pageLength - 1
                                            ? ColorPalette.primaryColor
                                            : HexColor('#D9D9D9'),
                                        width: 1.w)),
                                duration: const Duration(milliseconds: 300),
                                child: SvgPicture.asset(
                                  Assets.iconsIosArrowRight,
                                  color: currentIndex.value !=
                                          provider.pageLength - 1
                                      ? ColorPalette.primaryColor
                                      : Colors.black,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
    ]);
  }

  _onForward(int count) {
    if (currentIndex.value != count) {
      controller.animateToPage(
        currentIndex.value + 1,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  _onBackward() {
    if (currentIndex.value != 0) {
      controller.animateToPage(
        currentIndex.value - 1,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
      );
    }
  }
}
