import 'dart:io';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider_extends.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/profile_handler_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/progress_indicator.dart';

class BlockedUsers extends StatefulWidget {
  final String? appbarTitle;
  const BlockedUsers({Key? key, this.appbarTitle}) : super(key: key);

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  String userID = "";

  getBlockedUserLists() {
    Future.microtask(() {
      userID = context
              .read<AppDataProvider>()
              .basicDetailModel
              ?.basicDetail
              ?.id
              ?.toString() ??
          "";
      context.read<AccountProviderExtends>().init();
      context.read<AccountProviderExtends>().getBlockedUsers();
    });
  }

  @override
  void initState() {
    getBlockedUserLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.appbarTitle ?? 'App_title',
            style: FontPalette.white16Bold
                .copyWith(color: const Color.fromARGB(255, 78, 64, 64)),
          ),
          elevation: 0.0,
          leading: ReusableWidgets.roundedBackButton(context),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
        ),
        body: Column(
          children: [
            // 25.verticalSpace,
            Expanded(
              child: Consumer<AccountProviderExtends>(
                builder: (context, pro, child) {
                  return switchView(pro.loaderState, pro, context);
                  // if ((pro.blockedUsersList ?? []).isNotEmpty) {
                  //   return ListView.separated(
                  //       padding: EdgeInsets.symmetric(vertical: 25.h),
                  //       physics: const BouncingScrollPhysics(),
                  //       itemBuilder: (context, index) {
                  //         return blockedUserTile(
                  //             imgURL: pro.blockedUsersList?[index].profileImage,
                  //             username:
                  //                 pro.blockedUsersList?[index].getUser?.name ??
                  //                     '',
                  //             isMale:
                  //                 pro.blockedUsersList?[index].getUser?.isMale,
                  //             profileID:
                  //                 pro.blockedUsersList?[index].blockProfileId);
                  //       },
                  //       separatorBuilder: (context, index) => 25.verticalSpace,
                  //       itemCount: pro.blockedUsersList?.length ?? 0);
                  // } else if ((pro.blockedUsersList ?? []).isEmpty &&
                  //     !pro.btnLoader) {
                  //   return CommonErrorView(
                  //       error: Errors.noDatFound,
                  //       onTap: () => getBlockedUserLists());
                  // } else if (pro.btnLoader) {
                  //   return const Center(child: CircularProgressIndicator());
                  // } else {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                },
              ),
            )
          ],
        ));
  }

  mainView(AccountProviderExtends pro) {
    return StackLoader(
      inAsyncCall: pro.loaderState == LoaderState.loading ? true : false,
      child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return blockedUserTile(
                imgURL: pro.blockedUsersList[index].profileImage,
                username: pro.blockedUsersList[index].getUser?.name ?? '',
                isMale: pro.blockedUsersList[index].getUser?.isMale,
                profileID: pro.blockedUsersList[index].blockProfileId);
          },
          separatorBuilder: (context, index) => 25.verticalSpace,
          itemCount: pro.blockedUsersList.length),
    );
  }

  switchView(LoaderState loaderState, AccountProviderExtends provider,
      BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = provider.blockedUsersList.isEmpty
            ? const CommonErrorView(
                error: Errors.noDatFound,
                isTryAgainVisible: false,
              )
            : mainView(provider);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError, onTap: () => getBlockedUserLists());
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
            error: Errors.networkError, onTap: () => getBlockedUserLists());
        break;
      case LoaderState.noData:
        child = const CommonErrorView(
          error: Errors.noDatFound,
          isTryAgainVisible: false,
        );
        break;

      case LoaderState.loading:
        child = const StackLoader(inAsyncCall: true, child: SizedBox.shrink());
        break;
    }
    return child;
  }

  Widget blockedUserTile(
      {String? username, String? imgURL, int? profileID, bool? isMale}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                if (profileID != null) {
                  Navigator.pushNamed(context,
                          RouteGenerator.routePartnerSingleProfileDetail,
                          arguments: RouteArguments(profileId: profileID))
                      .then((value) {
                    getBlockedUserLists();
                  });
                }
              },
              child: Row(
                children: [
                  ProfileImageView(
                      isMale: isMale ?? false,
                      height: 40.h,
                      width: 40.h,
                      isCircular: true,
                      image: imgURL.thumbImagePath(context)
                      // "${context.read<AppDataProvider>().urlData?.thumbImage}$imgURL"
                      ),

                  // Center(
                  //   child: SizedBox(
                  //       height: 40.h,
                  //       width: 40.w,
                  //       child: Image.asset(
                  //         Assets.imagesPic,
                  //         width: 40.w,
                  //         height: 40.h,
                  //       )),
                  // ),
                  SizedBox(
                    width: 13.w,
                  ),
                  Text(
                    username ?? "",
                    style: FontPalette.black16SemiBold
                        .copyWith(color: HexColor("#131A24")),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 2,
              child: ReusableWidgets.commonWhiteButton(
                  onTap: () {
                    if (profileID != null && userID.isNotEmpty) {
                      context
                          .read<ProfileHandlerProvider>()
                          .blockProfileRequest(context, profileID);
                    } else {
                      Helpers.successToast("profile_id or user_id is missing!");
                    }
                  },
                  text: "Unblock",
                  height: 38.h,
                  width: 108))
        ],
      ),
    );
  }
}
