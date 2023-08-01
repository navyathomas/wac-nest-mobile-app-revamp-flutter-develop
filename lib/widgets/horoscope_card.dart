import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';

class HoroscopeCard extends StatelessWidget {
  final Map<int, List<String>>? horoscopeData;
  final String? title;
  const HoroscopeCard({Key? key, this.title, this.horoscopeData})
      : super(key: key);

  static Color lineColor = HexColor('#C1C9D2');
  Widget _box(double height,
      {bool disableRightBorder = false,
      bool disableBottomBorder = false,
      Widget? child}) {
    return Container(
      height: height,
      width: double.maxFinite,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: disableRightBorder ? Colors.transparent : lineColor),
              bottom: BorderSide(
                  color:
                      disableBottomBorder ? Colors.transparent : lineColor))),
      child: child,
    );
  }

  Widget _boxContainer(double width, int boxId,
      {bool disableRightBorder = false, bool disableBottomBorder = false}) {
    Map<int, List<String>> value = horoscopeData ?? {};
    List<String> data = value[boxId] ?? [];
    return _box(width * 0.7,
        disableRightBorder: disableRightBorder,
        disableBottomBorder: disableBottomBorder,
        child: Center(
          child: Wrap(
            direction: Axis.vertical,
            runSpacing: 8.w,
            children: List.generate(
                data.length,
                (subIndex) => Text(
                      data[subIndex],
                      style: FontPalette.f565F6C_14Medium,
                    )),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth / 4;
      return Container(
        decoration: BoxDecoration(border: Border.all(color: lineColor)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _boxContainer(width, 12)),
                Expanded(child: _boxContainer(width, 1)),
                Expanded(child: _boxContainer(width, 2)),
                Expanded(
                    child: _boxContainer(width, 3, disableRightBorder: true))
              ],
            ),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _boxContainer(width, 11),
                      _boxContainer(width, 10)
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: _box((width * 0.7) * 2,
                      child: Center(
                        child: Text(
                          title ?? '',
                          textAlign: TextAlign.center,
                          style: FontPalette.f565F6C_14Medium,
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _boxContainer(width, 4, disableRightBorder: true),
                      _boxContainer(width, 5, disableRightBorder: true)
                    ],
                  )),
            ]),
            Row(
              children: [
                Expanded(
                    child: _boxContainer(width, 9, disableBottomBorder: true)),
                Expanded(
                    child: _boxContainer(width, 8, disableBottomBorder: true)),
                Expanded(
                    child: _boxContainer(width, 7, disableBottomBorder: true)),
                Expanded(
                    child: _boxContainer(width, 6, disableBottomBorder: true))
              ],
            ),
          ],
        ),
      );
    });
  }
}
