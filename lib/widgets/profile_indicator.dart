import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/basic_detail_model.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/circle_progress.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:provider/provider.dart';

class ProfileIndicator extends StatefulWidget {
  final double percentage;
  final String? profilePhoto;
  const ProfileIndicator(
      {Key? key, this.percentage = 0.0, required this.profilePhoto})
      : super(key: key);

  @override
  State<ProfileIndicator> createState() => _ProfileIndicatorState();
}

class _ProfileIndicatorState extends State<ProfileIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  Animation<double>? animation;
  @override
  void initState() {
    progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0, end: widget.percentage)
        .animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    progressController.forward();

    Future.microtask(() {
      //  context.read<AccountProvider>().initProfileComplete();
      context.read<AccountProvider>().profilePercentage().then((v) {
        if (v != null) {
          debugPrint(v.toString());
          animation = Tween<double>(begin: 0, end: Helpers.convertToDouble(v))
              .animate(progressController);
          mounted ? progressController.forward() : null;
          setState(() {});
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(112.w, 112.h),
      painter: CircleProgress(
        animation!.value,
      ),
      child: SizedBox(
        width: 112.w,
        height: 112.h,
        child: GestureDetector(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Selector<AppDataProvider, BasicDetailModel?>(
                  selector: (context, provider) => provider.basicDetailModel,
                  builder: (context, snapshot, _) {
                    return SizedBox(
                        height: 85.r,
                        width: 85.r,
                        child: snapshot?.basicDetail?.profileImage?.imageFile !=
                                null
                            ? ProfileImageView(
                                image: (snapshot?.basicDetail?.profileImage
                                            ?.imageFile ??
                                        '')
                                    .thumbImagePath(context),
                                isMale: (snapshot?.basicDetail?.gender ?? '')
                                        .toLowerCase() ==
                                    "male",
                                isCircular: true,
                                boxFit: BoxFit.cover,
                              )
                            : ProfileImagePlaceHolder(
                                isMale: (snapshot?.basicDetail?.gender ?? '')
                                        .toLowerCase() ==
                                    "male",
                                isCircle: true,
                              ));
                  }),
            ),
            Container(
                decoration: BoxDecoration(
                    color: ColorPalette.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                height: 23.43.h,
                width: 44.25.w,
                child: Center(
                    child: Text(
                  "${animation!.value.toInt()} %",
                  style: FontPalette.black10Bold
                      .copyWith(color: Colors.white, fontSize: 12),
                ))),
          ],
        )),
      ),
    );
  }
}
