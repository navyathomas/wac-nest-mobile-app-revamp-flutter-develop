import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/address_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_btn_view.dart';
import 'package:nest_matrimony/widgets/empty_app_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../models/basic_detail_model.dart';
import '../../models/profile_detail_default_model.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/partner_detail_provider.dart';
import '../../services/widget_handler/data_collection_alert_handler.dart';
import '../../widgets/reusable_widgets.dart';
import 'widgets/partner_detail_address_card.dart';
import 'widgets/partner_detail_body_view.dart';
import 'widgets/partner_detail_bottom_sheets.dart';
import 'widgets/partner_detail_card_bottom_icons.dart';
import 'widgets/partner_image_card.dart';

class PartnerProfileDetailScreen extends StatefulWidget {
  final ProfileDetailArguments? profileDetailArguments;

  const PartnerProfileDetailScreen({Key? key, this.profileDetailArguments})
      : super(key: key);

  @override
  State<PartnerProfileDetailScreen> createState() =>
      _PartnerProfileDetailScreenState();
}

class _PartnerProfileDetailScreenState extends State<PartnerProfileDetailScreen>
    with TickerProviderStateMixin {
  ValueNotifier<bool> enableBottomTile = ValueNotifier(false);
  PageController pageController = PageController();
  late final ScrollController _controller;

  Widget _mainView() {
    return Stack(
      children: [
        NestedScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext cxt, bool innerBoxIsScrolled) {
            CommonFunctions.afterInit(() {
              enableBottomTile.value = innerBoxIsScrolled;
            });
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: (709.h),
                centerTitle: true,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: (innerBoxIsScrolled
                        ? Row(
                            children: [
                              ReusableWidgets.roundedBackButton(context),
                              Expanded(
                                child: Selector<PartnerDetailProvider,
                                    Iterable<ProfileDetailDefaultModel>>(
                                  selector: (context, provider) =>
                                      provider.defaultProfiles.reversed,
                                  builder: (context, value, child) {
                                    if (value.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      value.first.userName ?? '',
                                      textAlign: TextAlign.center,
                                      style: FontPalette.f131A24_16Bold,
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    PartnerDetailBottomSheets.showViewMoreSheet(
                                        context),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 14.w),
                                  child: SvgPicture.asset(
                                    Assets.iconsMoreBlack,
                                    height: 41.r,
                                    width: 41.r,
                                  ),
                                ),
                              )
                            ],
                          )
                        : const SizedBox())
                    .animatedSwitch(),
                floating: false,
                pinned: true,
                snap: false,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    titlePadding: EdgeInsets.zero,
                    background: _BuildCards(
                      buildContext: context,
                    )),
              ),
            ];
          },
          body: PartnerDetailBodyView(
            controller: _controller,
            fetchData: () => _fetchAfterSimilarProfileData(),
            enableBottomTile: enableBottomTile,
          ),
        ),

        /// Bottom button row for image, skip, interest and shortlist
        PartnerDetailBottomBtnView(
          enableBottomTile: enableBottomTile,
          respondBtnNotifier: ValueNotifier(false),
          buildContext: context,
          controller: _controller,
        ),

        /// Stack right, left for switching profiles
        _ScrollButtons(
          buildContext: context,
          onTap: () => CommonFunctions.scrollToTop(_controller),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EmptyAppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Selector<PartnerDetailProvider, LoaderState>(
        selector: (context, provider) => provider.loaderState,
        shouldRebuild: (p0, p1) => p0 != p1,
        builder: (context, value, child) {
          child = _mainView();
          switch (value) {
            case LoaderState.error:
              return CommonErrorView(
                error: Errors.serverError,
                onTap: () {
                  Navigator.pop(context);
                },
              );
            case LoaderState.networkErr:
              return CommonErrorView(
                error: Errors.networkError,
                onTap: () {
                  _fetchData();
                },
              );
            case LoaderState.noData:
              return CommonErrorView(
                error: Errors.noDatFound,
                onTap: () {
                  _fetchData();
                },
              );
            case LoaderState.loaded:
              return child;
            case LoaderState.loading:
              return child;
          }
        },
      )),
    );
  }

  @override
  void initState() {
    _controller = ScrollController();
    CommonFunctions.afterInit(_fetchData);
    /*context.read<PartnerDetailProvider>().checkBasicDetailsUpdated(context,
        onSuccess: () {
      if (mounted) {
        Navigator.popUntil(
          context,
          (route) {
            if (route.settings.name != Constants.dataCollectionAlert) {
              DataCollectionAlertHandler.instance.openBasicDetailAlert(context);
            }
            return true;
          },
        );
      }
    });*/
    _controller.addListener(onScrollListener);
    super.initState();
  }

  void _fetchData() {
    context.read<PartnerDetailProvider>()
      ..resetUsers()
      ..resetAlertStat()
      ..fetchDataFromPages(
          context: context,
          navFrom: widget.profileDetailArguments?.navToProfile,
          index: widget.profileDetailArguments?.index)
      ..updateBasicDetails(context)
      ..getPartnerInterestData();
    context.read<AddressProvider>().getContactAddressModel();
  }

  void _fetchAfterSimilarProfileData() {
    context.read<PartnerDetailProvider>()
      ..resetUsers()
      ..fetchDataFromPages(
          context: context,
          navFrom: widget.profileDetailArguments?.navToProfile,
          index: widget.profileDetailArguments?.index)
      ..getPartnerInterestData();
  }

  void onScrollListener() {
    if (_controller.offset >= (_controller.position.maxScrollExtent)) {
      context.read<PartnerDetailProvider>().profileViewed();
    }
  }
}

