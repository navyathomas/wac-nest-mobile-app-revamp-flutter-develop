import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/religion_list_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/services/widget_handler/registration_handler_class.dart';
import 'package:nest_matrimony/utils/tuple.dart';
import 'package:nest_matrimony/views/auth_screens/registration/religion/custom_radio_tile.dart';
import 'package:nest_matrimony/views/error_views/error_tile.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../providers/registration_provider.dart';
import '../../../../utils/font_palette.dart';

class ReligionScreen extends StatelessWidget {
  const ReligionScreen({Key? key}) : super(key: key);

  Widget religionView(
      BuildContext context, ReligionListModel? religionListModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        36.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Text(
            context.loc.whatsURReligion,
            style: FontPalette.black30Bold,
          ),
        ),
        30.verticalSpace,
        Expanded(
            child: Selector<RegistrationProvider, int>(
                selector: (context, provider) => provider.selectedReligion,
                builder: (context, data, _) {
                  return ListView.builder(
                      itemCount: religionListModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        ReligionListData? religionData =
                            religionListModel?.data?[index];
                        return CustomRadioTile(
                          onTap: () {
                            context.read<RegistrationProvider>()
                              ..updateSelectedReligion(religionData?.id ?? -1)
                              ..getCasteDataList(
                                  context: context,
                                  onSuccess: () {
                                    navToNext(context);
                                  });
                          },
                          isSelected: religionData?.id == null
                              ? false
                              : religionData!.id == data,
                          title: religionData?.religionName ?? '',
                        );
                      });
                }))
      ],
    );
  }

  Widget viewSwitch(
      {required BuildContext context,
      required ReligionListModel? religionListModel,
      required LoaderState loaderState}) {
    switch (loaderState) {
      case LoaderState.loaded:
        return (religionListModel?.data ?? []).isNotEmpty
            ? religionView(context, religionListModel)
            : ErrorTile(
                errors: Errors.noDatFound,
                onTap: () => fetchData(context),
              );
      case LoaderState.loading:
        return ReusableWidgets.circularProgressIndicator();
      case LoaderState.error:
        return ErrorTile(
          errors: Errors.serverError,
          onTap: () => fetchData(context),
        );
      case LoaderState.networkErr:
        return ErrorTile(
          errors: Errors.networkError,
          onTap: () => fetchData(context),
        );
      case LoaderState.noData:
        return ErrorTile(
          errors: Errors.noDatFound,
          onTap: () => fetchData(context),
        );
      default:
        return religionView(context, religionListModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, Tuple2<ReligionListModel?, LoaderState>>(
      selector: (context, provider) =>
          Tuple2(provider.religionListModel, provider.religionListLoader),
      builder: (context, data, child) {
        return viewSwitch(
            context: context,
            religionListModel: data.item1,
            loaderState: data.item2);
      },
    );
  }

  void navToNext(BuildContext context, {int duration = 1000}) {
    Future.delayed(Duration(milliseconds: duration)).then((value) {
      RegistrationHandlerClass().scrollToIndex(index: 6, context: context);
    });
  }

  void fetchData(BuildContext context) {
    context.read<AppDataProvider>().getReligionList();
  }
}
