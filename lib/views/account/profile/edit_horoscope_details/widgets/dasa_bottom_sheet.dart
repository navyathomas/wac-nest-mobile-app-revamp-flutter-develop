import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/dasa_model.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../../common/constants.dart';
import '../../../../../utils/tuple.dart';

class DasaBottomSheet extends StatelessWidget {
  const DasaBottomSheet({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context, List<DasaData>? dasaListData) {
    return ListView.builder(
        itemCount: dasaListData?.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<ProfileProvider>().changeDoneBtnActiveState(true);
              context
                  .read<ProfileProvider>()
                  .onDashaChanged(dasaListData?[index]);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    dasaListData?[index].jathakamType ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<ProfileProvider, DasaData?>(
                    selector: (context, provider) => provider.dasaData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (dasaListData?[index].id ?? -2),
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
    return Selector<ProfileProvider, DasaData?>(
      selector: (context, provider) => provider.dasaData,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.dasa,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<ProfileProvider,
                    Tuple2<DasaListModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.dasaListModel, provider.starsOrRashiLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () =>
                            context.read<ProfileProvider>().getDashaDataList(),
                        isEmpty: (value.item1?.dasaData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.dasaData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.dasa,
          selectedValue: value?.jathakamType ?? '',
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }
}
