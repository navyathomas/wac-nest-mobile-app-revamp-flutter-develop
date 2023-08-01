import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/contact_address_count_model.dart';
import 'package:nest_matrimony/models/partner_interest_model.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/address_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/providers/profile_handler_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/firebase_analytics_services.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/jumping_dots.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/report_profile_alert_dialog.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/common_map_view.dart';
import 'package:nest_matrimony/widgets/common_outline_btn.dart';
import 'package:nest_matrimony/widgets/custom_radio.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/contact_address_model.dart';
import '../../../models/profile_detail_default_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/widget_handler/pdf_handler.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/bottom_response_view.dart';
import '../../../widgets/common_alert_view.dart';
import '../../../widgets/common_text_btn.dart';
import '../../alert_views/address_view_reached_alert.dart';
import '../../alert_views/common_alert_view.dart';
import 'map_view_tile.dart';

class PartnerDetailBottomSheets {
  static void showInterestedSheet(BuildContext context,
      {VoidCallback? onTap, String? routeName}) {
    context.read<ProfileHandlerProvider>().updatedSelectedInterestId(1);
    ReusableWidgets.customBottomSheet(
        context: context,
        routeName: routeName,
        child: _InterestedListTile(
          onTap: onTap,
        ));
  }

  static void showContactDetailAlert(BuildContext context) {
    final addressModel = context.read<AddressProvider>();
    addressModel.pageInit();
    if (addressModel.contactAddressCountModel == null) {
      addressModel.getContactAddressModel();
    }
    ReusableWidgets.customMaterialBottomSheet(
        context: context,
        name: Constants.contactDetailAlert,
        child: const _ContactDetailAlert(),
        isDismissible: true);
  }

  static void showViewMoreSheet(BuildContext context) {
    if (AppConfig.isAuthorized) {
      context.read<ProfileHandlerProvider>().updateBtnLoader(false);
      ReusableWidgets.customBottomSheet(
          context: context,
          child: _ViewMoreContainer(
            cxt: context,
          ));
    } else {
      context
          .read<AuthProvider>()
          .updateNavFrom(RouteGenerator.routePartnerSingleProfileDetail);
      Navigator.pushNamed(context, RouteGenerator.routeLogin);
    }
  }

  static void showInterestRespondSheet(BuildContext context,
      {bool isDismissible = true, required Function onButtonTap}) {
    final model = context.read<PartnerDetailProvider>();
    ReusableWidgets.customMaterialBottomSheet(
        context: context,
        child: _InterestRespondTile(
          partnerDetailModel: model.partnerDetailModel,
          onButtonTap: onButtonTap,
        ),
        isDismissible: isDismissible);
  }

  static void showContactAddressSheet(BuildContext context) {
    ReusableWidgets.customBottomSheet(
        context: context, child: const _ContactAddressContainer());
  }
}

class _InterestedListTile extends StatelessWidget {
  final VoidCallback? onTap;
  const _InterestedListTile({Key? key, this.onTap}) : super(key: key);

