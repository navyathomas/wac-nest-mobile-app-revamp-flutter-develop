import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/nav_routes.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';

import '../common/common_functions.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import '../models/profile_detail_default_model.dart';
import '../utils/font_palette.dart';

class HomePartnerHorizontalTile extends StatelessWidget {
  final List<InterestUserData>? userDataList;
  final NavToProfile navToProfile;
  const HomePartnerHorizontalTile({
    Key? key,
    this.userDataList,
    required this.navToProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lWidth = context.sw(size: 0.24);
    double lHeight = lWidth + (lWidth * 0.6);
    return SizedBox(
      height: lHeight,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            InterestUserData? userData = userDataList?[index];
            if (userData == null) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () => NavRoutes.navToProductDetails(
                  context: context,
                  arguments: ProfileDetailArguments(
                      index: index, navToProfile: navToProfile)),
              child: Container(
                height: double.maxFinite,
                width: lWidth,
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
                                        userData.userDetails?.userImage ??
                                            []) ==
                                    null
                                ? ProfileImagePlaceHolder(
                                    isMale: userData.userDetails?.isMale,
                                  )
                                : ProfileImageView(
                                    image: CommonFunctions.getImage(userData
                                                    .userDetails?.userImage ??
                                                [])
                                            ?.thumbImagePath(context) ??
                                        '',
                                    height: double.maxFinite,
                                    isMale: userData.userDetails?.isMale,
                                  ))),
                    5.verticalSpace,
                    Text(
                      userData.userDetails?.name ?? '',
                      style: FontPalette.f131A24_16SemiBold,
                      textAlign: TextAlign.start,
                    ).avoidOverFlow(),
                    1.verticalSpace,
                    Text(
                      '${userData.userDetails?.age == null ? '' : '${userData.userDetails?.age} yrs, '}${userData.userDetails?.userDistricts?.districtName ?? ''}',
                      textAlign: TextAlign.start,
                      style: FontPalette.f565F6C_13Medium,
                    ).avoidOverFlow()
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => 11.horizontalSpace,
          itemCount: listLength),
    );
  }

  int get listLength =>
      (userDataList?.length ?? 0) > 8 ? 8 : (userDataList?.length ?? 0);
}
