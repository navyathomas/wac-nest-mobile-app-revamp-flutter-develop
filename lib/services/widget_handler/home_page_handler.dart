import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/models/profile_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/auth_provider.dart';
import 'package:nest_matrimony/providers/daily_recommendation_provider.dart';
import 'package:nest_matrimony/providers/home_provider.dart';
import 'package:nest_matrimony/providers/new_join_provider.dart';
import 'package:nest_matrimony/providers/premium_members_provider.dart';
import 'package:nest_matrimony/providers/top_matches_provider.dart';
import 'package:nest_matrimony/services/widget_handler/data_collection_alert_handler.dart';
import 'package:nest_matrimony/widgets/common_alert_view.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/basic_detail_model.dart';
import '../../providers/interest_received_provider.dart';
import '../../providers/mail_box_provider.dart';

class HomePageHandler {
  static HomePageHandler? _instance;

  static HomePageHandler get instance {
    _instance ??= HomePageHandler();
    return _instance!;
  }

  bool addBasicDetailVisibility = true;

  void fetchHomeApis(BuildContext context, {bool reload = false}) {
    final appDataProvider = context.read<AppDataProvider>();
    CommonFunctions.afterInit(() {
      context.read<AccountProvider>().profilePercentage();

//for agreement
      context.read<AuthProvider>().checkTermsofUse().then((value) {
        if (!value) {
          ReusableWidgets.showTerms(context,
              onPressed: () =>
                  context.read<AuthProvider>().agreeTermsofUse().then((agree) {
                    if (agree) {
                      Navigator.pop(context);
                      basicDetailAlert(context);
                    }
                  }));
        } else {
          basicDetailAlert(context);
        }
      });
//for agreement

      context.read<DailyRecommendationProvider>()
        ..pageInit()
        ..getDailyRecommendation();
      context.read<TopMatchesProvider>()
        ..pageInit()
        ..getTopMatchesData();
      context.read<HomeProvider>()
        ..pageInit()
        ..getDiscoverMoreData();
      context.read<PremiumMembersProvider>()
        ..pageInit()
        ..getPremiumMembersData();
      context.read<NewJoinProvider>()
        ..pageInit()
        ..getNewProfileData();
      context.read<InterestRecievedProvider>()
        ..pageInit()
        ..getInterestReceivedData();
      context.read<MailBoxProvider>().clearPageLoader();
      context.read<MailBoxProvider>().getProfileViewedList(context,
          enableLoader: true,
          page: 1,
          length: 20,
          profileViewedBy: ViewedBy.viewedByOthers,
          isFromHomePage: true);

      appDataProvider.getPaymentStatus(context);
      appDataProvider.getUpgradeStatus(context);
    });
  }

  void basicDetailAlert(BuildContext context) {
    final appDataProvider = context.read<AppDataProvider>();
    if (appDataProvider.basicDetailModel == null) {
      appDataProvider.getBasicDetails().then((value) {
        BasicDetail? basicDetail = value?.basicDetail;
        if (addBasicDetailVisibility &&
            (basicDetail?.isBasicProfileUpdated ?? true) == false) {
          addBasicDetailVisibility = false;
          DataCollectionAlertHandler.instance.openBasicDetailAlert(context);
        }
      });
    } else {
      BasicDetail? basicDetail = appDataProvider.basicDetailModel?.basicDetail;
      if (addBasicDetailVisibility &&
          (basicDetail?.isBasicProfileUpdated ?? true) == false) {
        addBasicDetailVisibility = false;
        DataCollectionAlertHandler.instance.openBasicDetailAlert(context);
      }
    }
  }
}
