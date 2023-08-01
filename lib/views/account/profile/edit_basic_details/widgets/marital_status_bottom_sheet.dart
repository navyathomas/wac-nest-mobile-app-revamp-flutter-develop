import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/marital_status_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/bottom_response_view.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:provider/provider.dart';
import '../../../../../widgets/reusable_widgets.dart';

class MaritalStatusBottomSheet extends StatelessWidget {
  final BuildContext contexts;
  const MaritalStatusBottomSheet({Key? key, required this.contexts})
      : super(key: key);

  Widget _optionContainer(
      BuildContext context, List<MaritalStatus>? maritalStatusData) {
    return ListView.builder(
        itemCount: maritalStatusData!.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context
                  .read<AccountProvider>()
                  .updateMaritalStatus(maritalStatusData[index], contexts);
              context.rootPop;
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 27.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    maritalStatusData[index].maritalStatus ?? '',
                    style: FontPalette.f131A24_16SemiBold,
                  ).avoidOverFlow()),
                  Selector<AccountProvider, MaritalStatus?>(
                    selector: (context, provider) => provider.maritalStatus,
                    builder: (context, value, _) {
                      return CustomRadio(
                        isSelected: (value?.id ?? -1) ==
                            (maritalStatusData[index].id ?? -2),
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
    return Selector<AccountProvider, MaritalStatus?>(
      selector: (context, provider) => provider.maritalStatus,
      builder: (context, value, childWidget) {
        childWidget = SizedBox(
          height: context.sh(size: 0.5),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  context.loc.maritalStatus,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              Expanded(
                child: Selector<AppDataProvider,
                    Tuple2<MaritalStatusModel?, LoaderState>>(
                  selector: (context, provider) => Tuple2(
                      provider.maritalStatusModel,
                      provider.maritalStatusLoader),
                  builder: (context, value, child) {
                    return BottomResView(
                        loaderState: value.item2,
                        onTap: () => context
                            .read<AppDataProvider>()
                            .getMaritalStatusData(),
                        isEmpty: (value.item1?.maritalStatusData ?? []).isEmpty,
                        child: _optionContainer(
                            context, value.item1?.maritalStatusData ?? []));
                  },
                ),
              ),
            ],
          ),
        );
        return CustomOptionBtn(
          title: context.loc.maritalStatus,
          selectedValue: value?.maritalStatus ?? '',
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context, child: childWidget);
          },
        );
      },
    );
  }
}
