import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/services_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/service_screens/chat_title.dart';
import 'package:nest_matrimony/widgets/common_alert_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';
import '../../models/service_chat_list_response_model.dart';
import '../../models/services_reponse_model.dart';
import '../../providers/contact_provider.dart';
import '../../widgets/profile_image_view.dart';
import '../error_views/error_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../partner_profile_detail/widgets/report_user_chat_dialog.dart';

class StaffProfileCard extends StatefulWidget {
  final bool removeStatus;
  final VoidCallback? onTap;
  final ServicesData servicesData;
  late ScrollController controller;
  StaffProfileCard(
      {Key? key,
      this.removeStatus = false,
      required this.servicesData,
      this.onTap})
      : super(key: key);

  @override
  State<StaffProfileCard> createState() => _StaffProfileCardState();
}

class _StaffProfileCardState extends State<StaffProfileCard> {
  late FocusNode focusNode;
  late ScrollController controller;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = ScrollController();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext modalSheetContext = context;
    return GestureDetector(
      onTap: () {
        if (widget.servicesData.clientUsersId != null) {
          Navigator.pushNamed(
              context, RouteGenerator.routePartnerSingleProfileDetail,
              arguments: RouteArguments(
                  profileId: widget.servicesData.partnerClientUsersId));
        }
      },
      child: Container(
        //height: 179.h,
        width: double.maxFinite,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            //PROFILE SECTION

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 44.h,
                        width: 44.w,
                        child: _StaffProfileImage(
                          image: CommonFunctions.getImage(widget.servicesData
                                      .partnerUserData?.userPerferImage ??
                                  [])
                              .thumbImagePath(context),
                        ),
                      ),
                      12.horizontalSpace,
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.servicesData.partnerUserData?.name ?? '',
                              style: FontPalette.black13SemiBold
                                  .copyWith(fontSize: 14.sp),
                            ).avoidOverFlow(),
                            4.verticalSpace,
                            Text(
                              widget.servicesData.partnerClientWebId.toString(),
                              style: FontPalette.black10Medium.copyWith(
                                  fontSize: 11.sp, color: HexColor("#8695A7")),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widget.servicesData.userServiceType?.serviceType ==
                            'Both Side' &&
                        !widget.removeStatus
                    ? Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              context.loc.service,
                              style: FontPalette.black10Medium.copyWith(
                                  fontSize: 11.sp, color: HexColor("#8695A7")),
                            ),
                            Text(
                              (widget.servicesData.service ?? []).isNotEmpty
                                  ? widget.servicesData.service![0]
                                          .serviceTitle ??
                                      ''
                                  : '',
                              style: FontPalette.black12Medium
                                  .copyWith(color: HexColor("#131A24")),
                            ).avoidOverFlow(),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            //PROFILE SECTION
            11.verticalSpace,
            ReusableWidgets.horizontalLine(density: 1.h),
            19.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.servicesData.staffData?.staffName ?? '',
                    style: FontPalette.black12Medium
                        .copyWith(color: HexColor("#132031"), fontSize: 14.sp),
                  ),
                ),
                5.horizontalSpace,
                Text(
                  widget.servicesData.staffData?.branch?.branchName ?? '',
                  style: FontPalette.black10Medium
                      .copyWith(fontSize: 11.sp, color: HexColor("#8695A7")),
                ),
                5.horizontalSpace,
                Text(
                  Jiffy(widget.servicesData.createdAt).from(DateTime.now()),
                  style: FontPalette.black10Medium
                      .copyWith(fontSize: 11.sp, color: HexColor("#8695A7")),
                ),
              ],
            ),
            18.verticalSpace,
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                roundedShape(
                  iconPath: Assets.iconsBlueCall,
                  onTap: () {
                    context.read<ContactProvider>().makePhoneCall(
                        phoneNumber:
                            widget.servicesData.staffData?.officeNumber);
                    // launch(
                    //     "tel://${widget.servicesData.staffData?.branch?.landLine ?? widget.servicesData.staffData?.branch?.mobile1}");
                  },
                ),
                9.horizontalSpace,
                roundedShape(
                  iconPath: Assets.iconsWhatsapp,
                  onTap: () async {
                    await CommonFunctions.launchWhatsapp(
                      widget.servicesData.staffData?.officeNumber ?? '',
                      "Hi, You've received an inquiry from ${widget.servicesData.clientWebId ?? ''} ${widget.servicesData.userData?.name ?? ''} for the profile ${widget.servicesData.partnerUserData?.name ?? ''} ${widget.servicesData.partnerClientWebId ?? ''}",
                    );
                  },
                ),
                9.horizontalSpace,
                Flexible(
                    child: roundedShape(
                  width: double.maxFinite,
                  onTap: () async {
                    context.read<ServicesProvider>().getServicesChatList(
                        widget.servicesData.id ?? 0, false);
                    chatSheet(modalSheetContext,
                        widget.servicesData.staffData!.id ?? 0);
                  },
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget roundedShape(
      {double? width,
      double? height,
      String? iconPath,
      bool shareIcon = false,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 81.w,
        height: height ?? 44.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(width: 1.w, color: HexColor("#DBE2EA"))),
        child: iconPath != null
            ? Padding(
                padding: EdgeInsets.all(8.r),
                child: Center(child: SvgPicture.asset(iconPath)),
              )
            : Padding(
                padding: EdgeInsets.all(2.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 15.86.h,
                        width: 18.12.w,
                        child: Center(
                            child: SvgPicture.asset(Assets.iconsReplyIcon))),
                    8.horizontalSpace,
                    // 13.89.horizontalSpace,
                    Flexible(
                      child: Text(
                        context.loc.replyToStaff,
                        style: FontPalette.black14Bold
                            .copyWith(color: HexColor("#565F6C")),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> chatSheet(BuildContext context, int staffId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(28.r),
                topLeft: Radius.circular(28.r))),
        builder: (_) {
          return Consumer<ServicesProvider>(
            builder: (context, value, child) {
              CommonFunctions.afterInit(() {
                if (controller.hasClients) {
                  controller.animateTo(
                    controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5.h,
                    width: 50.w,
                    margin: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                        color: HexColor('#C1C9D2'),
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                  value.bottomSheetLoader == false
                      ? Stack(
                          children: [
                            value.bottomSheetLoader == true
                                ? SizedBox(
                                    height: context.sh(size: 0.8.h),
                                    width: double.maxFinite,
                                    child: const Center(
                                        child: CircularProgressIndicator()))
                                : SizedBox(
                                    height: context.sh(size: 0.8.h),
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        10.verticalSpace,
                                        Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context.loc.replyToStaff,
                                                  style: FontPalette.black16Bold
                                                      .copyWith(
                                                          color: HexColor(
                                                              "#131A24")),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 15.w,
                                                child: Container(
                                                  height: 20.w,
                                                  width: 20,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      CommonAlertDialog
                                                          .showDialogPopUp(
                                                              barrierDismissible:
                                                                  false,
                                                              context,
                                                              Selector<
                                                                  ServicesProvider,
                                                                  bool>(
                                                                selector: (context,
                                                                        provider) =>
                                                                    provider
                                                                        .btnLoader,
                                                                builder:
                                                                    (context,
                                                                        val,
                                                                        child) {
                                                                  print(val);
                                                                  return ReportChatAlertDialog(
                                                                    staffID: staffId
                                                                        .toString(),
                                                                    buttonLoader:
                                                                        val,
                                                                    buildContext:
                                                                        context,
                                                                  );
                                                                },
                                                              ));
                                                    },
                                                    child: const Icon(
                                                      Icons.flag,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),

                                        15.verticalSpace,
                                        ReusableWidgets.horizontalLine(
                                            density: 1),
                                        16.verticalSpace,

                                        //userChat tile
                                        Expanded(
                                            child: value.serviceChatDataList
                                                    .isNotEmpty
                                                ? ListView.builder(
                                                    controller: controller,
                                                    itemCount: value
                                                        .serviceChatDataList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ChatTile(
                                                        name: value
                                                                    .serviceChatDataList[
                                                                        index]
                                                                    .createdBy ==
                                                                '0'
                                                            ? value
                                                                .serviceChatDataList[
                                                                    index]
                                                                .getServiceData
                                                                ?.staffData
                                                                ?.staffName
                                                            : 'You',
                                                        profileImage: widget
                                                                .servicesData
                                                                .userData!
                                                                .userPerferImage!
                                                                .isNotEmpty
                                                            ? widget
                                                                .servicesData
                                                                .userData
                                                                ?.userPerferImage![
                                                                    0]
                                                                .imageFile
                                                            : '',
                                                        msg: value
                                                                .serviceChatDataList[
                                                                    index]
                                                                .message ??
                                                            '',
                                                        time: value
                                                            .serviceChatDataList[
                                                                index]
                                                            .createdAt,
                                                      );
                                                    },
                                                  )
                                                : const SizedBox.shrink()),
                                        //userchat tile close

                                        AnimatedPadding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  21.h),
                                          duration:
                                              const Duration(milliseconds: 100),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            width: context.sw(),
                                            // height: 200.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: HexColor(
                                                              "#F2F4F5"),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      9.r)),
                                                      width: context.sw(),
                                                      child: TextField(
                                                        controller:
                                                            messageController,
                                                        maxLines: null,
                                                        onChanged: (values) {
                                                          value.updateMessage(
                                                              values.trim());
                                                        },
                                                        // focusNode: focusNode,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10.w),
                                                            border: InputBorder
                                                                .none,
                                                            hintText: context
                                                                .loc.typeHere,
                                                            hintStyle: FontPalette
                                                                .black16Medium
                                                                .copyWith(
                                                                    color: HexColor(
                                                                        "#8695A7"))),
                                                        style: FontPalette
                                                            .black14Medium
                                                            .copyWith(
                                                                color: HexColor(
                                                                    "#131A24")),
                                                      )),
                                                ),
                                                10.horizontalSpace,
                                                InkWell(
                                                  onTap: () {
                                                    if (value
                                                        .message.isNotEmpty) {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      value.sendChatMessage({
                                                        'service_id': widget
                                                            .servicesData.id,
                                                        'message':
                                                            messageController
                                                                .text
                                                                .trim(),
                                                        'created_by': "1"
                                                      });
                                                      messageController.clear();
                                                    }
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: EdgeInsets.only(
                                                          left: 3.w),
                                                      decoration: BoxDecoration(
                                                        color: value.message
                                                                .isNotEmpty
                                                            ? HexColor(
                                                                '#950553')
                                                            : HexColor(
                                                                    '#950553')
                                                                .withOpacity(
                                                                    .5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      height: 53.h,
                                                      width: 48.w,
                                                      child: SvgPicture.asset(
                                                        Assets.iconsSend,
                                                        height: 20.h,
                                                        width: 30.w,
                                                      )),
                                                ).removeSplash()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: ReusableWidgets.roundedCloseBtn(context),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: context.sh(size: 0.8.h),
                          width: double.maxFinite,
                          child:
                              const Center(child: CircularProgressIndicator()))
                ],
              );
            },
          );
        });
  }
}

class _StaffProfileImage extends StatelessWidget {
  final String image;
  const _StaffProfileImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      alignment: Alignment.topCenter,
      image: NetworkImage(image),
      placeholderBuilder: (context) => Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: ColorPalette.shimmerColor, //HexColor('E8E8E8'),
            shape: BoxShape.circle),
      ),
      errorBuilder: (context, _, __) =>
          SvgPicture.asset(Assets.iconsNoImageIcon),
      imageBuilder: OctoImageTransformer.circleAvatar(),
      fit: BoxFit.cover,
      height: double.maxFinite,
      width: double.maxFinite,
    );
  }
}
