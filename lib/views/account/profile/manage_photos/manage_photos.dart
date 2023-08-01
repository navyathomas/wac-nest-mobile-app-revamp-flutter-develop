import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/extensions.dart' as exten;
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/photo_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/common_error_view.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/image_upload_bottom_tile.dart';
import 'package:nest_matrimony/widgets/profile_image_view.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class ManagePhotos extends StatefulWidget {
  final int? intialIndex;
  const ManagePhotos({Key? key, this.intialIndex}) : super(key: key);

  @override
  State<ManagePhotos> createState() => _ManagePhotosState();
}

class _ManagePhotosState extends State<ManagePhotos> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    init();

    _scrollController.addListener(() {
      final provider = context.read<AccountProvider>();
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (provider.myPhotoList?.length != provider.myPhotoCount) {
          context
              .read<AccountProvider>()
              .getMyOWnPhotos(context, enableLoader: false);
        }
      }
    });

    super.initState();
  }

  init() {
    Future.microtask(() {
      context.read<AccountProvider>().clearManagePhotoSections();
      context
          .read<AccountProvider>()
          .clearAllManagePhotoSections(); //-- added on 12/14
      context.read<AccountProvider>().clearHouseSection();
      context.read<AccountProvider>().clearIdProofSection(); //--till clearing
      context.read<AccountProvider>().getIDproofPhotos();
      context.read<AccountProvider>().getMyOWnPhotos(context);
      context.read<AccountProvider>().getMyhousePhoto();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Manage photos',
              style:
                  FontPalette.white16Bold.copyWith(color: HexColor("#131A24"))),
          elevation: 0.2,
          leading: ReusableWidgets.roundedBackButton(context),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
          actions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(
                    context, RouteGenerator.routeHidePhotos),
                icon: Icon(
                  Icons.settings,
                  color: Colors.black54,
                ))
          ],
        ),
        body: SafeArea(
          child:
              Consumer<AccountProvider>(builder: ((context, provider, child) {
            return Column(
              children: [
                Expanded(
                  child: DefaultTabController(
                      length: 3,
                      initialIndex: widget.intialIndex ?? 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 50.h,
                              child: TabBar(
                                  indicatorColor: ColorPalette.primaryColor,
                                  // Custom Indicator for TAB
                                  indicator: MD2Indicator(
                                    indicatorSize: MD2IndicatorSize.full,
                                    indicatorHeight: 2.0,
                                    indicatorColor: ColorPalette.primaryColor,
                                  ),
                                  labelStyle: FontPalette.black13SemiBold
                                      .copyWith(
                                          color: ColorPalette.primaryColor),
                                  unselectedLabelStyle: FontPalette
                                      .black13SemiBold
                                      .copyWith(color: HexColor("#565F6C")),
                                  physics: const BouncingScrollPhysics(),
                                  indicatorPadding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  labelColor: ColorPalette.primaryColor,
                                  unselectedLabelColor: HexColor("#565F6C"),
                                  tabs: [
                                    'My Photos',
                                    'ID Proof &\nReligious Spec',
                                    'My House'
                                  ]
                                      .map((e) => Tab(
                                              child: Text(
                                            e,
                                            textAlign: TextAlign.center,
                                          )))
                                      .toList()),
                            ),
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.h))),
                                  child: TabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        myPhotosView(provider: provider),
                                        iDProofView(provider: provider),
                                        myHouseView(provider: provider),
                                      ])),
                            )
                          ])),
                ),
              ],
            );
          })),
        ));
  }

// TAB = 0
  Widget myPhotosView({required AccountProvider provider}) {
    return Consumer2<AccountProvider, PhotoProvider>(
        builder: (_, pro, photoProvider, __) {
      photoProvider.updateImageCategoryType(id: "");
      return AbsorbPointer(
        absorbing: pro.btnLoader || photoProvider.isUploading,
        child: Stack(
          children: [
            Column(children: [
              // hidePhotoSection(
              //     provider: pro,
              //     status: pro.toogleSwitchStatus[0]!,
              //     onChanged: () {
              //       pro.updateSwitchStatus(0);
              //     }),
              _photoGridbuild(
                primaryIndex: 0,
              ),
              photoProvider.isUploading
                  ? progressIndicator(
                      progressPercentage:
                          photoProvider.progressPercentage.toDouble())
                  : const SizedBox.shrink(),
              Text(
                "Photo will be visible to other users only\nafter the admins approval.",
                style: FontPalette.black12Medium
                    .copyWith(color: HexColor("#565F6C")),
                textAlign: TextAlign.center,
              ),
              19.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CommonButton(
                  onPressed: () => addPhotos(),
                  title: "Add photos",
                ),
              ),
              14.verticalSpace,
            ]),
            !provider.firstLoad
                ? ReusableWidgets.circularIndicator()
                : (pro.myPhotoLoader || photoProvider.isUploading)
                    ? ReusableWidgets.circularIndicator()
                    : const SizedBox()
          ],
        ),
      );
    });
  }

