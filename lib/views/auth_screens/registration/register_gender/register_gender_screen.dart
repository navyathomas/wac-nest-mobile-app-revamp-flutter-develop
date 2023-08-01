import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:provider/provider.dart';

import '../../../../utils/font_palette.dart';
import 'gender_tile.dart';

class RegisterGenderScreen extends StatelessWidget {
  const RegisterGenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            36.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                context.loc.whatsURGender,
                style: FontPalette.black30Bold,
              ),
            ),
            49.verticalSpace,
            Selector<RegistrationProvider, int>(
                selector: (_, provider) => provider.genderIndex,
                builder: (_, genderIndex, __) => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<RegistrationProvider>()
                                  .updateGenderIndex(0);
                              navToNext(context);
                            },
                            child: GenderTile(
                              isSelected: genderIndex == 0,
                              icon: Assets.iconsMaleAvatar,
                              title: context.loc.male,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<RegistrationProvider>()
                                  .updateGenderIndex(1);
                              navToNext(context);
                            },
                            child: GenderTile(
                              isSelected: genderIndex == 1,
                              icon: Assets.iconsFemaleAvatar,
                              title: context.loc.female,
                            ),
                          ),
                        ),
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  void navToNext(BuildContext context, {int duration = 1000}) {
    Future.delayed(Duration(milliseconds: duration)).then((value) {
      RegistrationHandlerClass().scrollToIndex(index: 3, context: context);
    });
  }
}
