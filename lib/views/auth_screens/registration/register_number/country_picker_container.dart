import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/countries_data_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/error_views/error_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../utils/color_palette.dart';
import '../../../../widgets/common_search_field.dart';

class CountryPickerContainer extends StatelessWidget {
  final ValueChanged<CountryData?>? onChange;
  const CountryPickerContainer({Key? key, this.onChange}) : super(key: key);

  Widget switchView(
      {required BuildContext context,
      required LoaderState loaderState,
      List<CountryData>? countryDataList}) {
    switch (loaderState) {
      case LoaderState.loaded:
        return (countryDataList ?? []).isEmpty
            ? Expanded(
                child: ErrorTile(
                  errors: Errors.noDatFound,
                  onTap: () => fetchData(context),
                ),
              )
            : mainView(context, countryDataList);
      case LoaderState.loading:
        return ReusableWidgets.circularProgressIndicator();
      case LoaderState.error:
        return Expanded(
            child: ErrorTile(
          errors: Errors.serverError,
          onTap: () => fetchData(context),
        ));
      case LoaderState.networkErr:
        return Expanded(
            child: ErrorTile(
          errors: Errors.networkError,
          onTap: () => fetchData(context),
        ));
      case LoaderState.noData:
        return Expanded(
            child: ErrorTile(
          errors: Errors.noDatFound,
          onTap: () => fetchData(context),
        ));
      default:
        return mainView(context, countryDataList);
    }
  }

  Widget mainView(BuildContext context, List<CountryData>? countryDataList) {
    return Expanded(
      child: Column(
        children: [
          CommonSearchField(
            hintText: context.loc.searchCountry,
            valueChange: (val) =>
                context.read<AppDataProvider>().searchByQuery(val),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                CountryData? countryData = countryDataList?[index];
                if (countryData.isNull) return const SizedBox.shrink();
                return InkWell(
                  onTap: () {
                    if (onChange != null) {
                      onChange!(countryData);
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 13.h, horizontal: 17.w),
                    child: Row(
                      children: [
                        5.horizontalSpace,
                        SizedBox(
                          height: 13.h,
                          width: 20.w,
                          child: SvgPicture.network(
                            countryData?.countryFlag ?? '',
                            placeholderBuilder: (context) {
                              return Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                color: Colors.grey.shade50,
                              );
                            },
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            '${countryData?.countryName ?? ''} (${countryData?.isoAlpha2Code ?? ''})',
                            style: FontPalette.black16Medium
                                .copyWith(color: HexColor('#131A24')),
                          ),
                        )),
                        Text(
                          '+${countryData?.dialCode ?? ''}',
                          style: FontPalette.black16Medium
                              .copyWith(color: HexColor('#131A24')),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: countryDataList?.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh(size: 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              context.loc.selectCountryCode,
              style:
                  FontPalette.white16Bold.copyWith(color: HexColor('#09274D')),
            ),
          ),
          6.verticalSpace,
          Selector<AppDataProvider, Tuple2<List<CountryData>?, LoaderState>>(
            selector: (context, provider) =>
                Tuple2(provider.countryDataList, provider.loaderState),
            builder: (context, value, child) {
              return switchView(
                  context: context,
                  countryDataList: value.item1,
                  loaderState: value.item2);
            },
          ),
          AnimatedPadding(
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: HexColor('#E4E7E8'), width: 1.5.h))),
              child: TextButton(
                  style: TextButton.styleFrom(
                      maximumSize: const Size.fromWidth(double.maxFinite)),
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      context.loc.cancel,
                      style: FontPalette.white16Bold
                          .copyWith(color: ColorPalette.primaryColor),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void fetchData(BuildContext context) {
    context.read<AppDataProvider>().getCountryData();
  }
}
