import 'dart:developer' as l;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/services/instagram_services.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class InstagramPhotos extends StatefulWidget {
  final Function? onResponse;
  final List<String>? response;
  final List<String>? imagIDs;
  final bool isFromManage;
  const InstagramPhotos(
      {Key? key,
      this.response,
      this.imagIDs,
      this.onResponse,
      this.isFromManage = false})
      : super(key: key);

  @override
  State<InstagramPhotos> createState() => _InstagramPhotosState();
}

class _InstagramPhotosState extends State<InstagramPhotos>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animationPosition;
  void _slideAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationPosition = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));
    _animationController.reset();
  }

  initInstaProvider() {
    Future.microtask(() {
      context.read<InstagramServiceProvider>().initProvider();
      context.read<InstagramServiceProvider>().accessToken != null
          ? context
                  .read<InstagramServiceProvider>()
                  .imagURLs
                  .isEmpty // NOTE:  during pagination remove this condition
              ? context.read<InstagramServiceProvider>().getProfilpic(
                  context, context.read<InstagramServiceProvider>().imageId)
              : null
          : Navigator.pushNamed(context, RouteGenerator.routeInstagramPhotos,
              arguments:
                  RouteArguments(isFromMangePhotos: widget.isFromManage));
    });
  }

  @override
  void initState() {
    initInstaProvider();
    _slideAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> selected = ValueNotifier<int>(-1);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Add Photos",
            style: FontPalette.black16Bold,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: SizedBox(
                height: 9.49.h,
                width: 9.49.h,
                child: Center(child: SvgPicture.asset(Assets.iconsBlackClose))),
          ),
        ),
        body: ValueListenableBuilder<int>(
            valueListenable: selected,
            builder: (BuildContext context, int value, Widget? child) {
              return Consumer2<InstagramServiceProvider, PhotoProvider>(
                builder: (_, provider, photoProvider, __) {
                  debugPrint('provider list ${provider.userID}');
                  debugPrint('img urls list ${provider.imagURLs}');
                  debugPrint('img ids list ${provider.imagIDs}');
                  return AbsorbPointer(
                    absorbing:
                        provider.isDownloading || photoProvider.isUploading,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 39.23.h,
                          width: 39.23.h,
                          child: SvgPicture.asset(Assets.iconsAwesomeInstagram),
                        ),
                        17.63.verticalSpace,
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 1.2,
                                    mainAxisSpacing: 1,
                                    crossAxisCount: 3,
                                    childAspectRatio: 124.h / 124.h,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    ((context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (value == index) {
                                            _animationController
                                                .animateBack(0.1);
                                            selected.value = -1;
                                          } else {
                                            selected.value = index;
                                            _animationController.forward();
                                          }
                                        },
                                        child: provider.imagURLs.isEmpty
                                            ? shimmerCard()
                                            : Stack(
                                                children: [
                                                  Image.network(
                                                    provider.imagURLs[index],
                                                    fit: BoxFit.fill,
                                                  ),
                                                  Positioned(
                                                    bottom: 9.h,
                                                    right: 7.w,
                                                    child: Container(
                                                      height: 21.h,
                                                      width: 21.w,
                                                      decoration: BoxDecoration(
                                                          color: value == index
                                                              ? Colors.white
                                                              : Colors
                                                                  .transparent,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            width: 1.h,
                                                            color: Colors.white,
                                                          )),
                                                      child: value == index
                                                          ? Center(
                                                              child: Icon(
                                                                  Icons.check,
                                                                  size: 15.h,
                                                                  color: ColorPalette
                                                                      .primaryColor),
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                  )
                                                ],
                                              ),
                                      );
                                    }),
                                    childCount: provider.imagURLs.isEmpty
                                        ? 15
                                        : provider.imagURLs.length,
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: true,
                                    addSemanticIndexes: true,
                                  ),
                                ),
                                // if (isLoading)
                                //   SliverToBoxAdapter(
                                //     child: widget.progressBuilder?.call(context) ?? _defaultLoading(),
                                //   ),
                              ],
                            ),
                          ),
                        ),
                        value != -1
                            ? SlideTransition(
                                position: _animationPosition,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 14.h,
                                      left: 16.w,
                                      right: 16.w,
                                      top: 15.h),
                                  child: CommonButton(
                                    title: "Continue",
                                    isLoading: provider.isDownloading ||
                                        photoProvider.isUploading,
                                    fontStyle: FontPalette.black16Bold
                                        .copyWith(color: Colors.white),
                                    onPressed: provider.isDownloading ||
                                            photoProvider.isUploading
                                        ? null
                                        : () async {
                                            await getInstaPhotos(
                                                    context, provider,
                                                    imageId:
                                                        provider.imagIDs[value],
                                                    imageUrl: provider
                                                        .imagURLs[value])
                                                .then((value) {
                                              if (widget.isFromManage) {
                                                context
                                                    .read<PhotoProvider>()
                                                    .clearUploadAnyPhoto();
                                                  //  context
                                                  //   .read<PhotoProvider>()
                                                  //   .clear();
                                                // context
                                                //     .read<AccountProvider>()
                                                //     .clearHouseSection();

                                              
                                              }

                                              context
                                                  .read<PhotoProvider>()
                                                  .pickDownloadedPhoto(
                                                    context,
                                                    value,
                                                    isFromManage:
                                                        widget.isFromManage,
                                                  );
                                            });
                                          },
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  );
                },
              );
            }));
  }

// SHIMMER GIRD VIEW
  Widget shimmerCard() {
    return SizedBox(
      height: 124.h,
      width: 124.h,
      // color: Colors.grey,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade200,
        child: Container(
          height: 124.h,
          width: 124.h,
          color: Colors.grey,
        ),
      ),
    );
  }
//

//
  Future<String> getInstaPhotos(
      BuildContext context, InstagramServiceProvider provider,
      {String? imageUrl, required String imageId}) async {
    String imagePath = '';
    String imgID = imageId;
    String pathDir = '/storage/emulated/0/Download/$imgID.jpg';
    bool fileExist = await checkFile(pathDir);
    l.log("SELECTED PHOTO ALREADY EXIST ? $fileExist");

    if (fileExist) {
      imagePath = pathDir;
      return imagePath;
    } else {
      l.log("need to download");
      try {
        // Saved with this method.
        provider.isDownloadingStatus(true);
        var imageId = await ImageDownloader.downloadImage(imageUrl ?? "",
            destination: AndroidDestinationType.custom(directory: 'Download')
              ..subDirectory("$imgID.jpg"));
        // var imageId = await ImageDownloader.downloadImage(imageUrl ?? "");

        if (imageId == null) {
          imagePath = '';
        } else {
          provider.isDownloadingStatus(false);
        }
        // saved image information.
        var fileName = await ImageDownloader.findName(imageId!);
        var path = await ImageDownloader.findPath(imageId);
        var size = await ImageDownloader.findByteSize(imageId);
        var mimeType = await ImageDownloader.findMimeType(imageId);
        debugPrint("FILE FILE NAME :$fileName");
        debugPrint("FILE PATH :$path");
        debugPrint("FILE SIZE :$size");
        debugPrint("FILE mime Type :$mimeType");
        imagePath = path ?? '';
      } on PlatformException catch (error) {
        debugPrint(error.toString());
      }
    }

    return imagePath;
  }

// CHECK FILE EXIST
  Future<bool> checkFile(String filePath) async {
    bool status = await File(filePath).exists();
    return status;
  }
}
