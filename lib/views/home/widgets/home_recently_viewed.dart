import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/user_viewed_profie_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/mail_box_response_model.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/home_partner_horizontal_tile.dart';
import '../../../widgets/shimmers/partner_horizontal_shimmer.dart';
import 'home_header_tile.dart';

class HomeRecentlyViewed extends StatelessWidget {
  const HomeRecentlyViewed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<UserViewedProfileProvider,
              Tuple2<List<InterestUserData>?, LoaderState>>(
          selector: (context, provider) =>
              Tuple2(provider.interestUserDataList, provider.loaderState),
          builder: (context, value, child) {
            return value.item2.isLoading
                    ? const PartnerHorizontalTileShimmer()
                    : (value.item1 ?? []).isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              HomeHeaderTile(
                                title: context.loc.recentlyViewed,
                                onTap: () => Navigator.pushNamed(context,
                                    RouteGenerator.routeRecentlyViewed),
                              ),
                              HomePartnerHorizontalTile(
                                userDataList: value.item1,
                                navToProfile:
                                    NavToProfile.navFromRecentlyViewed,
                              ),
                            ],
                          );
          }),
    );
  }
}