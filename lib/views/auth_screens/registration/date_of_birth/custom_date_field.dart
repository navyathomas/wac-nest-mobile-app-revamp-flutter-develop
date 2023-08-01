import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/validation_helper.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';

class CustomDateField extends StatefulWidget {
  const CustomDateField({Key? key}) : super(key: key);

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  final TextEditingController editingController1 = TextEditingController();
  final TextEditingController editingController2 = TextEditingController();
  final TextEditingController editingController3 = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: CustomTextField(
                editingController: editingController1,
                focusNode: focusNode1,
                hintText: 'DD',
                onChange: (val) {
                  if (val.length == 2) {
                    focusNode1.unfocus();
                    FocusScope.of(context).requestFocus(focusNode2);
                  }
                },
              ),
            ),
            slashWidget(),
            Flexible(
              child: CustomTextField(
                editingController: editingController2,
                focusNode: focusNode2,
                hintText: 'MM',
                onChange: (val) {
                  if (val.length == 2) {
                    focusNode2.unfocus();
                    FocusScope.of(context).requestFocus(focusNode3);
                  } else if (val == '') {
                    focusNode2.unfocus();
                    FocusScope.of(context).requestFocus(focusNode1);
                  }
                },
              ),
            ),
            slashWidget(),
            Flexible(
              flex: 2,
              child: CustomTextField(
                editingController: editingController3,
                maxLength: 4,
                hintText: 'YYYY',
                focusNode: focusNode3,
                onChange: (val) {
                  if (val.length == 4) {
                    focusNode3.unfocus();
                  } else if (val == '') {
                    focusNode3.unfocus();
                    FocusScope.of(context).requestFocus(focusNode2);
                  }
                },
              ),
            ),
            context.sw(size: 0.18).horizontalSpace,
          ],
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final int maxLength;
  final FocusNode focusNode;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String> onChange;
  final TextEditingController editingController;
  const CustomTextField(
      {Key? key,
      required this.focusNode,
      this.maxLength = 2,
      this.onTap,
      required this.hintText,
      required this.onChange,
      required this.editingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      textAlign: TextAlign.center,
      maxLength: maxLength,
      focusNode: focusNode,
      onChanged: onChange,
      onTap: onTap,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      controller: editingController,
      scrollPadding: EdgeInsets.zero,
      keyboardType: TextInputType.number,
      inputFormatters:
          ValidationHelper.inputFormatter(InputFormats.phoneNumber),
      style: FontPalette.black20SemiBold
          .copyWith(color: HexColor('#131A24'), letterSpacing: 7.6.w),
      decoration: InputDecoration(
          counterText: "",
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor('#E4E7E8'), width: 1.5.h),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor('#000000'), width: 1.5.h),
          ),
          hintStyle: FontPalette.black20SemiBold.copyWith(
            color: HexColor('#8695A7'),
          )),
    );
  }
}
