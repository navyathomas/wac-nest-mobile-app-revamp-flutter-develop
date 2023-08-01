import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/branches_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/contact_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
//import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<Datum> branches = [];
  bool isWhatsappInstalled = true;
  BasicDetail? basicDetail;

  // we are using this function inorder to route to whatsapp chat
  Future<void> launchWhatsAppUri({String? mobile}) async {
    BasicDetail? basicDetails = basicDetail ??
        context.read<AppDataProvider>().basicDetailModel?.basicDetail;
    final link = WhatsAppUnilink(
      phoneNumber: '{91$mobile}',
      text:
          '''Hi,You've received an inquiry from ${basicDetails?.registerId ?? ""}, ${basicDetails?.name ?? ""} ?''',
    );
    await launchUrl(
      link.asUri(),
      mode: LaunchMode.externalApplication,
    );
  }

//.. make call
  Future<void> _makePhoneCall({String? phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber ?? "",
    );
    await launchUrl(launchUri);
  }

// ··· sent email
  Future<void> sentEmail({String? email}) async {
    BasicDetail? basicDetails = basicDetail ??
        context.read<AppDataProvider>().basicDetailModel?.basicDetail;

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject':
            'Enquiry from ${basicDetails?.registerId ?? ""}, ${basicDetails?.name ?? ""}',
        'body':
            '''Hi,You've received an inquiry from ${basicDetails?.registerId ?? ""}, ${basicDetails?.name ?? ""} ?'''
      }),
    );

    launchUrl(emailLaunchUri);
  }

  // Future<void> isInstalled() async {
  //   final whatsappInstalled =
  //       await WhatsappShare.isInstalled(package: Package.whatsapp);
  //   final businessWhatsappInstalled =
  //       await WhatsappShare.isInstalled(package: Package.businessWhatsapp);

  //   whatsappInstalled == true || businessWhatsappInstalled == true
  //       ? isWhatsappInstalled = true
  //       : isWhatsappInstalled = false;

  //   log('Whatsapp is installed: $whatsappInstalled');
  //   log('Business Whatsapp is installed: $businessWhatsappInstalled');
  // }

  // Future<void> whatappChat({String? mobile}) async {
  //   await WhatsappShare.share(
  //     text:
  //         '''Hi,You've received an inquiry from ${basicDetail?.registerId}, ${basicDetail?.name} ?''',
  //     phone: "91$mobile",
  //   );
  // }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    final contactProvider = context.read<ContactProvider>();
    final appDataProvider = context.read<AppDataProvider>();

    // isInstalled();
    basicDetail = appDataProvider.basicDetailModel?.basicDetail;
    Future.microtask(() {
      contactProvider.init();
      contactProvider.getContactBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Contact Us',
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
        body: Consumer<ContactProvider>(
          builder: (_, provider, __) {
            if (provider.loaderState == LoaderState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.loaderState == LoaderState.loaded) {
              branches = provider.data ?? [];
              return provider.data != null
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            21.76.verticalSpace,
                            provider.mainBranch != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nest Matrimony",
                                        style: FontPalette.black16Bold,
                                      ),
                                      9.12.verticalSpace,
                                      _branchAddress(
                                          provider.mainBranch?.branchAddress ??
                                              ""),
                                      17.76.verticalSpace,
                                      iconText(
                                          onTap: () => _makePhoneCall(
                                              phoneNumber: provider
                                                      .mainBranch?.mobile1 ??
                                                  provider.mainBranch?.mobile2),
                                          title: provider.mainBranch?.mobile1 ??
                                              provider.mainBranch?.mobile2),
                                      22.26.verticalSpace,
                                      iconText(
                                          onTap: () => sentEmail(
                                              email:
                                                  provider.mainBranch?.email ??
                                                      ""),
                                          iconPath: Assets.iconsBoldSms,
                                          title:
                                              provider.mainBranch?.email ?? ""),
                                      24.11.verticalSpace,
                                      whatsappChatButton(
                                          onTap: () => launchWhatsAppUri(
                                              mobile: provider
                                                  .mainBranch?.whatsappNo)),
                                      23.verticalSpace,
                                      ReusableWidgets.horizontalLine(),
                                      20.76.verticalSpace,
                                    ],
                                  )
                                : const SizedBox(),
                            Text(
                              "Branch locations",
                              style: FontPalette.black16Bold
                                  .copyWith(color: HexColor("#131A24")),
                            ),
                            18.24.verticalSpace,
                            _listBranch(context),
                            15.verticalSpace,
                          ],
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator());
            } else if (provider.loaderState == LoaderState.error) {
              return const Center(child: Text("Exceptions"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _branchAddress(String? address) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 57.w),
            child: Text(
              address ?? "",
              style: FontPalette.black14Medium
                  .copyWith(color: HexColor("#131A24")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listBranch(
    BuildContext context,
  ) {
    return branches.isNotEmpty
        ? GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 7.h,
              crossAxisSpacing: 7.w,
              childAspectRatio: 168.w / 68.h,
              crossAxisCount: 2,
            ),
            children: List.generate(
                branches.length,
                (index) => branchCard(
                      location: branches[index].branchName ?? '',
                      mobile:
                          branches[index].mobile1 ?? branches[index].mobile2,
                      onTap: () => ReusableWidgets.customBottomSheet(
                          context: context,
                          child: bottomSheetContents(context, index)),
                    )))
        : Text(
            "No Branches",
            style:
                FontPalette.black14Medium.copyWith(color: HexColor("#131A24")),
          );
  }

  Widget bottomSheetContents(BuildContext context, int index) {
    return Container(
      height: context.sh(size: 0.4),
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 27.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            28.verticalSpace,
            Text(
              branches[index].branchName ?? "",
              style: FontPalette.black16Bold.copyWith(fontSize: 18.sp),
            ),
            16.verticalSpace,
            Text(
              branches[index].branchAddress ?? "",
              style: FontPalette.black14Medium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            23.verticalSpace,
            iconText(
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall(
                      phoneNumber:
                          branches[index].mobile1 ?? branches[index].mobile2);
                },
                title: branches[index].mobile1 ?? branches[index].mobile2),
            22.26.verticalSpace,
            iconText(
                onTap: () {
                  Navigator.pop(context);
                  sentEmail(email: branches[index].email ?? "");
                },
                iconPath: Assets.iconsBoldSms,
                title: branches[index].email ?? ""),
            31.62.verticalSpace,
            whatsappChatButton(
              onTap: () {
                Navigator.pop(context);
                launchWhatsAppUri(mobile: branches[index].whatsappNo);
              },
            ),
            14.verticalSpace
          ],
        ),
      ),
    );
  }

  Widget whatsappChatButton({VoidCallback? onTap}) {
    return InkWell(
      onTap: !isWhatsappInstalled
          ? (() =>
              Helpers.successToast("Whatsapp is not installed on your device"))
          : onTap,
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
            color: HexColor("#21C155"),
            borderRadius: BorderRadius.circular(23.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 19.41.h,
                width: 19.41.w,
                child: SvgPicture.asset(Assets.iconsLogoWhatsapp)),
            14.84.horizontalSpace,
            Text(
              "Chat with us on WhatsApp",
              style: FontPalette.black14Bold.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    ).removeSplash();
  }

  Widget iconText({String? iconPath, String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              height: 17.5.h,
              width: 17.5.w,
              child: SvgPicture.asset(iconPath ?? Assets.iconsBoldCall)),
          14.horizontalSpace,
          Text(
            title ?? "Demo",
            style: FontPalette.black14Bold.copyWith(color: HexColor("#2995E5")),
          ),
        ],
      ),
    ).removeSplash();
  }

  Widget branchCard({VoidCallback? onTap, String? location, String? mobile}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 68.h,
        // width: 168.w,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(width: 1.w, color: HexColor("#E4E7E8"))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(location ?? "",
                      style: FontPalette.black14Bold
                          .copyWith(color: HexColor("#565F6C")),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  9.verticalSpace,
                  Text(
                    mobile ?? "",
                    style: FontPalette.black14Bold
                        .copyWith(color: HexColor("#131A24")),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            SvgPicture.asset(Assets.iconsLiteChevronRight)
          ],
        ),
      ),
    );
  }
}
