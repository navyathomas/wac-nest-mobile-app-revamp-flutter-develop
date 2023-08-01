import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/tuple.dart';
import '../../../../../widgets/custom_radio.dart';

class CasteBottomSheet extends StatefulWidget {
  const CasteBottomSheet({Key? key}) : super(key: key);

  @override
  State<CasteBottomSheet> createState() => _CasteBottomSheetState();
}

class _CasteBottomSheetState extends State<CasteBottomSheet> {
  Widget _optionContainer(
      BuildContext context, List<CasteData>? casteListData) {
    return ListView.builder(
        itemCount: casteListData?.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context
                  .read<AccountProvider>()
                  .updateCasteOnChanged(casteListData?[index], context);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    casteListData?[index].casteName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<AccountProvider, CasteData?>(
                    selector: (context, provider) => provider.casteData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (casteListData?[index].id ?? -2),
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
    return Selector<AccountProvider, Tuple2<CasteData?, ReligionListData?>>(
      selector: (context, provider) =>
          Tuple2(provider.casteData, provider.religionListData),
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.caste,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AccountProvider,
                    Tuple2<CasteListModel?, LoaderState>>(
                  selector: (context, provider) =>
                      Tuple2(provider.casteListModel, provider.casteListLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () => context
                            .read<AccountProvider>()
                            .getCasteDataList(context: context),
                        isEmpty: (value.item1?.data?.castes ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.data?.castes ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.caste,
          selectedValue: value.item1?.casteName ?? '',
          onTap: value.item2 == null || (value.item1?.casteName ?? '') != ''
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
