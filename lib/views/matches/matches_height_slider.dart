import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:provider/provider.dart';

import '../../common/extensions.dart';
import '../../models/height_data_model.dart';
import '../../providers/app_data_provider.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../utils/tuple.dart';
import '../search_filter/widgets/slider_tile.dart';

class MatchesHeightSlider extends StatelessWidget {
  final ValueNotifier<RangeValues>? heightSliderRange;
  const MatchesHeightSlider({Key? key, this.heightSliderRange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, HeightDataModel?>(
      selector: (context, provider) => provider.heightDataModel,
      builder: (context, value, child) {
        child = Column(
          children: [
            Selector<MatchesProvider, Tuple4<double, double, double, double>>(
              selector: (context, provider) => Tuple4(
                  provider.minHeightRange,
                  provider.maxHeightRange,
                  provider.minHeight,
                  provider.maxHeight),
              builder: (context, heightVal, selectorChild) {
                return SliderTile(
                  key: UniqueKey(),
                  leadingTxt: context.loc.height,
                  trailingText: ValueListenableBuilder<RangeValues>(
                    valueListenable: heightSliderRange ??
                        ValueNotifier(const RangeValues(0.0, 200.0)),
                    builder: (context, value, _) {
                      print("-------------${value.start}");
                      return Text.rich(
                          textAlign: TextAlign.right,
                          TextSpan(
                              text: context
                                  .read<MatchesProvider>()
                                  .getCmInFeet(value.start.ceil()),
                              style: FontPalette.f131A24_16SemiBold,
                              children: [
                                TextSpan(
                                  text:
                                  " (${context.read<MatchesProvider>().getHeightFromId(value.start.ceil())} ${context.loc.cm})",
                                  style: FontPalette.black16SemiBold
                                      .copyWith(color: HexColor('#8695A7')),
                                ),
                                TextSpan(
                                  text:
                                  " - ${context.read<MatchesProvider>().getCmInFeet(value.end.ceil())} ",
                                  style: FontPalette.f131A24_16SemiBold,
                                ),
                                TextSpan(
                                  text:
                                  " (${context.read<MatchesProvider>().getHeightFromId(value.end.ceil())} ${context.loc.cm})",
                                  style: FontPalette.black16SemiBold
                                      .copyWith(color: HexColor('#8695A7')),
                                )
                              ]));
                    },
                  ),
                  minValue: heightVal.item1,
                  maxValue: heightVal.item2,
                  rangeValues: RangeValues(
                      heightSliderRange?.value.start ?? 0.0,
                      heightSliderRange?.value.end ?? 200.0),
                  onChange: (start, end) {
                    Future.microtask(() {
                      heightSliderRange!.value = RangeValues(start, end);
                    });

                    print("--${heightSliderRange!.value.start}");
                  },
                );
              },
            ),
            WidgetExtension.horizontalDivider(
                color: HexColor('#E4E7E8'),
                margin: EdgeInsets.symmetric(horizontal: 2.w)),
          ],
        );
        return WidgetExtension.crossSwitch(
          value: (value?.heightData ?? []).isNotEmpty,
          curvesIn: Curves.easeIn,
          curvesOut: Curves.easeOut,
          first: child,
        );
      },
    );
  }
}
