import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/color_palette.dart';

class PartnerDetailCardButton extends StatefulWidget {
  final String icon;
  final String selectedIcon;
  final VoidCallback onTap;
  final bool enableBorder;
  final EdgeInsets? padding;
  const PartnerDetailCardButton(
      {Key? key,
      required this.icon,
      required this.onTap,
      this.enableBorder = false,
      this.padding,
      required this.selectedIcon})
      : super(key: key);

  @override
  State<PartnerDetailCardButton> createState() =>
      _PartnerDetailCardButtonState();
}

class _PartnerDetailCardButtonState extends State<PartnerDetailCardButton> {
  ValueNotifier<bool> hovered = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return InkWell(
          onTap: () {
            hovered.value = true;
            Future.delayed(const Duration(milliseconds: 300)).then((value) {
              widget.onTap();
              hovered.value = false;
            });
          },
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            child: ValueListenableBuilder<bool>(
                valueListenable: hovered,
                builder: (context, value, _) {
                  return AnimatedCrossFade(
                      firstChild: SvgPicture.asset(
                        widget.selectedIcon,
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                      ),
                      secondChild: Container(
                          decoration: widget.enableBorder
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: HexColor('#DBE2EA'),
                                  ))
                              : null,
                          child: SvgPicture.asset(
                            widget.icon,
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                          )),
                      firstCurve: Curves.bounceInOut,
                      secondCurve: Curves.bounceInOut,
                      crossFadeState: value
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300));
                }),
          ),
        );
      }),
    );
  }
}
