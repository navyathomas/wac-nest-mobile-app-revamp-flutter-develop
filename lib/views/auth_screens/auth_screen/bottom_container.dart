import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/widgets/common_text_btn.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/route_arguments.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_outline_btn.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.r), topRight: Radius.circular(22.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          29.0.verticalSpace,
          Center(
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: context.loc.fiveLakh,
                    style: FontPalette.black26Bold
                        .copyWith(color: HexColor('#950553')),
                    children: [
                      TextSpan(
                          text: context.loc.profilesToChooseYourMatch,
                          style: FontPalette.black26Bold
                              .copyWith(color: HexColor('#131A24'))),
                      // TextSpan(
                      //     text: context.loc.toChooseYourMatch,
                      //     style: FontPalette.black26Bold
                      //         .copyWith(color: HexColor('#131A24')))
                    ])),
          ),
          19.0.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CommonOutlineBtn(
                  title: context.loc.login,
                  fontStyle: FontPalette.black17Bold,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.routeLogin);
                  },
                ),
              ),
              9.0.horizontalSpace,
              Expanded(
                child: CommonButton(
                  title: context.loc.register,
                  fontStyle: FontPalette.white16Bold,
                  onPressed: () {
                    context
                        .read<RegistrationProvider>()
                        .updateCountryData(indianData);
                    Navigator.pushNamed(
                        context, RouteGenerator.routeRegistrationScreen);
                  },
                ),
              )
            ],
          ),
          21.0.verticalSpace,
          RichText(
              textAlign: TextAlign.center,
              strutStyle: StrutStyle(height: 1.1.h),
              text: TextSpan(
                  text: context.loc.loginConditions,
                  style: FontPalette.black10Regular
                      .copyWith(color: HexColor('#7C7B84')),
                  children: [
                    TextSpan(
                        text: context.loc.termsOfUse,
                        style: FontPalette.black10Bold
                            .copyWith(color: HexColor('#7C7B84')),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, RouteGenerator.routeTermsAndPolicy,
                              arguments: RouteArguments(
                                  title: Constants.legalList[0],
                                  anyValue: true))),
                    TextSpan(
                      text: context.loc.and,
                      style: FontPalette.black10Regular
                          .copyWith(color: HexColor('#7C7B84')),
                    ),
                    TextSpan(
                        text: context.loc.privacyPolicy,
                        style: FontPalette.black10Bold
                            .copyWith(color: HexColor('#7C7B84')),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, RouteGenerator.routeTermsAndPolicy,
                              arguments: RouteArguments(
                                  title: Constants.legalList[1],
                                  anyValue: false)))
                  ])),
          5.0.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextBtn(
                text: context.loc.support,
                onTap: () =>
                    Navigator.pushNamed(context, RouteGenerator.routeSupport),
              ),
              CommonTextBtn(
                text: context.loc.contactUs,
                onTap: () => Navigator.pushNamed(
                    context, RouteGenerator.routeToContactUs),
              ),
            ],
          ),
          15.0.verticalSpace
        ],
      ),
    );
  }
}
