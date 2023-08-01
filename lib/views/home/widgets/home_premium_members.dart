import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/premium_members_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/profile_search_model.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/partner_horizontal_tile.dart';
import '../../../widgets/shimmers/partner_horizontal_shimmer.dart';
import 'home_header_tile.dart';

class HomePremiumMembers extends StatelessWidget {
  const HomePremiumMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<PremiumMembersProvider,
              Tuple2<List<UserData>?, LoaderState>>(
          selector: (context, provider) =>
              Tuple2(provider.userDataList, provider.loaderState),
          builder: (context, value, child) {
            return value.item2.isLoading
                    ? const PartnerHorizontalTileShimmer()
                    : (value.item1 ?? []).isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              HomeHeaderTile(
                                title: context.loc.premiumMembers,
                                onTap: () => Navigator.pushNamed(context,
                                    RouteGenerator.routePremiumMembers),
                              ),
                              PartnerHorizontalTile(
                                userDataList: value.item1,
                                enableCrown: true,
                                navToProfile:
                                    NavToProfile.navFromPremiumMembers,
                              ),
                            ],
                          );
          }),
    );
  }
}
