import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/extensions.dart';
import '../../models/marital_status_model.dart';
import '../../providers/matches_provider.dart';
import '../../utils/tuple.dart';
import '../../widgets/bottom_response_view.dart';
import '../../widgets/reusable_widgets.dart';
import '../search_filter/search_filter_screen.dart';
import '../search_filter/widgets/apply_cancel_btn.dart';
import '../search_filter/widgets/custom_option_btn.dart';
import '../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../search_filter/widgets/filter_checkbox_tile.dart';

class MatchesMartialStatusBtn extends StatefulWidget {
  const MatchesMartialStatusBtn({Key? key}) : super(key: key);

  @override
  State<MatchesMartialStatusBtn> createState() => _FilterCasteBtnState();
}

class _FilterCasteBtnState extends State<MatchesMartialStatusBtn> {
  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;

  Widget _mainListView(
      MaritalStatusModel? maritalStatusModel, Map<int, String> martialStatus) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          MaritalStatus? maritalStatus =
              maritalStatusModel!.maritalStatusData![index];
          return FilterCheckBoxTile(
            title: maritalStatus.maritalStatus ?? '',
            isChecked: martialStatus.containsKey(maritalStatus.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context.read<MatchesProvider>().updateSelectedMaritalStatus(
                  maritalStatus.id, maritalStatus.maritalStatus);
            },
          );
        }, childCount: maritalStatusModel?.maritalStatusData?.length ?? 0))

        ///TODO: need to change no data found
      ],
    );
  }

  Widget _optionContainer(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Consumer<MatchesProvider>(
        builder: (context, model, child) {
          MaritalStatusModel? maritalStatusModel = model.maritalStatusModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.maritalStatus}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () {
              context.read<MatchesProvider>().clearMartialStatusData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (maritalStatusModel?.maritalStatusData ?? []).isEmpty,
              onTap: () => model.getMaritalStatusDataList(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(maritalStatusModel,
                              model.tempSelectedMartialStatus);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context
                          .read<MatchesProvider>()
                          .assignTempToSelectedMartialStatus();
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
      Selector<MatchesProvider, Tuple2<MaritalStatus?, Map<int, String>>>(
        selector: (context, provider) => Tuple2(
            provider.searchFilterValueModel?.maritalStatus,
            provider.searchFilterValueModel?.selectedMaritalStatus ?? {}),
        builder: (context, value, child) {
          return CustomOptionBtn(
            title: context.loc.maritalStatus,
            selectedValue: value.item2.isEmpty
                ? ''
                : context.loc.selected(value.item2.length),
            onTap: () {
              context.read<MatchesProvider>().reAssignTempMaritalStatus();
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          );
        },
      ),
      Consumer<MatchesProvider>(
        builder: (context, model, child) {
          return WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options: (model.searchFilterValueModel?.selectedMaritalStatus
                            ?.values ??
                        [])
                    .join(', '),
              ),
              value: (model.searchFilterValueModel?.selectedMaritalStatus ?? {})
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
          .read<MatchesProvider>()
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
