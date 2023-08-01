import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/views/search_filter/widgets/custom_option_btn.dart';
import 'package:nest_matrimony/widgets/date_picker_route.dart';
import 'package:provider/provider.dart';

class HoroscopeTimePicker extends StatelessWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;
  const HoroscopeTimePicker({Key? key, this.onSuccess, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider, String>(
      selector: (context, provider) => provider.birthTimeSelected,
      builder: (context, tuple, _) {
        return CustomOptionBtn(
          title: context.loc.birthTime,
          selectedValue: tuple,
          onTap: () {
            showCustomTimePicker(context,
                showTitleActions: true,
                onChanged: (date) {}, onConfirm: (date) {
              DateTime tempDate = DateFormat("hh:mm")
                  .parse("${date.hour}:${date.minute}:${date.second}");
              var dateFormat = DateFormat("hh:mm a");
              context.read<ProfileProvider>()
                ..updateBirthTime(dateFormat.format(tempDate))
                ..changeDoneBtnActiveState(true);
            }, currentTime: DateTime.now());
          },
        );
      },
    );
  }
}
