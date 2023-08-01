import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../providers/search_filter_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_button.dart';

class SearchByIdScreen extends StatefulWidget {
  const SearchByIdScreen({Key? key}) : super(key: key);

  @override
  State<SearchByIdScreen> createState() => _SearchByIdScreenState();
}

class _SearchByIdScreenState extends State<SearchByIdScreen> {
  TextEditingController queryController = TextEditingController();
  ValueNotifier<String> query = ValueNotifier('');

  OutlineInputBorder outLineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.r),
      borderSide: BorderSide(color: ColorPalette.pageBgColor));

  late SearchFilterProvider searchFilterProvider;

  Widget _searchListTile(index, recentSearchList) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        searchById(recentSearchList);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            4.horizontalSpace,
            SvgPicture.asset(
              Assets.iconsSearchGrey2,
              width: 13.r,
              height: 13.r,
            ),
            13.horizontalSpace,
            Expanded(
                child: Text(
              recentSearchList,
              style: FontPalette.black15Medium
                  .copyWith(color: HexColor('#131A24')),
            ).avoidOverFlow()),
            InkWell(
              onTap: () {
                query.value = '';
                queryController.clear();
                searchFilterProvider.deleteKeyFromRecentlySearchedList(
                    recentSearchList, true);
              },
              child: Padding(
                padding: EdgeInsets.all(7.h),
                child: SvgPicture.asset(
                  Assets.iconsCloseGrey,
                  height: 13.r,
                  width: 13.r,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    searchFilterProvider = context.read<SearchFilterProvider>();
    CommonFunctions.afterInit(() {
      searchFilterProvider.getRecentlySearchedKeys();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 103.h,
        titleSpacing: 0,
        leading: const SizedBox(),
        leadingWidth: 16.0.w,
        title: ValueListenableBuilder<String>(
          valueListenable: query,
          builder: (context, value, _) {
            return SizedBox(
              height: 60.h,
              child: TextField(
                autofocus: true,
                controller: queryController,
                textAlign: TextAlign.left,
                style: FontPalette.f131A24_16SemiBold,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.search,
                onSubmitted: searchById,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Z0-9]"))
                ],
                onChanged: (val) {
                  query.value = val;
                  context.read<SearchFilterProvider>().updateQueryId(val);
                },
                decoration: InputDecoration(
                    focusedBorder: outLineBorder,
                    enabledBorder: outLineBorder,
                    contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                    fillColor: ColorPalette.pageBgColor,
                    filled: true,
                    hintText: context.loc.searchByNestID,
                    hintStyle: FontPalette.black16SemiBold
                        .copyWith(color: HexColor('#8695A7')),
                    border: outLineBorder,
                    suffixIconConstraints:
                        BoxConstraints(maxWidth: 60.5.r, minWidth: 56.5.r),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(left: 22.w, right: 14.5.w),
                            child: SvgPicture.asset(
                              Assets.iconsArrowLeft,
                              height: 11.h,
                              width: 15.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (value.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      queryController.clear();
                                      query.value = '';
                                      context
                                          .read<SearchFilterProvider>()
                                          .updateQueryId('');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 14.5.w, right: 22.w),
                                      child: SvgPicture.asset(
                                        Assets.iconsCloseRoundedGrey,
                                        height: 20.r,
                                        width: 20.r,
                                      ),
                                    ),
                                  )
                                : const SizedBox())
                            .animatedSwitch(),
                      ],
                    )),
              ),
            );
          },
        ),
        elevation: 0,
        actions: [16.horizontalSpace],
      ),
      body: SafeArea(
        child: Consumer<SearchFilterProvider>(
          builder: (context, value, child) {
            return StackLoader(
                inAsyncCall:
                    value.loaderState.isLoading,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.recentlySearchedList.length >= 10
                            ? 10
                            : value.recentlySearchedList.length,
                        itemBuilder: (context, index) => _searchListTile(
                            index, value.recentlySearchedList[index]),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.02)
                          ])),
                      padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 23.h),
                      child: Selector<SearchFilterProvider, String>(
                        selector: (context, provider) => provider.query ?? '',
                        builder: (context, value, child) {
                          return CommonButton(
                            height: 50.h,
                            title: context.loc.search,
                            onPressed: value.trim().isEmpty ||
                                    value.trim() == ''
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    debugPrint('query $value');
                                    context
                                        .read<SearchFilterProvider>()
                                        .clearValues();
                                    searchFilterProvider.searchById(context,
                                        onSuccess: () {
                                      Navigator.pushNamed(context,
                                              RouteGenerator.routeSearchResult,
                                              arguments: true)
                                          .then((value) {
                                        searchFilterProvider
                                            .getRecentlySearchedKeys();
                                        query.value = '';
                                        queryController.clear();
                                        searchFilterProvider.clearQuery();
                                      });
                                      searchFilterProvider
                                          .addRecentlySearchedKeys(query.value);
                                    });
                                  },
                          );
                        },
                      ),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  void searchById(String val) {
    searchFilterProvider.clearValues();
    searchFilterProvider.updateQueryId(val);
    searchFilterProvider.searchById(context, onSuccess: () {
      Navigator.pushNamed(context, RouteGenerator.routeSearchResult,
              arguments: true)
          .then((value) {
        searchFilterProvider.getRecentlySearchedKeys();
        query.value = '';
        queryController.clear();
        searchFilterProvider.clearQuery();
      });
    });
    searchFilterProvider.addRecentlySearchedKeys(val);
  }
}
