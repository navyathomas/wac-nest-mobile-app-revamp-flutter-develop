import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/star_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../common/constants.dart';

class StarBottomSheet extends StatelessWidget {
  const StarBottomSheet({Key? key}) : super(key: key);

  Widget _optionContainer(BuildContext context, List<StarData>? starListData) {
    return ListView.builder(
        itemCount: starListData?.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<ProfileProvider>().changeDoneBtnActiveState(false);
              context.read<ProfileProvider>()
                ..changeDoneBtnActiveState(true)
                ..onStarChanged(starListData?[index]);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    starListData?[index].starName ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<ProfileProvider, StarData?>(
                    selector: (context, provider) => provider.starData,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (starListData?[index].id ?? -2),
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
    return Selector<ProfileProvider, StarData?>(
      selector: (context, provider) => provider.starData,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.starOrRasi,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<ProfileProvider,
                    Tuple2<StarListModel?, LoaderState>>(
                  selector: (context, provider) =>
                      Tuple2(provider.starsModel, provider.starsOrRashiLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () =>
                            context.read<ProfileProvider>().getStarsDataList(),
                        isEmpty: (value.item1?.starData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.starData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.starOrRasi,
          selectedValue: value?.starName ?? '',
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }
}
