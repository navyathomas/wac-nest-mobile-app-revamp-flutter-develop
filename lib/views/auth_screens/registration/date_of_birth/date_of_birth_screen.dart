import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/age_data_list_model.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/auth_screens/registration/date_of_birth/age_scroll_wheel.dart';
import 'package:nest_matrimony/views/auth_screens/registration/date_of_birth/date_widget.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../providers/registration_provider.dart';
import '../../../../utils/font_palette.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({Key? key}) : super(key: key);

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child:
          Selector<RegistrationProvider, Tuple2<AgeDataListModel?, DateTime?>>(
        selector: (context, provider) =>
            Tuple2(provider.ageDataListModel, provider.dateOfBirth),
        builder: (context, value, child) {
          AgeDataListModel? ageModel = value.item1;
          if (ageModel == null) {
            return ReusableWidgets.circularProgressIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                36.verticalSpace,
                Text(
                  context.loc.whenYouBorn,
                  style: FontPalette.black30Bold,
                ),
                27.verticalSpace,
                Text(
                  context.loc.enterDOB,
                  style: FontPalette.black13SemiBold
                      .copyWith(color: HexColor('#4D4D4D')),
                ),
                13.verticalSpace,
                DateWidget(
                  year:
                      value.item2?.year != null ? '${value.item2?.year}' : null,
                  ageDataListModel: ageModel,
                  onCancel: () {
                    context.rootPop;
                  },
                  onSuccess: () async {
                    context.rootPop;
                    if (context.read<RegistrationProvider>().dateOfBirth !=
                        null) {
                      context.read<RegistrationProvider>()
                        ..assignTempToCurrent()
                        ..updateInterruptAgeScroll(true);
                      int index = await context
                          .read<RegistrationProvider>()
                          .calculateAge();
                      RegistrationHandlerClass().scrollAgeWheelToIndex(index);
                    }
                  },
                ),
                32.verticalSpace,
                Text(
                  context.loc.selectAge,
                  style: FontPalette.black13SemiBold
                      .copyWith(color: HexColor('#4D4D4D')),
                ),
                17.verticalSpace,
                Container(
                  height: 90.h,
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(
                              color: HexColor('#E4E7E8'), width: 1.5.h))),
                  child: AgeScrollWheel(
                    initialIndex:
                        RegistrationHandlerClass().selectedAgeValue?.value ?? 5,
                  ),
                ),
                17.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    CommonFunctions.afterInit(() {
      final model = context.read<RegistrationProvider>();
      if (model.dateOfBirth == null) {
        model.updateInterruptAgeScroll(false);
        model.updateDateFromAge(model.minAge);
        RegistrationHandlerClass().selectedAgeValue!.value = 0;
        RegistrationHandlerClass().scrollAgeWheelToIndex(0);
      }
    });
    super.initState();
  }
}
