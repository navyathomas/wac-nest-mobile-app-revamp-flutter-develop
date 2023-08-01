import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

class ChatTile extends StatelessWidget {
  final String? name;
  final String? profileImage;
  final String? time;
  final String? msg;
  final String? createdBy;
  ChatTile(
      {Key? key,
      this.name,
      this.profileImage,
      this.time,
      this.msg,
      this.createdBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: createdBy == '1'
                    ? Image.network(
                        profileImage!,
                        errorBuilder: (context, error, stackTrace) {
                          return SvgPicture.asset(Assets.iconsNoImageIcon);
                        },
                      )
                    : SvgPicture.asset(Assets.iconsNoImageIcon),
              ),
              15.horizontalSpace,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name ?? '',
                            style: FontPalette.black14Bold
                                .copyWith(color: HexColor("#132031")),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          Jiffy(time).fromNow(),
                          // Jiffy(time).format('hh:mm a'),
                          style: FontPalette.black12Medium
                              .copyWith(color: HexColor("#8695A7")),
                        ),
                      ],
                    ),
                    7.verticalSpace,
                    Text(
                      msg ?? '',
                      style: FontPalette.black14Medium
                          .copyWith(color: HexColor("#131A24")),
                    ),
                  ],
                ),
              )
            ],
          ),
          10.verticalSpace,
          ReusableWidgets.horizontalLine(density: 1.h),
          15.verticalSpace
        ],
      ),
    );
  }
}
