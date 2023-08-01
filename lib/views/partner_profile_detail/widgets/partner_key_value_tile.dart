import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class PartnerKeyValueTile extends StatefulWidget {
  final String? trailing;
  final String? leading;
  final String? leadingIcon;
  const PartnerKeyValueTile(
      {Key? key, this.trailing, this.leading, this.leadingIcon})
      : super(key: key);

  @override
  State<PartnerKeyValueTile> createState() => _PartnerKeyValueTileState();
}

class _PartnerKeyValueTileState extends State<PartnerKeyValueTile> {
  ValueNotifier<bool> enableMore = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    if (widget.trailing == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Row(
            children: [
              if (!widget.leadingIcon.isNull)
                Padding(
                  padding: EdgeInsets.only(right: 7.w),
                  child: SvgPicture.asset(
                    widget.leadingIcon!,
                    width: 11.r,
                    height: 11.r,
                  ),
                ),
              Expanded(
                child: Text(
                  widget.leading ?? '',
                  textAlign: TextAlign.start,
                  style: FontPalette.f565F6C_14Medium,
                ),
              ),
            ],
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: enableMore,
                    builder: (context, value, _) {
                      return Text(
                        CommonFunctions.reAssignText(widget.trailing ?? '',
                            enableMore: value),
                        maxLines: value ? null : 4,
                        style: FontPalette.f131A24_14Medium,
                      );
                    }),
                if ((widget.trailing ?? '').length > 50)
                  InkWell(
                      onTap: () => enableMore.value = !enableMore.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: ValueListenableBuilder<bool>(
                            valueListenable: enableMore,
                            builder: (context, value, _) {
                              return (value
                                      ? Text(
                                          context.loc.viewLess,
                                          style: FontPalette.black14Bold
                                              .copyWith(
                                                  color: HexColor('#2995E5')),
                                        )
                                      : Text(context.loc.viewMore,
                                          style: FontPalette.black14Bold
                                              .copyWith(
                                                  color: HexColor('#2995E5'))))
                                  .animatedSwitch();
                            }),
                      ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
