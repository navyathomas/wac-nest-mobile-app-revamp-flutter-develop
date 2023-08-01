import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/planDetailModel.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/inapp_provider.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:provider/provider.dart';

import '../../../common/route_generator.dart';

class PlanDetail extends StatefulWidget {
  final String planId;
  final String planName;
  final String planAmount;
  final String mont;
  final String description;
  final bool showUpgradePlan;
  final String inAppTitle;
  const PlanDetail({
    Key? key,
    required this.planId,
    required this.planName,
    required this.planAmount,
    required this.mont,
    required this.description,
    required this.inAppTitle,
    this.showUpgradePlan = true,
  }) : super(key: key);

  @override
  State<PlanDetail> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetail> {
  init() {
    Future.microtask(() {
      context.read<AccountProvider>().initPlanDetail();
      context.read<AccountProvider>().getPlanDetail(planId: widget.planId);
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          customAppBar(context),
          33.49.verticalSpace,
          planDetailsList(),
          widget.showUpgradePlan
              ? Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.outer,
                        offset: const Offset(0, 3),
                        blurRadius: 3,
                        spreadRadius: 2,
                        color: HexColor("#BABABA").withOpacity(0.50))
                  ]),
                  height: 79.h,
                  width: double.maxFinite,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CommonButton(
                        title: "Upgrade now",
                        onPressed: () {
                          context
                              .read<InappProvider>()
                              .updateKeys(kConsumable: widget.inAppTitle);
                          context
                              .read<PaymentProvider>()
                              .updateSubscriptionPayment(widget.planAmount);
                          context
                              .read<PaymentProvider>()
                              .updateTotalAmount(int.parse(widget.planAmount));
                          context.read<PaymentProvider>().paymentPurpose =
                              widget.planName;
                          Navigator.pushNamed(
                                  context, RouteGenerator.routePaymentInit,
                                  arguments: RouteArguments(
                                      isUpgradePlan: true,
                                      planId: int.parse(widget.planId),
                                      planAmount: int.parse(widget.planAmount)))
                              .then((value) => context
                                  .read<PaymentProvider>()
                                  .removeAppliedCoupon(context));
                        },
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget planDetailsList() {
    return Consumer<AccountProvider>(
      builder: (context, value, child) {
        // Data? data;
        List<String?>? appData;
        if (value.planDetail != null) {
          appData = value.planDetail?.data?.appData ?? [];
          return Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return planDetails(title: appData?[index] ?? "");
                },
                separatorBuilder: (context, int index) {
                  return 16.verticalSpace;
                },
                itemCount: appData.length),
          );

          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     physics: const BouncingScrollPhysics(),
          //     children: [
          //       planDetails(
          //           title: "Secure chat feature",
          //           correct: (data?.chatFeature != null)
          //               ? data?.chatFeature == 'Y'
          //                   ? true
          //                   : false
          //               : false),
          //       16.verticalSpace,
          //       planDetails(
          //           title:
          //               "Your plan is valid for  ${data?.validityMonth ?? ''} months",
          //           correct: data?.validityMonth != null ? true : false),
          //       16.verticalSpace,
          //       planDetails(
          //           title: "Address view feature",
          //           correct: data?.addressViewFeature == "Y" ? true : false),
          //       16.verticalSpace,
          //       planDetails(
          //           title:
          //               "${data?.dailyAddressViewLimit ?? ''} “address views” per day",
          //           correct:
          //               data?.dailyAddressViewLimit != null ? true : false),
          //       16.verticalSpace,
          //       planDetails(
          //           title: "Express your interest feature",
          //           correct:
          //               data?.interestExpressFeature == "Y" ? true : false),
          //       16.verticalSpace,
          //       planDetails(
          //           title:
          //               "${data?.interestExpressCount ?? ''} “interest express feature” per day"),
          //       16.verticalSpace,
          //       planDetails(title: "No service charge"),
          //       16.verticalSpace,
          //       planDetails(title: "Customer support service"),
          //       16.verticalSpace,
          //       planDetails(title: "Profile conversions to, if requested"),
          //     ],
          //   ),
          // );
        } else {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget planDetails({bool correct = true, String? title, String? nextText}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23.w),
      child: Row(
        children: [
          correct
              ? SvgPicture.asset(Assets.iconsTickGreen)
              : SvgPicture.asset(Assets.iconsCloseMd),
          10.72.horizontalSpace,
          Flexible(
            child: Text(
              title ?? "test",
              style: FontPalette.black14Medium
                  .copyWith(color: HexColor("#131A24")),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          nextText != null
              ? Text(
                  "/ $nextText",
                  style: FontPalette.black14Medium
                      .copyWith(color: HexColor("#8695A7")),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 215.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: HexColor("#FFF7FC"),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 75.w, bottom: 13.97.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 7.91.w,
                        height: 11.07.h,
                        child: SvgPicture.asset(Assets.iconsMediumRupeeIcon)),
                    Text(
                      widget.planAmount,
                      // "13,000",
                      style: FontPalette.white18Bold.copyWith(
                          fontSize: 19.sp, color: HexColor("#131A24")),
                    ),
                    Text(
                      "/ ${widget.mont}",
                      // "/ ${widget.mont} month",
                      style: FontPalette.black14Medium.copyWith(
                          fontSize: 13.sp,
                          color: Colors.black.withOpacity(0.54)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 163.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.6, 1],
                colors: [
                  HexColor("#FFF0E3"),
                  HexColor("#F8D5FF").withOpacity(0.8),
                ],
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 20.verticalSpace, -- original
              35.verticalSpace,
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 5.h),
                  child: Container(
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
                      )),
                ),
              ).removeSplash(),
              // Padding(
              //   padding: EdgeInsets.only(left: 8.w), // here there is no padding as per UI/UX
              //   child: ReusableWidgets.roundedBackButton(context,size: 43),
              // ),
              23.verticalSpace,
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 23.w),
                    child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.2, 1],
                              colors: [
                                HexColor("#950053"),
                                HexColor("#FC93D9").withOpacity(0.8),
                              ],
                            )),
                        child: SizedBox(
                          height: 12.65.h,
                          width: 15.81.w,
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.iconsWhiteCrown,
                              height: 12.65.h,
                              width: 15.81.w,
                            ),
                          ),
                        )),
                  ),
                  17.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.planName,
                        // "Royal Delight",
                        style: FontPalette.black10Bold.copyWith(
                            fontSize: 20.sp, color: ColorPalette.primaryColor),
                      ),
                      Text(
                        widget.description,
                        style: FontPalette.black14Medium.copyWith(
                            fontSize: 14.sp,
                            color: HexColor("#131A24").withOpacity(0.50)),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
