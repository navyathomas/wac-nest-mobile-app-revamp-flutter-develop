import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

enum EPnav { free, mat, home, other }

class EasyPayHome extends StatelessWidget {
  const EasyPayHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> icons = [
      Assets.iconsRegisterIcon,
      Assets.iconsRingIcon,
      Assets.iconsHome,
      Assets.iconsSupportIcon,
    ];
    List<String> titles = [
      context.loc.feeForRegistration,
      context.loc.matrimonyServiceCharge,
      context.loc.homePageActivation,
      context.loc.otherServiceCharge,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: SizedBox(
        height: context.sh(),
        width: context.sw(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              20.verticalSpace,
              Text(
                context.loc.easyPay,
                style: FontPalette.black28Bold,
              ),
              15.verticalSpace,
              Text(context.loc.easyPayDialog,
                  textAlign: TextAlign.center,
                  style: FontPalette.black14SemiBold
                      .copyWith(color: HexColor('#565F6C'))),
              37.verticalSpace,
              _gridbuild(icons: icons, titles: titles, context: context)
            ],
          ),
        ),
      ),
    );
  }

//GRID BUILDER
  Widget _gridbuild({
    required BuildContext context,
    List<String>? icons,
    List<String>? titles,
  }) {
    return Expanded(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 1),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCard(
                    context: context,
                    icon: icons![index],
                    title: titles![index],
                    ePnav: EPnav.values.elementAt(index)),
                childCount: icons!.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 13.h,
                   mainAxisExtent: 145.h + (Helpers.validateScale(context, 0.0) * 30).h,
                 // mainAxisExtent: 138.h,

                  mainAxisSpacing: 13.h,
                  crossAxisCount: 2),
            ),
          ),
        ],
      ),
    );
  }

//CARD
  Widget _buildCard({
    required String icon,
    String? title,
    required EPnav ePnav,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        context.read<PaymentProvider>().paymentPurpose = title;
        context.read<PaymentProvider>().clearValues();
        Navigator.pushNamed(
          context,
          RouteGenerator.routeCommonEasyPayForm,
          arguments: RouteArguments(title: title, anyValue: ePnav),
        );
      },
      child: Container(
        // width: 165.w,
        decoration: BoxDecoration(
            border: Border.all(
              color: HexColor('#E4E7E8'),
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.r))),
        child: Padding(
          padding: EdgeInsets.only(left: 18.r, top: 18.r, right: 50.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 37.h, width: 37.w, child: SvgPicture.asset(icon)),
              12.verticalSpace,
              Flexible(
                flex: 2,
                child: Text(title ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: FontPalette.black16SemiBold
                        .copyWith(color: HexColor('#131A24'))),
              ),
              // 18.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
