import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/authentication/login_arguments.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/widgets/common_floating_btn.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../common/route_generator.dart';
import '../../../services/widget_handler/registration_handler_class.dart';
import '../../../utils/tuple.dart';
import '../../../widgets/common_alert_view.dart';
import '../../alert_views/common_alert_view.dart';
import 'animated_circular_container.dart';

class RegistrationScreen extends StatefulWidget {
  final LoginArguments? loginArguments;
  const RegistrationScreen({Key? key, this.loginArguments}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationHandlerClass _instance = RegistrationHandlerClass();
  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      leading: Selector<RegistrationProvider, Tuple2<int, bool>>(
          selector: (context, provider) =>
              Tuple2(provider.tabIndex, provider.btnLoader),
          builder: (context, data, _) {
            return IconButton(
                onPressed:
                    data.item2 ? null : () => _handleBackButton(data.item1),
                icon: SvgPicture.asset(Assets.iconsChevronLeft));
          }),
      title: SizedBox(
        height: 36,
        width: double.maxFinite,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _instance.layoutData.length,
            physics: const NeverScrollableScrollPhysics(),
            controller: _instance.scrollController,
            itemBuilder: (cxt, index) {
              return AutoScrollTag(
                  index: index,
                  key: ValueKey(index),
                  controller: _instance.scrollController!,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    margin: EdgeInsets.only(right: index == 24 ? 20 : 0),
                    child: Selector<RegistrationProvider, int>(
                        selector: (context, provider) => provider.tabIndex,
                        builder: (context, currentIndex, _) {
                          return GlowCircle(
                              icon: _instance.layoutData[index].icon,
                              flag: index == currentIndex);
                        }),
                  ));
            }),
      ),
      actions: const [],
    );
  }

  Widget _floatingBtnHandler() {
    return Consumer<RegistrationProvider>(builder: (context, model, _) {
      switch (model.tabIndex) {
        case 0:
          return CommonFloatingBtn(
            enableBtn: (model.countryData == null || model.countryData?.id == 1)
                ? model.isNumberValid
                : model.isNumberValid && model.isEmailValid,
            enableLoader: model.btnLoader,
            onPressed: () => onRegisterClick(model),
          );
        case 3:
          return CommonFloatingBtn(
            enableBtn: model.fullName.length > 2,
            onPressed: () {
              FocusScope.of(context).unfocus();
              _nextFloatingAction();
            },
          );
        case 4:
          return CommonFloatingBtn(
            enableBtn: model.dateOfBirth != null,
            onPressed: () {
              _nextFloatingAction();
            },
          );
        default:
          return const SizedBox();
      }
    });
  }

  void _nextFloatingAction() {
    int index = (_instance.pageController?.page?.ceil() ?? 0) + 1;
    if (index < (_instance.layoutData.length)) {
      _instance.scrollToIndex(context: context, index: index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      floatingActionButton: _floatingBtnHandler(),
      body: Selector<RegistrationProvider, int>(
          selector: (context, provider) => provider.tabIndex,
          builder: (context, currentIndex, ignoreChild) {
            ignoreChild = PageView.builder(
                itemCount: _instance.layoutData.length,
                physics: const NeverScrollableScrollPhysics(),
                controller: _instance.pageController,
                itemBuilder: (cxt, index) {
                  return _instance.layoutData[index].view;
                });
            return WillPopScope(
              onWillPop: () => _onWillPop(currentIndex),
              child: ignoreChild,
            );
          }),
    );
  }

  @override
  void initState() {
    _instance.initialize(
        registerNumber: widget.loginArguments?.mobileNumber,
        email: widget.loginArguments?.email);
    CommonFunctions.afterInit(() {
      context
          .read<RegistrationProvider>()
          .pageInit(countryData: widget.loginArguments?.countryData);
      if (widget.loginArguments != null) {
        context.read<RegistrationProvider>()
          ..updatePhoneNumber(widget.loginArguments?.mobileNumber ?? '')
          ..assignCountryDataIfNull(context)
          ..validatePhoneNumber(widget.loginArguments?.mobileNumber ?? '')
          ..validateEmailAddress(widget.loginArguments?.email ?? '');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _instance.disposeAll();
    super.dispose();
  }

  void _handleBackButton(int currentIndex) {
    context.read<RegistrationProvider>().updateErrorMsg('');
    if (currentIndex == 2) {
      _instance.scrollToIndex(context: context, index: 0);
    } else if (currentIndex >= 1) {
      _instance.scrollToIndex(context: context, index: currentIndex - 1);
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool> _onWillPop(int currentIndex) async {
    context.read<RegistrationProvider>().updateErrorMsg('');
    if (currentIndex == 2) {
      _instance.scrollToIndex(context: context, index: 0);
      return false;
    } else if (currentIndex >= 1) {
      _instance.scrollToIndex(context: context, index: currentIndex - 1);
      return false;
    } else {
      return true;
    }
  }

  void onRegisterClick(RegistrationProvider model) {
    FocusScope.of(context).unfocus();
    model.registerRequestOtp(context, onSuccess: (res) {
      if (res != null) {
        if (res) {
          _nextFloatingAction();
        } else {
          Helpers.successToast(context.loc.numberAlreadyExist);
          Navigator.pushNamed(context, RouteGenerator.routeLoginViaOTP,
              arguments: LoginArguments(
                  mobileNumber: model.phoneNumber,
                  countryData: model.countryData,
                  email: model.emailId));
        }
      }
    });
  }
}
