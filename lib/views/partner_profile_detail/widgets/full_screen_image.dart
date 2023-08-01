import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/empty_app_bar.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> images;
  const FullScreenImage({Key? key, required this.images}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  final TransformationController transformationController =
      TransformationController();
  ValueNotifier<int> pageCount = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 7.h),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      Assets.iconsCloseOutlineWhite,
                      height: 26.r,
                      width: 26.r,
                    )),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: PageView.builder(
                    itemCount: widget.images.length,
                    onPageChanged: (int index) {
                      pageCount.value = index;
                      if (transformationController.value !=
                          Matrix4.identity()) {
                        transformationController.value = Matrix4.identity();
                      }
                    },
                    itemBuilder: (context, index) {
                      return InteractiveImage(
                          transformationController: transformationController,
                          path: widget.images[index].fullImagePath(context),
                          clipBehavior: Clip.none);
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
              margin: EdgeInsets.only(top: 9.h),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(50.r)),
              child: ValueListenableBuilder<int>(
                  valueListenable: pageCount,
                  builder: (context, value, _) {
                    return Text(
                      '${value + 1}/${widget.images.length}',
                      style: FontPalette.white16Medium,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}

class InteractiveImage extends StatelessWidget {
  final Clip clipBehavior;
  final String path;
  final TransformationController transformationController;

  InteractiveImage(
      {Key? key,
      required this.path,
      this.clipBehavior = Clip.hardEdge,
      required this.transformationController})
      : super(key: key);

  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        clipBehavior: clipBehavior,
        transformationController: transformationController,
        minScale: 1.0,
        onInteractionStart: (_) {},
        onInteractionEnd: (details) {
          transformationController.toScene(Offset.zero);
        },
        onInteractionUpdate: (_) => print("Interaction Updated"),
        child: ProfileImageView(
          image: path,
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (transformationController.value != Matrix4.identity()) {
      transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      transformationController.value = Matrix4.identity()
        // ..translate(-position.dx * 2, -position.dy * 2)
        // ..scale(3.0);
        // Fox a 2x zoom
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }
}
