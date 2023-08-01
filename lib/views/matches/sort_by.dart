import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/providers/matches_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/font_palette.dart';
import '../../widgets/customRadioTile.dart';

class SortByButtonsMatches extends StatelessWidget {
  SortByButtonsMatches({Key? key, required this.sortOptions}) : super(key: key);
  List<String> sortOptions;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort by',
          style: FontPalette.white13SemiBold
              .copyWith(color: Colors.black, fontSize: 16.sp),
        ),
        ListView.builder(
          itemCount: sortOptions.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
          itemBuilder: (context, index) {
            return Selector<MatchesProvider, int>(
              selector: (context, provider) => provider.selectedSortId,
              builder: (context, value, child) {
                return CustomRadioTile(
                  horizontalPadding: 0,
                  title: sortOptions[index],
                  isSelected: (index + 1) == value,
                  onTap: () {
                    context
                        .read<MatchesProvider>()
                        .updateSelectedSortId(index + 1);
                    // if (onTap != null) onTap!();
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
