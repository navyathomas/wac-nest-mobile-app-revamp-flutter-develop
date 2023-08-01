import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_preference.dart';
import 'package:nest_matrimony/widgets/network_connectivity.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../common/constants.dart';
import '../../../../common/route_generator.dart';
import '../../../../generated/assets.dart';
import '../../../../providers/partner_detail_provider.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/reusable_widgets.dart';
import '../../../error_views/common_error_view.dart';
import '../../../partner_profile_detail/widgets/about_partner.dart';
import '../../../partner_profile_detail/widgets/partner_basic_details.dart';
import '../../../partner_profile_detail/widgets/partner_family_details.dart';
import '../../../partner_profile_detail/widgets/partner_horoscope_details.dart';
import '../../../partner_profile_detail/widgets/partner_info_tile.dart';
import '../../../partner_profile_detail/widgets/partner_location.dart';
import '../../../partner_profile_detail/widgets/partner_location_preferences.dart';
import '../../../partner_profile_detail/widgets/partner_professional_info.dart';
import '../../../partner_profile_detail/widgets/partner_professional_preferences.dart';
import '../../../partner_profile_detail/widgets/partner_religious_info.dart';
import '../../../partner_profile_detail/widgets/partner_religious_preferences.dart';
import 'contact_address_preview.dart';

class ProfilePreviewScreen extends StatefulWidget {
  const ProfilePreviewScreen({Key? key}) : super(key: key);

