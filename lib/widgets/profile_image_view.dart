import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:octo_image/octo_image.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';

/*class ProfileImageView extends StatelessWidget {
  final String image;
  final bool? isCircular;
  final BoxFit? boxFit;
  final bool? isMale;
  final double? height;
  final double? width;
  const ProfileImageView(
      {Key? key,
      required this.image,
      this.boxFit,
      this.isCircular,
      this.isMale,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
      decoration: BoxDecoration(
        color: ColorPalette.shimmerColor,
        shape: (isCircular ?? false) ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: (isCircular ?? false) ? ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: FadeInImage.assetNetwork(
          alignment: Alignment.topCenter,
          placeholder: Assets.imagesSolidGreyImage,
          image: image,
          fit: boxFit ?? BoxFit.cover,
          height: double.maxFinite,
          width: double.maxFinite,
          placeholderFit: boxFit ?? BoxFit.cover,
          imageErrorBuilder: (_, __, ___) => isMale == null
              ? Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: ColorPalette.shimmerColor,
          )
              : (isCircular ?? false)
              ? ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: isMale.genderPlaceHolder,
          )
              : isMale.genderPlaceHolder,
          placeholderErrorBuilder: (_, __, ___) => Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
                shape:
                (isCircular ?? false) ? BoxShape.circle : BoxShape.rectangle),
          ),
        ),
      ) : FadeInImage.assetNetwork(
        alignment: Alignment.topCenter,
        placeholder: Assets.imagesSolidGreyImage,
        image: image ,
        fit: boxFit ?? BoxFit.cover,
        height: double.maxFinite,
        width: double.maxFinite,
        placeholderFit: boxFit ?? BoxFit.cover,
        imageErrorBuilder: (_, __, ___) => isMale == null
            ? Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: ColorPalette.shimmerColor,
              )
            : (isCircular ?? false)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: isMale.genderPlaceHolder,
                  )
                : isMale.genderPlaceHolder,
        placeholderErrorBuilder: (_, __, ___) => Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
              shape:
                  (isCircular ?? false) ? BoxShape.circle : BoxShape.rectangle),
        ),
      ),
    );
  }
}*/

class ProfileImageView extends StatelessWidget {
  final String image;
  final double? height;
  final bool isCircular;
  final BoxFit? boxFit;
  final bool? isMale;
  final double? width;

  const ProfileImageView(
      {Key? key,
      required this.image,
      this.height,
      this.isMale,
      this.width,
      this.boxFit,
      this.isCircular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCircular
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: CachedNetworkImage(
              alignment: Alignment.topCenter,
              imageUrl: image,
              placeholder: (context, _) => Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle),
              ),
              errorWidget: (context, _, __) => isMale == null
                  ? Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: ColorPalette.shimmerColor,
                    )
                  : isCircular
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: isMale.genderPlaceHolder,
                        )
                      : isMale.genderPlaceHolder,
              fit: boxFit ?? BoxFit.cover,
              height: height ?? double.maxFinite,
              width: width ?? double.maxFinite,
            ),
          )
        : CachedNetworkImage(
            alignment: Alignment.topCenter,
            imageUrl: image,
            placeholder: (context, _) => Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
                  shape: isCircular ? BoxShape.circle : BoxShape.rectangle),
            ),
            errorWidget: (context, _, __) => isMale == null
                ? Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: ColorPalette.shimmerColor,
                  )
                : isCircular
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: isMale.genderPlaceHolder,
                      )
                    : isMale.genderPlaceHolder,
            fit: boxFit ?? BoxFit.cover,
            height: height ?? double.maxFinite,
            width: width ?? double.maxFinite,
          );
  }
}

class ProfileImagePlaceHolder extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? isMale;
  final bool isCircle;
  const ProfileImagePlaceHolder({
    Key? key,
    this.height,
    this.width,
    this.isMale,
    this.isCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
      child: isMale == null
          ? Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: ColorPalette.shimmerColor,
            )
          : isCircle
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: isMale!.genderPlaceHolder,
                )
              : isMale!.genderPlaceHolder,
    );
  }
}

class ProfileImageTestView extends StatelessWidget {
  final String image;
  final double? height;
  final bool isCircular;
  final BoxFit? boxFit;
  final bool? isMale;
  final double? width;

  const ProfileImageTestView(
      {Key? key,
      required this.image,
      this.height,
      this.isMale,
      this.width,
      this.boxFit,
      this.isCircular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
      child: Image.network(
        image,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, _, __) => Container(
          height: double.maxFinite,
          width: double.maxFinite,
        ),
        alignment: Alignment.topCenter,
        fit: boxFit ?? BoxFit.cover,
      ),
    );
    return OctoImage(
      alignment: Alignment.topCenter,
      image: NetworkImage(image),
      placeholderBuilder: (context) => Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle),
      ),
      errorBuilder: (context, _, __) => isMale == null
          ? Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: ColorPalette.shimmerColor,
            )
          : isCircular
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: isMale.genderPlaceHolder,
                )
              : isMale.genderPlaceHolder,
      imageBuilder: isCircular ? OctoImageTransformer.circleAvatar() : null,
      fit: boxFit ?? BoxFit.cover,
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
    );
  }
}
