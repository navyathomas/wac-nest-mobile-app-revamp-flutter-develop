import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/widgets/shimmers/partner_horizontal_shimmer.dart';

import 'home_header_shimmer.dart';

class HomeHorizontalShimmer extends StatelessWidget {
  const HomeHorizontalShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [HomeHeaderShimmer(), PartnerHorizontalTileShimmer()],
    ).addShimmer;
  }
}