  Widget _contentTile(InterestData? interestData) {
    return Selector<ProfileHandlerProvider, int>(
        selector: (context, provider) => provider.selectedInterestId,
        builder: (context, value, child) {
          return InkWell(
            onTap: () => context
                .read<ProfileHandlerProvider>()
                .updatedSelectedInterestId(interestData?.key ?? -2),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 7.h),
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 10.w),
              decoration: BoxDecoration(
                  color: value == (interestData?.key ?? -1)
                      ? HexColor('#FEDEF4')
                      : Colors.white,
                  border:
                      true ? null : Border.all(color: ColorPalette.pageBgColor),
                  borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                children: [
                  CustomRadio(
                    isSelected: value == (interestData?.key ?? -1),
                  ),
                  10.horizontalSpace,
                  Expanded(
                      child: Text(
                    interestData?.value ?? '',
                    strutStyle: StrutStyle(height: 1.5.h),
                    style: FontPalette.f131A24_14SemiBold,
                  ).addEllipsis(maxLine: 2))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                33.horizontalSpaceRadius,
                Expanded(
                    child: Column(
                  children: [
                    10.verticalSpace,
                    Text(
                      context.loc.sendInterestTo,
                      textAlign: TextAlign.center,
                      style: FontPalette.f131A24_16Bold,
                    ),
                    6.verticalSpace,
                    Selector<PartnerDetailProvider, PartnerDetailModel?>(
                      selector: (context, provider) =>
                          provider.partnerDetailModel,
                      builder: (context, value, child) {
                        return Text(
                          value?.data?.basicDetails?.name ?? '',
                          textAlign: TextAlign.center,
                          style: FontPalette.f131A24_13Medium,
                        );
                      },
                    ),
                  ],
                )),
                ReusableWidgets.roundedCloseBtn(
                  context,
                )
              ],
            ),
          ),
          WidgetExtension.verticalDivider(
              height: 1.0, margin: EdgeInsets.only(top: 14.h, bottom: 17.h)),
          Expanded(
            child: Selector<PartnerDetailProvider,
                Tuple2<PartnerInterestModel?, LoaderState>>(
              selector: (cxt, provider) =>
                  Tuple2(provider.partnerInterestModel, provider.loaderState),
              builder: (cxt, value, child) {
                List<InterestData> interestData = value.item1?.data ?? [];
                return BottomResView(
                  loaderState: value.item2,
                  isEmpty: interestData.isEmpty,
                  onTap: () => context
                      .read<PartnerDetailProvider>()
                      .getPartnerInterestData(),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.chooseAMessage,
                          style: FontPalette.f8695A7_14Bold,
                        ),
                        Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: interestData.length,
                                itemBuilder: (context, index) {
                                  return _contentTile(interestData[index]);
                                })),
                        10.verticalSpace,
                        CommonButton(
                          height: 50.h,
                          onPressed: onTap,
                          title: context.loc.send,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ContactDetailAlert extends StatelessWidget {
  const _ContactDetailAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 33.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.sw(size: 0.01)),
            child: Text(
              context.loc.doUWantToSeeTheContactDetails,
              textAlign: TextAlign.center,
              strutStyle: StrutStyle(height: 1.5.h),
              style: FontPalette.f131A24_16SemiBold,
            ),
          ),
          14.verticalSpace,
          Selector<AddressProvider, ContactAddressCountModel?>(
            selector: (context, provider) => provider.contactAddressCountModel,
            builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 10.h),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '${value?.data?.count?.userAddressViewCount ?? 0} / ${value?.data?.totalContactViewLimit ?? 0}',
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(height: 1.5.h),
                  style: FontPalette.f131A24_14SemiBold,
                ),
              );
            },
          ),
          14.verticalSpace,
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: HexColor('#E3F3FF'),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.iconsInfoCircle,
                  height: 24.r,
                  width: 24.r,
                ),
                11.horizontalSpace,
                Expanded(
                    child: Text(
                  context.loc.subscriptionPlanMsg,
                  strutStyle: StrutStyle(height: 1.3.h),
                  style: FontPalette.f2995E5_13SemiBold,
                ))
              ],
            ),
          ),
          29.verticalSpace,
          Selector<AddressProvider, Tuple2<bool, ContactAddressCountModel?>>(
            selector: (context, provider) =>
                Tuple2(provider.btnLoader, provider.contactAddressCountModel),
            builder: (context, value, child) {
              List<ProfileDetailDefaultModel> profiles =
                  context.read<PartnerDetailProvider>().defaultProfiles;
              int profileId = profiles.isEmpty
                  ? -1
                  : profiles[profiles.length - 1].id ?? -1;
              return Row(
                children: [
                  Expanded(
                      child: CommonOutlineBtn(
                    height: 50.h,
                    title: context.loc.cancel,
                    fontStyle: FontPalette.black16Bold,
                    onPressed:
                        value.item1 ? null : () => Navigator.of(context).pop(),
                  )),
                  9.horizontalSpace,
                  Expanded(
                      child: CommonButton(
                    height: 50.h,
                    title: context.loc.ok,
                    isLoading: value.item1 || value.item2?.data == null,
                    onPressed: () {
                      context
                          .read<AddressProvider>()
                          .getProfileAddressData(profileId, onSuccess: (val) {
                        if (val ?? false) {
                          Navigator.of(context).pop();
                          context
                              .read<AddressProvider>()
                              .getContactAddressModel();
                          PartnerDetailBottomSheets.showContactAddressSheet(
                              context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      }, onCountZero: (String? val) {
                        if ((val ?? '').isNotEmpty) {
                          Navigator.of(context).pop();
                          CommonAlertDialog.showDialogPopUp(
                              context,
                              AddressViewReachedAlert(
                                msg: val,
                              ),
                              barrierDismissible: false);
                        }
                      });
                    },
                  ))
                ],
              );
            },
          ),
          20.verticalSpace
        ],
      ),
    );
  }
}

