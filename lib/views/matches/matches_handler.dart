import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/extensions.dart';

import '../../generated/assets.dart';
import '../../models/button_style_model.dart';
import '../../utils/color_palette.dart';

class MatchesHandler {
  static List<ButtonStyleModel> matchesMenuList(BuildContext context) => [
        ButtonStyleModel(
            title: context.loc.allMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsInterestsGrey,
            gradiantColor: [HexColor('#9AA6FF'), HexColor('#344CFF')]),
        ButtonStyleModel(
            title: context.loc.topMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsViewedWhite,
            gradiantColor: [HexColor('#A5DDFF'), HexColor('#00A7FF')]),
        ButtonStyleModel(
            title: context.loc.newProfiles.replaceFirst(' ', '\n'),
            icon: Assets.iconsPhoneSearch,
            gradiantColor: [HexColor('#B6EDD5'), HexColor('#00BC76')]),
        ButtonStyleModel(
            title: context.loc.premiumProfiles.replaceFirst(' ', '\n'),
            icon: Assets.iconsShortlistedWhite,
            gradiantColor: [HexColor('#E8D1FF'), HexColor('#8B0EF7')]),
        ButtonStyleModel(
            title: context.loc.nearByMatches.replaceFirst(' ', '\n'),
            icon: Assets.iconsShortlistedWhite,
            gradiantColor: [HexColor('#FF9182'), HexColor('#FF4F38')])
      ];

  static List<String> matchesMenuTitleList(BuildContext context) => [
        context.loc.allMatches,
        context.loc.topMatches,
        context.loc.newProfiles,
        context.loc.premiumProfiles,
        context.loc.nearByMatches
      ];

  static List<List<Color>> matchesMenuBgList(BuildContext context) => [
        [HexColor('#9AA6FF'), HexColor('#344CFF')],
        [HexColor('#A5DDFF'), HexColor('#00A7FF')],
        [HexColor('#B6EDD5'), HexColor('#00BC76')],
        [HexColor('#E8D1FF'), HexColor('#8B0EF7')],
        [HexColor('#FF9182'), HexColor('#FF4F38')]
      ];

  static List<Color> tabSelectedColors = [
    HexColor('#354DFF'),
    HexColor('#15A7FF'),
    HexColor('#1FBD77'),
    HexColor('#8B0EF7'),
    HexColor('#FF4F38')
  ];

  static List<String> tabTitles(BuildContext context) =>
      [context.loc.notViewed, context.loc.viewed];
}
