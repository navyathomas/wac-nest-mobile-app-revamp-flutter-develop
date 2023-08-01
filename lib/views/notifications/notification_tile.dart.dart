import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/notification_reponse_model.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:octo_image/octo_image.dart';

import '../../generated/assets.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';

class NotificationTile extends StatelessWidget {
  NotificationTile(
      {Key? key,
      required this.notificationData,
      this.onTap,
      this.isRedDot = false})
      : super(key: key);
  final NotificationUserData notificationData;
  Function()? onTap;
  bool isRedDot;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: double.maxFinite,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 13.h,
            left: 16.w,
            right: 16.w,
          ),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isRedDot
                    ? Container(
                        height: 5.h,
                        width: 5.w,
                        margin: EdgeInsets.only(top: 5.h),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: HexColor('#FC0000')),
                      )
                    : const SizedBox.shrink(),
                OctoImage(
                  alignment: Alignment.topCenter,
                  image: NetworkImage(
                      (notificationData.user?.userProfileImage?.imageFile ?? '')
                          .thumbImagePath(context)),
                  placeholderBuilder: (context) => Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                        color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
                        shape: BoxShape.circle),
                  ),
                  errorBuilder: (context, _, __) =>
                      SvgPicture.asset(Assets.iconsNoImageIcon),
                  imageBuilder: OctoImageTransformer.circleAvatar(),
                  fit: BoxFit.cover,
                  height: 44.h,
                  width: 44.w,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      Text.rich(
                        TextSpan(
                            text: notificationData.user?.name ?? '',
                            style: FontPalette.black13SemiBold
                                .copyWith(fontSize: 14.sp),
                            children: [
                              TextSpan(
                                text: '\t${(notificationData.notificationMsg ?? '').trim().replaceAll('', '\u200B')}',
                                style: FontPalette.black14Medium.copyWith(
                                    fontSize: 14.sp,
                                    color: HexColor('#565F6C')),
                              )
                            ]),
                        maxLines: 2,
                        strutStyle: StrutStyle(
                          height: 1.5.h
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.verticalSpace,
                      Text(
                        Jiffy(notificationData.createdAt).from(DateTime.now()),
                        style: FontPalette.black10Medium.copyWith(
                            fontSize: 11.sp, color: HexColor("#8695A7")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //PROFILE SECTION
            20.verticalSpace,
            ReusableWidgets.horizontalLine(density: 1.h)
          ])),
    );
  }
}
