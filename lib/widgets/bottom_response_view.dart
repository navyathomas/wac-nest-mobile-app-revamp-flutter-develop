import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';

import '../views/error_views/error_tile.dart';

class BottomResView extends StatelessWidget {
  final Widget child;
  final LoaderState loaderState;
  final bool isEmpty;
  final Errors? errors;
  final VoidCallback? onTap;
  const BottomResView(
      {Key? key,
      required this.child,
      required this.loaderState,
      required this.isEmpty,
      this.errors,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (loaderState) {
      case LoaderState.loading:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: ReusableWidgets.circularIndicator(),
        );
      case LoaderState.loaded:
        return isEmpty
            ? ErrorTile(
                errors: Errors.noDatFound,
                onTap: onTap,
              )
            : child;
      case LoaderState.networkErr:
        return ErrorTile(
          errors: Errors.networkError,
          onTap: onTap,
        );
      case LoaderState.error:
        return ErrorTile(
          errors: Errors.serverError,
          onTap: onTap,
        );
      case LoaderState.noData:
        return ErrorTile(
          errors: errors ?? Errors.noDatFound,
          onTap: onTap,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
