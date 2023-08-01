import 'package:flutter/material.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interest_declined.dart';

import 'mail_box_interest_accepted.dart';
import 'mail_box_interest_received.dart';
import 'mail_box_interest_sent.dart';

class MailBoxInterests extends StatefulWidget {
  final TabController? tabController;
  const MailBoxInterests({Key? key, this.tabController}) : super(key: key);

  @override
  State<MailBoxInterests> createState() => _MailBoxInterestsState();
}

class _MailBoxInterestsState extends State<MailBoxInterests>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<Widget> tabViewWidgets() => [
        MailBoxInterestReceived(),
        MailBoxInterestSend(),
        MailBoxInterestAccepted(),
        MailBoxInterestDeclined()
      ];

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: List.generate(
            tabViewWidgets().length, (index) => tabViewWidgets()[index]));
  }

  @override
  void initState() {
    tabController = widget.tabController;
    super.initState();
  }
}
