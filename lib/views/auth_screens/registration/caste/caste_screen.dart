import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/caste_list_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/auth_screens/registration/caste/search_field.dart';
import 'package:nest_matrimony/views/auth_screens/registration/religion/custom_radio_tile.dart';
import 'package:nest_matrimony/views/error_views/error_tile.dart';
import 'package:provider/provider.dart';

import '../../../../providers/registration_provider.dart';
import '../../../../services/widget_handler/registration_handler_class.dart';
import '../../../../utils/font_palette.dart';

class CasteScreen extends StatelessWidget {
  const CasteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        36.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Text(
            context.loc.whatsURCaste,
            style: FontPalette.black30Bold,
          ),
        ),
        30.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: GestureDetector(
              onTap: () async {
                context.read<RegistrationProvider>().reAssignCastListModel();
                final val = await Navigator.pushNamed(
                    context, RouteGenerator.routeSearchCaste);
                if (val == true) {
                  navToNext(context);
                  /*Future.microtask(() =>
                      context.read<RegistrationProvider>().registerUserData(
                          context: context,
                          onSuccess: () {
                            context.read<AppDataProvider>().getBasicDetails();
                            navToNext(context);
                          }));*/
                }
              },
              child: AbsorbPointer(
                  child: CustomSearchField(
                borderColor: HexColor('#D9DCE0'),
              ))),
        ),
        Expanded(
            child: Selector<RegistrationProvider, Tuple2<CasteListModel?, int>>(
          selector: (context, provider) =>
              Tuple2(provider.casteListModel, provider.selectedCasteId),
          builder: (context, value, child) {
            if (value.item1 == null) return const SizedBox.shrink();
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if ((value.item1?.data?.mostUsedCaste ?? []).isNotEmpty) ...[
                  SliverList(
                      delegate: SliverChildBuilderDelegate((cxt, index) {
                    CasteData? mostUsedCaste =
                        value.item1?.data!.mostUsedCaste![index];
                    return InkWell(
                      onTap: () {
                        context
                            .read<RegistrationProvider>()
                            .updateCasteId(mostUsedCaste?.id ?? -1);
                        navToNext(context);
                        /*..registerUserData(
                              context: context,
                              onSuccess: () {
                                context
                                    .read<AppDataProvider>()
                                    .getBasicDetails();
                                navToNext(context);
                              });*/
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 7.h : 0),
                        child: CustomRadioTile(
                          title: mostUsedCaste?.casteName ?? '',
                          horizontalSpacing: 27,
                          isSelected: mostUsedCaste?.id == null
                              ? false
                              : mostUsedCaste?.id == value.item2,
                        ),
                      ),
                    );
                  }, childCount: value.item1!.data!.mostUsedCaste!.length)),
                  SliverToBoxAdapter(
                    child: WidgetExtension.horizontalDivider(
                        color: HexColor('#E4E7E8'),
                        margin: EdgeInsets.symmetric(
                            horizontal: 27.w, vertical: 9.h)),
                  )
                ],
                (value.item1?.data?.castes ?? []).isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((cxt, index) {
                        CasteData? caste = value.item1!.data!.castes![index];
                        return InkWell(
                          onTap: () {
                            context
                                .read<RegistrationProvider>()
                                .updateCasteId(caste.id ?? -1);
                            navToNext(context);
                            /*..registerUserData(
                                  context: context,
                                  onSuccess: () {
                                    context
                                        .read<AppDataProvider>()
                                        .getBasicDetails();
                                    navToNext(context);
                                  });*/
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: index == 0 ? 7.h : 0),
                            child: CustomRadioTile(
                              title: caste.casteName ?? '',
                              horizontalSpacing: 27,
                              isSelected: caste.id == null
                                  ? false
                                  : caste.id == value.item2,
                            ),
                          ),
                        );
                      }, childCount: value.item1!.data!.castes!.length))
                    : const SliverToBoxAdapter(
                        child: Center(
                          child: ErrorTile(
                            errors: Errors.noDatFound,
                            enableBtn: false,
                          ),
                        ),
                      )
              ],
            );
          },
        )),
      ],
    );
  }

  void navToNext(BuildContext context, {int duration = 1000}) {
    Future.delayed(Duration(milliseconds: duration)).then((value) {
      RegistrationHandlerClass().scrollToIndex(index: 7, context: context);
    });
  }
}