class _ContactAddressContainer extends StatelessWidget {
  const _ContactAddressContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AddressProvider, ContactAddressModel?>(
      selector: (context, provider) => provider.contactAddressModel,
      builder: (context, value, child) {
        return Container(
          height: (value?.data?.msg?.longitude != 0.0 &&
                  value?.data?.msg?.latitude != 0.0)
              ? context.sh(size: 0.75)
              : null,
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 14.h),
          child: Column(
            children: [
              Text(
                context.loc.contactAddress,
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(height: 1.5.h),
                style: FontPalette.f09274D_16Bold,
              ),
              23.verticalSpace,
              if ((value?.data?.msg?.houseAddress ?? '').isNotEmpty)
                _IconTile(
                    icon: Assets.iconsLocationPinkBg,
                    title: value?.data?.msg?.houseAddress ?? ''),
              _IconTile(
                  icon: Assets.iconsPhoneOrangeBg,
                  title:
                      '${value?.data?.msg?.contacts?.mobile != null ? '${value!.data!.msg!.contacts!.mobile}' : ''}${value?.data?.msg?.phoneNo != null ? ', ${value!.data!.msg!.phoneNo}' : ''}'),
              if (value?.data?.msg?.whatsappNo != null)
                _IconTile(
                    icon: Assets.iconsWhatsapp,
                    title: value!.data!.msg!.whatsappNo ?? ''),
              18.verticalSpace,
              if (value?.data?.msg?.longitude != 0.0 &&
                  value?.data?.msg?.latitude != 0.0)
                MapViewTile(
                  latitude: value?.data?.msg?.latitude,
                  longitude: value?.data?.msg?.longitude,
                )
            ],
          ),
        );
      },
    );
  }
}

class _IconTile extends StatelessWidget {
  final String icon;
  final String title;
  _IconTile({Key? key, required this.icon, required this.title})
      : super(key: key);

  ValueNotifier<bool> enableCenter = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: ValueListenableBuilder<bool>(
          valueListenable: enableCenter,
          builder: (context, value, widgetChild) {
            widgetChild = LayoutBuilder(builder: (context, constraints) {
              final span = TextSpan(
                text: title,
                style: FontPalette.f131A24_16Medium.copyWith(height: 1.6.h),
              );
              final tp =
                  TextPainter(text: span, textDirection: TextDirection.ltr);
              tp.layout(maxWidth: constraints.maxWidth);
              final numLines = tp.computeLineMetrics().length;
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                enableCenter.value = numLines == 1 ? true : false;
              });
              return Text(
                title,
                style: FontPalette.f131A24_16Medium,
                strutStyle: StrutStyle(height: 1.6.h),
              );
            });
            return Row(
              crossAxisAlignment:
                  value ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 32.r,
                  width: 32.r,
                  fit: BoxFit.contain,
                ),
                14.horizontalSpace,
                Expanded(child: widgetChild)
              ],
            );
          }),
    );
  }
}

class _ViewMoreContainer extends StatelessWidget {
  final BuildContext? cxt;
  const _ViewMoreContainer({Key? key, this.cxt}) : super(key: key);

