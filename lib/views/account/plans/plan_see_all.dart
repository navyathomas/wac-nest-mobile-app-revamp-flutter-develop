import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/models/see_all_plans_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PlanSeeAll extends StatefulWidget {
  const PlanSeeAll({Key? key}) : super(key: key);

  @override
  State<PlanSeeAll> createState() => _PlanSeeAllState();
}

class _PlanSeeAllState extends State<PlanSeeAll> {
  SeeAllPlansModel? seeAllPlans;
  final List<Map<String, dynamic>> _listColors = [
    // {
    //   "cardColor": HexColor("#A7006F"),
    //   "textColor": HexColor("#FFDEF4"),
    // },
    {
      "cardColor": HexColor("#FFD1FB"),
      "textColor": HexColor("#B13EA9"),
    },
    {
      "cardColor": HexColor("#E7D5FF"),
      "textColor": HexColor('#4B0090'),
    },
  ];
  init() {
    Future.microtask(() {
      context.read<AccountProvider>().initSeeAll();
      context.read<AccountProvider>().getSeeAllPlans();
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F2F4F5"),
      body: Column(
        children: [customAppbar(context), palnList()],
      ),
    );
  }

  Widget palnList() {
    return Consumer<AccountProvider>(
      builder: (context, pro, child) {
        if (pro.seeAllPlans != null) {
          List<Datum>? data = pro.seeAllPlans?.data;
          return Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 11.w),
              itemCount: data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return whitePlanCard(context,
                    inAppTitle: data?[index].iosAppTitle ?? '',
                    planID: data?[index].id ?? 0,
                    month: data?[index].validity ?? "",
                    // month: '${data?[index].validityMonth ?? ""}',
                    planName: data?[index].subscriptionTitle ?? '',
                    amount:Platform.isIOS?'${data?[index].iosInAppAmount ?? ""}': '${data?[index].subscriptionPrice ?? ""}',
                    cardColor: _listColors[index % _listColors.length]
                        ["cardColor"],
                    textColor: _listColors[index % _listColors.length]
                        ['textColor'],
                    description:
                        data?[index].subscriptionType?.subscriptionType ?? "",
                    validUPtoText: data?[index].extraFeatures ?? "",
                    validUpto:
                        data?[index].extraFeatures != null ? true : false,
                    upgradeAble: data?[index].canUpgrade ?? false);

                //  index == 2
                //     ? whitePlanCard(context,
                //         planName: "Delight",
                //         amount: "5,000",
                //         description: "",
                //         validUpto: true)
                // : index == 3
                //     ? whitePlanCard(context,
                //         planName: "Classic Plus",
                //         amount: "2,500",
                //         description: "",
                //         textColor: HexColor("#A7006F"),
                //         cardColor: HexColor("#FFDEF4"),
                //         validUpto: true)
                //     : index == 4
                //         ? whitePlanCard(context,
                //             planName: "Classic",
                //             amount: "2,000",
                //             description: "",
                //             textColor: HexColor("#B13EA9"),
                //             cardColor: HexColor("#FFD1FB"),
                //             validUpto: true)
                //         : whitePlanCard(
                //             context,
                //           );
              },
              separatorBuilder: (BuildContext context, int index) {
                return 7.verticalSpace;
              },
            ),
          );
        } else {
          return Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: HexColor("#EFF1F4"),
                    highlightColor: Colors.white,
                    child: whitePlanCard(context,
                        planName: "Delight",
                        amount: "5,000",
                        description: "",
                        validUpto: true),
                  );
                },
                separatorBuilder: (context, index) {
                  return 7.verticalSpace;
                },
                itemCount: 10),
          );
        }
      },
    );
  }

  Widget whitePlanCard(BuildContext context,
      {int? planID,
      String? planName,
      String? inAppTitle,
      String? description,
      String? amount,
      String? month,
      String? validUPtoText,
      Color? textColor,
      Color? cardColor,
      bool upgradeAble = false,
      bool validUpto = false}) {
    return GestureDetector(
      onTap: (() => Navigator.pushNamed(context, RouteGenerator.routePlanDetail,
          arguments: RouteArguments(
              inAppTitle: inAppTitle,
              title: planName ?? "",
              anyText: month ?? "",
              anyValue: amount ?? "",
              descriptions: description ?? "",
              index: planID ?? 0,
              showUpgradePlan: upgradeAble))),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            height: 104.h + (Helpers.validateScale(context, 0.0) * 20).h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(width: 1.w, color: HexColor("#E9EDEF"))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        planName ?? "",
                        // planName ?? "Royal Delight",
                        maxLines: 1,
                        style: FontPalette.black16Bold
                            .copyWith(color: HexColor("#131A24")),
                      ),
                      7.verticalSpace, // as per UI
                      // 2.verticalSpace,
                      Text(
                        description ?? "",
                        // description ?? "CR Manager support",
                        maxLines: 1,
                        style: FontPalette.black12Medium.copyWith(
                            color: Colors.grey.shade600, fontSize: 13.sp),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      amount != null && amount != "0"
                          ? Row(
                              children: [
                                SvgPicture.asset(Assets.iconsTinyRupeeSign),
                                2.02.horizontalSpace,
                                Text(
                                  amount,
                                  // amount ?? "13,000",
                                  maxLines: 1,
                                  style: FontPalette.black16Bold.copyWith(
                                      color: HexColor("#131A24"),
                                      fontSize: 17.sp),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      4.verticalSpace,
                      Text(
                        month != null && month != "" ? month : "",
                        // month ?? "6 month",
                        maxLines: 1,
                        style: FontPalette.black13SemiBold.copyWith(
                            color: HexColor("#525B67"), fontSize: 11.sp),
                      ),
                      9.55.verticalSpace,
                      if (upgradeAble)
                        Text(
                          "Upgrade",
                          maxLines: 1,
                          style: FontPalette.black14Bold
                              .copyWith(color: ColorPalette.primaryColor),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          validUpto
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  height: 28.h,
                  width: 166.w,
                  decoration: BoxDecoration(
                      color: cardColor ?? HexColor("#E7D5FF"),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(9.r),
                          topRight: Radius.circular(9.r))),
                  child: Text(
                    validUPtoText ?? "",
                    //  validUPtoText?? "Valid up to marriage",
                    maxLines: 1,
                    style: FontPalette.black14SemiBold
                        .copyWith(color: textColor ?? HexColor("#4B0090")),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

//CUSTOM APPBAR
  Widget customAppbar(BuildContext context) {
    return Stack(
      children: [
        //pink card
        Container(
            height: 235.h + (Helpers.validateScale(context, 0.0) * 20).h,
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 34.w, right: 34.w, bottom: 14.h,
              // top: 180.h // new change not as per UI <-- top
            ),
            decoration: BoxDecoration(
              color: HexColor("#FFDEF4"),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22.r),
                  bottomRight: Radius.circular(22.r)),
            ),
            child: Consumer<AccountProvider>(
              builder: (context, pro, child) {
                String? subscriptionTitle = "";
                int? subscriptionPrice = 0;
                if (pro.profileComplete?.data != null &&
                    pro.profileComplete?.data?.userPackage != null) {
                  subscriptionTitle =
                      pro.profileComplete?.data?.userPackage!.subscriptionTitle;
                  subscriptionPrice = pro.profileComplete?.data?.userPackage!
                          .subscriptionPrice ??
                      0;
                }
                if (pro.profileComplete?.data != null &&
                    pro.profileComplete?.data?.userPackage != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscriptionTitle ?? '',
                            style: FontPalette.black14Bold,
                          ),
                          3.verticalSpace,
                          Text(
                            "Current plan",
                            maxLines: 1,
                            style: FontPalette.f131A24_13Medium
                                .copyWith(color: HexColor("#950053")),
                          ),
                          // Text(
                          //   "Delight",
                          //   style: FontPalette.black14Bold,
                          // ),
                          // 3.verticalSpace,
                          // Text(
                          //   "Current plan",
                          //   maxLines: 1,
                          //   style: FontPalette.f131A24_13Medium
                          //       .copyWith(color: HexColor("#950053")),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 9.h,
                        ),
                        child: subscriptionPrice != 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(Assets.iconsTinyRupeeSign),
                                  2.02.horizontalSpace,
                                  Text(
                                      // context.read<AccountProvider>().profileComplete.data.userPackage.
                                      '$subscriptionPrice',
                                      style: FontPalette.f131A24_14Bold
                                          .copyWith(
                                              color: HexColor("#131A24"),
                                              fontSize: 15.sp),
                                      maxLines: 1)
                                ],
                              )
                            : const SizedBox(),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            )),

        //Upgrade your plan container
        Container(
          // height: 173.h, // as per UI
          padding: EdgeInsets.only(bottom: 10.h), // not as per UI
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22.r),
                  bottomRight: Radius.circular(22.r)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [HexColor("#D634A4"), HexColor("#770C56")],
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                // offset: Offset(15.w, 48.h), -- original value
                offset: Offset(10.w, 35.h),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 53.w,
                    width: 53.w,
                    // height: 43.w,
                    // width: 43.w,
                    // height: 33.h, -- original value
                    // width: 33.w, -- original value

                    // alignment: Alignment.center,
                    // decoration: const BoxDecoration(
                    //     color: Colors.white24, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      Assets.iconsTransparentBackButton,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ).removeSplash(),
              ),
              25.verticalSpace,
              // 50.verticalSpace, -- original value
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.iconsSmallCrown),
                  9.02.horizontalSpace,
                  Text(
                    "Upgrade your plan",
                    style: FontPalette.black14Bold
                        .copyWith(fontSize: 21.sp, color: HexColor("#EEE19C")),
                  ),
                ],
              ),
              8.79.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 9.02.w),
                child: Center(
                  child: Text(
                    "Maximise your chances of\ngetting responses.",
                    style: FontPalette.black12Medium
                        .copyWith(fontSize: 13.sp, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
