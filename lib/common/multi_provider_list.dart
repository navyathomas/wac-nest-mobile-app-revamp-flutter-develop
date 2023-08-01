import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/address_provider.dart';
import 'package:nest_matrimony/providers/account_provider_extends.dart';
import 'package:nest_matrimony/providers/connectivity_provider.dart';
import 'package:nest_matrimony/providers/contact_provider.dart';
import 'package:nest_matrimony/providers/inapp_provider.dart';
import 'package:nest_matrimony/providers/interest_received_provider.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/providers/map_provider.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/providers/new_join_provider.dart';
import 'package:nest_matrimony/providers/partner_prefernce_provider.dart';
import 'package:nest_matrimony/providers/premium_members_provider.dart';
import 'package:nest_matrimony/providers/payment_provider.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/providers/profile_handler_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/providers/search_filter_provider.dart';
import 'package:nest_matrimony/providers/services_provider.dart';
import 'package:nest_matrimony/providers/similar_profiles_provider.dart';
import 'package:nest_matrimony/providers/testimonials_provider.dart';
import 'package:nest_matrimony/providers/top_matches_provider.dart';
import 'package:nest_matrimony/providers/user_viewed_profie_provider.dart';
import 'package:nest_matrimony/services/instagram_services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/app_data_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/daily_recommendation_provider.dart';
import '../providers/forgot_password_provider.dart';
import '../providers/home_provider.dart';
import '../providers/partner_detail_provider.dart';
import '../providers/notification_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => AppDataProvider()),
    ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => RegistrationProvider()),
    ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
    ChangeNotifierProvider(create: (_) => SearchFilterProvider()),
    ChangeNotifierProvider(create: (_) => PaymentProvider()),
    ChangeNotifierProvider(create: (_) => PhotoProvider()),
    ChangeNotifierProvider(create: (_) => AccountProvider()),
    ChangeNotifierProvider(create: (_) => MailBoxProvider()),
    ChangeNotifierProvider(create: (_) => InstagramServiceProvider()),
    ChangeNotifierProvider(create: (_) => MatchesProvider()),
    ChangeNotifierProvider(create: (_) => DailyRecommendationProvider()),
    ChangeNotifierProvider(create: (_) => TopMatchesProvider()),
    ChangeNotifierProvider(create: (_) => PremiumMembersProvider()),
    ChangeNotifierProvider(create: (_) => NewJoinProvider()),
    ChangeNotifierProvider(create: (_) => UserViewedProfileProvider()),
    ChangeNotifierProvider(create: (_) => InterestRecievedProvider()),
    ChangeNotifierProvider(create: (_) => TestimonialsProvider()),
    ChangeNotifierProvider(create: (_) => ServicesProvider()),
    ChangeNotifierProvider(create: (_) => ContactProvider()),
    ChangeNotifierProvider(create: (_) => PartnerDetailProvider()),
    ChangeNotifierProvider(create: (_) => SimilarProfilesProvider()),
    ChangeNotifierProvider(create: (_) => ProfileHandlerProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => LocationProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => AccountProviderExtends()),
    ChangeNotifierProvider(create: (context) {
      ConnectivityProvider changeNotifier = ConnectivityProvider();
      changeNotifier.initialLoad();
      return changeNotifier;
    }),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => PartnerPreferenceProvider()),
    ChangeNotifierProvider(create: (_)=>InappProvider())
  ];
}
