import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';

class ProfileInfoListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final double matchPer;
  final String? imagePath;
  final bool? isMale;
  final double? height;
  const ProfileInfoListTile(
      {Key? key,
      this.child,
      this.onTap,
      this.matchPer = 0.0,
      this.height,
      required this.imagePath,
      required this.isMale})
      : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height:
            (height ?? 154.h) + (30 * Helpers.validateScale(context, 0.0)).h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HexColor('#DBE2EA')),
            borderRadius: BorderRadius.circular(9.r)),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: imagePath == null
                        ? ProfileImagePlaceHolder(
                            isMale: isMale,
                            width: 130.w,
                          )
                        : ProfileImageView(
                            image: (imagePath ?? '').thumbImagePath(context),
                            isMale: isMale,
                            width: 130.w,
                            height: double.maxFinite,
                            boxFit: BoxFit.cover,
                          )),
                if (matchPer > 0.0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 9.w),
                    margin: EdgeInsets.only(bottom: 6.h),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3)),
                        ]),
                    child: Text.rich(
                      TextSpan(
                        text: '$matchPer%',
                        style: FontPalette.white_12Bold,
                        children: [
                          WidgetSpan(
                            child: 4.horizontalSpace,
                          ),
                          TextSpan(
                              text: context.loc.match,
                              style: FontPalette.black12semiBold.copyWith(
                                  color: Colors.white.withOpacity(0.7)))
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.8.h),
              child: child,
            ))
          ],
        ),
      ),
    ).removeSplash(color: Colors.transparent);
  }
}
