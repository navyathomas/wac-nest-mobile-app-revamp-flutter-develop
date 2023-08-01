import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/providers/contact_provider.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class CommonTermsAndConditions extends StatefulWidget {
  final String? appbarTitle;
  final bool isTerms;
  const CommonTermsAndConditions(
      {Key? key, this.appbarTitle, this.isTerms = false})
      : super(key: key);

  @override
  State<CommonTermsAndConditions> createState() =>
      _CommonTermsAndConditionsState();
}

class _CommonTermsAndConditionsState extends State<CommonTermsAndConditions> {
  String htmlContent = "";
  @override
  void initState() {
    Future.microtask(() {
      final provider = context.read<ContactProvider>();
      provider.clearTermsAndPolicy();
      provider.termsData == null && provider.policyData == null
          ? widget.isTerms
              ? provider.getTerms()
              : provider.getPolicy()
          : null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String htmlContent = """<div>
    //     <h1>Demo Page</h1>
    //     <p>This is a fantastic product that you should buy!</p>
    //     <h3>Features</h3>
    //     <ul>
    //       <li>It actually works</li>
    //       <li>It exists</li>
    //       <li>It doesn't cost much!</li>
    //     </ul>
    //     <!--You can pretty much put any html in here!-->
    //   </div>""";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.appbarTitle ?? 'App_title',
          style: FontPalette.white16Bold
              .copyWith(color: const Color.fromARGB(255, 78, 64, 64)),
        ),
        elevation: 0.5,
        leading: ReusableWidgets.roundedBackButton(context),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      backgroundColor: Colors.white,
      body: Consumer<ContactProvider>(builder: (context, value, child) {
        return switchView(value.loaderState, value, context);
      }),
    );
  }

  switchView(
      LoaderState loaderState, ContactProvider provider, BuildContext context) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loaded:
        child = mainView(provider);
        break;
      case LoaderState.error:
        child = CommonErrorView(
            error: Errors.serverError,
            onTap: () =>
                widget.isTerms ? provider.getTerms() : provider.getPolicy());
        break;
      case LoaderState.networkErr:
        child = CommonErrorView(
            error: Errors.networkError,
            onTap: () =>
                widget.isTerms ? provider.getTerms() : provider.getPolicy());
        break;
      case LoaderState.noData:
        CommonErrorView(
            error: Errors.noDatFound,
            onTap: () =>
                widget.isTerms ? provider.getTerms() : provider.getPolicy());
        break;

      case LoaderState.loading:
        // TODO: Handle this case.
        break;
    }
    return child;
  }

  mainView(ContactProvider value) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 17.w,
              right: 17.w,
            ),
            //top:21.h removed
            child: HtmlWidget(
              onLoadingBuilder: (context, element, loadingProgress) => Center(
                  child: LinearProgressIndicator(
                minHeight: 3.5.h,
              )),
              // onErrorBuilder: (context, element, error) =>
              //     const CommonErrorView(error: Errors.serverError),
              value.termsData ?? value.policyData ?? "",
              isSelectable: true,
            ),
          ),
        ],
      ),
    );
  }
}
