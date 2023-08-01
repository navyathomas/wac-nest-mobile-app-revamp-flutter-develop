import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';

class PartnerDetailShimmer extends StatelessWidget {
  const PartnerDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 23.h),
            children: const [
              _PartnerInfoShimmer(),
               _AboutPartnerShimmer(),
              _PartnerBasicDetailShimmer(),
              _PartnerBasicDetailShimmer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PartnerInfoShimmer extends StatelessWidget {
  const _PartnerInfoShimmer({Key? key}) : super(key: key);

  Widget _infoTypeTile(double width) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(19.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 19.r,
            width: 19.r,
          ),
          6.horizontalSpace,
          SizedBox(
            width: width,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                height: 20.h,
                width: context.sw(size: 0.4),
              ),
              18.verticalSpace,
              Wrap(
                spacing: 7.w,
                runSpacing: 12.h,
                children: [
                  _infoTypeTile(context.sw(size: 0.13)),
                  _infoTypeTile(context.sw(size: 0.13)),
                  _infoTypeTile(context.sw(size: 0.13)),
                  _infoTypeTile(context.sw(size: 0.6)),
                  _infoTypeTile(context.sw(size: 0.3)),
                  _infoTypeTile(context.sw(size: 0.2))
                ],
              ),
            ],
          ),
        ).addShimmer,
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 24.h, bottom: 17.h))
      ],
    );
  }
}

class _AboutPartnerShimmer extends StatelessWidget {
  const _AboutPartnerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PartnerCategoryTileShimmer(),
              6.verticalSpace,
              Container(
                height: 17.h,
                width: double.maxFinite,
                color: Colors.white,
              ),
              5.verticalSpace,
              Container(
                height: 17.h,
                width: double.maxFinite,
                color: Colors.white,
              ),
            ],
          ),
        ).addShimmer,
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h))
      ],
    );
  }
}

class _PartnerCategoryTileShimmer extends StatelessWidget {
  const _PartnerCategoryTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.5.h),
      child: Row(
        children: [
          Container(
            height: 24.r,
            width: 24.r,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
          7.horizontalSpace,
          Expanded(
              child: Row(
            children: [
              Container(
                color: Colors.white,
                height: 20.h,
                width: context.sw(size: 0.3),
              ),
            ],
          ))
        ],
      ),
    ).addShimmer;
  }
}

class _PartnerBasicDetailShimmer extends StatelessWidget {
  const _PartnerBasicDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PartnerCategoryTileShimmer(),
              6.verticalSpace,
              ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, _) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 16.h,
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 20.w),
                            width: double.maxFinite,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 16.h,
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 20.w, left: 10.w),
                            width: double.maxFinite,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ).addShimmer,
            ],
          ),
        ),
        WidgetExtension.verticalDivider(
            height: 2.h, margin: EdgeInsets.only(top: 23.h, bottom: 17.h))
      ],
    );
  }
}
