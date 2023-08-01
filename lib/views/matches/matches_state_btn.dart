import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/countries_data_model.dart';
import '../../models/state_data_model.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/matches_provider.dart';
import '../../utils/font_palette.dart';
import '../../utils/tuple.dart';
import '../../widgets/bottom_response_view.dart';
import '../../widgets/custom_radio.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_filter/widgets/custom_option_btn.dart';

class MatchesStateBtn extends StatelessWidget {
  const MatchesStateBtn({Key? key}) : super(key: key);

  Widget _optionContainer(
      BuildContext context, List<StateData>? stateDataList) {
    return ListView.builder(
        itemCount: stateDataList!.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (cxt, index) {
          return InkWell(
            onTap: () {
              context.read<MatchesProvider>()
                ..updateSelectedState(stateDataList[index], isFromSearch: false)
                ..clearDistrictFilterData()
                ..clearDistrictTempFilterData();
              context
                  .read<AppDataProvider>()
                  .getDistrictList(context, stateDataList[index].id ?? -1);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    stateDataList[index].stateName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<MatchesProvider, StateData?>(
                    selector: (context, provider) =>
                        provider.searchFilterValueModel?.stateData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (stateDataList[index].id ?? -2),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MatchesProvider, Tuple2<StateData?, CountryData?>>(
      selector: (context, provider) => Tuple2(
          provider.searchFilterValueModel?.stateData,
          provider.searchFilterValueModel?.countryData),
      builder: (context, providerValue, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.8),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.state,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<StateDataModel?, LoaderState>>(
                  selector: (context, provider) =>
                      Tuple2(provider.stateDataModel, provider.stateListLoader),
                  builder: (cxt, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () => context
                            .read<AppDataProvider>()
                            .getStatesList(providerValue.item2?.id ?? -1),
                        isEmpty: (value.item1?.stateData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.stateData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.state,
          selectedValue: providerValue.item1?.stateName ?? '',
          onTap: providerValue.item2?.id == null
              ? null
              : () {
                  ReusableWidgets.customBottomSheet(
                      context: context, child: childWidget);
                },
        );
      },
    );
  }
}
