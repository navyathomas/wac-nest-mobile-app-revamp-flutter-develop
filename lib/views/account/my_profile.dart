import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/higher_plans_model.dart';
import 'package:nest_matrimony/models/profile_complete_model.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_plan_card.dart';
import 'package:nest_matrimony/widgets/profile_indicator.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common/constants.dart';
import '../error_views/common_error_view.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  PageController controller = PageController(initialPage: 0);
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  List<String> settingList = [
    "Profile",
    "Partner preference",
    "Settings",
    "Help centre"
  ];
  List<String> settingIcons = [
    Assets.iconsVuesaxBoldUserOctagon,
    Assets.iconsPartnerPreference,
    Assets.iconsBoldSetting,
    Assets.iconsHelpCenter
  ];

  final List<Map<String, dynamic>> _listColors = [
    {
      "gradient": [HexColor("#950553"), HexColor("#E461A7")],
      "matchColor": HexColor('#DF5CA2'),
    },
    {
      "gradient": [HexColor("#A51A1A"), HexColor("#FB7A7A")],
      "matchColor": HexColor('#F97777'),
    },
    {
      "gradient": [HexColor("#561096"), HexColor("#985BE6")],
      "matchColor": HexColor("D4B4FF")
    },
    {
      "gradient": [HexColor("#256C4D"), HexColor("#5CD49F")],
      "matchColor": HexColor("ABF0D1")
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AccountProvider>(
          builder: ((context, pro, child) {
            return switchView(pro.loaderState, pro, context);
          }),
        ));
  }

  switchView(
      LoaderState loaderState, AccountProvider provider, BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = mainView(provider);
        break;
      case LoaderState.error:
        child = mainViewWhileError(provider);
        // CommonErrorView(
        //   error: Errors.serverError,
        //   onTap: () => provider.higherPlans(),
        // );
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
            error: Errors.networkError, onTap: () => provider.higherPlans());
        break;
      case LoaderState.noData:
        CommonErrorView(
            error: Errors.noDatFound,
            isTryAgainVisible: false,
            onTap: () => provider.higherPlans());
        break;

      case LoaderState.loading:
        Center(child: ReusableWidgets.circularIndicator());
        break;
    }
    return child;
  }

  mainView(AccountProvider pro) {
    return Column(
      children: [
        gradeintCard(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              listSettings(),
              12.46.verticalSpace,
              ReusableWidgets.horizontalLine(),
              24.86.verticalSpace,
              planHeading(),
              16.32.verticalSpace,
              planCardList(pro),
              18.02.verticalSpace,
              pro.higherPlansData?.data != null
                  ? pro.higherPlansData?.data?.length == 1
                      ? const SizedBox.shrink()
                      : SmoothPageIndicator(
                          controller: controller,
                          // count: 6,
                          // count: ((pro.higherPlansData?.data?.length)) ?? 0,
                          count: pro.higherPlansData?.data?.length == 6
                              ? 4
                              : ((pro.higherPlansData?.data?.length)! - 1),
                          // count: 1,
                          effect: WormEffect(
                              spacing: 10.r,
                              radius: 8.r,
                              dotWidth: 8.0,
                              dotHeight: 8.0,
                              dotColor: HexColor('#D9D9D9'),
                              activeDotColor: HexColor("#565F6C")),
                          onDotClicked: (index) {
                            // currentIndex.value = index;
                            controller.animateToPage(
                              currentIndex.value,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 200),
                            );
                          })
                  : const SizedBox(),
            ]),
          ),
        )
      ],
    );
  }

  mainViewWhileError(AccountProvider pro) {
    return Column(
      children: [
        gradeintCard(),
        24.86.verticalSpace,
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              listSettings(),
              12.46.verticalSpace,
              ReusableWidgets.horizontalLine(),
              24.86.verticalSpace,
            ]),
          ),
        )
      ],
    );
  }

//INSIDE WIDGETS

