// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/contact_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/auth_screens/registration/register_number/country_picker_container.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/common_msg_textfield.dart';
import 'package:nest_matrimony/widgets/common_textfield.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isBorder = ValueNotifier<bool>(false);
  final ValueNotifier<bool> enablebtn = ValueNotifier<bool>(false);
  Color get dimBlackColor => const Color(0xFFE4E7E8);
  Color get darkGreyColor => const Color(0xFF565F6C);
  Color get btnGreyColor => const Color(0xFFC1C9D2);
  final TextEditingController _controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Support',
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.3,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: contents())),
              Consumer<ContactProvider>(
                builder: (context, pro, child) => Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: CommonButton(
                    title: "Submit",
                    isLoading: pro.btnLoader,
                    onPressed:
                        // pro.fullname != "" &&
                        // pro.countryCode != "" &&
                        // pro.email != "" &&
                        // pro.message != "" &&
                        // pro.mobileNumber != ""
                        // ?
                        () {
                      pro.countryCode != "" && pro.mobileNumber != ""
                          ? pro.support(onSuccess: () => Navigator.pop(context))
                          : Helpers.successToast(
                              "Mobile Number can't be empty ");
                    },
                    // :
                    //  null,
                  ),
                ),
              )
            ],
          )),
    );
  }

