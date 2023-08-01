import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/body_type_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
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

class PartnerPreferenceBodyTypeBtn extends StatefulWidget {
  const PartnerPreferenceBodyTypeBtn({Key? key}) : super(key: key);

  @override
  State<PartnerPreferenceBodyTypeBtn> createState() => _FilterCasteBtnState();
}

class _FilterCasteBtnState extends State<PartnerPreferenceBodyTypeBtn> {
  late final TextEditingController textEditingController;
  late final ValueNotifier<String> searchQuery;

  Widget _mainListView(
      BodyTypeModel? bodyTypeModel, Map<int, String> bodyTypeData) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((cxt, index) {
          BodyType? bodyType = bodyTypeModel!.data![index];
          return FilterCheckBoxTile(
            title: bodyType.bodyType ?? '',
            isChecked: bodyTypeData.containsKey(bodyType.id ?? -1),
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.h),
            onTap: () {
              context
                  .read<PartnerPreferenceProvider>()
                  .updateSelectedBodyType(bodyType.id, bodyType.bodyType);
            },
          );
        }, childCount: bodyTypeModel?.data?.length ?? 0))

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
          BodyTypeModel? bodyTypeModel = model.bodyTypeModel;
          return FilterBottomSheetContainer(
            title: '${context.loc.select} ${context.loc.bodyType}',
            hideSearch: true,
            hintText: "${context.loc.search} ${context.loc.caste}",
            textEditingController: textEditingController,
            onClearTap: () {
              context.read<PartnerPreferenceProvider>().clearBodyTypeData();
            },
            child: BottomResView(
              loaderState: model.loaderState,
              isEmpty: (bodyTypeModel?.data ?? []).isEmpty,
              onTap: () => model.getBodyType(),
              child: Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return _mainListView(
                              bodyTypeModel, model.tempSelectedBodyType);
                        },
                      ),
                    ),
                    ApplyCancelBtn(onApplyTap: () {
                      context.read<PartnerPreferenceProvider>()
                        ..assignTempToBodyType()
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
          CustomOptionBtn(
            title: context.loc.bodyType,
            selectedValue: value.isFilterApplied
                ? value.searchFilterValueModel?.selectedBodyType != null
                    ? value.searchFilterValueModel!.selectedBodyType!.values
                            .isNotEmpty
                        ? context.loc.selected(value.searchFilterValueModel!
                            .selectedBodyType!.values.length)
                        : ''
                    : ''
                : (data!.bodyTypesUnserialize ?? []).isNotEmpty
                    ? context.loc
                        .selected(data.bodyTypesUnserialize?.length ?? 0)
                    : '',
            onTap: () {
              ReusableWidgets.customBottomSheet(
                  context: context, child: _optionContainer(context));
            },
          ),
          //   },
          // ),
          WidgetExtension.crossSwitch(
              first: OptionSelectedText(
                options:
                    (value.searchFilterValueModel?.selectedBodyType?.values ??
                            [])
                        .join(', '),
              ),
              value: (value.searchFilterValueModel?.selectedBodyType ?? {})
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
    // CommonFunctions.afterInit(() {
    //   getFilterValues();
    // });
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
