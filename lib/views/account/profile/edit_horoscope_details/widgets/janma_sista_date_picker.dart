import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class HoroscopeDatePicker extends StatelessWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  const HoroscopeDatePicker({Key? key, this.onSuccess, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int lastYear =
        DateTime.now().year - context.read<RegistrationProvider>().minAge;
    int firstYear =
        DateTime.now().year - context.read<RegistrationProvider>().maxAge;
    return Selector<ProfileProvider, Tuple3>(
      selector: (context, provider) =>
          Tuple3(provider.day, provider.month, provider.year),
      builder: (context, tuple, _) {
        return CustomOptionBtn(
          title: context.loc.janmaSistaDasaEnd,
          selectedValue:
              '${tuple.item1 != null && tuple.item1 != "" ? '${tuple.item1}' : 'DD'}'
              '${tuple.item2 != null && tuple.item2 != "" ? '/${tuple.item2}' : '/MM'}'
              '${tuple.item3 != null && tuple.item3 != "" ? '/${tuple.item3}' : '/YYYY'}',
          onTap: () {
            ReusableWidgets.customBottomSheet(
                context: context,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      child: Text(
                        context.loc.chooseDate,
                        style: FontPalette.white16Bold
                            .copyWith(color: HexColor('#131A24')),
                      ),
                    ),
                    WidgetExtension.horizontalDivider(
                        color: HexColor('#E4E7E8'), height: 1.h),
                    Selector<ProfileProvider,
                            Tuple3<String?, String?, String?>>(
                        selector: (context, provider) =>
                            Tuple3(provider.day, provider.month, provider.year),
                        builder: (context, tuple, _) {
                          return DatePickerWidget(
                            initialDate: DateTime(
                                int.tryParse(tuple.item3 ?? '1994') ?? 1994,
                                int.tryParse(tuple.item2 ?? '1') ?? 1,
                                int.tryParse(tuple.item1 ?? '1') ?? 1),
                            firstDate: DateTime(firstYear),
                            lastDate: DateTime(lastYear),
                            dateFormat: "dd-MMMM-yyyy",
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                            onChange: (val, _) {
                              context.read<ProfileProvider>()
                                  .updateJanmaDasaOnChanged(val);
                            },
                          );
                        }),
                    WidgetExtension.horizontalDivider(
                        color: HexColor('#E4E7E8'), height: 1.h),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                width: double.maxFinite,
                                height: 60,
                                child: TextButton(
                                    onPressed: onCancel,
                                    child: Text(
                                      context.loc.cancel,
                                      style: FontPalette.white16Bold
                                          .copyWith(color: HexColor('#131A24')),
                                    )))),
                        Expanded(
                            child: SizedBox(
                                width: double.maxFinite,
                                height: 60,
                                child: TextButton(
                                    onPressed: onSuccess,
                                    child: Text(context.loc.ok,
                                        style: FontPalette.white16Bold.copyWith(
                                            color:
                                                ColorPalette.primaryColor)))))
                      ],
                    )
                  ],
                ));
          },
        );
      },
    );
  }
}
