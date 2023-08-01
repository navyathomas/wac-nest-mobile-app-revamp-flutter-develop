import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/service_config.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/common_image_view.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../widgets/horoscope_card.dart';
import 'partner_category_tile.dart';
import 'partner_key_value_tile.dart';

class PartnerHoroscopeDetails extends StatelessWidget {
  final bool enableTopDivider;
  final bool hideDownloadBtn;
  const PartnerHoroscopeDetails(
      {Key? key, this.enableTopDivider = false, this.hideDownloadBtn = false})
      : super(key: key);

  Widget _downloadHoroscopeBtn(BuildContext context, String filePath,
      List<UserHoroscopeImage> imageList) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (imageList.isNotEmpty) {
              ServiceConfig config = ServiceConfig();
              config.downloadImage(
                  imageUrls: imageList
                      .map((UserHoroscopeImage? e) =>
                          e?.userImagePath.horoscopeImagePath(context) ?? '')
                      .toList(),
                  filePath: filePath);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Assets.iconsDownload,
                    width: 12.r, height: 12.r),
                10.horizontalSpace,
                Text(
                  context.loc.downloadHoroscope,
                  style: FontPalette.f2995E5_13ExtraBold,
                ).flexWrap
              ],
            ),
          ),
        ).applyRipple(color: Colors.black26),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PartnerDetailProvider, PartnerDetailModel?>(
      selector: (context, provider) => provider.partnerDetailModel,
      builder: (context, value, child) {
        return (value?.data?.basicDetails?.isHindu ?? false)
            ? Column(
                children: [
                  WidgetExtension.verticalDivider(
                      height: 2.h,
                      margin: EdgeInsets.only(top: 0, bottom: 17.h)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PartnerCategoryTile(
                          title: context.loc.horoscopeDetails,
                          icon: Assets.iconsCake,
                        ),
                        6.verticalSpace,

                        ///ToDo: removed after discussing with backend
                        PartnerKeyValueTile(
                          leading: context.loc.birthTime,
                          trailing: value?.data?.basicDetails?.userReligiousInfo
                              ?.timeOfBirth,
                        ),
                        if (value?.data?.basicDetails?.userReligiousInfo
                                ?.sistaDasaDay !=
                            null)
                          PartnerKeyValueTile(
                            leading: context.loc.janmaSistaDasaEnd,
                            trailing:
                                '${value?.data?.basicDetails?.userReligiousInfo?.sistaDasaDay}-${value?.data?.basicDetails?.userReligiousInfo?.sistaDasaMonth}-${value?.data?.basicDetails?.userReligiousInfo?.sistaDasaYear}',
                          ),
                        PartnerKeyValueTile(
                          leading: context.loc.dasa,
                          trailing: value?.data?.basicDetails?.userReligiousInfo
                              ?.dhasaName,
                        ),
                        PartnerKeyValueTile(
                          leading: context.loc.dobMalayalam,
                          trailing: value?.data?.basicDetails?.userReligiousInfo
                              ?.malayalamDob,
                        ),
                        PartnerKeyValueTile(
                          leading: context.loc.dobEnglish,
                          trailing: value?.data?.basicDetails?.dateOfBirth,
                        ),
                        PartnerKeyValueTile(
                          leading: context.loc.starOrRasi,
                          trailing: value?.data?.basicDetails?.userReligiousInfo
                              ?.userStars?.starName,
                        ),
                        Selector<PartnerDetailProvider, Map<int, List<String>>>(
                          selector: (context, provider) =>
                              provider.grahanilaData,
                          builder: (context, horoscopeValue, child) {
                            return horoscopeValue.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 14.h),
                                    child: HoroscopeCard(
                                      title: context.loc.grahanila,
                                      horoscopeData: horoscopeValue,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        Selector<
                            PartnerDetailProvider,
                            Tuple2<Map<int, List<String>>,
                                PartnerDetailModel?>>(
                          selector: (context, provider) => Tuple2(
                              provider.navamshakamData,
                              provider.partnerDetailModel),
                          builder: (context, horoscopeValue, child) {
                            return horoscopeValue.item1.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 25.h),
                                    child: HoroscopeCard(
                                      title: context.loc.navamshakam,
                                      horoscopeData: horoscopeValue.item1,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      UserHoroscopeImage? image = horoscopeValue
                                          .item2
                                          ?.data
                                          ?.basicDetails
                                          ?.userHoroscopeImage?[index];
                                      print(
                                          'Url ----------- ${image?.userImagePath ?? ''}');
                                      if ((image?.userImagePath ?? '')
                                          .isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: CommonImageView(
                                          image: image?.userImagePath
                                                  ?.horoscopeImagePath(
                                                      context) ??
                                              '',
                                          height: 230.h,
                                          boxFit: BoxFit.cover,
                                          width: double.maxFinite,
                                        ),
                                      );
                                    },
                                    itemCount: horoscopeValue
                                            .item2
                                            ?.data
                                            ?.basicDetails
                                            ?.userHoroscopeImage
                                            ?.length ??
                                        0,
                                  );
                          },
                        ),

                        (value?.data?.basicDetails?.userHoroscopeImage ?? [])
                                    .isNotEmpty &&
                                !hideDownloadBtn
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: 6.h, bottom: 14.h),
                                child: _downloadHoroscopeBtn(
                                    context,
                                    value?.data?.basicDetails?.name ??
                                        value?.data?.basicDetails?.registerId ??
                                        '',
                                    value?.data?.basicDetails
                                            ?.userHoroscopeImage ??
                                        []),
                              )
                            : SizedBox(
                                height: 32.h,
                              )
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
