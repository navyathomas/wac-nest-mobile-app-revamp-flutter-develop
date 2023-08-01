import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_basic_details.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_contact_address.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_family_details.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_horoscope_details.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_info_tile.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_location.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_location_preferences.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_preference.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_professional_info.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_professional_preferences.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_religious_info.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_religious_preferences.dart';
import 'package:nest_matrimony/views/partner_profile_detail/widgets/partner_similar_profiles.dart';
import 'package:provider/provider.dart';

import '../../../common/common_functions.dart';
import '../../../common/constants.dart';
import '../../../models/profile_view_model.dart';
import '../../../providers/partner_detail_provider.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/shimmers/partner_detail_shimmer.dart';
import 'about_partner.dart';

class PartnerDetailBodyView extends StatelessWidget {
  const PartnerDetailBodyView(
      {Key? key,
      required this.controller,
      required this.enableBottomTile,
      this.fetchData})
      : super(key: key);

  final ScrollController controller;
  final ValueNotifier<bool> enableBottomTile;
  final Function? fetchData;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorPalette.pageBgColor,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19.r), topRight: Radius.circular(19.r))),
        child: Selector<PartnerDetailProvider,
            Tuple2<LoaderState, PartnerDetailModel?>>(
          selector: (cxt, provider) =>
              Tuple2(provider.loaderState, provider.partnerDetailModel),
          builder: (cxt, value, child) {
            child = Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 23.h),
                    children: [
                      const PartnerInfo(),
                      const AboutPartner(),
                      const PartnerBasicDetails(),
                      const PartnerProfessionalInfo(),
                      const PartnerReligiousInfo(),
                      const PartnerLocation(),
                      const PartnerFamilyDetails(),
                      const PartnerContactAddress(),
                      const PartnerHoroscopeDetails(),
                      const PartnerPreference(),
                      const PartnerProfessionalPreferences(),
                      const PartnerReligiousPreferences(),
                      const PartnerLocationPreferences(),
                      PartnerSimilarProfiles(
                        onReturn: (value) {
                          if (value) {
                            CommonFunctions.scrollToTop(controller);
                            if (fetchData != null) fetchData!();
                          }
                        },
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: enableBottomTile,
                          builder: (context, value, _) {
                            return value
                                ? SizedBox(
                                    height: ((context.sw() - 166.w) / 5) + 36.h)
                                : const SizedBox.shrink();
                          })
                    ],
                  ),
                ),
              ],
            );
            return (value.item1.isLoading ||
                    value.item2?.data?.basicDetails == null)
                ? const PartnerDetailShimmer()
                : child;
          },
        ),
      ),
    );
  }
}
