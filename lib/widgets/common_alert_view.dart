import 'package:flutter/cupertino.dart';

class CommonAlertDialog {
  static showDialogPopUp(BuildContext context, Widget dialogWidget,
      {bool? barrierDismissible, String? routeName}) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible ?? true,
      context: context,
      routeSettings: routeName != null ? RouteSettings(name: routeName) : null,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return barrierDismissible ?? true;
          },
          child: Transform.scale(
            scale: curve,
            child: dialogWidget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
