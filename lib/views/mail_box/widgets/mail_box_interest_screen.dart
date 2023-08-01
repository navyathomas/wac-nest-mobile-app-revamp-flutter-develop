import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/providers/mail_box_provider.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interest_accepted.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interest_declined.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interest_received.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interest_sent.dart';
import 'package:provider/provider.dart';

class MailBoxInterestScreen extends StatefulWidget {
  const MailBoxInterestScreen({Key? key, required this.tabController})
      : super(key: key);
  final TabController? tabController;
  @override
  State<MailBoxInterestScreen> createState() => _MailBoxInterestScreenState();
}

class _MailBoxInterestScreenState extends State<MailBoxInterestScreen> {
  List<Widget> tabViewWidgets() => [
        MailBoxInterestReceived(),
        MailBoxInterestSend(),
        MailBoxInterestAccepted(),
        MailBoxInterestDeclined()
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MailBoxProvider>(
        builder: (context, mailBoxProvider, child) {
          return _mainView(mailBoxProvider.selectedChildIndex);
        },
      ),
    );
  }

  _mainView(int index) {
    Widget child = const SizedBox.shrink();
    switch (index) {
      case 0:
        child = MailBoxInterestReceived();
        break;
      case 1:
        child = MailBoxInterestSend();
        break;
      case 2:
        child = MailBoxInterestAccepted();
        break;
      case 3:
        child = MailBoxInterestDeclined();
        break;
      default:
        child = MailBoxInterestReceived();
    }
    return child;
  }
}