class _BuildCards extends StatelessWidget {
  final BuildContext? buildContext;

  const _BuildCards({Key? key, this.buildContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.pageBgColor,
      child: Container(
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 11.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(19.r),
                bottomRight: Radius.circular(19.r))),
        child: Column(
          children: [
            SizedBox(
              height: 631.h,
              child: Selector<PartnerDetailProvider,
                  List<ProfileDetailDefaultModel>>(
                selector: (context, provider) => provider.defaultProfiles,
                builder: (context, defaultProfiles, child) {
                  return Stack(
                    children: [
                      Stack(
                        fit: StackFit.expand,
                        children: defaultProfiles.isEmpty
                            ? [
                                Container(
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.shimmerColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                )
                              ]
                            : defaultProfiles
                                .map((ProfileDetailDefaultModel
                                        defaultProfile) =>
                                    PartnerImageCard(
                                      profileDetailDefaultModel: defaultProfile,
                                      isFront: defaultProfiles.last.id ==
                                          defaultProfile.id,
                                      context: buildContext ?? context,
                                    ))
                                .toList(),
                      ),
                      Positioned(
                        top: 11.5.h,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 6.w, top: 4.h, bottom: 4.h),
                            child: SvgPicture.asset(
                              Assets.iconsTransparentChevronLeft,
                              height: 51.r,
                              width: 51.r,
                            ),
                          ),
                        ),
                      ),

                      /// Photo card button view
                      if (defaultProfiles.isNotEmpty)
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 12.h,
                          child: PartnerDetailCardBottomIcons(
                            buildContext: buildContext,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            10.verticalSpace,

            /// Photo card bottom address view
            const PartnerDetailAddressCard(),
            8.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _ScrollButtons extends StatelessWidget {
  final BuildContext? buildContext;
  final VoidCallback onTap;

  const _ScrollButtons({Key? key, this.buildContext, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Selector<PartnerDetailProvider, int>(
            selector: (context, provider) => provider.currentIndex,
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  onTap();
                  CommonFunctions.addDelay(() {
                    context
                        .read<PartnerDetailProvider>()
                        .sliderLeftCard(buildContext ?? context);
                  });
                },
                child: Container(
                  height: 54.h,
                  width: 41.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10.w, right: 15.w),
                  decoration: BoxDecoration(
                      color:
                          value == 0 ? const Color(0x0d000000) : Colors.black26,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50.r),
                          bottomRight: Radius.circular(50.r))),
                  child: SvgPicture.asset(Assets.iconsChevronRightWhite),
                ),
              );
            },
          ),
          Selector<PartnerDetailProvider, List<ProfileDetailDefaultModel>>(
            selector: (context, provider) => provider.defaultProfiles,
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  onTap();
                  CommonFunctions.addDelay(() {
                    context
                        .read<PartnerDetailProvider>()
                        .sliderRightCard(buildContext ?? context);
                  });
                },
                child: Container(
                  height: 54.h,
                  width: 41.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  decoration: BoxDecoration(
                      color: value.length == 1
                          ? const Color(0x0d000000)
                          : Colors.black26,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          bottomLeft: Radius.circular(50.r))),
                  child: SvgPicture.asset(Assets.iconsChevronLeftWhite),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
