import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../../models/body_type_list_model.dart';
import '../../../../../utils/font_palette.dart';
import '../../../../../widgets/bottom_response_view.dart';

class BodyTypeBottomSheet extends StatelessWidget {
  final BuildContext contexts;
  const BodyTypeBottomSheet({Key? key, required this.contexts})
      : super(key: key);

  Widget _optionContainer(BuildContext context, List<BodyType>? bodyTypeData) {
    return ListView.builder(
        itemCount: bodyTypeData!.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.read<AccountProvider>()
                  .updateBodyTypeStatus(bodyTypeData[index], contexts);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    bodyTypeData[index].bodyType ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<AccountProvider, BodyType?>(
                    selector: (context, provider) => provider.bodyType,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected:
                            (value?.id ?? -1) == (bodyTypeData[index].id ?? -2),
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
    return Selector<AccountProvider, BodyType?>(
      selector: (context, provider) => provider.bodyType,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.bodyType,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<BodyTypeListModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.bodyTypeListModel, provider.bodyTypeListLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () =>
                            context.read<AppDataProvider>().getBodyTypeList(),
                        isEmpty: (value.item1?.bodyTypeData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.bodyTypeData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.bodyType,
          selectedValue: value?.bodyType ?? '',
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }
}
