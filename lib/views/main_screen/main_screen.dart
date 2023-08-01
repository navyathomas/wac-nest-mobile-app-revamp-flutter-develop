import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/account/my_profile.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_sample_screen.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_screen.dart';
import 'package:nest_matrimony/views/matches/matches_screen.dart';
import 'package:nest_matrimony/views/matches/matches_screen_sample.dart';
import 'package:nest_matrimony/widgets/empty_app_bar.dart';
import 'package:provider/provider.dart';

import '../../generated/assets.dart';
import '../../one_signal_messaging_services.dart';
import '../../providers/mail_box_provider.dart';
import '../../services/uni_links_services.dart';
import '../../services/widget_handler/home_page_handler.dart';
import '../home/home_screen.dart';
import '../service_screens/services.dart';

class MainScreen extends StatefulWidget {
  final int? tabIndex;
  const MainScreen({Key? key, this.tabIndex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ValueNotifier<int> selectedIndex;
  DateTime? currentBackPressTime;
  final List<String> _bottomNavIcons = [
    Assets.iconsHomeOutlined,
    Assets.iconsMatches,
    Assets.iconsMailbox,
    Assets.iconsServices,
    Assets.iconsAccount
  ];

  final List<String> _bottomNavSelectedIcons = [
    Assets.iconsHomeSelected,
    Assets.iconsMatchesSelected,
    Assets.iconsMailBoxSelected,
    Assets.iconsServicesSelected,
    Assets.iconsAccountSelected
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const MatchesScreenSample(),
    const MailBoxSampleScreen(),
    const ServiceScreen(),
    const MyProfile()
  ];

  final List<PreferredSizeWidget?> _appBars = [
    null,
    EmptyAppBar(
      backgroundColor: Colors.white,
    ),
    EmptyAppBar(
      backgroundColor: Colors.white,
    ),
    EmptyAppBar(
      backgroundColor: Colors.white,
    ),
    AccountAppBar()
  ];

  List<String> _bottomNavLabels = [];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, value, _) {
            if (_bottomNavLabels.isEmpty) assignTabValues();
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: value,
                showSelectedLabels: true,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                onTap: (val) {
                  switch (val) {
                    // case 1:
                    //   selectedIndex.value = val;
                    //   context.read<MatchesProvider>().clearFilterTempValues();
                    //   break;
                    case 2:
                      selectedIndex.value = val;
                      CommonFunctions.afterInit(() {
                        context
                            .read<MailBoxProvider>()
                            .updateTabControllerIndex(0);
                        context
                            .read<MailBoxProvider>()
                            .updateSubTabControllerIndex(0);
                        context.read<MailBoxProvider>().updateSelectedIndex(0);
                        context
                            .read<MailBoxProvider>()
                            .updateSelectedChildIndex(0);
                        context
                            .read<MailBoxProvider>()
                            .updateChildTabControllerIndex(0);
                      });
                      break;
                    default:
                      selectedIndex.value = val;
                  }
                },
                selectedLabelStyle: FontPalette.f950053_11semiBold,
                unselectedLabelStyle: FontPalette.f525B67_11semiBold,
                items: List.generate(
                  _bottomNavIcons.length,
                  (index) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: ValueListenableBuilder<int>(
                          valueListenable: selectedIndex,
                          builder: (context, value, _) {
                            return AnimatedSwitcher(
                              duration: const Duration(microseconds: 300),
                              child: (value != index
                                      ? SvgPicture.asset(
                                          _bottomNavIcons[index],
                                          height: 20.w,
                                          width: 20.w,
                                        )
                                      : SvgPicture.asset(
                                          _bottomNavSelectedIcons[index],
                                          height: 20.w,
                                          width: 20.w,
                                        ))
                                  .animatedSwitch(),
                            );
                          }),
                    ),
                    label: _bottomNavLabels[index],
                  ),
                ),
              ),
              appBar: _appBars[value],
              body: Stack(
                children: [
                  WillPopScope(
                    onWillPop: () => _onWillPop(value),
                    child: PageTransitionSwitcher(
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return FadeThroughTransition(
                          fillColor: Colors.white,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: _widgetOptions[value],
                    ),
                  ),
                  if (value == 0)
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: MediaQuery.of(context).padding.top,
                        automaticallyImplyLeading: false,
                        systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarBrightness: Brightness.dark,
                          statusBarIconBrightness: Brightness.light,
                          systemNavigationBarIconBrightness: Brightness.light,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  void assignTabValues() {
    _bottomNavLabels = [
      context.loc.home,
      context.loc.matches,
      context.loc.mailBox,
      context.loc.services,
      context.loc.account
    ];
  }

  @override
  void initState() {
    selectedIndex = ValueNotifier(widget.tabIndex ?? 0);
    UriLinkService.instance.initURIHandler(context, mounted);
    UriLinkService.instance.incomingLinkHandler(context, mounted);
    CommonFunctions.afterInit(() {
      NotificationServices.oneSignalInitialization(context);
    });
    HomePageHandler.instance.fetchHomeApis(context);
    super.initState();
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(int index) async {
    if (index != 0) {
      selectedIndex.value = 0;
      return false;
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        // Helpers.successToast(context.loc.pressAgainToExit);
        return Future.value(false);
      } else {
        return true;
      }
    }
  }
}
