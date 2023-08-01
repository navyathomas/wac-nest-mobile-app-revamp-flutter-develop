import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../providers/registration_provider.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';

class DateWidget extends StatelessWidget {
  final String? day;
  final String? month;
  final String? year;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  final AgeDataListModel? ageDataListModel;
  const DateWidget(
      {Key? key,
      this.day,
      this.month,
      this.year,
      this.onCancel,
      this.onSuccess,
      this.ageDataListModel})
      : super(key: key);

  Widget slashWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, right: 15.w),
      child: Transform.rotate(
        angle: 60,
        child: Container(
          height: 22.h,
          width: 1.w,
          color: HexColor('#C1C9D2'),
        ),
      ),
    );
  }

  Widget customText(String? val, bool enableHint) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 14.h, 5.w, 14.h),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: HexColor('#E4E7E8'), width: 1.5.h))),
      child: Text(
        val ?? '',
        style: FontPalette.black20SemiBold.copyWith(
            color: enableHint ? HexColor('#8695A7') : HexColor('#131A24'),
            letterSpacing: 7.6.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int lastYear =
        DateTime.now().year - context.read<RegistrationProvider>().minAge;
    int firstYear =
        DateTime.now().year - context.read<RegistrationProvider>().maxAge;
    return InkWell(
      onTap: () async {
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
                Selector<RegistrationProvider,
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
                        looping: false,
                        onConfirm: (val, _) {
                          print(val);
                        },
                        onChange: (val, _) {
                          context
                              .read<RegistrationProvider>()
                              .updateDateOfBirth(val);
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
                                        color: ColorPalette.primaryColor)))))
                  ],
                )
              ],
            ));
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child:
            Selector<RegistrationProvider, Tuple3<String?, String?, String?>>(
                selector: (context, provider) =>
                    Tuple3(provider.day, provider.month, provider.year),
                shouldRebuild: (Tuple3<String?, String?, String?> p0,
                        Tuple3<String?, String?, String?> p1) =>
                    p0.item3 != p1.item3,
                builder: (context, tuple, _) {
                  return Row(
                    children: [
                      customText(tuple.item1 ?? 'DD', day.isNull),
                      slashWidget(),
                      customText(tuple.item2 ?? 'MM', month.isNull),
                      slashWidget(),
                      customText(tuple.item3 ?? 'YYYY', year.isNull),
                    ],
                  );
                }),
      ),
    ).removeSplash();
  }
}
