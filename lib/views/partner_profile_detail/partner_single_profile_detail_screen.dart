import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/address_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_detail_bottom_btn_view.dart';
import 'package:nest_matrimony/widgets/empty_app_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../models/profile_detail_default_model.dart';
import '../../providers/partner_detail_provider.dart';
import '../../providers/profile_handler_provider.dart';
import '../../widgets/reusable_widgets.dart';
import 'widgets/partner_detail_address_card.dart';
import 'widgets/partner_detail_body_view.dart';
import 'widgets/partner_detail_bottom_sheets.dart';
import 'widgets/partner_detail_card_bottom_icons.dart';
import 'widgets/partner_detail_respond_bottom_tile.dart';
import 'widgets/partner_image_card.dart';

class PartnerSingleProfileDetailScreen extends StatefulWidget {
  final RouteArguments? routeArguments;

  const PartnerSingleProfileDetailScreen({Key? key, this.routeArguments})
      : super(key: key);

  @override
  State<PartnerSingleProfileDetailScreen> createState() =>
      _PartnerSingleProfileDetailScreenState();
}

class _PartnerSingleProfileDetailScreenState
    extends State<PartnerSingleProfileDetailScreen>
    with TickerProviderStateMixin {
  ValueNotifier<bool> enableBottomTile = ValueNotifier(false);
  PageController pageController = PageController();
  late final ScrollController _controller;
  late final bool enableRespondBtn;
  ValueNotifier<bool> respondBtnNotifier = ValueNotifier(true);

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
                      enableRespondBtn: enableRespondBtn,
                      respondBtnNotifier: respondBtnNotifier,
                      navFrom: widget.routeArguments?.navFrom,
                    )),
              ),
            ];
          },
          body: PartnerDetailBodyView(
            controller: _controller,
            fetchData: () => _fetchData(),
            enableBottomTile: enableBottomTile,
          ),
        ),
        PartnerDetailBottomBtnView(
          enableBottomTile: enableBottomTile,
          buildContext: context,
          respondBtnNotifier: respondBtnNotifier,
          enableRespondTile: enableRespondBtn,
          controller: _controller,
          navFrom: widget.routeArguments?.navFrom,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.pageBgColor,
      appBar: const EmptyAppBar(
        backgroundColor: Colors.white,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPalette.primaryColor,
            systemNavigationBarIconBrightness: Brightness.light),
        child: SafeArea(
            bottom: false,
            child: Selector<PartnerDetailProvider, LoaderState>(
              selector: (context, provider) => provider.loaderState,
              builder: (context, value, child) {
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

                  default:
                    return _mainView();
                }
              },
            )),
      ),
    );
  }

  @override
  void initState() {
    _controller = ScrollController();
    if (widget.routeArguments?.navFrom != null &&
        widget.routeArguments?.navFrom == NavFrom.navFromInterests) {
      enableRespondBtn = true;
    } else {
      enableRespondBtn = false;
    }
    _controller.addListener(onScrollListener);
    CommonFunctions.afterInit(_fetchData);
    super.initState();
  }

  void _fetchData() {
    final model = context.read<PartnerDetailProvider>();
    model
      ..resetUsers()
      ..resetAlertStat();
    if (widget.routeArguments?.anyValue != null) {
      model
        ..updateProfileForSingleData(context, widget.routeArguments!.anyValue!)
        ..updateInterestId(widget.routeArguments?.profileId);
    } else {
      model
        ..getPartnerDetailData(context,
            userId: widget.routeArguments?.profileId)
        ..updateInitialProfileId(widget.routeArguments?.profileId ?? -1);
    }
    model.getPartnerInterestData();
    context.read<AddressProvider>().getContactAddressModel();
  }

  void onScrollListener() {
    if (_controller.offset >= (_controller.position.maxScrollExtent)) {
      context.read<PartnerDetailProvider>().profileViewed();
    }
  }
}

class _BuildCards extends StatelessWidget {
  final BuildContext? buildContext;
  final bool enableRespondBtn;
  final NavFrom? navFrom;
  final ValueNotifier<bool> respondBtnNotifier;

  const _BuildCards(
      {Key? key,
      this.buildContext,
      required this.enableRespondBtn,
      this.navFrom,
      required this.respondBtnNotifier})
      : super(key: key);

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
                shouldRebuild: (_, __) => true,
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
                      if (defaultProfiles.isNotEmpty)
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 12.h,
                          child: enableRespondBtn
                              ? PartnerDetailRespondCardBottomTile(
                                  buildContext: buildContext,
                                  respondBtnNotifier: respondBtnNotifier)
                              : PartnerDetailCardBottomIcons(
                                  buildContext: buildContext,
                                  navFrom: navFrom,
                                ),
                        ),
                    ],
                  );
                },
              ),
            ),
            10.verticalSpace,
            const PartnerDetailAddressCard(),
            8.verticalSpace,
          ],
        ),
      ),
    );
  }
}
