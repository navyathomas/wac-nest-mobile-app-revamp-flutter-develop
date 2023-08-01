import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:provider/provider.dart';

import '../models/profile_detail_default_model.dart';

class NavRoutes {
  static void navToProductDetails(
      {required BuildContext context, ProfileDetailArguments? arguments}) {
    context.read<PartnerDetailProvider>().clearDefaultProfiles();
    Navigator.pushNamed(context, RouteGenerator.routePartnerProfileDetail,
        arguments: arguments);
  }
}
