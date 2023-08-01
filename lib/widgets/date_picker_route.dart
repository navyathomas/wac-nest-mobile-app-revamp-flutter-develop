import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

Future<DateTime?> showCustomTimePicker(
  BuildContext context, {
  bool showTitleActions = true,
  bool showSecondsColumn = true,
  DateChangedCallback? onChanged,
  DateChangedCallback? onConfirm,
  DateCancelledCallback? onCancel,
  locale = LocaleType.en,
  DateTime? currentTime,
  DatePickerTheme? theme,
}) async {
  return await Navigator.push(
    context,
    _DatePickerRoute(
      showTitleActions: showTitleActions,
      onChanged: onChanged,
      onConfirm: onConfirm,
      onCancel: onCancel,
      locale: locale,
      theme: theme,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pickerModel: TimePickerModel(
        currentTime: currentTime,
        locale: locale,
        showSecondsColumn: showSecondsColumn,
      ),
    ),
  );
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    DatePickerTheme? theme,
    this.barrierLabel,
    this.locale,
    RouteSettings? settings,
    BasePickerModel? pickerModel,
  })  : pickerModel = pickerModel ?? DatePickerModel(),
        theme = theme ?? const DatePickerTheme(),
        super(settings: settings);

  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final LocaleType? locale;
  final DatePickerTheme theme;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: locale,
        route: this,
        pickerModel: pickerModel,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class _DatePickerComponent extends StatefulWidget {
  const _DatePickerComponent({
    Key? key,
    required this.route,
    required this.pickerModel,
    this.onChanged,
    this.locale,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final LocaleType? locale;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  late FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    leftScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = widget.route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                widget.route.animation!.value,
                theme,
                showTitleActions: widget.route.showTitleActions!,
                bottomPadding: bottomPadding,
              ),
              child: GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(theme),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.pickerModel.finalTime()!);
    }
  }

  Widget _renderPickerView(DatePickerTheme theme) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions == true) {
      return Column(
        children: <Widget>[
          itemView,
          WidgetExtension.horizontalDivider(
              color: HexColor('#E4E7E8'), height: 1.h),
          Expanded(child: _renderTitleActionsView(theme)),
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
    ValueKey key,
    DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: EdgeInsets.all(8.r),
        height: 170.h,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollEndNotification &&
                notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics =
                  notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
            onSelectedItemChanged: (int index) {
              selectedChangedWhenScrolling(index);
            },
            useMagnifier: true,
            itemBuilder: (BuildContext context, int index) {
              final content = stringAtIndexCB(index);
              if (content == null) {
                return null;
              }
              return Container(
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: theme.itemStyle,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _renderItemView(DatePickerTheme theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(28.r), topLeft: Radius.circular(28.r)),
        color: theme.backgroundColor,
      ),
      child: Column(
        children: [
          Container(
            height: 5.h,
            width: 50.w,
            margin: EdgeInsets.symmetric(vertical: 9.h),
            decoration: BoxDecoration(
                color: HexColor('#C1C9D2'),
                borderRadius: BorderRadius.circular(100.r)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
            child: Text(
              context.loc.chooseTime,
              style:
                  FontPalette.white16Bold.copyWith(color: HexColor('#131A24')),
            ),
          ),
          WidgetExtension.horizontalDivider(
              color: HexColor('#E4E7E8'), height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: widget.pickerModel.layoutProportions()[0] > 0
                    ? _renderColumnView(
                        ValueKey(widget.pickerModel.currentLeftIndex()),
                        theme,
                        widget.pickerModel.leftStringAtIndex,
                        leftScrollCtrl,
                        widget.pickerModel.layoutProportions()[0], (index) {
                        widget.pickerModel.setLeftIndex(index);
                      }, (index) {
                        setState(() {
                          refreshScrollOffset();
                          _notifyDateChanged();
                        });
                      })
                    : null,
              ),
              Text(
                widget.pickerModel.leftDivider(),
                style: theme.itemStyle,
              ),
              Container(
                child: widget.pickerModel.layoutProportions()[1] > 0
                    ? _renderColumnView(
                        ValueKey(widget.pickerModel.currentLeftIndex()),
                        theme,
                        widget.pickerModel.middleStringAtIndex,
                        middleScrollCtrl,
                        widget.pickerModel.layoutProportions()[1], (index) {
                        widget.pickerModel.setMiddleIndex(index);
                      }, (index) {
                        setState(() {
                          refreshScrollOffset();
                          _notifyDateChanged();
                        });
                      })
                    : null,
              ),
              Text(
                widget.pickerModel.rightDivider(),
                style: theme.itemStyle,
              ),
              Container(
                child: widget.pickerModel.layoutProportions()[2] > 0
                    ? _renderColumnView(
                        ValueKey(widget.pickerModel.currentMiddleIndex() * 100 +
                            widget.pickerModel.currentLeftIndex()),
                        theme,
                        widget.pickerModel.rightStringAtIndex,
                        rightScrollCtrl,
                        widget.pickerModel.layoutProportions()[2], (index) {
                        widget.pickerModel.setRightIndex(index);
                      }, (index) {
                        setState(() {
                          refreshScrollOffset();
                          _notifyDateChanged();
                        });
                      })
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView(DatePickerTheme theme) {
    final done = _localeDone();
    final cancel = _localeCancel();

    return Container(
      height: theme.titleHeight,
      color: theme.headerColor ?? theme.backgroundColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 60,
              child: CupertinoButton(
                pressedOpacity: 0.3,
                padding: EdgeInsets.only(left: 16.w, top: 0),
                child: Text(
                  cancel,
                  style: FontPalette.white16Bold
                      .copyWith(color: HexColor('#131A24')),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.route.onCancel != null) {
                    widget.route.onCancel!();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 60,
              child: CupertinoButton(
                pressedOpacity: 0.3,
                padding: EdgeInsets.only(right: 16.w, top: 0),
                child: Text(done,
                    style: FontPalette.white16Bold
                        .copyWith(color: ColorPalette.primaryColor)),
                onPressed: () {
                  Navigator.pop(context, widget.pickerModel.finalTime());
                  if (widget.route.onConfirm != null) {
                    widget.route.onConfirm!(widget.pickerModel.finalTime()!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    return i18nObjInLocale(widget.locale)['done'] as String;
  }

  String _localeCancel() {
    return i18nObjInLocale(widget.locale)['cancel'] as String;
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
    this.progress,
    this.theme, {
    this.itemCount,
    this.showTitleActions,
    this.bottomPadding = 0,
  });

  final double progress;
  final int? itemCount;
  final bool? showTitleActions;
  final DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = 260.h;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
