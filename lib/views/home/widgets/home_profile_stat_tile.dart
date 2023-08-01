import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/home_slider_banner_model.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/profile_complete_model.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/app_data_provider.dart';

class HomeProfileStatTile extends StatelessWidget {
  const HomeProfileStatTile({Key? key}) : super(key: key);

  Widget loaderWidget(double maxWidth) {
    return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: maxWidth * 0.73,
                margin: EdgeInsets.only(
                    left: index == 0 ? 16.w : 0, right: index == 4 ? 16.w : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorPalette.shimmerColor,
                ),
              );
            },
            separatorBuilder: (_, __) => 8.horizontalSpace,
            itemCount: 5)
        .addShimmer;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<AppDataProvider, List<HomeSliderBannerModel>?>(
        selector: (context, provider) => provider.homeSliderBannerList,
        builder: (context, value, child) {
          if (value != null && value.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: EdgeInsets.only(top: 17.h, bottom: 8.h),
            padding: EdgeInsets.only(top: 27.h, bottom: 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    HexColor('#FFF0E3'),
                    HexColor('#F8D5FF').withOpacity(0.8)
                  ],
                  stops: const [
                    0.6,
                    1.0
                  ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Selector<AccountProvider, ProfileCompleteModel?>(
                    selector: (context, provider) => provider.profileComplete,
                    shouldRebuild: (p1, p2) => true,
                    builder: (context, value, child) {
                      return Text.rich(TextSpan(
                          text: '${context.loc.urProfileIsOnly}\n',
                          style: FontPalette.f131A24_19ExtraBold,
                          children: [
                            TextSpan(
                                text: '${value?.data?.percentage ?? 0}%',
                                style: FontPalette.f131A24_19ExtraBold
                                    .copyWith(color: HexColor('#950053'))),
                            WidgetSpan(child: 5.horizontalSpace),
                            TextSpan(
                              text: context.loc.complete,
                              style: FontPalette.f131A24_19ExtraBold,
                            )
                          ]));
                    },
                  ),
                ),
                22.verticalSpace,
                value != null && value.length == 1
                    ? GestureDetector(
                        onTap: () =>
                            onBannerTap(value[0].dataCollectionTypes, context),
                        child: Container(
                          height: context.sw(size: 0.52),
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: SvgPicture.asset(
                              value[0].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: context.sw(size: 0.73) * 0.54,
                        child: value == null
                            ? loaderWidget(context.sw())
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => onBannerTap(
                                        value[index].dataCollectionTypes,
                                        context),
                                    child: Container(
                                      width: context.sw(size: 0.73),
                                      margin: EdgeInsets.only(
                                          left: index == 0 ? 16.w : 0,
                                          right: index == value.length - 1
                                              ? 16.w
                                              : 0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: SvgPicture.asset(
                                          value[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) => 8.horizontalSpace,
                                itemCount: value.length),
                      )
                /*LayoutBuilder(builder: (context, constraints) {
                  if (value != null && value.length == 1) {
                    return GestureDetector(
                      onTap: () =>
                          onBannerTap(value[0].dataCollectionTypes, context),
                      child: Container(
                        height: constraints.maxWidth * 0.52,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: SvgPicture.asset(
                            value[0].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: (constraints.maxWidth * 0.73) * 0.54,
                    child: (value == null
                            ? loaderWidget(constraints.maxWidth)
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => onBannerTap(
                                        value[index].dataCollectionTypes,
                                        context),
                                    child: Container(
                                      width: constraints.maxWidth * 0.73,
                                      margin: EdgeInsets.only(
                                          left: index == 0 ? 16.w : 0,
                                          right: index == value.length - 1
                                              ? 16.w
                                              : 0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: SvgPicture.asset(
                                          value[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) => 8.horizontalSpace,
                                itemCount: value.length))
                        .animatedSwitch(),
                  );
                })*/
                ,
              ],
            ),
          );
        },
      ),
    );
  }

  void onBannerTap(
      DataCollectionTypes dataCollectionTypes, BuildContext context) {
    switch (dataCollectionTypes) {
      case DataCollectionTypes.addPhotos:
        Navigator.pushNamed(context, RouteGenerator.routeManagePhotos);
        break;
      case DataCollectionTypes.addIdProof:
        Navigator.pushNamed(context, RouteGenerator.routeManagePhotos,
            arguments: 1);
        break;
      case DataCollectionTypes.addProfessionalInfo:
        Navigator.pushNamed(context, RouteGenerator.routeEditProfessionalInfo);
        break;
      case DataCollectionTypes.addEducation:
        Navigator.pushNamed(context, RouteGenerator.routeEditProfessionalInfo);
        break;

      default:
        debugPrint("Not found");
    }
  }
}