  Widget _iconTile(BuildContext context,
      {required String icon,
      required String title,
      VoidCallback? onTap,
      bool loading = false}) {
    return InkWell(
      onTap: loading ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.w),
        child: Row(
          children: [
            SizedBox(
                height: 20.r,
                width: 20.r,
                child: loading
                    ? const CircularProgressIndicator(
                        strokeWidth: 3,
                      )
                    : SvgPicture.asset(
                        icon,
                        fit: BoxFit.contain,
                      )),
            9.horizontalSpace,
            Expanded(
                child: Text(
              title,
              style: FontPalette.f131A24_14SemiBold,
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerDetailProvider, List<ProfileDetailDefaultModel>>(
      selector: (context, provider) => provider.defaultProfiles,
      builder: (context, value, child) {
        int profileId = value.isEmpty ? -1 : value[value.length - 1].id ?? -1;
        return Column(
          children: [
            16.verticalSpace,
            _iconTile(context,
                icon: Assets.iconsShare, title: context.loc.share, onTap: () {
              shareProfile(context);
            }),
            Selector<
                    PartnerDetailProvider,
                    Tuple4<PartnerDetailModel?, Map<int, List<String>>,
                        Map<int, List<String>>, bool>>(
                selector: (context, provider) => Tuple4(
                    provider.partnerDetailModel,
                    provider.grahanilaData,
                    provider.navamshakamData,
                    provider.pdfLoading),
                builder: (context, partnerDetailModel, _) {
                  return _iconTile(
                      loading: partnerDetailModel.item4,
                      context,
                      icon: Assets.iconsDownloadGrey,
                      title: context.loc.downloadProfile, onTap: (() {
                    context.read<PartnerDetailProvider>().pdfLoader(true);
                    final baseImagePath =
                        context.read<AppDataProvider>().urlData!.fullImage;

                    try {
                      PdfHandler.instance
                          .generatePdf(
                              context,
                              partnerDetailModel.item1,
                              partnerDetailModel.item2,
                              partnerDetailModel.item3,
                              baseImagePath)
                          .then((value) {
                        Navigator.pop(context);
                        context.read<PartnerDetailProvider>().pdfLoader(false);
                      });
                    } on Exception catch (e) {
                      context.read<PartnerDetailProvider>().pdfLoader(false);
                      debugPrint("something went wrong on device $e");
                    }
                  }));
                }),
            WidgetExtension.horizontalDivider(
                color: HexColor('#E4E7E8'),
                margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h)),
            Selector<PartnerDetailProvider, PartnerDetailModel?>(
              selector: (context, provider) => provider.partnerDetailModel,
              builder: (context, partnerDetailModel, _) {
                bool isReported =
                    (partnerDetailModel?.data?.isReported ?? 0) == 1;
                return _iconTile(context,
                    icon: Assets.iconsFlagGrey,
                    title:
                        isReported ? context.loc.reported : context.loc.report,
                    onTap: isReported
                        ? null
                        : () {
                            context.rootPop;
                            CommonAlertDialog.showDialogPopUp(
                                barrierDismissible: false,
                                context,
                                Selector<ProfileHandlerProvider, bool>(
                                  selector: (context, provider) =>
                                      provider.btnLoader,
                                  builder: (context, value, child) {
                                    return ReportProfileAlertDialog(
                                      profileId: profileId,
                                      buttonLoader: value,
                                      buildContext: cxt,
                                    );
                                  },
                                ));
                          });
              },
            ),
            Selector<PartnerDetailProvider, PartnerDetailModel?>(
              selector: (context, provider) => provider.partnerDetailModel,
              builder: (context, partnerDetailModel, _) {
                bool isBlocked =
                    (partnerDetailModel?.data?.isBlocked ?? 0) == 1;
                return _iconTile(context,
                    icon: Assets.iconsEditUser,
                    title: isBlocked
                        ? context.loc.unBlockUser
                        : context.loc.blockUser, onTap: () {
                  Navigator.pop(context);
                  CommonAlertDialog.showDialogPopUp(
                      barrierDismissible: false,
                      context,
                      Selector<ProfileHandlerProvider, bool>(
                        selector: (context, provider) => provider.btnLoader,
                        builder: (context, value, child) {
                          return CommonAlertView(
                            buttonText: context.loc.confirm,
                            heading: context.loc.attentionPlease,
                            contents: isBlocked
                                ? context.loc.unBlockAlertText
                                : context.loc.blockAlertText,
                            buttonLoader: value,
                            onTap: () {
                              BuildContext buildContext = cxt ?? context;
                              final model =
                                  buildContext.read<PartnerDetailProvider>();
                              buildContext
                                  .read<ProfileHandlerProvider>()
                                  .blockProfileRequest(buildContext, profileId,
                                      onSuccess: () {
                                Navigator.pop(context);
                                if (model.defaultProfiles.length > 1) {
                                  model.sliderRightCard(buildContext);
                                } else {
                                  Navigator.maybePop(context);
                                }
                              });
                            },
                          );
                        },
                      ));
                });
              },
            ),
            WidgetExtension.horizontalDivider(
                color: HexColor('#E4E7E8'),
                height: 1.5.h,
                margin: EdgeInsets.only(top: 10.h)),
            CommonTextBtn(
              titleWidget: Container(
                height: 48.h,
                alignment: Alignment.center,
                child: Text(
                  'Close',
                  textAlign: TextAlign.center,
                  style: FontPalette.f131A24_16Bold,
                ),
              ),
              onTap: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<void> shareProfile(BuildContext context) async {
    final model = context.read<PartnerDetailProvider>();
    String link = model.partnerDetailModel?.data?.profileUrl ??
        'https://nestmatrimony.com/';
    FirebaseAnalyticsService.instance.logShareData(url: link);

    ReusableWidgets.customCircularLoader(context);
    try {
      String text =
          'Check out ${model.partnerDetailModel?.data?.basicDetails?.name ?? ''} profile $link on Nest Matrimony';
      Share.share(text)
          .whenComplete(() => context.rootPop)
          .onError((error, stackTrace) => context.rootPop);
    } catch (_) {
      context.rootPop;
    }
  }
}

class _InterestRespondTile extends StatelessWidget {
  _InterestRespondTile(
      {Key? key, this.partnerDetailModel, required this.onButtonTap})
      : super(key: key);
  final PartnerDetailModel? partnerDetailModel;
  final Function onButtonTap;
  ValueNotifier<bool> declineBtnStat = ValueNotifier(false);
  ValueNotifier<bool> acceptBtnStat = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 26.h, bottom: 34.h),
          child: Text(
            msgByGender(
                partnerDetailModel?.data?.basicDetails?.isMale, context),
            textAlign: TextAlign.center,
            style: FontPalette.f131A24_16SemiBold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 35.h),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: declineBtnStat,
                      builder: (context, value, _) {
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.r),
                                  side:
                                      BorderSide(color: HexColor('#DBE2EA')))),
                          onPressed: value
                              ? null
                              : () {
                                  declineBtnStat.value = true;
                                  final model = context.read<MailBoxProvider>();
                                  model.acceptOrDeclineInterest(
                                      context,
                                      context
                                              .read<PartnerDetailProvider>()
                                              .interestId ??
                                          -1,
                                      InterestAction.decline, onSuccess: () {
                                    onButtonTap(true);
                                    model.mailBoxInterestDeclinedByMeDataList
                                        .clear();
                                    model.getInterestList(context,
                                        enableLoader: true,
                                        interestTypes: InterestTypes.received);
                                    declineBtnStat.value = false;
                                    context.rootPop;
                                  }, onFailure: () {
                                    onButtonTap(false);
                                    declineBtnStat.value = false;
                                  });
                                },
                          child: value
                              ? JumpingDots(
                                  color: HexColor('#565F6C'),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.iconsCloseLightGrey,
                                      height: 12.r,
                                      width: 12.r,
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      context.loc.decline,
                                      style: FontPalette.f565F6C_14Bold,
                                      maxLines: 1,
                                    ).flexWrap
                                  ],
                                ),
                        );
                      }),
                ),
              ),
              5.horizontalSpace,
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: ValueListenableBuilder<bool>(
                    builder: (context, value, _) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: HexColor('#14BF84'),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.r),
                            ),
                          ),
                          onPressed: value
                              ? null
                              : () {
                                  acceptBtnStat.value = true;
                                  final model = context.read<MailBoxProvider>();
                                  model.acceptOrDeclineInterest(
                                      context,
                                      context
                                              .read<PartnerDetailProvider>()
                                              .interestId ??
                                          -1,
                                      InterestAction.accept, onSuccess: () {
                                    onButtonTap(true);
                                    model.mailBoxInterestAcceptedByMeDataList
                                        .clear();
                                    model.getInterestList(context,
                                        enableLoader: true,
                                        interestTypes: InterestTypes.received);
                                    acceptBtnStat.value = false;
                                    context.rootPop;
                                  }, onFailure: () {
                                    onButtonTap(false);
                                    acceptBtnStat.value = false;
                                  });
                                },
                          child: value
                              ? const JumpingDots(
                                  color: Colors.white,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.iconsCheckWhite,
                                      height: 12.r,
                                      width: 12.r,
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      context.loc.accept,
                                      style: FontPalette.white14Bold,
                                      maxLines: 1,
                                    ).flexWrap
                                  ],
                                ));
                    },
                    valueListenable: acceptBtnStat,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String msgByGender(bool? isMale, BuildContext context) {
    return isMale == null
        ? context.loc.areUAcceptingThisInterest
        : isMale
            ? context.loc.areUAcceptingHisInterest
            : context.loc.areUAcceptingHerInterest;
  }
}
