import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/search_filter/widgets/slider_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/height_data_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';

class SearchHeightSlider extends StatelessWidget {
  final ValueNotifier<RangeValues>? heightSliderRange;
  const SearchHeightSlider({Key? key, this.heightSliderRange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, HeightDataModel?>(
      selector: (context, provider) => provider.heightDataModel,
      builder: (context, value, child) {
        child = Column(
          children: [
            Selector<SearchFilterProvider,
                Tuple4<double, double, double, double>>(
              selector: (context, provider) => Tuple4(
                  provider.minHeightRange,
                  provider.maxHeightRange,
                  provider.minHeight,
                  provider.maxHeight),
              builder: (context, heightVal, selectorChild) {
                selectorChild = ValueListenableBuilder<RangeValues>(
                  valueListenable: heightSliderRange ??
                      ValueNotifier(const RangeValues(0.0, 200.0)),
                  builder: (context, value, _) {
                    return Text.rich(
                        textAlign: TextAlign.right,
                        TextSpan(
                            text: context
                                .read<SearchFilterProvider>()
                                .getCmInFeet(value.start.ceil()),
                            style: FontPalette.f131A24_16SemiBold,
                            children: [
                              TextSpan(
                                text:
                                    " (${context.read<SearchFilterProvider>().getHeightFromId(value.start.ceil())} ${context.loc.cm})",
                                style: FontPalette.black16SemiBold
                                    .copyWith(color: HexColor('#8695A7')),
                              ),
                              TextSpan(
                                text:
                                    " - ${context.read<SearchFilterProvider>().getCmInFeet(value.end.ceil())} ",
                                style: FontPalette.f131A24_16SemiBold,
                              ),
                              TextSpan(
                                text:
                                    " (${context.read<SearchFilterProvider>().getHeightFromId(value.end.ceil())} ${context.loc.cm})",
                                style: FontPalette.black16SemiBold
                                    .copyWith(color: HexColor('#8695A7')),
                              )
                            ]));
                  },
                );
                return SliderTile(
                  key: UniqueKey(),
                  leadingTxt: context.loc.height,
                  trailingText: selectorChild,
                  minValue: heightVal.item1,
                  maxValue: heightVal.item2,
                  rangeValues: RangeValues(
                      heightSliderRange?.value.start ?? 0.0,
                      heightSliderRange?.value.end ?? 200.0),
                  onChange: (start, end) {
                    Future.microtask(() {
                      heightSliderRange!.value = RangeValues(start, end);
                    });
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

/*
class SearchHeightSlider extends StatefulWidget {
  final Function(bool, bool)? onChanged;
  const SearchHeightSlider({Key? key, this.onChanged}) : super(key: key);

  @override
  State<SearchHeightSlider> createState() => _SearchHeightSliderState();
}

class _SearchHeightSliderState extends State<SearchHeightSlider> {
  ValueNotifier<RangeValues>? heightSliderRange;
  // SearchHandler searchHandler = SearchHandler();

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, HeightDataModel?>(
      selector: (context, provider) => provider.heightDataModel,
      builder: (context, value, child) {
        child = Column(
          children: [
            Selector<SearchFilterProvider,
                Tuple4<double, double, double, double>>(
              selector: (context, provider) => Tuple4(
                  provider.minHeightRange,
                  provider.maxHeightRange,
                  provider.minHeight,
                  provider.maxHeight),
              builder: (context, heightVal, selectorChild) {
                heightSliderRange ??= ValueNotifier(
                    RangeValues(heightVal.item3, heightVal.item4));
                selectorChild = ValueListenableBuilder<RangeValues>(
                  valueListenable: heightSliderRange ??
                      ValueNotifier(const RangeValues(0.0, 0.0)),
                  builder: (context, value, _) {
                    return Text.rich(
                        textAlign: TextAlign.right,
                        TextSpan(
                            text: context
                                .read<SearchFilterProvider>()
                                .getCmInFeet(value.start.ceil()),
                            style: FontPalette.f131A24_16SemiBold,
                            children: [
                              TextSpan(
                                text:
                                    " (${context.read<SearchFilterProvider>().getHeightFromId(value.start.ceil())} ${context.loc.cm})",
                                style: FontPalette.black16SemiBold
                                    .copyWith(color: HexColor('#8695A7')),
                              ),
                              TextSpan(
                                text:
                                    " - ${context.read<SearchFilterProvider>().getCmInFeet(value.end.ceil())} ",
                                style: FontPalette.f131A24_16SemiBold,
                              ),
                              TextSpan(
                                text:
                                    " (${context.read<SearchFilterProvider>().getHeightFromId(value.end.ceil())} ${context.loc.cm})",
                                style: FontPalette.black16SemiBold
                                    .copyWith(color: HexColor('#8695A7')),
                              )
                            ]));
                  },
                );
                return SliderTile(
                  key: UniqueKey(),
                  leadingTxt: context.loc.height,
                  trailingText: selectorChild,
                  minValue: heightVal.item1,
                  maxValue: heightVal.item2,
                  rangeValues: RangeValues(heightVal.item3, heightVal.item4),
                  onChange: (start, end) {
                    if (onChanged != null) onChanged(start, end);
                    Future.microtask(() {
                      heightSliderRange!.value = RangeValues(start, end);
                    });
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
*/
