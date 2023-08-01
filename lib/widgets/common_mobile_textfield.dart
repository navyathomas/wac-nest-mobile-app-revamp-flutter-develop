import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/validation_helper.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';
import '../providers/auth_provider.dart';
import '../views/auth_screens/registration/register_number/country_picker_container.dart';

class CommonMobileTextField extends StatefulWidget {
  final String labelText;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  String errorMsg = '';
  bool errorBorder = false;
  final bool isEditable;
  var validator;
  CommonMobileTextField(
      {Key? key,
      required this.labelText,
      this.onChanged,
      this.errorBorder = false,
      this.errorMsg = '',
      this.validator,
      this.isEditable = true,
      required this.controller})
      : super(key: key);

  @override
  State<CommonMobileTextField> createState() => _CommonMobileTextFieldState();
}

class _CommonMobileTextFieldState extends State<CommonMobileTextField> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> enablebtn = ValueNotifier<bool>(false);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  Color get btnGreyColor => const Color(0xFFC1C9D2);
  // final TextEditingController _controller = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                        left: 12.w,
                      ),
                      height: 60.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          border: Border.all(
                              width: 1.sp,
                              color: widget.errorBorder
                                  ? Colors.red
                                  : value && focusNode.hasFocus
                                      ? Colors.black
                                      : dimBlackColor)),
                      child: TextFormField(
                        enabled: widget.isEditable,
                        inputFormatters: ValidationHelper.inputFormatter(
                            InputFormats.phoneNumber),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: widget.controller,
                        onChanged: widget.onChanged,
                        keyboardType: TextInputType.number,
                        style: FontPalette.black16SemiBold,
                        maxLength: provider.maxLength,
                        focusNode: focusNode,
                        validator: widget.validator,
                        decoration: InputDecoration(
                          counterText: '',
                          prefixIcon: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<AppDataProvider>()
                                  .resetCountryList();
                              ReusableWidgets.customBottomSheet(
                                  context: context,
                                  child: CountryPickerContainer(
                                    onChange: (val) =>
                                        provider.updateCountryData(val),
                                  ));
                            },
                            onLongPress: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 32.88.w,
                                  height: 22.87.h,
                                  child: provider.countryData?.countryFlag !=
                                          null
                                      ? SvgPicture.network(
                                          provider.countryData!.countryFlag!,
                                          alignment: Alignment.center,
                                          width: 32.88.w,
                                          height: 22.87.h,
                                          placeholderBuilder: (context) {
                                            return Container(
                                              color: Colors.grey,
                                              alignment: Alignment.center,
                                              width: 32.88.w,
                                              height: 22.87.h,
                                            );
                                          },
                                        )
                                      : SvgPicture.asset(
                                          Assets.iconsFlag,
                                          alignment: Alignment.center,
                                          width: 32.88.w,
                                          height: 22.87.h,
                                        ),
                                ),
                                4.12.horizontalSpace,
                                Text(
                                  provider.countryData?.dialCode != null
                                      ? "+${provider.countryData!.dialCode}"
                                      : "+91",
                                  style: FontPalette.black16SemiBold,
                                ),
                                4.12.horizontalSpace,
                                SizedBox(
                                  width: 9.63.w,
                                  height: 5.84.h,
                                  child: SvgPicture.asset(
                                    Assets.iconsDownArrow,
                                    alignment: Alignment.center,
                                    width: 9.63.w,
                                    height: 5.84.h,
                                  ),
                                ),
                                14.25.horizontalSpace,
                              ],
                            ),
                          ),
                          border: InputBorder.none,
                          labelText: widget.labelText,
                          labelStyle: value && focusNode.hasFocus
                              ? FontPalette.f8695A7_12semiBold
                              : FontPalette.f8695A7_12semiBold.copyWith(
                                  fontSize: 16.sp, color: darkGreyColor),
                        ),
                      )),
                  widget.errorBorder
                      ? Padding(
                          padding: EdgeInsets.all(3.r),
                          child: Text(
                            widget.errorMsg,
                            style: FontPalette.black10Medium
                                .copyWith(color: Colors.red),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            },
          );
        });
  }

  @override
  void initState() {
    focusListen();
    super.initState();
  }

  void focusListen() {
    focusNode.addListener(() {
      if (focusNode.hasFocus == true) {
        isBorder.value = true;
      } else {
        isBorder.value = false;
      }
    });
  }
}
