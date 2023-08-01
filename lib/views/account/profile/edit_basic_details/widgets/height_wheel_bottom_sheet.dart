import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/height_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/apply_cancel_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants.dart';
import '../../../../../providers/account_provider.dart';
import '../../../../../utils/tuple.dart';

class HeightWheelBottomSheet extends StatefulWidget {
  final BuildContext contexts;
  final ValueNotifier<int>? selectedIndex;
  const HeightWheelBottomSheet(
      {Key? key, this.selectedIndex, required this.contexts})
      : super(key: key);

  @override
  State<HeightWheelBottomSheet> createState() => _HeightWheelBottomSheetState();
}

class _HeightWheelBottomSheetState extends State<HeightWheelBottomSheet> {
  FixedExtentScrollController? controller;

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: 0);
    context.read<AccountProvider>().getHeightWheelFromIndex(context);
    super.initState();
  }

  Widget _optionContainer(BuildContext context, List<HeightData>? heightData) {
    widget.selectedIndex?.value = 0;
    return Consumer<AccountProvider>(builder: (context, provider, child) {
      if (!provider.isHeightUpdated) {
        CommonFunctions.afterInit(() {
          controller!.animateToItem(provider.heightDataFromIndex,
              duration: const Duration(milliseconds: 100),
              curve: Curves.bounceInOut);
          provider.isHeightUpdated = true;
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
                    provider.heightData = heightData?[index];
                  },
                  useMagnifier: false,
                  itemExtent: 60.h,
                  magnification: 2.0,
                  childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(heightData!.length, (itemIndex) {
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
                          heightData[itemIndex].height ?? '',
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AccountProvider, HeightData?>(
      selector: (context, provider) => provider.heightData,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.585),
          child: Column(
            children: [
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.height,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              21.verticalSpace,
              ReusableWidgets.horizontalLine(density: 2.h),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<HeightDataModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.heightDataModel, provider.maritalStatusLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () => context
                            .read<AppDataProvider>()
                            .getHeightListData(context),
                        isEmpty: (value.item1?.heightData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.heightData ?? []));
                  },
                ),
              ),
              ApplyCancelBtn(
                onApplyTap: () {
                  context.read<AccountProvider>()
                    ..getHeightWheelFromIndex(context)
                    ..updateHeight(context.read<AccountProvider>().heightData)
                    ..sendBasicInfoRequest(widget.contexts, needPop: false);
                  context.rootPop;
                },
              )
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.height,
          selectedValue: value?.height ?? '',
          onTap: () {
            context.read<AccountProvider>().isHeightUpdated = false;
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
}