// TAB = 1
  Widget iDProofView({required AccountProvider provider}) {
    return Consumer2<AccountProvider, PhotoProvider>(
        builder: (_, pro, photoProvider, __) {
      photoProvider.updateImageCategoryType(id: "3");
      return AbsorbPointer(
        absorbing: pro.btnLoader || photoProvider.uploadButtonLoading,
        child: Stack(
          children: [
            Column(
              children: [
                // hidePhotoSection(
                //     provider: provider,
                //     status: provider.toogleSwitchStatus[1]!,
                //     onChanged: () => provider.updateSwitchStatus(1)),
                _photoGrid2build(
                  primaryIndex: 1,
                ),
                photoProvider.uploadButtonLoading
                    ? progressIndicator(
                        progressPercentage:
                            photoProvider.progressPercentage.toDouble())
                    : const SizedBox.shrink(),
                Text(
                  "Photo will be visible to other users only\nafter the admins approval.",
                  style: FontPalette.black12Medium
                      .copyWith(color: HexColor("#565F6C")),
                  textAlign: TextAlign.center,
                ),
                19.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CommonButton(
                    onPressed: () => addPhotos(),
                    title: "Add photos",
                  ),
                ),
                14.verticalSpace,
              ],
            ),
            (pro.btnLoader || photoProvider.uploadButtonLoading)
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox()
          ],
        ),
      );
    });
  }

