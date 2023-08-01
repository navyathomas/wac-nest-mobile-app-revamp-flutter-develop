import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/search_filter/widgets/bride_groom_tile.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_age_slider.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_country_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_district_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_field.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_height_slider.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_matching_stars.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_occupation_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_religion_btn.dart';
import 'package:nest_matrimony/views/search_filter/widgets/search_state_btn.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:provider/provider.dart';

import 'widgets/search_caste_btn.dart';
import 'widgets/search_education_btn.dart';
import 'widgets/search_marital_status_btn.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late ScrollController _scrollController;

  late final SearchFilterProvider searchModel;
  ValueNotifier<RangeValues>? _heightSlider;
  ValueNotifier<RangeValues>? _ageSlider;

  Widget get bgContainer => Container(
        height: context.sh(size: 0.36),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const [0.5, 1],
                colors: [ColorPalette.primaryColor, HexColor('#FF906F')])),
      );

  Widget _customAppBar() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            43.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 41.w),
              alignment: Alignment.center,
              child: Text(
                context.loc.searchTile,
                style: FontPalette.white18Bold,
                textAlign: TextAlign.center,
              ),
            ),
            16.verticalSpace,
          ],
        ),
        Positioned(
          left: 0,
          top: 35.h,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: SvgPicture.asset(
                Assets.iconsTransparentChevronLeft,
                fit: BoxFit.fill,
                height: 41.r,
                width: 41.r,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _moreFilterWidgets() {
    return Selector<SearchFilterProvider, bool>(
        builder: (cxt, value, _) {
          return (value
                  ? Column(
                      children: [
                        const SearchEducationBtn(),
                        const SearchOccupationBtn(),
                        Row(
                          children: [
                            const Expanded(
                              child: SearchCountryBtn(),
                            ),
                            11.horizontalSpace,
                            const Expanded(
                              child: SearchStateBtn(),
                            )
                          ],
                        ),
                        const SearchDistrictBtn(),
                        const SearchMatchingStars(),
                        27.verticalSpace
                      ],
                    )
                  : const SizedBox())
              .animatedSwitch();
        },
        selector: (context, provider) => provider.moreFilterEnabled);
  }

  Widget _brideGroomTile() {
    return Selector<SearchFilterProvider, Tuple2<Gender?, bool?>>(
      selector: (context, provider) => Tuple2(
          provider.searchValueModel?.selectedGender, provider.isProfileMale),
      builder: (context, value, child) {
        return Row(
          children: [
            Expanded(
                child: BrideGroomTile(
              title: context.loc.bride,
              icon: Assets.iconsBride,
              disableBtn: value.item2 != null && !value.item2!,
              isSelected: value.item1 != null && value.item1 == Gender.female,
              onTap: () {
                context
                    .read<SearchFilterProvider>()
                    .updateSelectedGender(Gender.female);
              },
            )),
            13.horizontalSpace,
            Expanded(
                child: BrideGroomTile(
              title: context.loc.groom,
              icon: Assets.iconsGroom,
              disableBtn: value.item2 != null && value.item2!,
              isSelected: value.item1 != null && value.item1 == Gender.male,
              onTap: () {
                context
                    .read<SearchFilterProvider>()
                    .updateSelectedGender(Gender.male);
              },
            ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.white, Colors.white.withOpacity(0.02)])),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: Selector<SearchFilterProvider, bool>(
          selector: (cxt, provider) => provider.btnLoader,
          builder: (cxt, value, child) {
            return CommonButton(
              height: 50.h,
              isLoading: value,
              title: context.loc.search,
              onPressed: value
                  ? null
                  : () {
                      context.read<SearchFilterProvider>()
                        ..updateBtnLoader(true)
                        ..updateSelectedHeight(
                            _heightSlider?.value.start ?? 0.0,
                            _heightSlider?.value.end ?? 0.0)
                        ..updateSelectedAge(_ageSlider?.value.start ?? 0.0,
                            _ageSlider?.value.end ?? 0.0)
                        ..clearValues()
                        ..assignValuesSearchToFilter()
                        ..setSearchParam()
                        ..assignSearchToReqPram()
                        ..advancedSearchRequest(
                            context: context,
                            onSuccess: () {
                              Navigator.pushNamed(
                                  context, RouteGenerator.routeSearchResult,
                                  arguments: false);
                            });
                    },
            );
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [bgContainer, const Expanded(child: SizedBox())],
            ),
            Column(
              children: [
                _customAppBar(),
                Expanded(
                    child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 41.w),
                        child: Text(
                          context.loc.searchSubTile,
                          textAlign: TextAlign.center,
                          style: FontPalette.black13SemiBold
                              .copyWith(color: Colors.white.withOpacity(0.75)),
                        ),
                      ),
                      10.verticalSpace,
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteGenerator.routeSearchById),
                          child: const AbsorbPointer(child: SearchField())),
                      20.verticalSpace,
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 21.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28.r),
                                topRight: Radius.circular(28.r))),
                        child: Column(
                          children: [
                            ///Todo: Need to handle slider left padding
                            Text(
                              context.loc.imLookingFor,
                              style: FontPalette.black16SemiBold
                                  .copyWith(color: HexColor('#172431')),
                            ),
                            18.verticalSpace,
                            _brideGroomTile(),
                            const SearchMaritalStatusBtn(),
                            const SearchReligionBtn(),
                            const SearchCasteBtn(),
                            30.verticalSpace,
                            SearchHeightSlider(
                              heightSliderRange: _heightSlider,
                            ),
                            SearchAgeSlider(
                              ageSliderRange: _ageSlider,
                            ),
                            _moreFilterWidgets(),
                            _FilterBtn(
                              onTap: _onFilterTap,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                elevation: 0,
                leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 30.w,
                    width: 30.w,
                  ),
                ).removeSplash(color: Colors.transparent),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    searchModel = context.read<SearchFilterProvider>();
    _scrollController = ScrollController();
    _heightSlider = ValueNotifier(
        RangeValues(searchModel.minHeight, searchModel.maxHeight));
    _ageSlider =
        ValueNotifier(RangeValues(searchModel.minAge, searchModel.maxAge));
    CommonFunctions.afterInit(() {
      context.read<SearchFilterProvider>()
        ..pageInit()
        ..fetchFromAppData(context)
        ..assignLoginUserData(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void _onFilterTap() {
    if (_scrollController.offset < 500) {
      if ((AppConfig.accessToken ?? '').isNotEmpty) {
        _scrollController.animateTo(800,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        context.read<SearchFilterProvider>().setMoreFilterEnabled();
      } else {
        context
            .read<AuthProvider>()
            .updateNavFrom(RouteGenerator.routeSearchFilter);
        Navigator.pushNamed(context, RouteGenerator.routeLogin);
      }
    } else {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      context.read<SearchFilterProvider>().setMoreFilterEnabled();
    }
  }
}

class _FilterBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const _FilterBtn({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 9.h),
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19.r),
                border: Border.all(color: HexColor('#DDDDDD')),
                boxShadow: [
                  BoxShadow(
                      color: HexColor('#DDDDDD'),
                      blurRadius: 6.r,
                      offset: const Offset(0.5, 3))
                ]),
            child: Selector<SearchFilterProvider, bool>(
                selector: (context, provider) => provider.moreFilterEnabled,
                builder: (cxt, value, _) {
                  return Row(
                    children: [
                      SvgPicture.asset(
                          value ? Assets.iconsRemove : Assets.iconsAdd),
                      8.horizontalSpace,
                      Text(
                          value
                              ? context.loc.lessFilters
                              : context.loc.moreFilters,
                          style: FontPalette.f131A24_16SemiBold)
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class OptionSelectedText extends StatelessWidget {
  final String? options;
  const OptionSelectedText({Key? key, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 3.w, right: 3.w),
      child: Text(
        options ?? '',
        style: FontPalette.black12Medium.copyWith(color: HexColor('#565F6C')),
      ),
    );
  }
}
