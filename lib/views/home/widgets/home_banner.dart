import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:provider/provider.dart';

class HomeUpgradePlanBanner extends StatelessWidget {
  final Image image;
  final Function()? onTap;
  const HomeUpgradePlanBanner({Key? key, required this.image, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<AppDataProvider, BasicDetailModel?>(
        selector: (context, provider) => provider.basicDetailModel,
        builder: (context, value, child) {
          return (value?.basicDetail?.premiumAccount ?? false)
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.fromLTRB(7.w, 32.h, 7.w, 8.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.r),
                    child: InkWell(
                      onTap: onTap,
                      child: SizedBox(
                        height: (context.sw() - 14.w) * .52,
                        child: image,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class HomeSuccessStoriesBanner extends StatelessWidget {
  final Image image;
  final Function()? onTap;
  const HomeSuccessStoriesBanner({Key? key, required this.image, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(7.w, 32.h, 7.w, 8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.r),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: (context.sw() - 14.w) * .52,
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}