//contents
  Widget contents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Flexible(child: callNow()),
        //     9.horizontalSpace,
        //     Flexible(child: whatsappNow())
        //   ],
        // ),
        Consumer<ContactProvider>(
          builder: (_, value, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: ((value.mainBranch?.mobile2 ?? "").isNotEmpty ||
                      (value.mainBranch?.mobile2 ?? "").isNotEmpty)
                  ? Column(
                      children: [
                        23.verticalSpace,
                        Row(
                          children: [
                            Flexible(child: callNow(value)),
                            9.horizontalSpace,
                            Flexible(child: whatsappNow(value))
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            );
          },
        ),

        23.verticalSpace,
        Text(
          "Support request",
          style: FontPalette.black16ExtraBold
              .copyWith(color: HexColor("#131A24"), fontSize: 18.sp),
        ),
        8.verticalSpace,
        Text(
          "Our support team is standing by to help.",
          style: FontPalette.black12Medium.copyWith(color: HexColor("#8695A7")),
        ),
        18.verticalSpace,
        CommonTextField(
          labelText: "Full Name",
          onChanged: (val) {
            context.read<ContactProvider>().updateFullname(val);
          },
        ),
        12.verticalSpace,
        mobileTextField(
          labelText: "Mobile number",
        ),
        12.verticalSpace,
        CommonTextField(
          labelText: "Email ID (Optional)",
          onChanged: (val) {
            context.read<ContactProvider>().updateEmail(val);
          },
        ),
        12.verticalSpace,
        CommonMessageTextField(
          labelText: "Your message",
          isMessageField: true,
          onChanged: (val) {
            context.read<ContactProvider>().updateMsg(val);
          },
        ),
        12.verticalSpace,
        Consumer<ContactProvider>(
          builder: (context, value, child) {
            return Padding(
              padding: EdgeInsets.all(5.sp),
              child: value.image != null
                  ? fileAdded(
                      onTap: () {
                        value.updateAttachFile(null);
                      },
                      title: value.image?.name ?? "",
                      centerTitle: false)
                  // Text(
                  //     value.image?.name ?? "",
                  //     style: FontPalette.black16ExtraBold
                  //         .copyWith(color: HexColor("#131A24"), fontSize: 8.sp),
                  //   )
                  : const SizedBox(),
            );
          },
        ),
        ReusableWidgets.commonAddIconButton(
            onTap: (() {
              context.read<ContactProvider>().pickFile();
            }),
            height: 30,
            width: 145.w,
            title: "Attach file",
            iconPath: Assets.iconsAttachment,
            makeRoundedButton: true)
      ],
    );
  }

  Future<void> launchWhatsAppUri(
      {String? mobile, String? registerID, String? name}) async {
    final link = WhatsAppUnilink(
      phoneNumber: '{91$mobile}',
      text: '''Hi,You've received an inquiry from ${registerID}, ${name} ?''',
    );
    await launchUrl(
      link.asUri(),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget callNow(ContactProvider value) {
    // final pro = context.read<ContactProvider>();
    return InkWell(
      onTap: () => value.makePhoneCall(
          phoneNumber: value.mainBranch?.mobile1 ?? value.mainBranch?.mobile2),
      child: Container(
        height: 68.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: HexColor("#DBE2EA"))),
        child: Row(
          children: [
            SvgPicture.asset(Assets.iconsBlueCallBtn),
            // SvgPicture.asset(Assets.iconsGreenCallUs),
            // 14.horizontalSpace,
            10.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Call now",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FontPalette.black14Bold
                        .copyWith(color: HexColor("#131A24")),
                  ),
                  6.verticalSpace,
                  Text(
                    "24/7 customer care",
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                    style: FontPalette.black12Medium
                        .copyWith(color: HexColor("#8695A7")),
                    // Text(
                    //   "24/7 customer care support",
                    //   style: FontPalette.black12Medium
                    //       .copyWith(color: HexColor("#8695A7")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget whatsappNow(ContactProvider value) {
    // final pro = context.read<ContactProvider>();
    final appDataProvider = context.read<AppDataProvider>();
    BasicDetail? basicDetail = appDataProvider.basicDetailModel?.basicDetail;
    return InkWell(
      onTap: () => launchWhatsAppUri(
          mobile: value.mainBranch?.mobile1 ?? value.mainBranch?.mobile2,
          name: basicDetail?.name ?? "",
          registerID: basicDetail?.registerId ?? ""),
      child: Container(
        height: 68.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: HexColor("#DBE2EA"))),
        child: Row(
          children: [
            SizedBox(
                height: 23.w,
                width: 23.w,
                child: SvgPicture.asset(Assets.iconsWhatsapp)),
            // 14.horizontalSpace,
            10.horizontalSpace,
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chat with us",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FontPalette.black14Bold
                        .copyWith(color: HexColor("#131A24")),
                  ),
                  6.verticalSpace,
                  Text(
                    "on Whatsapp",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FontPalette.black12Medium
                        .copyWith(color: HexColor("#8695A7")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileTextField({
    String? labelText,
  }) {
    return ValueListenableBuilder<bool>(
        valueListenable: isBorder,
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
              padding: EdgeInsets.only(
                left: 26.w,
              ),
              height: 60.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  border: Border.all(
                      width: 1.sp,
                      color: value && focusNode.hasFocus
                          ? Colors.black
                          : dimBlackColor)),
              child: TextFormField(
                controller: _controller,
                // onChanged: ((value) => enableButton()),
                onChanged: ((value) {
                  context.read<ContactProvider>().updateMobile(value);
                }),
                keyboardType: TextInputType.number,
                style: FontPalette.black16SemiBold,
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        ReusableWidgets.customBottomSheet(
                            context: context,
                            child: CountryPickerContainer(
                              onChange: (val) {
                                print(val!.countryFlag! +
                                    val.dialCode.toString());
                                context
                                    .read<ContactProvider>()
                                    .updateContryFlag(val.countryFlag!,
                                        val.dialCode.toString());
                              },
                            ));
                      },
                      onLongPress: () {
                        //TODO
                      },
                      child: Consumer<ContactProvider>(
                        builder: (context, pro, child) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 32.88.w,
                                height: 22.87.h,
                                child: pro.countryFlagUrl != ""
                                    ? SvgPicture.network(
                                        pro.countryFlagUrl,
                                        width: 32.88.w,
                                        height: 22.87.h,
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
                                pro.countryCode,
                                style: FontPalette.black16SemiBold,
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
                          );
                        },
                      )),
                  border: InputBorder.none,
                  labelText: labelText,
                  labelStyle: value && focusNode.hasFocus
                      ? FontPalette.f8695A7_12semiBold
                      : FontPalette.f8695A7_12semiBold
                          .copyWith(fontSize: 16.sp, color: darkGreyColor),
                ),
              ));
        });
  }

  static Widget fileAdded({
    String? title,
    String? iconPath,
    VoidCallback? onTap,
    bool makeRoundedButton = false,
    bool centerTitle = true,
    double? horizontalPadding,
    double? height,
    double? width,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0.0),
      child: Container(
        // color:  Colors.red,
        width: width ?? double.maxFinite,
        height: height,
        decoration: makeRoundedButton
            ? BoxDecoration(
                color: color ?? Colors.white,
                border: Border.all(width: 1.w, color: HexColor("#2995E5")),
                borderRadius: BorderRadius.circular(21.r))
            : null,
        child: Row(
          mainAxisAlignment:
              centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset(iconPath ?? Assets.iconsSmallBlueAdd),
            4.horizontalSpace,
            Flexible(
              child: Text(title ?? "Add horoscope",
                      style: FontPalette.black16ExtraBold.copyWith(
                          fontSize: 10.sp, color: HexColor("#2995E5")))
                  .avoidOverFlow(),
            ),
            InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 15,
                ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // Future.microtask(() => context.read<ContactProvider>().init());
    Future.microtask(() {
      context.read<ContactProvider>().initSupport();
      context.read<ContactProvider>().getContactBranches();
      _controller.clear();
    });
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
