import 'package:flutter/material.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:octo_image/octo_image.dart';

class CommonImageView extends StatelessWidget {
  final String image;
  final double? height;
  final bool isCircular;
  final Widget? placeHolder;
  final Widget? errorView;
  final BoxFit? boxFit;
  final double? width;
  final Alignment? alignment;

  const CommonImageView(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.alignment,
      this.placeHolder,
      this.errorView,
      this.boxFit,
      this.isCircular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('testimonial image $image');
    return OctoImage(
      alignment: alignment,
      image: NetworkImage(image),
      placeholderBuilder: (context) =>
          placeHolder ??
          Container(
            height: height ?? double.maxFinite,
            width: width ?? double.maxFinite,
            decoration: BoxDecoration(
                color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle),
          ),
      errorBuilder: (context, _, __) =>
          errorView ??
          Container(
            decoration: BoxDecoration(
                color: ColorPalette.shimmerColor,
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle),
            height: height ?? double.maxFinite,
            width: width ?? double.maxFinite,
          ),
      imageBuilder: isCircular ? OctoImageTransformer.circleAvatar() : null,
      fit: boxFit ?? BoxFit.contain,
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
    );
  }
}
