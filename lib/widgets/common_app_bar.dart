import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

import '../utils/color_palette.dart';

class CommonAppBar extends AppBar {
  final String? pageTitle;
  final bool? enableNavBAck;
  final double? elevationVal;
  final Widget? titleWidget;
  final BuildContext buildContext;
  final List<Widget>? actionList;
  final bool disableWish;

  CommonAppBar({
    Key? key,
    this.pageTitle,
    this.enableNavBAck,
    this.elevationVal,
    required this.buildContext,
    this.titleWidget,
    this.actionList,
    this.disableWish = false,
  }) : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          leading: ReusableWidgets.roundedBackButton(buildContext),
          backgroundColor: Colors.white,
          elevation: elevationVal ?? 0,
          shadowColor: HexColor('#D9E3E3'),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleSpacing: 0,
          title: titleWidget ??
              Text(
                pageTitle ?? '',
                style: FontPalette.f131A24_16Bold,
              ),
          automaticallyImplyLeading: enableNavBAck ?? true,
          actions: actionList,
        );
}