// TAB = 2
  Widget myHouseView({required AccountProvider provider}) {
    return Consumer2<AccountProvider, PhotoProvider>(
        builder: (_, pro, photoProvider, __) {
      photoProvider.updateImageCategoryType(id: "2");
      return AbsorbPointer(
        absorbing: pro.btnLoader || photoProvider.uploadButtonLoading,
        child: Stack(
          children: [
            Column(
              children: [
                // hidePhotoSection(
                //     provider: provider,
                //     status: provider.toogleSwitchStatus[2]!,
                //     onChanged: () => provider.updateSwitchStatus(2)),
                _photoGrid3build(
                  primaryIndex: 2,
                  // onTap: (int val) => provider.updatePrimaryIndexMap(2, val),
                ),
                photoProvider.uploadButtonLoading
                    ? progressIndicator(
                        progressPercentage:
                            photoProvider.progressPercentage.toDouble())
                    : const SizedBox.shrink(),
                Text(
                  "Photo will be visible to other users only\nafter the admins approval.",
                  style: FontPalette.black12Medium
                      .copyWith(color: HexColor("#565F6C")),
                  textAlign: TextAlign.center,
                ),
                19.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CommonButton(
                    onPressed: () => addPhotos(),
                    title: "Add photos",
                  ),
                ),
                14.verticalSpace,
              ],
            ),
            (pro.btnLoader || photoProvider.uploadButtonLoading)
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox()
          ],
        ),
      );
    });
  }

  //common widgets
  Widget _photoGridbuild(
      {
      // Function(int val) onTap,
      required int primaryIndex}) {
    return Expanded(
      child: Consumer2<AccountProvider, PhotoProvider>(
          builder: ((ctxt, provider, photoProvider, __) {
        if (provider.loaderState == LoaderState.error) {
          return const CommonErrorView(error: Errors.serverError);
        }
        return !provider.firstLoad
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.18.h),
                child: CustomScrollView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            log("my photos length : ${provider.myPhotoList?.length}");
                            if (index == provider.myPhotoList?.length) {
                              return photoUploadCard(onResponse: () {
                                print("Here---------------------");
                                Navigator.pop(context);
                                photoProvider.uploadPhotos(context,
                                    onSuccess: (val) {
                                  if (val ?? false) {
                                    Helpers.successToast(
                                        "profile Image Upload successfully");
                                    photoProvider.clearUploadAnyPhoto();
                                    context
                                        .read<AppDataProvider>()
                                        .getBasicDetails();
                                    provider.clearAllManagePhotoSections();
                                    provider.getMyOWnPhotos(ctxt);
                                  }
                                });
                              });
                            }
                            return provider.myPhotoList!.isNotEmpty
                                ? _photoCard(
                                    onTapDelete: (v) {
                                      print(v);
                                      provider.deleteMyPhoto(
                                          id: provider.myPhotoList?[index].id
                                              .toString(),
                                          onSuccess: (val) {
                                            if (val ?? false) {
                                              provider
                                                  .clearAllManagePhotoSections();
                                              provider.getMyOWnPhotos(ctxt);
                                              context
                                                  .read<AppDataProvider>()
                                                  .getBasicDetails();
                                              //
                                              provider.updatePrimaryIndexMap(0,
                                                  -1); //<-- added latestly on 1/13/2023
                                            }
                                          });
                                    },
                                    isPendingImage: (provider
                                            .myPhotoList?[index].imageApprove
                                            ?.toLowerCase() ==
                                        "pending"),
                                    // isPendingImage: index == 3 ? true : false,
                                    imgURLPath: ((provider.myPhotoList?[index]
                                                .imageFile ??
                                            "")
                                        .thumbImagePath(context)),
                                    index: index,
                                    primaySelected: index ==
                                        provider.primaryIndexMap[primaryIndex],
                                    onTap: (val) async {
                                      await provider
                                          .makePrimaryPhoto(
                                              id: ('${provider.myPhotoList?[index].id}'),
                                              onSuccess: (val) {
                                                if (val ?? false) {
                                                  context
                                                      .read<AppDataProvider>()
                                                      .getBasicDetails();
                                                }
                                              })
                                          .then((value) {
                                        provider.updatePrimaryIndexMap(0, val);
                                      });
                                    },
                                  )
                                // _photoCard(
                                //     isPendingImage: (provider
                                //                 .myPhotos
                                //                 ?.data
                                //                 ?.original
                                //                 ?.data?[index]
                                //                 .imageApprove)
                                //             ?.toLowerCase() ==
                                //         "pending",
                                //     // isPendingImage: index == 3 ? true : false,
                                //     imgURLPath: provider.profileImages[index],
                                //     index: index,
                                //     primaySelected: index ==
                                //         provider.primaryIndexMap[primaryIndex],
                                //     onTap: (val) async {
                                //       await provider
                                //           .makePrimaryPhoto(
                                //               id:
                                //                   ('${provider.myPhotos?.data?.original?.data?[index].id}'))
                                //           .then((value) => provider
                                //               .updatePrimaryIndexMap(0, val));
                                //     },
                                //   )
                                : const SizedBox();
                          },
                          childCount: provider.myPhotoList!.length + 1,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 13.h,
                            mainAxisExtent: 155.h,
                            mainAxisSpacing: 13.h,
                            crossAxisCount: 3),
                      ),
                    ),
                    //  if (provider.myPhotoList!.isEmpty)
                    if (provider.myPhotoCount != null &&
                        provider.myPhotoList?.length != provider.myPhotoCount)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Center(
                              child: SizedBox(
                                  height: 25.w,
                                  width: 25.w,
                                  child: const CircularProgressIndicator())),
                        ),
                      )
                  ],
                ),
              );
      })),
    );
  }

  //common widgets TAB 2
  Widget _photoGrid2build(
      {
      // Function(int val) onTap,
      required int primaryIndex}) {
    return Expanded(
      child: Consumer2<AccountProvider, PhotoProvider>(
          builder: ((ctxt, provider, photoProvider, __) {
        if (provider.loaderState == LoaderState.error) {
          return const CommonErrorView(error: Errors.serverError);
        }
        return
            // provider.loaderState == LoaderState.loading
            //     ? const Center(child: CircularProgressIndicator())
            //     :

            Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.18.h),
          child: CustomScrollView(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      log("my id proof photos length : ${provider.idProofPhoto?.length}");
                      if (index == provider.idProofPhoto?.length) {
                        return photoUploadCard(onResponse: () {
                          print("Here 2---------------------");
                          Navigator.pop(context);
                          photoProvider
                              .uploadAnyPhotos(
                                  imageType: "3",
                                  isFeatured: "0",
                                  filesList: photoProvider.croppedFileList,
                                  onSuccess: (val) {
                                    if (val ?? false) {
                                      context
                                          .read<AppDataProvider>()
                                          .getBasicDetails();
                                    }
                                  })
                              .then((value) {
                            photoProvider.clearUploadAnyPhoto();
                            provider.clearIdProofSection();
                            provider.getIDproofPhotos();
                          });
                          // photoProvider.uploadPhotos(onSuccess: () {
                          //   Helpers.successToast(
                          //       "profile Image Upload successfully");
                          //   provider.clearAllManagePhotoSections();
                          //   // provider.clearManagePhotoSections();
                          //   provider.getMyOWnPhotos(ctxt);
                          // });
                        });
                      }
                      return provider.idProofPhoto!.isNotEmpty
                          ? _photoCard(
                              onTapDelete: (v) {
                                provider.deleteCategoryImages(
                                    id: provider.idProofPhoto?[index].id
                                        .toString(),
                                    onSuccess: () {
                                      provider.clearIdProofSection();

                                      provider.getIDproofPhotos();
                                    });
                              },
                              imgURLPath: ((provider
                                          .idProofPhoto?[index].userImagePath ??
                                      "")
                                  .idProofImagePath(context)),
                              index: index,
                              onTap: (val) async {},
                            )
                          : const SizedBox();
                    },
                    childCount: provider.idProofPhoto!.length + 1,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 13.h,
                      mainAxisExtent: 155.h,
                      mainAxisSpacing: 13.h,
                      crossAxisCount: 3),
                ),
              ),
              // if (provider.myPhotoCount != null &&
              //     provider.myPhotoList?.length != provider.myPhotoCount)
              //   SliverToBoxAdapter(
              //     child: Padding(
              //       padding: EdgeInsets.all(10.r),
              //       child: Center(
              //           child: SizedBox(
              //               height: 25.w,
              //               width: 25.w,
              //               child: const CircularProgressIndicator())),
              //     ),
              //   )
            ],
          ),
        );
      })),
    );
  }

  //common widgets TAB 3
  Widget _photoGrid3build(
      {
      // Function(int val) onTap,
      required int primaryIndex}) {
    return Expanded(
      child: Consumer2<AccountProvider, PhotoProvider>(
          builder: ((ctxt, provider, photoProvider, __) {
        if (provider.loaderState == LoaderState.error) {
          return const CommonErrorView(error: Errors.serverError);
        }
        return
            //  provider.loaderState == LoaderState.loading
            //     ? const Center(child: CircularProgressIndicator())
            //     :

            Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.18.h),
          child: CustomScrollView(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      log("my house photos length : ${provider.myhousePhoto?.length}");
                      if (index == provider.myhousePhoto?.length) {
                        return photoUploadCard(onResponse: () {
                          print("Here 3---------------------");
                          Navigator.pop(context);
                          photoProvider
                              .uploadAnyPhotos(
                                  imageType: "2",
                                  isFeatured: "0",
                                  filesList: photoProvider.croppedFileList)
                              .then((value) {
                            photoProvider.clearUploadAnyPhoto();
                            provider.clearHouseSection();
                            provider.getMyhousePhoto();
                          });
                        });
                      }
                      return provider.myhousePhoto!.isNotEmpty
                          ? _photoCard(
                              onTapDelete: (v) {
                                provider.deleteCategoryImages(
                                    id: provider.myhousePhoto?[index].id
                                        .toString(),
                                    onSuccess: () {
                                      provider.clearHouseSection();
                                      provider.getMyhousePhoto();
                                    });
                              },
                              imgURLPath: ((provider
                                          .myhousePhoto?[index].userImagePath ??
                                      "")
                                  .houseImagePath(context)),
                              index: index,
                              onTap: (val) async {},
                            )
                          : const SizedBox();
                    },
                    childCount: provider.myhousePhoto!.length + 1,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 13.h,
                      mainAxisExtent: 155.h,
                      mainAxisSpacing: 13.h,
                      crossAxisCount: 3),
                ),
              ),
            ],
          ),
        );
      })),
    );
  }

  Widget _photoCard(
      {var imgURLPath,
      required int index,
      bool primaySelected = false,
      required Function(int val) onTap,
      required Function(int val) onTapDelete,
      bool removeWhiteCircle = false,
      bool isPendingImage = false}) {
    return isPendingImage
        ? GestureDetector(
            // onTap: () => onTap(index),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.dstATop),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: ProfileImageView(
                      image: imgURLPath,
                      // fit: BoxFit.cover,
                      height: 155.h,
                      width: 105.w,
                    ),
                  ),
                ),
                Container(
                  // height: 18.h,
                  height: 30.h,
                  // width: 75.w,
                  width: 93.w,
                  padding: EdgeInsets.only(
                      left: 5.w, right: 5.w, top: 1.h, bottom: 2.h),
                  margin: EdgeInsets.only(
                    bottom: 5.78.h,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      // borderRadius: BorderRadius.circular(13.r),
                      color: Colors.black54),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Pending Approval",
                      textAlign: TextAlign.center,
                      style: FontPalette.black12Medium
                          .copyWith(color: Colors.white, fontSize: 11.sp),
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () => onTap(index),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: 155.h,
                    width: 105.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11.r))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11.r),
                      child: ProfileImageView(
                        image: imgURLPath,
                        // fit: BoxFit.cover,
                      ),
                    )),
                InkWell(
                  onTap: () => onTapDelete(index),
                  // onTapDelete
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Container(
                        height: 23.w,
                        width: 23.w,
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.5, 2),
                              blurRadius: 3.0),
                        ], shape: BoxShape.circle),
                        child: SvgPicture.asset(Assets.iconsManagePhotoClose)),
                    // child: SvgPicture.asset(Assets.iconsCloseIcon)),
                  ),
                ),
                primaySelected
                    ? Positioned(
                        bottom: 5.78.h,
                        right: 5.5.w,
                        child: Container(
                          height: 30.h,
                          width: 93.w,
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                              color: HexColor("#19A065"),
                              borderRadius: BorderRadius.circular(15.r)),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 22.w,
                                    width: 22.w,
                                    child:
                                        SvgPicture.asset(Assets.iconsTickMark)),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  "Primary",
                                  style: FontPalette.black13SemiBold.copyWith(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : removeWhiteCircle
                        ? Positioned(
                            bottom: 5.78.h,
                            left: 5.5.w,
                            child: Container(
                              height: 22.h,
                              width: 22.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                            ))
                        : const SizedBox()
              ],
            ),
          );
  }