  @override
  State<ProfilePreviewScreen> createState() => _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends State<ProfilePreviewScreen> {
  PageController controller = PageController(initialPage: 0);

  Widget _mainView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _ProfileImageTile(
            pageController: controller,
          ),
          const _ProfileGradientTile(),
          Transform.translate(
            offset: const Offset(0, -38),
            child: Container(
              padding: EdgeInsets.only(top: 19.h),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19.r),
                    topRight: Radius.circular(19.r)),
              ),
              child: Column(
                children: [
                  const PartnerInfo(),
                  const AboutPartner(),
                  const PartnerBasicDetails(),
                  const PartnerProfessionalInfo(),
                  const PartnerReligiousInfo(),
                  const PartnerLocation(),
                  const PartnerFamilyDetails(),
                  const PreviewContactAddress(),
                  const PartnerHoroscopeDetails(
                    enableTopDivider: false,
                    hideDownloadBtn: true,
                  ),
                  PartnerPreference(
                    enableMatchScore: false,
                    enableIcon: false,
                    padding: EdgeInsets.only(
                        top: 17.h, left: 16.w, right: 16.w, bottom: 22.8.h),
                  ),
                  const PartnerProfessionalPreferences(
                    enableIcon: false,
                  ),
                  const PartnerReligiousPreferences(
                    enableIcon: false,
                  ),
                  const PartnerLocationPreferences(
                    enableIcon: false,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _viewSwitcher(LoaderState state) {
    switch (state) {
      case LoaderState.loading:
        return const SizedBox.shrink();
      case LoaderState.error:
        return CommonErrorView(
          error: Errors.serverError,
          onTap: () {
            Navigator.of(context).popUntil((route) {
              return route.settings.name != null
                  ? route.settings.name == RouteGenerator.routeMainScreen
                  : true;
            });
          },
        );
      case LoaderState.networkErr:
        return CommonErrorView(
          error: Errors.networkError,
          onTap: () {
            _fetchData();
          },
        );
      case LoaderState.noData:
        return CommonErrorView(
          error: Errors.noDatFound,
          onTap: () {
            _fetchData();
          },
        );

      default:
        return _mainView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.loc.profilePreview,
          style: FontPalette.white16Bold.copyWith(color: HexColor("#131A24")),
        ),
        elevation: 0.0,
        leading: ReusableWidgets.roundedBackButton(context),
      ),
      body: SafeArea(
        child: Selector<PartnerDetailProvider, LoaderState>(
          selector: (context, provider) => provider.loaderState,
          builder: (context, value, child) {
            return NetworkConnectivity(
                onTap: () => _fetchData(),
                inAsyncCall: value.isLoading,
                child: _viewSwitcher(value));
          },
        ),
      ),
    );
  }

  void _fetchData() {
    CommonFunctions.afterInit(() {
      context.read<PartnerDetailProvider>().getProfilePreviewData();
    });
  }

  @override
  void initState() {
    CommonFunctions.afterInit(() {
      context.read<PartnerDetailProvider>().profilePreviewInit();
    });
    _fetchData();
    super.initState();
  }
}

class _ProfileGradientTile extends StatelessWidget {
  const _ProfileGradientTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -19),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.5.h),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19.r), topRight: Radius.circular(19.r)),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [HexColor('#FFF0E3'), HexColor('#F8D5FF')],
              stops: const [0.6, 1.0]),
        ),
        child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
          selector: (context, provider) => provider.partnerDetailModel,
          builder: (context, value, child) {
            BasicDetails? basicDetails = value?.data?.basicDetails;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: value?.data?.basicDetails?.name ?? '',
                    style: FontPalette.white18Bold
                        .copyWith(color: HexColor("#131A24")),
                    children: [
                      if ((value?.data?.basicDetails
                                  ?.profileVerificationStatus ??
                              '1') ==
                          '1')
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w),
                            child: SvgPicture.asset(
                              Assets.iconsVerifiedPink,
                              height: 18.5.r,
                              width: 18.5.r,
                            ),
                          ),
                        )
                    ])),
                7.94.verticalSpace,
                Text(
                  '${basicDetails?.age != null ? '${basicDetails?.age}YRS, ' : ''}${basicDetails?.registerId}',
                  style: FontPalette.black13SemiBold.copyWith(
                      color: HexColor("#131A24"), letterSpacing: 0.7.w),
                ),
                9.verticalSpace,
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.iconsLocationGrey,
                      width: 19.w,
                      height: 13.h,
                      color: HexColor('#131A24').withOpacity(0.6),
                    ),
                    7.horizontalSpace,
                    Expanded(
                      child: Text(
                        '${(basicDetails?.userFamilyInfo?.userDistrict?.districtName ?? '').isNotEmpty ? "${basicDetails?.userFamilyInfo?.userDistrict?.districtName}, " : ''}${basicDetails?.userFamilyInfo?.userState?.stateName ?? 'Unknown'}',
                        style: FontPalette.f131A24_14Medium.copyWith(
                            color: HexColor('131A24').withOpacity(0.6)),
                      ),
                    )
                  ],
                ),
                15.verticalSpace
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileImageTile extends StatelessWidget {
  final PageController pageController;

  const _ProfileImageTile({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 443.h,
        width: double.maxFinite,
        color: Colors.white,
        child: Selector<PartnerDetailProvider, PartnerDetailModel?>(
          selector: (context, provider) => provider.partnerDetailModel,
          builder: (context, value, child) {
            List<UserImage> imageList =
                value?.data?.basicDetails?.userImage ?? [];
            if (imageList.isEmpty) {
              return ProfileImagePlaceHolder(
                isMale: value?.data?.basicDetails?.isMale,
              );
            }
            return Stack(
              children: [
                PageView.builder(
                    controller: pageController,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      if (imageList[index].imageFile == null) {
                        return ProfileImagePlaceHolder(
                          isMale: value?.data?.basicDetails?.isMale,
                        );
                      }
                      return ProfileImageView(
                          isMale: value?.data?.basicDetails?.isMale,
                          image: imageList[index]
                              .imageFile
                              .fullImagePath(context));
                    }),
                if (imageList.length > 1)
                  Positioned(
                    bottom: 38.h,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                          controller: pageController,
                          count: imageList.length,
                          effect: WormEffect(
                              spacing: 10.r,
                              radius: 8.r,
                              dotWidth: 8.0,
                              dotHeight: 8.0,
                              dotColor: Colors.white60,
                              activeDotColor: Colors.white),
                          onDotClicked: (index) {
                            pageController.animateToPage(
                              index,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 200),
                            );
                          }),
                    ),
                  ),
              ],
            );
          },
        ));
  }
}
