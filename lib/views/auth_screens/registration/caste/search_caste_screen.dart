import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/registration_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/auth_screens/registration/caste/search_field.dart';
import 'package:nest_matrimony/views/auth_screens/registration/religion/custom_radio_tile.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../models/caste_list_model.dart';
import '../../../error_views/error_tile.dart';

class SearchCasteScreen extends StatefulWidget {
  const SearchCasteScreen({Key? key}) : super(key: key);

  @override
  State<SearchCasteScreen> createState() => _SearchCasteScreenState();
}

class _SearchCasteScreenState extends State<SearchCasteScreen> {
  TextEditingController queryController = TextEditingController();
  ValueNotifier<String> query = ValueNotifier('');

  Widget _trailIcon() {
    return ValueListenableBuilder<String>(
      valueListenable: query,
      builder: (context, value, _) {
        return (value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      queryController.clear();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: SvgPicture.asset(
                        Assets.iconsCloseRoundedGrey,
                        height: 20.r,
                        width: 20.r,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: SvgPicture.asset(
                      Assets.iconsSearchBlack,
                      height: 16.5.r,
                      width: 16.5.r,
                    ),
                  ))
            .animatedSwitch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72.h,
        titleSpacing: 0,
        leading: const SizedBox(),
        leadingWidth: 15.0.w,
        title: CustomSearchField(
          enableClose: false,
          borderColor: HexColor('#131A24'),
          trailingBtn: _trailIcon(),
          controller: queryController,
        ),
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 11.w, right: 23.w),
              child:
                  Text(context.loc.cancel, style: FontPalette.f131A24_15Bold),
            ),
          ).removeSplash()
        ],
      ),
      backgroundColor: Colors.white,
      body: Selector<RegistrationProvider, Tuple2<List<CasteData>?, int>>(
        selector: (context, provider) =>
            Tuple2(provider.casteDataList, provider.selectedCasteId),
        builder: (context, value, child) {
          if ((value.item1 ?? []).isEmpty) {
            ///TODO: need to change no match Found
            return const Center(
                child: ErrorTile(
              errors: Errors.noDatFound,
              enableBtn: false,
            ));
          }
          return ListView.builder(
              itemCount: value.item1!.length,
              itemBuilder: (context, index) {
                CasteData? caste = value.item1![index];
                return CustomRadioTile(
                  onTap: () => onTabCall(caste.id ?? -1),
                  title: caste.casteName ?? '',
                  isSelected:
                      caste.id == null ? false : caste.id == value.item2,
                  horizontalSpacing: 27,
                );
              });
        },
      ),
    );
  }

  @override
  void initState() {
    queryController.addListener(queryListener);
    super.initState();
  }

  void queryListener() {
    query.value = queryController.text;
    context
        .read<RegistrationProvider>()
        .searchCasteByQuery(queryController.text);
  }

  void onTabCall(int id) {
    context.read<RegistrationProvider>().updateCasteId(id);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => Navigator.pop(context, true));
  }

  @override
  void dispose() {
    query.dispose();
    queryController.dispose();
    super.dispose();
  }
}
