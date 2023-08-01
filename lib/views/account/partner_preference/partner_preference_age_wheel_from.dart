import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/apply_cancel_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants.dart';
import '../../../../../providers/account_provider.dart';
import '../../../../../utils/tuple.dart';
import '../../../common/common_functions.dart';

class PartnerPreferenceAgeWheelFrom extends StatefulWidget {
  final BuildContext context;
  final ValueNotifier<int>? selectedIndex;
  final String? title;
  const PartnerPreferenceAgeWheelFrom(
      {Key? key, this.selectedIndex, required this.context, this.title})
      : super(key: key);

  @override
  State<PartnerPreferenceAgeWheelFrom> createState() =>
      _PartnerPreferenceAgeWheelFromState();
}

class _PartnerPreferenceAgeWheelFromState
    extends State<PartnerPreferenceAgeWheelFrom> {
  FixedExtentScrollController? controller;
  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: 0);
    context.read<PartnerPreferenceProvider>().getAgeWheeFromIndex(context);
    super.initState();
  }

  Widget _optionContainer(BuildContext context, List<AgeList>? ageData) {
    widget.selectedIndex?.value = 0;

    return Consumer<PartnerPreferenceProvider>(
      builder: (context, provider, child) {
        if (!provider.isAgeIndexUpdated) {
          CommonFunctions.afterInit(() {
            controller!.animateToItem(provider.ageFromIndex,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceInOut);
            provider.isAgeIndexUpdated = true;
          });
        }
        return Stack(
          children: [
            ValueListenableBuilder<int>(
                valueListenable: widget.selectedIndex!,
                builder: (context, value, child) {
                  return ListWheelScrollView.useDelegate(
                    controller: controller,
                    renderChildrenOutsideViewport: false,
                    onSelectedItemChanged: (int index) {
                      widget.selectedIndex?.value = index;
                      provider.ageDataTFromValue = ageData?[index];
                      // context
                      //     .read<PartnerPreferenceProvider>()
                      //     .updateAgeFrom(ageData?[index]);
                    },
                    useMagnifier: false,
                    itemExtent: 60.h,
                    magnification: 2.0,
                    childDelegate: ListWheelChildLoopingListDelegate(
                        children: List.generate(ageData!.length, (itemIndex) {
                      try {
                        return AnimatedContainer(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          alignment: Alignment.center,
                          decoration: widget.selectedIndex?.value == itemIndex
                              ? const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Colors.black),
                                      bottom: BorderSide(
                                          width: 1, color: Colors.black)))
                              : null,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            ageData[itemIndex].age.toString(),
                            style: FontPalette.black16SemiBold,
                          ),
                        );
                      } catch (e) {
                        return const Text("No Text");
                      }
                    })),
                  );
                }),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shadowWidget(bottom: false),
                  shadowWidget(),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerPreferenceProvider, AgeList?>(
      selector: (context, provider) => provider.ageListDataFrom,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.585),
          child: Column(
            children: [
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.age,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              21.verticalSpace,
              ReusableWidgets.horizontalLine(density: 2.h),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<AgeDataListModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.ageDataListModel, provider.maritalStatusLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () =>
                            context.read<AppDataProvider>().getAgeData(context),
                        isEmpty: (value.item1?.data?.ageList ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1!.data?.ageList ?? []));
                  },
                ),
              ),
              ApplyCancelBtn(
                onApplyTap: () {
                  getFilterValues()
                      .then((value) => context.read<PartnerPreferenceProvider>()
                        ..setBasicPreferenceParam(context)
                        ..saveBasicPreference(context));
                  context.read<PartnerPreferenceProvider>().updateAgeFrom(
                      context
                          .read<PartnerPreferenceProvider>()
                          .ageDataTFromValue);
                  context
                      .read<PartnerPreferenceProvider>()
                      .getAgeWheeFromIndex(context);
                  context.rootPop;
                },
              )
            ],
          ),
        );
        return CustomOptionBtn(
          title: widget.title ?? '',
          selectedValue: value?.age.toString() ?? '',
          onTap: () {
            context.read<PartnerPreferenceProvider>().isAgeIndexUpdated = false;
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }

  Widget shadowWidget({bool bottom = true}) {
    return Container(
      height: 120.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: bottom ? Alignment.bottomCenter : Alignment.topCenter,
              end: bottom ? Alignment.topCenter : Alignment.bottomCenter,
              colors: const [
            Colors.white,
            Colors.white10,
          ])),
    );
  }

  Future<void> getFilterValues() async {
    var data =
        widget.context.read<AccountProvider>().partnerPreferenceData?.data!;
    if (!widget.context.read<PartnerPreferenceProvider>().isFilterApplied) {
      if (data!.bodyTypesUnserialize != null &&
          data.bodyTypesUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.bodyTypesUnserialize!.length; i++) {
          widget.context
              .read<PartnerPreferenceProvider>()
              .updateSelectedBodyType(
                  int.parse(data.bodyTypesUnserializeId![i]),
                  data.bodyTypesUnserialize![i]);
        }
        widget.context.read<PartnerPreferenceProvider>().assignTempToBodyType();
      }
      if (data.complexionUnserialize != null &&
          data.complexionUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.complexionUnserialize!.length; i++) {
          widget.context
              .read<PartnerPreferenceProvider>()
              .updateSelectedComplexion(
                  int.parse(data.complexionUnserializeId![i]),
                  data.complexionUnserialize![i]);
        }
        widget.context
            .read<PartnerPreferenceProvider>()
            .assignTempToComplexion();
      }
      if (data.maritalStatusUnserialize != null &&
          data.maritalStatusUnserialize!.isNotEmpty) {
        for (int i = 0; i < data.maritalStatusUnserialize!.length; i++) {
          widget.context
              .read<PartnerPreferenceProvider>()
              .updateSelectedMaritalStatus(
                  int.parse(data.maritalStatusUnserializeId![i]),
                  data.maritalStatusUnserialize![i]);
        }
        widget.context
            .read<PartnerPreferenceProvider>()
            .assignTempToSelectedMartialStatus();
      }
      widget.context.read<PartnerPreferenceProvider>().isFilterApplied = true;
    }
  }
}
