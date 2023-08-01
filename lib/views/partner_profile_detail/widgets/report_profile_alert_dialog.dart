import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:provider/provider.dart';

import '../../../providers/partner_detail_provider.dart';
import '../../../providers/profile_handler_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../utils/jumping_dots.dart';

class ReportProfileAlertDialog extends AlertDialog {
  final bool buttonLoader;
  final int profileId;
  final BuildContext? buildContext;

  const ReportProfileAlertDialog(
      {Key? key,
      this.buttonLoader = false,
      required this.profileId,
      this.buildContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 39.w),
      content: _ContentView(
        profileId: profileId,
        buttonLoader: buttonLoader,
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final bool buttonLoader;
  final int profileId;
  final BuildContext? buildContext;

  const _ContentView(
      {Key? key,
      required this.buttonLoader,
      required this.profileId,
      this.buildContext})
      : super(key: key);

  static TextEditingController controller = TextEditingController();

  Widget upgradeNowButton(BuildContext context,
      {Color? buttonColor, String? buttonText, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        height: 35.h,
        width: 118.w,
        alignment: Alignment.center,
        child: Text(
          buttonText ?? '',
          style: onPressed == null
              ? FontPalette.f565F6C16Bold
              : FontPalette.primary16Bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 316.h,
      width: double.maxFinite,
      child: Column(
        children: [
          36.verticalSpace,
          Text(context.loc.attentionPlease, style: FontPalette.black18Bold),
          13.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              context.loc.reportAlertText,
              textAlign: TextAlign.center,
              style: FontPalette.black14Medium,
              strutStyle: StrutStyle(height: 1.5.h),
            ),
          ),
          15.verticalSpace,
          Container(
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: ColorPalette.pageBgColor,
                borderRadius: BorderRadius.circular(3.r)),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: FontPalette.black13Regular,
                  hintText: context.loc.enterUrReason,
                  contentPadding: EdgeInsets.all(10.r)),
              maxLines: 4,
            ),
          ),
          17.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: upgradeNowButton(context,
                        buttonText: context.loc.cancel)),
                Expanded(
                    child: (buttonLoader
                            ? const JumpingDots(numberOfDots: 3)
                            : upgradeNowButton(context, onPressed: () {
                                if (controller.text.isEmpty) {
                                  "Please enter your reason for report."
                                      .showToast();
                                } else {
                                  BuildContext cxt = buildContext ?? context;
                                  final model =
                                      cxt.read<PartnerDetailProvider>();
                                  context
                                      .read<ProfileHandlerProvider>()
                                      .reportProfileRequest(
                                          context, profileId, controller.text,
                                          onSuccess: () {
                                    Navigator.pop(context);
                                    if (model.defaultProfiles.length > 1) {
                                      model.sliderRightCard(cxt);
                                    } else {
                                      Navigator.maybePop(context);
                                    }
                                  });
                                }
                              }, buttonText: context.loc.confirm))
                        .animatedSwitch())
              ],
            ),
          )
        ],
      ),
    );
  }
}
