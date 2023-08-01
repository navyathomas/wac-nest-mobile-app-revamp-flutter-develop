import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../utils/color_palette.dart';

class CommonErrorView extends StatefulWidget {
  const CommonErrorView(
      {Key? key,
      required this.error,
      this.onTap,
      this.isTryAgainVisible = true})
      : super(key: key);
  final Errors error;
  final VoidCallback? onTap;
  final bool isTryAgainVisible;

  @override
  State<CommonErrorView> createState() => _CommonErrorViewState();
}

class _CommonErrorViewState extends State<CommonErrorView> {
  String? image;

  String? subTitle;

  String? description;

  @override
  void didChangeDependencies() {
    returnErrorValues(widget.error);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#F2F4F5'),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                image ?? Assets.iconsServerError,
                height: 115.34.h,
                width: 117.6.w,
              ),
              16.verticalSpace,
              Text(
                subTitle ?? '',
                style: FontPalette.black18Bold
                    .copyWith(color: HexColor('#525B67')),
              ),
              13.verticalSpace,
              Text(
                description ?? '',
                textAlign: TextAlign.center,
                style: FontPalette.black14Medium.copyWith(
                  color: HexColor('#525B67'),
                ),
                strutStyle: StrutStyle(height: 1.5.h),
              ),
              widget.error == Errors.serverError ||
                      widget.error == Errors.networkError ||
                      widget.error == Errors.noDatFound
                  ? 40.verticalSpace
                  : const SizedBox(),
              (widget.error == Errors.serverError ||
                          widget.error == Errors.networkError ||
                          widget.error == Errors.noDatFound) &&
                      widget.isTryAgainVisible
                  ? CommonButton(
                      width: 157.w,
                      title: widget.error == Errors.networkError ||
                              widget.error == Errors.noDatFound
                          ? context.loc.tryAgain
                          : context.loc.backToHome,
                      fontStyle:
                          FontPalette.white13SemiBold.copyWith(fontSize: 16.sp),
                      onPressed: widget.onTap,
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  returnErrorValues(error) {
    switch (error) {
      case Errors.declinesError:
        image = Assets.iconsNoDeclines;
        subTitle = context.loc.noDeclines;
        description = context.loc.theFiltersYouApplyDoNotDisplayDeclines;
        break;
      case Errors.searchResultError:
        image = Assets.iconsNoSearchResult;
        subTitle = context.loc.searchResultNotFound;
        description = context.loc.checkYourSpellingOrTrySomethingElse;
        break;
      case Errors.serverError:
        image = Assets.iconsServerError;
        subTitle = context.loc.serverError;
        description = context.loc.somethingWentWrong;
        break;
      case Errors.networkError:
        image = Assets.iconsNetworkError;
        subTitle = context.loc.networkError;
        description = context.loc.noInternetConnectionFound;
        break;
      case Errors.noDatFound:
        image = Assets.iconsNoDataFound;
        subTitle = context.loc.noDataFound;
        description = context.loc.noDataFoundPleaseTryAgain;
        break;
      case Errors.noAccepts:
        image = Assets.iconsNoDeclines;
        subTitle = context.loc.noAccepts;
        description = context.loc.thereAreNoAccepts;
        break;
      default:
        image = Assets.iconsServerError;
        subTitle = context.loc.serverError;
        description = context.loc.somethingWentWrong;
    }
  }
}
