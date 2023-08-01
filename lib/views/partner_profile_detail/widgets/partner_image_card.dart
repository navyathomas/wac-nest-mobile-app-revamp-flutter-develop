import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/common_alert_view.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../alert_views/data_collection_alert.dart';
import 'partner_detail_bottom_sheets.dart';

class PartnerImageCard extends StatefulWidget {
  final BuildContext? context;
  final ProfileDetailDefaultModel? profileDetailDefaultModel;
  final bool isFront;

  const PartnerImageCard(
      {Key? key,
      required this.profileDetailDefaultModel,
      this.context,
      required this.isFront})
      : super(key: key);

  @override
  State<PartnerImageCard> createState() => _PartnerImageCardState();
}

class _PartnerImageCardState extends State<PartnerImageCard>
    with TickerProviderStateMixin {
  late PageController pageController;
  late AnimationController animatedController;
  ValueNotifier<int> indexNotifier = ValueNotifier(0);
  ValueNotifier<bool> pauseAnimation = ValueNotifier(false);

  Future<List<CachedNetworkImageProvider>> loadAllImages() async {
    List<CachedNetworkImageProvider> cachedImages = [];
    widget.profileDetailDefaultModel?.userImage?.forEach((element) {
      var configuration = createLocalImageConfiguration(context);
      cachedImages.add(CachedNetworkImageProvider(element?.imageFile ?? "")
        ..resolve(configuration));
    });
    return cachedImages;
  }

  Widget _bottomTile() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.profileDetailDefaultModel?.userName ?? '',
                        style: FontPalette.white27Bold,
                      ).avoidOverFlow(maxLine: 3),
                    ),
                    6.horizontalSpace,
                    Selector<PartnerDetailProvider, PartnerDetailModel?>(
                      selector: (context, provider) =>
                          provider.partnerDetailModel,
                      builder: (context, value, child) {
                        String? status = value
                            ?.data?.basicDetails?.profileVerificationStatus;
                        return status != null && status == '1'
                            ? Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: SvgPicture.asset(
                                  Assets.iconsVerifiedPink,
                                  height: 24.r,
                                  width: 24.r,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    )
                  ],
                ),
                6.verticalSpace,
                Text(
                  "${widget.profileDetailDefaultModel?.age != null ? "${widget.profileDetailDefaultModel?.age}YRS, " : ""}${widget.profileDetailDefaultModel?.nestId ?? ''}",
                  style: FontPalette.white13SemiBold,
                ),
                9.verticalSpace,
              ],
            ),
          ),
          Row(
              children: List.generate(
            Constants.partnerCardBtn.length,
            (index) =>
                Expanded(child: LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: SizedBox(
                  height: constraints.maxWidth,
                  width: constraints.maxHeight,
                ),
              );
            })),
          ))
        ],
      ),
    );
  }

  Widget _imageView(String imageUrl) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => _onCardTap(details),
      child: Stack(
        children: [
          imageUrl.isEmpty
              ? ProfileImagePlaceHolder(
                  isMale: widget.profileDetailDefaultModel?.isMale,
                )
              : ProfileImageView(
                  image: imageUrl.fullImagePath(context),
                  boxFit: BoxFit.cover,
                ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 124.h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black38, Colors.transparent])),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 295.h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black])),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: ColoredBox(
        color: Colors.white,
        child: Stack(children: [
          (widget.profileDetailDefaultModel?.userImage ?? []).isEmpty
              ? PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_imageView('')],
                )
              : FutureBuilder<List<CachedNetworkImageProvider>>(
                  future: loadAllImages(),
                  builder: (context, snapshot) {
                    return ((snapshot.hasData &&
                            snapshot.data != null &&
                            (snapshot.data?.isNotEmpty ?? false))
                        ? PageView.builder(
                            controller: pageController,
                            itemCount: snapshot.data?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _imageView(snapshot.data![index].url);
                            })
                        : PageView.builder(
                            controller: pageController,
                            itemCount: widget.profileDetailDefaultModel
                                    ?.userImage?.length ??
                                0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _imageView(widget.profileDetailDefaultModel
                                      ?.userImage?[index].imageFile ??
                                  '');
                            }));
                  }),
          Positioned(bottom: 0, right: 0, left: 0, child: _bottomTile())
        ]),
      ),
    );
  }

  Widget buildStamps() {
    final model = context.read<PartnerDetailProvider>();
    final status = model.getStatus();
    final opacity = model.getStatusOpacity();

    return Selector<PartnerDetailProvider, bool>(
      selector: (context, provider) => provider.hideStatusLabel,
      builder: (context, value, child) {
        if (status == null || value) return const SizedBox.shrink();
        switch (status) {
          case CardStatus.interested:
            return Positioned(
                top: 180.h,
                left: 30.w,
                child: buildStamp(
                    angle: -0.05,
                    color: Colors.green,
                    icon: Assets.iconsInterested,
                    opacity: opacity));
          case CardStatus.skip:
            return Positioned(
                top: 70.h,
                right: context.sw(size: 0.2).w,
                child: buildStamp(
                    angle: 0.1,
                    color: Colors.red,
                    icon: Assets.iconsSkip,
                    opacity: opacity));
          case CardStatus.shortListed:
            return Positioned(
                top: 135.h,
                right: 0,
                left: 0,
                child: buildStamp(
                    color: Colors.blue,
                    icon: Assets.iconsShortlisted,
                    opacity: opacity));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildStamp(
      {double angle = 0,
      required Color color,
      required String icon,
      required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: SvgPicture.asset(icon),
      ),
    );
  }

  Widget statusIndicators() {
    int length = widget.profileDetailDefaultModel?.userImage?.length ?? 0;
    return Positioned(
      top: 7.5.h,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.5.w, right: 8.5.w, bottom: 7.3.h),
            child: SizedBox(
              height: 3.h,
              child: length > 1
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          length,
                          (index) => ValueListenableBuilder<int>(
                                valueListenable: indexNotifier,
                                builder: (context, value, child) {
                                  return _AnimatedStatusBar(
                                      animController: animatedController,
                                      position: index,
                                      currentIndex: value);
                                },
                              )),
                    )
                  : null,
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 56.w),
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19.r),
                    color: Colors.white12),
                child: Row(
                  children: [
                    Container(
                      height: 11.r,
                      width: 11.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: HexColor('#62FF00')),
                    ),
                    6.horizontalSpace,
                    Text(
                      context.loc.online,
                      style: FontPalette.black12semiBold
                          .copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              const Spacer(),
              /*SizedBox(
                height: 58.r,
                width: 55.r,
                child: (widget.profileDetailDefaultModel?.userImage ?? [])
                        .isEmpty
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.routeFullScreenImage,
                              arguments: widget
                                  .profileDetailDefaultModel?.userImage
                                  ?.map((e) => (e.imageFile ?? '').toString())
                                  .toList());
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: SvgPicture.asset(
                            Assets.iconsImageViewAll,
                          ),
                        ),
                      ),
              ),*/
              InkWell(
                onTap: () =>
                    PartnerDetailBottomSheets.showViewMoreSheet(context),
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: SvgPicture.asset(
                    Assets.iconsMore,
                    height: 41.r,
                    width: 41.r,
                  ),
                ),
              ).removeSplash()
              // SvgPicture.asset(Assets.iconsMore, height: 41.r, width: 41.r,)
            ],
          )
        ],
      ),
    );
  }

  Widget buildFrontCard() {
    return LayoutBuilder(builder: (cxt, constraints) {
      return Selector<PartnerDetailProvider, Tuple3<bool, double, Offset>>(
          builder: (_, value, child) {
            bool isDragging = value.item1;
            double angle = value.item2;
            Offset position = value.item3;
            final milliseconds = isDragging ? 0 : 400;
            final rotateAngle = angle * pi / 180;
            final center = constraints.smallest.center(Offset.zero);

            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(rotateAngle)
              ..translate(-center.dx, -center.dy);
            child = Stack(
              children: [buildCard(), statusIndicators(), buildStamps()],
            );
            return GestureDetector(
              onPanStart: (details) {
                context.read<PartnerDetailProvider>()
                  ..startPosition(details)
                  ..checkProfilePhotoUpdated(context);
              },
              onPanUpdate: context.read<PartnerDetailProvider>().updatePosition,
              onPanEnd: (details) {
                context
                    .read<PartnerDetailProvider>()
                    .endPosition(widget.context ?? context);
                pageController.jumpTo(0);
              },
              child: Selector<PartnerDetailProvider, bool>(
                selector: (context, provider) => provider.hideTransform,
                builder: (context, value, _) {
                  return value
                      ? (child ?? const SizedBox.shrink())
                      : AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: milliseconds),
                          transform: rotatedMatrix
                            ..translate(position.dx, position.dy),
                          child: child);
                },
              ),
            );
          },
          selector: (context, provider) =>
              Tuple3(provider.isDragging, provider.angle, provider.position));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  @override
  void initState() {
    initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      context.read<PartnerDetailProvider>().setScreenSize(size);
    });
    super.initState();
  }

  void initializeControllers() {
    pageController = PageController(initialPage: 0);
    animatedController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    //  _loadImage(animateToPage: false);
    if (mounted) _loadImage(animateToPage: false);

    animatedController.addStatusListener((status) {
      int currentIndex = indexNotifier.value;

      if (status == AnimationStatus.completed && !pauseAnimation.value) {
        animatedController.stop();
        animatedController.reset();
        if (currentIndex + 1 <
            (widget.profileDetailDefaultModel?.userImage?.length ?? 0)) {
          indexNotifier.value = currentIndex + 1;
          _loadImage(currentIndex: currentIndex + 1);
        } else {
          indexNotifier.value = currentIndex + 1;
        }
      }
    });
  }

  void _loadImage({bool animateToPage = true, int currentIndex = 0}) {
    animatedController.stop();
    animatedController.reset();
    //  animatedController.duration = const Duration(seconds: 10);
    animatedController.forward();
    if (animateToPage) {
      paginateToNext(currentIndex);
    }
  }

  @override
  void didUpdateWidget(covariant PartnerImageCard oldWidget) {
    if (widget.profileDetailDefaultModel?.id !=
            oldWidget.profileDetailDefaultModel?.id &&
        widget.profileDetailDefaultModel?.userImage != null) {
      indexNotifier.value = 0;
      disposeController();
      initializeControllers();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  void disposeController() {
    pageController.dispose();
    animatedController.dispose();
  }

  void _onCardTap(TapDownDetails details) {
    final dx = details.globalPosition.dx;
    int currentIndex = indexNotifier.value;
    double width = context.sw() - 22.w;
    if (dx < width / 3) {
      if (currentIndex - 1 >= 0) {
        indexNotifier.value = currentIndex - 1;
        _loadImage(currentIndex: currentIndex - 1);
      }
    } else {
      if (currentIndex + 1 <
          (widget.profileDetailDefaultModel?.userImage?.length ?? 0)) {
        indexNotifier.value = currentIndex + 1;
        _loadImage(currentIndex: currentIndex + 1);
      } else {
        indexNotifier.value = 0;
        _loadImage(currentIndex: 0);
      }
    }
  }

  void paginateToNext(int page) {
    if (!pageController.hasClients) return;
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }
}

class _AnimatedStatusBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const _AnimatedStatusBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.26),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 3.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
