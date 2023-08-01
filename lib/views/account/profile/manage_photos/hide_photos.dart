import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../utils/font_palette.dart';

class HidePhotos extends StatelessWidget {
  const HidePhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Hide photo',
              style:
                  FontPalette.white16Bold.copyWith(color: HexColor("#131A24"))),
          elevation: 0.5,
          leading: ReusableWidgets.roundedBackButton(context),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
        ),
        body: Consumer<AccountProvider>(
          builder: (context, pro, child) {
            return SingleChildScrollView(
              child: Column(children: [
                Stack(
                  children: [
                    hidePhotoSection(
                        provider: pro,
                        status: pro.toogleSwitchStatus[0]!,
                        onChanged: () {
                          pro.updateSwitchStatus(0);
                        }),
                    pro.btnLoader
                        ? SizedBox(
                            height: context.sh(size: 0.8),
                            width: context.sw(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ]),
            );
          },
        ));
  }

//IOS type Switcher
  Widget switchToggle({bool status = true, VoidCallback? onChanged}) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        alignment: status ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(4.h),
        height: 25.h,
        width: 46.w,
        decoration: BoxDecoration(
            color: status ? ColorPalette.primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(16.r)),
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 17.h,
          width: 17.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget hidePhotoSection(
      {required AccountProvider provider,
      bool status = false,
      VoidCallback? onChanged}) {
    return Container(
      padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 18.18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hide photos",
                  style: FontPalette.black15SemiBold
                      .copyWith(color: HexColor("#131A24"))),
              Text("Hide your photos from other users",
                  style: FontPalette.black12Medium
                      .copyWith(color: HexColor("#565F6C"))),
            ],
          ),
          switchToggle(
            status: status,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