//IOS type Switcher
  Widget switchToggle({bool status = true, VoidCallback? onChanged}) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        alignment: status ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(4.h),
        height: 25.h,
        width: 46.w,
        decoration: BoxDecoration(
            color: status ? ColorPalette.primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(16.r)),
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 17.h,
          width: 17.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget photoUploadCard({Function? onResponse}) {
    return InkWell(
      onTap: () => fileUpload(context, onResponse: onResponse),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 155.h,
            // width: 96.w,
            width: 105.w,
            decoration: BoxDecoration(
                color: HexColor("#F7F7F7"),
                border: Border.all(
                  color: HexColor('#E6E6E6'),
                ),
                borderRadius: BorderRadius.all(Radius.circular(11.r))),
            child: SizedBox(
                width: 27.57.w,
                height: 22.4.h,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsMetroCamera,
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.r, bottom: 1.r),
            child: SvgPicture.asset(Assets.iconsPhotoAdd),
          )
        ],
      ),
    );
  }

  Widget hidePhotoSection(
      {required AccountProvider provider,
      bool status = false,
      VoidCallback? onChanged}) {
    return Container(
      padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 18.18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hide photos",
                  style: FontPalette.black15SemiBold
                      .copyWith(color: HexColor("#131A24"))),
              Text("Hide your photos from other users",
                  style: FontPalette.black12Medium
                      .copyWith(color: HexColor("#565F6C"))),
            ],
          ),
          switchToggle(
            status: status,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  void addPhotos() {
    Navigator.pushNamed(context, RouteGenerator.routeAddPhotos);
  }

  void fileUpload(BuildContext context, {Function? onResponse}) {
    ReusableWidgets.customBottomSheet(
        context: context,
        child: ImageUploadBottomSheet(
          onResponse: onResponse,
          isFromManagePhotos: true,
        ));
  }
}

