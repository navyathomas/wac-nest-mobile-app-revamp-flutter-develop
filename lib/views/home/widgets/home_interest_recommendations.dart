import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/providers/interest_received_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/home_partner_horizontal_tile.dart';
import '../../../widgets/shimmers/partner_horizontal_shimmer.dart';
import 'home_header_tile.dart';

class HomeInterestRecommendations extends StatelessWidget {
  const HomeInterestRecommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<InterestRecievedProvider,
              Tuple2<List<InterestUserData>?, LoaderState>>(
          selector: (context, provider) =>
              Tuple2(provider.userDataList, provider.loaderState),
          builder: (context, value, child) {
            return value.item2.isLoading
                    ? const PartnerHorizontalTileShimmer()
                    : (value.item1 ?? []).isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              8.verticalSpace,
                              HomeHeaderTile(
                                title: context.loc.interestRecommendations,
                                onTap: () => Navigator.pushNamed(context,
                                    RouteGenerator.routeInterestRecommendation),
                              ),
                              HomePartnerHorizontalTile(
                                userDataList: value.item1,
                                navToProfile:
                                    NavToProfile.navFromInterestRecommendations,
                              ),
                            ],
                          );
          }),
    );
  }
}
