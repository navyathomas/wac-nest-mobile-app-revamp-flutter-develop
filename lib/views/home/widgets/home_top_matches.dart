import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/profile_search_model.dart';
import 'package:nest_matrimony/providers/top_matches_provider.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/widgets/shimmers/partner_horizontal_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/partner_horizontal_tile.dart';
import '../../../common/constants.dart';
import 'home_header_tile.dart';

class HomeTopMatches extends StatelessWidget {
  const HomeTopMatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<TopMatchesProvider, Tuple2<List<UserData>?, LoaderState>>(
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
                                title: context.loc.topMatches,
                                onTap: () => Navigator.pushNamed(
                                    context, RouteGenerator.routeTopMatches),
                              ),
                              PartnerHorizontalTile(
                                userDataList: value.item1,
                                navToProfile: NavToProfile.navFromTopMatches,
                              ),
                              15.verticalSpace,
                            ],
                          );
          }),
    );
  }
}
