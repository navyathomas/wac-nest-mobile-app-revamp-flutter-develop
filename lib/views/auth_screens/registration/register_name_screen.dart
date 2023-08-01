import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/validation_helper.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../utils/font_palette.dart';

class RegisterNameScreen extends StatelessWidget {
  const RegisterNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            36.verticalSpace,
            Text(
              context.loc.whatsUrName,
              style: FontPalette.black30Bold,
            ),
            51.verticalSpace,
            TextField(
              style: FontPalette.black20SemiBold,
              textCapitalization: TextCapitalization.words,
              controller: RegistrationHandlerClass().registerNameCtrl,
              onChanged: (val) =>
                  context.read<RegistrationProvider>().updateFullName(val),
              decoration: InputDecoration(
                hintText: context.loc.fullName,
                hintStyle: FontPalette.black20SemiBold
                    .copyWith(color: HexColor('#565F6C')),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor('#E4E7E8'), width: 1.5.h),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor('#000000'), width: 1.5.h),
                ),
              ),
              inputFormatters:
                  ValidationHelper.inputFormatter(InputFormats.name),
            )
          ],
        ),
      ),
    );
  }
}