// SizedBox(
//         height: 126.h,
//         width: context.sw(),
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           physics: const BouncingScrollPhysics(),
//           controller: controller,
//           scrollDirection: Axis.horizontal,
//           children: [
//             const CommonPlanCard(),
//             8.horizontalSpace,
//             const CommonPlanCard(),
//             8.horizontalSpace,
//             CommonPlanCard(
//               title: "Delight",
//               rupees: "5,000",
//               bottomTagTitle: "Valid up to marriage",
//               backgroudNestLogo: Assets.imagesNestLogoPurple,
//               gradientColour: [HexColor("#560096"), HexColor("#AC77FF")],
//               bottomColors: [HexColor("#D4B4FF"), HexColor("#D4B4FF")],
//             ),
//           ],
//         ))

  Widget planCardList(AccountProvider provider) {
    if (!provider.btnLoader) {
      return SizedBox(
          height: 126.h,
          width: context.sw(),
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const BouncingScrollPhysics(),
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  provider.higherPlansData?.data?.length ?? 0, (index) {
                HigherPlansModel plans = provider.higherPlansData!;
                return provider.higherPlansData!.data!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: CommonPlanCard(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.routePlanDetail,
                                arguments: RouteArguments(
                                    inAppTitle:
                                        plans.data?[index].iosAppTitle ?? '',
                                    title:
                                        plans.data?[index].subscriptionTitle ??
                                            "",
                                    // anyText:
                                    //     '${plans.data?[index].validityMonth}',
                                    anyText: plans.data?[index].validity ?? "",
                                    anyValue: Platform.isIOS
                                        ? '${plans.data?[index].iosInAppAmount??""}'
                                        : '${plans.data?[index].subscriptionPrice??""}',
                                    descriptions:
                                        '${plans.data?[index].subscriptionType?.subscriptionType}',
                                    // planAmount: '${routeArgs.anyvalue}'
                                    index: plans.data?[index].id ?? 0));
                          },
                          title:
                              plans.data![index].subscriptionTitle.toString(),
                          rupees: Platform.isIOS
                              ? (plans.data![index].iosInAppAmount!=null?plans.data![index].iosInAppAmount.toString():"")
                              : plans.data![index].subscriptionPrice.toString(),
                          bottomTagTitle: plans.data![index].extraFeatures,
                          perMontOrDate: plans.data![index].validity ?? "",
                          // perMontOrDate:
                          //     plans.data![index].validityMonth.toString(),
                          // backgroudNestLogo: Assets.imagesNestLogoPurple,
                          gradientColour:
                              _listColors[index % _listColors.length]
                                  ["gradient"],
                          bottomColors:
                              plans.data![index].premiumPackage == true
                                  ? null
                                  : [
                                      _listColors[index % _listColors.length]
                                          ["matchColor"],
                                      _listColors[index % _listColors.length]
                                          ["matchColor"],
                                    ],
                        ),
                      )
                    : const SizedBox();
              })));
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.bottomLeft,
        height: 126.h,
        width: context.sw(),
        child: Shimmer.fromColors(
            baseColor: HexColor("#EFF1F4"),
            highlightColor: Colors.white,
            child: const CommonPlanCard()),
      );
      // return const SizedBox();
    }
  }

  Widget planHeading() {
    return Consumer<AccountProvider>(
      builder: (context, pro, child) {
        return Container(
          width: context.sw(),
          padding: EdgeInsets.only(left: 18, right: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pro.btnLoader
                  ? Shimmer.fromColors(
                      baseColor: HexColor("#EFF1F4"),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 130.w,
                        height: 20.h,
                        color: Colors.white,
                      ))
                  : pro.higherPlansData?.data != null
                      ? Text(
                          "Popular plans",
                          style: FontPalette.black16ExtraBold,
                        )
                      : const SizedBox(),
              pro.btnLoader
                  ? Shimmer.fromColors(
                      baseColor: HexColor("#EFF1F4"),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 50.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                    )
                  : pro.higherPlansData?.data != null
                      ? InkWell(
                          onTap: (() => Navigator.pushNamed(
                              context, RouteGenerator.routePlanSeeAll)),
                          child: Row(
                            children: [
                              Text(
                                "See All",
                                style: FontPalette.black16ExtraBold.copyWith(
                                    color: HexColor("#2995E5"),
                                    fontSize: 13.sp),
                              ),
                              SizedBox(
                                  height: 32.h,
                                  width: 32.w,
                                  child:
                                      SvgPicture.asset(Assets.iconsForwardBlue))
                            ],
                          ),
                        ).removeSplash()
                      : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  Widget horizontalLine() {
    return Container(
      height: 2.h,
      width: double.maxFinite,
      color: HexColor("#F2F4F5"),
    );
  }

  Widget listSettings() {
    return SizedBox(
      height: (55 * settingList.length).h, //four -> count of item
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: settingList.length,
          itemBuilder: (context, index) {
            return iconListTile(
              icon: settingIcons[index],
              title: settingList[index],
              onTap: () {
                switch (index) {
                  case 0:
                    routeToProfile(index);
                    break;
                  case 1:
                    routeToPartnerPreference(index);
                    break;
                  case 2:
                    routeToSetting(index);
                    break;
                  case 3:
                    routeToHelpCentre(index);
                    break;
                }
              },
            );
          }),
    );
  }

  routeToSetting(index) {
    Navigator.pushNamed(context, RouteGenerator.routeSettings,
        arguments: RouteArguments(title: settingList[index]));
  }

  routeToHelpCentre(index) {
    Navigator.pushNamed(context, RouteGenerator.routeHelpCentre,
        arguments: RouteArguments(title: settingList[index]));
  }

  routeToPartnerPreference(index) {
    Navigator.pushNamed(context, RouteGenerator.routePartnerPreference,
        arguments: RouteArguments(title: settingList[index]));
  }

  routeToProfile(index) {
    Navigator.pushNamed(context, RouteGenerator.routeProfile,
        arguments: RouteArguments(title: settingList[index]));
  }

  Widget iconListTile({String? icon, String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 55.h,
          margin: EdgeInsets.only(left: 16.w, right: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: SvgPicture.asset(
                      icon ?? Assets.iconsVuesaxBoldUserOctagon)),
              12.81.horizontalSpace,
              Expanded(
                  child: Text(
                title ?? '',
                style: FontPalette.black15SemiBold,
              )),
              SvgPicture.asset(Assets.iconsForwardPoint)
            ],
          )),
    );
  }

  Widget gradeintCard() {
    UserPackage? userPackage;
    return Consumer<AccountProvider>(builder: (context, p, child) {
      userPackage = p.profileComplete?.data?.userPackage;

      String? userName = (p.profileComplete?.data?.name ?? '').isNotEmpty
          ? p.profileComplete?.data?.name
          : "";
      String? regID = (p.profileComplete?.data?.nestId ?? '').isNotEmpty
          ? p.profileComplete?.data?.nestId
          : "";
      return SizedBox(
        height: userPackage == null ? (196 + 10).h : (196 + 68).h,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: 196.h,
                width: context.sw(),
                padding: EdgeInsets.only(left: 38.w, right: 23.67.w),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  stops: const [
                    0.5,
                    0.9,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.topRight,
                  colors: [
                    HexColor('#FFF0E3'),
                    HexColor('#F8D5FF'),
                  ],
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? '',
                            style: FontPalette.black10Bold
                                .copyWith(fontSize: 19.sp),
                          ),
                          5.verticalSpace,
                          Text(
                              regID ?? ''
                              // "NST155646WTY"
                              ,
                              style: FontPalette.black12Medium),
                        ],
                      ),
                    ),
                    // Consumer<AccountProvider>(
                    //   builder: (context, p, child) {
                    //     return
                    InkWell(
                      onTap: (() => Navigator.pushNamed(
                          context, RouteGenerator.routeManagePhotos)),
                      child: ProfileIndicator(
                        profilePhoto: null,
                        percentage: p.percentage.toDouble(),
                        // percentage: 42,
                        //   );
                        // },
                      ),
                    ).removeSplash()
                  ],
                ),
              ),
            ),
            userPackage == null
                ? const SizedBox(
                    width: double.maxFinite,
                  )
                : InkWell(
                    onTap: userPackage?.subscriptionType != null
                        ? (() => Navigator.pushNamed(
                            context, RouteGenerator.routePlanDetail,
                            arguments: RouteArguments(
                                showUpgradePlan: false,
                                title: userPackage?.subscriptionTitle ?? "",
                                anyText:
                                    userPackage?.validityMonth.toString() ?? "",
                                anyValue:
                                    userPackage?.subscriptionPrice.toString() ??
                                        "",
                                descriptions:
                                    userPackage?.subscriptionTitle ?? "",
                                index: userPackage?.id ?? 0)))
                        : null,
                    child: Container(
                      height: 68.h,
                      width: context.sw(),
                      margin: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 10.h, bottom: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                                spreadRadius: 0.5)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(Assets.iconsGiftBox),
                              14.38.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userPackage?.subscriptionTitle ?? '',
                                    style: FontPalette.black14SemiBold,
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    "Current plan",
                                    style: FontPalette.black12Medium.copyWith(
                                        fontSize: 13.sp,
                                        color: HexColor("#8695A7")),
                                  )
                                  // Text(
                                  //   "Delight",
                                  //   style: FontPalette.black14SemiBold,
                                  // ),
                                  // 4.verticalSpace,
                                  // Text(
                                  //   "Current plan",
                                  //   style: FontPalette.black12Medium.copyWith(
                                  //       fontSize: 13.sp, color: HexColor("#8695A7")),
                                  // )
                                ],
                              ),
                            ],
                          ),
                          SvgPicture.asset(Assets.iconsRoundedForward)
                        ],
                      ),
                    ),
                  ).removeSplash()
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().initHigherPalns();

      context.read<AccountProvider>().higherPlans();
    });
    super.initState();
  }
}