Widget progressIndicator({double? progressPercentage}) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          margin: EdgeInsets.only(
            bottom: 35..h,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          height: 30.h,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            child: LinearProgressIndicator(
              value: progressPercentage ?? 0.toDouble() / 100,
              color: Colors.grey.shade300,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 35..h,
          ),
          child: Text(
            "$progressPercentage %",
            style: FontPalette.black14Bold,
            maxLines: 1,
          ),
        )
      ],
    ),
  );
}

// Custom Indicator for TAB
enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class MD2Indicator extends Decoration {
  final double? indicatorHeight;
  final Color? indicatorColor;
  final MD2IndicatorSize? indicatorSize;

  const MD2Indicator(
      {@required this.indicatorHeight,
      @required this.indicatorColor,
      @required this.indicatorSize});

  @override
  MDPainter createBoxPainter([VoidCallback? onChanged]) {
    return MDPainter(this, onChanged!);
  }
}

class MDPainter extends BoxPainter {
  final MD2Indicator decoration;

  MDPainter(this.decoration, VoidCallback onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    Rect? rect;
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight!);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight!)) &
          Size(16, decoration.indicatorHeight ?? 3);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor ?? const Color(0xff1967d2);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect!,
            topRight: const Radius.circular(8),
            topLeft: const Radius.circular(8)),
        paint);
  }
}
