import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../providers/connectivity_provider.dart';
import '../views/error_views/error_tile.dart';

class NetworkConnectivity extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Function? onTap;
  final Color color;

  const NetworkConnectivity(
      {Key? key,
      required this.child,
      this.inAsyncCall = false,
      this.opacity = 0.3,
      this.onTap,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, snapshot, _) {
      List<Widget> widgetList = [];
      widgetList.add(child);
      if (!snapshot.isConnected || snapshot.enableRefresh) {
        widgetList.add(Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: Colors.black12,
              ),
              Expanded(
                child: ErrorTile(
                  errors: Errors.networkError,
                  onTap: () {
                    if (snapshot.isConnected) snapshot.updateEnableRefresh();
                    if (onTap != null && snapshot.isConnected) {
                      onTap!();
                    }
                  },
                ),
              ),
            ],
          ),
        ));
      }
      final modal = (inAsyncCall
              ? Stack(
                  children: [
                    Opacity(
                      opacity: opacity,
                      child: ModalBarrier(dismissible: false, color: color),
                    ),
                    ReusableWidgets.circularProgressIndicator(),
                  ],
                )
              : const SizedBox())
          .animatedSwitch();
      widgetList.add(modal);
      return Stack(
        children: widgetList,
      );
    });
  }
}
