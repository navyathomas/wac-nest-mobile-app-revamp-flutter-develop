import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

class AgeScrollWheel extends StatefulWidget {
  final int initialIndex;
  AgeScrollWheel({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<AgeScrollWheel> createState() => _AgeScrollWheelState();
}

class _AgeScrollWheelState extends State<AgeScrollWheel> {
  Widget shadowWidget(int index, int value) {
    if (index == value) {
      return const SizedBox();
    } else if (index - 1 == value) {
      return Container(
          height: 61.r,
          width: 61.r,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white24,
                    Colors.white38,
                    Colors.white.withOpacity(0.7),
                  ])));
    } else if (index + 1 == value) {
      return Container(
        height: 61.r,
        width: 61.r,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white54,
                  Colors.white38
                ])),
      );
    } else {
      return Container(
        height: 61.r,
        width: 61.r,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.6),
                  Colors.white60
                ])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> ageList = context.read<RegistrationProvider>().ageList;
    return GestureDetector(
      onHorizontalDragDown: (val) {
        context.read<RegistrationProvider>().updateInterruptAgeScroll(false);
      },
      child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 61.r,
            diameterRatio: 10,
            onSelectedItemChanged: (x) {
              RegistrationHandlerClass().selectedAgeValue!.value = x;
              context
                  .read<RegistrationProvider>()
                  .updateDateFromAge(ageList[x]);
            },
            physics: const FixedExtentScrollPhysics(),
            controller: RegistrationHandlerClass().ageScrollController,
            childDelegate: ListWheelChildLoopingListDelegate(
                children: List.generate(ageList.length, (index) {
              return RotatedBox(
                  quarterTurns: 1,
                  child: ValueListenableBuilder<int>(
                      valueListenable:
                          RegistrationHandlerClass().selectedAgeValue!,
                      builder: (context, value, _) {
                        return Stack(
                          children: [
                            AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 61.r,
                                height: 61.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: index == value
                                        ? HexColor('#FFDEF4')
                                        : Colors.white,
                                    shape: BoxShape.circle),
                                child: Text(
                                  '${ageList[index]}',
                                  style: FontPalette.black20SemiBold
                                      .copyWith(color: HexColor('#131A24')),
                                )),
                            shadowWidget(index, value)
                          ],
                        );
                      }));
            })),
          )),
    );
  }

  @override
  void initState() {
    RegistrationHandlerClass().initializeAgeWheel(widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    RegistrationHandlerClass().disposeAgeWheel();
    super.dispose();
  }
}
