import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';

import '../common/constants.dart';
import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../models/profile_detail_default_model.dart';
import '../utils/font_palette.dart';

class PartnerHorizontalTile extends StatelessWidget {
  final double? height;
  final double? width;
  final bool enableCrown;
  final NavToProfile navToProfile;
  final List<UserData>? userDataList;
  const PartnerHorizontalTile(
      {Key? key,
      this.enableCrown = false,
      this.height,
      this.width,
      required this.navToProfile,
      this.userDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double lWidth = constraints.maxWidth * 0.24;
      double lHeight = lWidth + (lWidth * 0.6);
      return SizedBox(
        height: height ?? lHeight,
        child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              UserData? userData = userDataList?[index];
              if (userData == null) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => NavRoutes.navToProductDetails(
                    context: context,
                    arguments: ProfileDetailArguments(
                        index: index,
                        userData: userData,
                        navToProfile: navToProfile)),
                child: Stack(
                  children: [
                    Container(
                      height: double.maxFinite,
                      width: width ?? lWidth,
                      margin: EdgeInsets.only(
                          left: index == 0 ? 16.w : 0,
                          right: index == listLength - 1 ? 16.w : 0,
                          top: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7.r),
                                  child: CommonFunctions.getImage(
                                              userData.userImage ?? []) ==
                                          null
                                      ? ProfileImagePlaceHolder(
                                          isMale: userData.isMale,
                                        )
                                      : ProfileImageView(
                                          image: CommonFunctions.getImage(
                                                  userData.userImage ?? [])
                                              .thumbImagePath(context),
                                          height: double.maxFinite,
                                          isMale: userData.isMale,
                                        ))),
                          5.verticalSpace,
                          Text(
                            userData.name ?? '',
                            style: FontPalette.f131A24_16SemiBold,
                            textAlign: TextAlign.start,
                          ).avoidOverFlow(),
                          1.verticalSpace,
                          Text(
                            '${userData.age.isNull ? '' : '${userData.age} yrs, '}${userData.userDistricts?.districtName ?? ''}',
                            textAlign: TextAlign.start,
                            style: FontPalette.f565F6C_13Medium,
                          ).avoidOverFlow()
                        ],
                      ),
                    ),
                    if (enableCrown)
                      Positioned(
                          right: 0,
                          top: 1.h,
                          child: SvgPicture.asset(Assets.iconsCrown))
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => 11.horizontalSpace,
            itemCount: listLength),
      );
    });
  }

  int get listLength =>
      (userDataList?.length ?? 0) > 8 ? 8 : (userDataList?.length ?? 0);
}
