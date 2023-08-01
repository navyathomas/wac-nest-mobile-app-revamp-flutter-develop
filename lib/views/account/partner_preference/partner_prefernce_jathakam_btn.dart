import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/body_type_model.dart';
import 'package:nest_matrimony/models/complexion_model.dart';
import 'package:nest_matrimony/models/jathakam_model.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/marital_status_model.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/custom_option_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceJathakamTypeBtn extends StatefulWidget {
  const PartnerPreferenceJathakamTypeBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceJathakamTypeBtn> createState() =>
      _FilterCasteBtnState();
}

class _FilterCasteBtnState extends State<PartnerPreferenceJathakamTypeBtn> {
  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;

  Widget _mainListView(
      JathakamModel? jathakamModel, Map<int, String> jathakamData) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          JathakamType? jathakamType = jathakamModel!.jathakamData![index];
          return FilterCheckBoxTile(
            title: jathakamType.jathakamType ?? '',
            isChecked: jathakamData.containsKey(jathakamType.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context.read<PartnerPreferenceProvider>().updateSelectedJathakam(
                  jathakamType.id, jathakamType.jathakamType);
            },
          );
        }, childCount: jathakamModel?.jathakamData?.length ?? 0))

        ///TODO: need to change no data found
      ],
    );
  }

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          JathakamModel? jathakamModel = model.jathakamModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.jathakam}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () {
              context.read<PartnerPreferenceProvider>().clearJathakamTypeData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (jathakamModel?.jathakamData ?? []).isEmpty,
              onTap: () => model.getJathakam(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(
                              jathakamModel, model.tempSelectedJathakam);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToJathakam()
                        ..setReligiousPreferenceParam(context)
                        ..saveReligiousPreference(context);
                      context.rootPop;
                    })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Selector<PartnerPreferenceProvider,
          Tuple3<JathakamType?, Map<int, String>, Map<int, String>>>(
        selector: (context, provider) => Tuple3(
            provider.searchFilterValueModel?.jathakamType,
            provider.searchFilterValueModel?.selectedJathakam ?? {},
            provider.searchFilterValueModel?.selectedCaste ?? {}),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.jathakam,
            selectedValue: value.item2.isEmpty
                ? ''
                : context.loc.selected(value.item2.length),
            onTap: value.item3.isNotEmpty
                ? () {
                    ReusableWidgets.customBottomSheet(
                        context: context, child: _optionContainer(context));
                  }
                : null,
          );
        },
      ),
      Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    (model.searchFilterValueModel?.selectedJathakam?.values ??
                            [])
                        .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedJathakam ?? {})
                  .values
                  .isNotEmpty);
        },
      )
    ]);
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    searchQuery = ValueNotifier('');
    textEditingController.addListener(() {
      searchQuery.value = textEditingController.text;
      context
          .read<PartnerPreferenceProvider>()
          .searchCasteByQuery(textEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    searchQuery.dispose();
    super.dispose();
  }
}
