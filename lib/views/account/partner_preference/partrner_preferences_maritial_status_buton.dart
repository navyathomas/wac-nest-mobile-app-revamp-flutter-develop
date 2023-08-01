import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/marital_status_model.dart';
import '../../../providers/account_provider.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/reusable_widgets.dart';
import '../../search_filter/search_filter_screen.dart';
import '../../search_filter/widgets/apply_cancel_btn.dart';
import '../../search_filter/widgets/custom_option_btn.dart';
import '../../search_filter/widgets/filter_bottom_sheet_container.dart';
import '../../search_filter/widgets/filter_checkbox_tile.dart';

class PartnerPreferenceMaritalStatusBtn extends StatefulWidget {
  const PartnerPreferenceMaritalStatusBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceMaritalStatusBtn> createState() =>
      _FilterCasteBtnState();
}

class _FilterCasteBtnState extends State<PartnerPreferenceMaritalStatusBtn> {
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
              context
                  .read<PartnerPreferenceProvider>()
                  .updateSelectedMaritalStatus(
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
      child: Consumer<PartnerPreferenceProvider>(
        builder: (context, model, child) {
          MaritalStatusModel? maritalStatusModel = model.maritalStatusModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.maritalStatus}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () {
              context
                  .read<PartnerPreferenceProvider>()
                  .clearMartialStatusData();
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
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToSelectedMartialStatus()
                        ..setBasicPreferenceParam(context)
                        ..saveBasicPreference(context);
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
    var data = context.read<AccountProvider>().partnerPreferenceData?.data!;
    return Consumer<PartnerPreferenceProvider>(
      builder: (context, value, child) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Selector<PartnerPreferenceProvider,
          //     Tuple2<MaritalStatus?, Map<int, String>>>(
          //   selector: (context, provider) => Tuple2(
          //       provider.searchFilterValueModel?.maritalStatus,
          //       provider.searchFilterValueModel?.selectedMaritalStatus ?? {}),
          //   builder: (context, value, child) {
          //     return
          CustomOptionBtn(
            title: context.loc.maritalStatus,
            selectedValue: value.isFilterApplied
                ? value.searchFilterValueModel?.selectedMaritalStatus != null
                    ? value.searchFilterValueModel!.selectedMaritalStatus!
                            .values.isNotEmpty
                        ? context.loc.selected(value.searchFilterValueModel!
                            .selectedMaritalStatus!.values.length)
                        : ''
                    : ''
                : (data!.maritalStatusUnserialize ?? []).isNotEmpty
                    ? context.loc
                        .selected(data.maritalStatusUnserialize?.length ?? 0)
                    : '',

            // (data?.maritalStatusUnserialize?.toString() ?? '').isNotEmpty
            //     ? data?.maritalStatusUnserialize?.join(", ") ?? ''
            //     : '',
            onTap: () {
              //getFilterValues();
              // if (data!.maritalStatusUnserialize != null &&
              //     data.maritalStatusUnserialize!.isNotEmpty) {
              //   for (int i = 0;
              //       i < data.maritalStatusUnserialize!.length;
              //       i++) {
              //     context
              //         .read<PartnerPreferenceProvider>()
              //         .updateSelectedMaritalStatus(
              //             int.parse(data.maritalStatusUnserializeId![i]),
              //             data.maritalStatusUnserialize![i]);
              //   }
              // }
              // context
              //     .read<PartnerPreferenceProvider>()
              //     .reAssignTempMaritalStatus();
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          ),
          //   },
          // ),
          WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options: (value.searchFilterValueModel?.selectedMaritalStatus
                            ?.values ??
                        [])
                    .join(', '),
              ),
              value: (value.searchFilterValueModel?.selectedMaritalStatus ?? {})
                  .values
                  .isNotEmpty)
        ]);
      },
    );
  }

  Future<void> getFilterValues() async {
    var data = context.read<AccountProvider>().partnerPreferenceData?.data!;
    if (!context.read<PartnerPreferenceProvider>().isFilterApplied) {
      if (data!.bodyTypesUnserialize != null &&
          data.bodyTypesUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.bodyTypesUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedBodyType(
              int.parse(data.bodyTypesUnserializeId![i]),
              data.bodyTypesUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToBodyType();
      }
      if (data.complexionUnserialize != null &&
          data.complexionUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.complexionUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedComplexion(
              int.parse(data.complexionUnserializeId![i]),
              data.complexionUnserialize![i]);
        }
        context.read<PartnerPreferenceProvider>().assignTempToComplexion();
      }
      if (data.maritalStatusUnserialize != null &&
          data.maritalStatusUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.maritalStatusUnserialize!.length; i++) {
          context.read<PartnerPreferenceProvider>().updateSelectedMaritalStatus(
              int.parse(data.maritalStatusUnserializeId![i]),
              data.maritalStatusUnserialize![i]);
        }
        context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedMartialStatus();
      }
      context.read<PartnerPreferenceProvider>().isFilterApplied = true;
    }
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
