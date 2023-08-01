import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/views/auth_screens/registration/image_upload/image_upload_screen.dart';
import 'package:nest_matrimony/views/auth_screens/registration/otp_verification/otp_verification_screen.dart';
import 'package:nest_matrimony/views/auth_screens/registration/religion/religion_screen.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../generated/assets.dart';
import '../../providers/registration_provider.dart';
import '../../utils/tuple.dart';
import '../../views/auth_screens/registration/caste/caste_screen.dart';
import '../../views/auth_screens/registration/date_of_birth/date_of_birth_screen.dart';
import '../../views/auth_screens/registration/register_gender/register_gender_screen.dart';
import '../../views/auth_screens/registration/register_name_screen.dart';
import '../../views/auth_screens/registration/register_number/register_number_screen.dart';
import '../../views/auth_screens/registration/registration_layout_data.dart';

class RegistrationHandlerClass {
  static final RegistrationHandlerClass _instance =
      RegistrationHandlerClass._internal();
  factory RegistrationHandlerClass() => _instance;
  RegistrationHandlerClass._internal();

  PageController? pageController;
  AutoScrollController? scrollController;

  FixedExtentScrollController? ageScrollController;
  ValueNotifier<int>? selectedAgeValue;

  List<RegistrationLayoutData> layoutData = [
    RegistrationLayoutData(
        view: const RegisterNumberScreen(), icon: Assets.iconsMobile),
    RegistrationLayoutData(
        view: Selector<RegistrationProvider, Tuple2<String, bool>>(
            selector: (context, provider) =>
                Tuple2(provider.errorMsg, provider.btnLoader),
            builder: (context, value, child) {
              return OtpVerificationScreen(
                enableError: value.item1.isNotEmpty,
                errorMsg: value.item1,
                enableLoader: value.item2,
                mobileNumber:
                    context.read<RegistrationProvider>().numberWithCode,
                email: context.read<RegistrationProvider>().emailId,
                onTap: (BuildContext context) {
                  RegistrationHandlerClass()
                      .scrollToIndex(index: 0, context: context);
                },
                onChange: (val) {
                  context.read<RegistrationProvider>()
                    ..updateOtpInput(val)
                    ..updateErrorMsg('');
                },
                onResendTap: () => context
                    .read<RegistrationProvider>()
                    .registerRequestOtp(context),
                onComplete: (BuildContext context, val) {
                  context
                      .read<RegistrationProvider>()
                      .registerVerifyOtp(context, onSuccess: () {
                    RegistrationHandlerClass()
                        .scrollToIndex(index: 2, context: context);
                  });
                },
              );
            }),
        icon: Assets.iconsVerification),
    RegistrationLayoutData(
        view: const RegisterGenderScreen(), icon: Assets.iconsGenderIndicator),
    RegistrationLayoutData(
        view: const RegisterNameScreen(), icon: Assets.iconsUser),
    RegistrationLayoutData(
        view: const DateOfBirthScreen(), icon: Assets.iconsCalender),
    RegistrationLayoutData(
        view: const ReligionScreen(), icon: Assets.iconsReligion),
    RegistrationLayoutData(view: const CasteScreen(), icon: Assets.iconsCaste),
    RegistrationLayoutData(
        view: const ImageUploadScreen(), icon: Assets.iconsCamera),
  ];

  ///Mobile NumberN

  TextEditingController? registerNameCtrl;
  TextEditingController? registerNumberCtrl;
  TextEditingController? registerEmailCtrl;
  TextEditingController? whatsappNumberCtrl;

  initialize({String? registerNumber, String? email}) {
    pageController = PageController();
    scrollController = AutoScrollController(axis: Axis.horizontal);
    registerNameCtrl = TextEditingController();
    registerNumberCtrl = TextEditingController(text: registerNumber ?? '');
    registerEmailCtrl = TextEditingController(text: email ?? '');
    whatsappNumberCtrl = TextEditingController();

  }

  void initializeAgeWheel(int? val) {
    ageScrollController = FixedExtentScrollController(initialItem: val ?? 0);
    selectedAgeValue = ValueNotifier(val ?? 0);
  }

  Future<void> scrollToIndex(
      {required int index,
      required BuildContext context,
      bool mounted = true}) async {
    pageController!.animateToPage(index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut);
    if (index % 5 == 0) {
      await scrollController!
          .scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
    }
    if (!mounted) return;
    context.read<RegistrationProvider>().updateTabIndex(index);
  }

  void scrollAgeWheelToIndex(int index) {
    ageScrollController!.animateToItem(index,
        duration: const Duration(milliseconds: 500), curve: Curves.bounceInOut);
    selectedAgeValue!.value = index;
  }

  void disposeAll() {
    pageController!.dispose();
    scrollController!.dispose();
    registerNameCtrl!.dispose();
    registerNumberCtrl!.dispose();
    whatsappNumberCtrl?.dispose();
    registerEmailCtrl?.dispose();

    "Disposed".log;
  }

  void disposeAgeWheel() {
    ageScrollController!.dispose();
  }
}
