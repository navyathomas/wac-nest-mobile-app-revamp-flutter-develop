import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/profile/edit_contact/widgets/watsap_number_verify_tile.dart';
import 'package:nest_matrimony/views/auth_screens/registration/register_number/country_picker_container.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class CommonMobileTextField extends StatefulWidget {
  final bool isPasswordField;
  final String labelText;
  final String? errorMsg;
  final TextInputType? keyboardType;
  final bool isAddress;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onSuffixIconTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool showSuffix;
  final bool isVerified;
  final bool enableVerifyButton;
  final bool errorBorder;
  final bool isReadOnly;

  const CommonMobileTextField(
      {Key? key,
      this.isPasswordField = false,
      required this.labelText,
      this.errorMsg,
      this.keyboardType,
      this.isAddress = false,
      this.controller,
      this.onChanged,
      this.onSuffixIconTap,
      this.maxLength,
      this.showSuffix = false,
      this.isVerified = false,
      this.errorBorder = false,
      this.inputFormatters,
      this.enableVerifyButton = false,
      this.isReadOnly = false})
      : super(key: key);

  @override
  State<CommonMobileTextField> createState() => _CommonMobileTextFieldState();
}

class _CommonMobileTextFieldState extends State<CommonMobileTextField> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> obscured = ValueNotifier<bool>(true);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);

  @override
  Widget build(BuildContext context) {
    obscured.value = widget.isPasswordField;
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Consumer<AuthProvider>(builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 11.62.w),
                    height: widget.isAddress ? 110.h : 60.h,
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
                      readOnly: widget.isReadOnly,
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      keyboardType: TextInputType.number,
                      maxLength: widget.maxLength,
                      style: FontPalette.black16SemiBold,
                      focusNode: focusNode,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration(
                        counterText: '',
                        suffixIcon: widget.showSuffix
                            ? GestureDetector(
                                onTap: !widget.isVerified &&
                                        widget.enableVerifyButton
                                    ? widget.onSuffixIconTap
                                    : null,
                                child: WhatsAppVerifiedTile(
                                  isVerified: widget.isVerified,
                                  enableButton: widget.enableVerifyButton,
                                ),
                              )
                            : null,
                        prefixIcon: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          onLongPress: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<AppDataProvider>()
                                      .resetCountryList();
                                  ReusableWidgets.customBottomSheet(
                                      context: context,
                                      child: CountryPickerContainer(
                                          onChange: (val) {
                                        context
                                            .read<RegistrationProvider>()
                                            .updateCountryData(val);
                                        RegistrationHandlerClass()
                                            .whatsappNumberCtrl
                                            ?.clear();
                                      }));
                                },
                                child: Selector<RegistrationProvider,
                                        CountryData?>(
                                    selector: (context, provider) =>
                                        provider.countryData,
                                    builder: (context, model, child) {
                                      CountryData? countryData = model ??
                                          ((context
                                                          .read<
                                                              AppDataProvider>()
                                                          .countryDataList ??
                                                      [])
                                                  .isNotEmpty
                                              ? context
                                                  .read<AppDataProvider>()
                                                  .countryDataList!
                                                  .first
                                              : null);
                                      return Text(
                                        '+${countryData?.dialCode ?? ''}',
                                        style: FontPalette.f131A24_16SemiBold,
                                      );
                                    }),
                              ),
                              4.12.horizontalSpace,
                              SizedBox(
                                width: 5.84.w,
                                height: 9.61.h,
                                child: SvgPicture.asset(
                                  Assets.iconsDownArrow,
                                  alignment: Alignment.center,
                                  width: 5.84.w,
                                  height: 9.61.h,
                                ),
                              ),
                              14.25.horizontalSpace,
                            ],
                          ),
                        ),
                        border: InputBorder.none,
                        labelText: widget.labelText,
                        labelStyle: value && focusNode.hasFocus ||
                                widget.controller?.text != ""
                            ? FontPalette.f8695A7_12semiBold
                            : FontPalette.f8695A7_12semiBold.copyWith(
                                fontSize: 16.sp, color: darkGreyColor),
                      ),
                    )),
                widget.errorBorder
                    ? Padding(
                        padding: EdgeInsets.all(3.r),
                        child: Text(
                          widget.errorMsg ?? "",
                          style: FontPalette.black10Medium
                              .copyWith(color: Colors.red),
                        ),
                      )
                    : const SizedBox()
              ],
            );
          });
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
