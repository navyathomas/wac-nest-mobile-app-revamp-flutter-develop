import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/search_filter/widgets/slider_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/age_data_list_model.dart';
import '../../../models/height_data_model.dart';
import '../../../providers/app_data_provider.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/tuple.dart';

class SearchAgeSlider extends StatelessWidget {
  final ValueNotifier<RangeValues>? ageSliderRange;
  const SearchAgeSlider({Key? key, this.ageSliderRange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, HeightDataModel?>(
      selector: (context, provider) => provider.heightDataModel,
      builder: (context, value, child) {
        child = Selector<AppDataProvider, AgeDataListModel?>(
            selector: (context, provider) => provider.ageDataListModel,
            builder: (context, value, child) {
              child = Padding(
                padding: EdgeInsets.only(top: 21.h),
                child: Selector<SearchFilterProvider,
                    Tuple4<double, double, double, double>>(
                  selector: (context, provider) => Tuple4(provider.minAgeRange,
                      provider.maxAgeRange, provider.minAge, provider.maxAge),
                  builder: (context, ageVal, selectorChild) {
                    return SliderTile(
                      key: UniqueKey(),
                      leadingTxt: context.loc.ageBetweenYrs,
                      trailingText: ValueListenableBuilder<RangeValues>(
                          valueListenable: ageSliderRange ??
                              ValueNotifier(const RangeValues(18, 70)),
                          builder: (context, value, _) {
                            return Text.rich(
                                textAlign: TextAlign.right,
                                TextSpan(
                                    text: '${value.start.floor()}',
                                    style: FontPalette.f131A24_16SemiBold,
                                    children: [
                                      TextSpan(
                                        text: " - ${value.end.floor()}",
                                        style: FontPalette.f131A24_16SemiBold,
                                      ),
                                    ]));
                          }),
                      minValue: ageVal.item1,
                      maxValue: ageVal.item2,
                      rangeValues: RangeValues(
                          ageSliderRange?.value.start ?? 18,
                          ageSliderRange?.value.end ?? 70),
                      onChange: (start, end) {
                        Future.microtask(() {
                          ageSliderRange!.value = RangeValues(start, end);
                        });
                      },
                    );
                  },
                ),
              );
              return WidgetExtension.crossSwitch(
                value: (value?.data?.ageList ?? []).isNotEmpty,
                curvesIn: Curves.easeIn,
                curvesOut: Curves.easeOut,
                first: child,
              );
            });
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
