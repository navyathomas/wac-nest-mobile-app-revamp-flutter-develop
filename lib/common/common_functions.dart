import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nest_matrimony/models/profile_detail_default_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../generated/assets.dart';
import '../models/profile_search_model.dart';
import '../providers/partner_detail_provider.dart';

class CommonFunctions {
  static void afterInit(Function function) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      function();
    });
  }

  static String? getImage(List<dynamic>? userImage) {
    return (userImage ?? []).isEmpty ? null : userImage?.first.imageFile;
  }

  static void updateToProfileProvider(
      {required BuildContext context,
      required List<UserData> userData,
      required int index}) {
    List<UserData> data = [...userData.take(3)];
    for (var userData in data) {
      context.read<PartnerDetailProvider>().updateProfileList(
          ProfileDetailDefaultModel(
              id: userData.id,
              age: userData.age,
              isMale: userData.isMale,

              nestId: userData.registerId,
              userImage: userData.userImage,
              userName: userData.name));
    }
  }

  static String partnerKeyValueIcon(dynamic val) =>
      val == null ? Assets.iconsCloseCircleRed : Assets.iconsCheckCircle;

  static String reAssignText(String text, {bool enableMore = false}) {
    if (text.length > 50 && !enableMore) {
      return text.substring(0, 50);
    } else {
      return text;
    }
  }

  static void scrollToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  static void addDelay(Function function, {int seconds = 300}) {
    Future.delayed(Duration(milliseconds: seconds)).then((value) {
      function();
    });
  }

  static launchWhatsapp(String mobile,String text) async {
    final link = WhatsAppUnilink(
      phoneNumber: '{91$mobile}',
      text:
      text,
    );
    await launchUrl(
      link.asUri(),
      mode: LaunchMode.externalApplication,
    );
  }

  static void launchMap(String lat, String lng) async {
    var fallbackUrl = 'geo:$lat,$lng';
    var url = Platform.isAndroid
        ? 'google.navigation:q=$lat,$lng&mode=d'
        : 'https://maps.apple.com/?q=$lat,$lng';
    try {
      bool launched = await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }
}
