// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nest_matrimony/common/common_functions.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/generated/assets.dart';
import 'package:nest_matrimony/providers/map_provider.dart';
import 'package:nest_matrimony/providers/profile_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/utils/color_palette.dart';
import 'package:nest_matrimony/utils/font_palette.dart';
import 'package:nest_matrimony/views/error_views/loaction_error_view.dart';
import 'package:nest_matrimony/views/map_views/map_bottom_shimmer.dart';
import 'package:nest_matrimony/widgets/common_button.dart';
import 'package:nest_matrimony/widgets/reusable_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen>
    with WidgetsBindingObserver {
  int markerIdCounter = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController>? mapController = Completer();
  GoogleMapController? _googleMapController;
  LocationProvider? model;

  final Future _mapFuture =
      Future.delayed(const Duration(seconds: 2), () => true);

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$markerIdCounter';
    if (increment) markerIdCounter++;
    return val;
  }

  @override
  void initState() {
    initData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void initData() {
    CommonFunctions.afterInit(() {
      context.read<LocationProvider>().checkLocationPermission(context,
          googleMapControllerr: _googleMapController,
          mapController: mapController);
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final locationProvider = context.read<LocationProvider>();
    Permission permission = Permission.location;
    PermissionStatus status = await permission.status;
    if (state == AppLifecycleState.resumed) {
      if (status.isGranted && locationProvider.checkPermission) {
        locationProvider.updateCheckPermission(false);
        Future.microtask(() => locationProvider.checkLocationPermission(context,
            googleMapControllerr: _googleMapController,
            mapController: mapController));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: HexColor('#D9E3E3'),
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          titleSpacing: 0,
          title: Text('Confirm Residence Location',
              style: FontPalette.f131A24_16Bold),
          leading: Consumer<LocationProvider>(builder: (context, value, child) {
            return ReusableWidgets.roundedBackButton(context,
                onBackPressed: () {
              if (value.loaderState == LoaderState.loaded &&
                  (value.cameraIdleCompleted)) {
                Navigator.of(context).pop();
              } else {
                Helpers.successToast('Processing your location data...');
              }
            });
          }),
        ),
        body: FutureBuilder(
            future: _mapFuture,
            builder: (context, snapshot) {
              return Consumer<LocationProvider>(
                  builder: (context, value, child) {
                model = value;
                _googleMapController = value.googleMapController;
                return SafeArea(
                  child: value.isLocationEnabled
                      ? Stack(
                          children: [
                            (model?.currentLoc != null ||
                                        model?.loaderState ==
                                            LoaderState.loaded ||
                                        model?.selectedLoc != null) &&
                                    (model?.isLocationEnabled ?? false)
                                ? _buildMapWidget()
                                : ReusableWidgets.circularProgressIndicator(),
                            bottomContainer(snapshot.hasData, model),
                            value.loaderState == LoaderState.loading
                                ? ReusableWidgets.circularProgressIndicator()
                                : Container()
                          ],
                        )
                      : requestLocation(),
                );
              });
            }),
      ),
    );
  }

  Widget _buildMapWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: GoogleMap(
            compassEnabled: false,
            zoomControlsEnabled: false,
            onCameraIdle: onCameraIdle,
            onMapCreated: onMapCreated,
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            onCameraMove: (CameraPosition position) => onCameraMove(position),
            initialCameraPosition: CameraPosition(
              target: model?.currentLoc ??
                  const LatLng(Constants.lat, Constants.lng),
              zoom: 16.0,
            ),
          ),
        ),
        SvgPicture.asset(Assets.iconsMarkerPin, width: 40.r, height: 40.r),
      ],
    );
  }

  Widget bottomContainer(bool enableLoader, LocationProvider? model) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          model?.loaderState == LoaderState.loaded &&
                  (model?.cameraIdleCompleted ?? false) &&
                  (model?.selectedLoc != null) &&
                  enableLoader
              ? GestureDetector(
                  onTap: () {
                    Future.microtask(() => context.read<LocationProvider>()
                      ..clearData()
                      ..clearFromSearch(false)
                      ..checkLocationPermission(context,
                          googleMapControllerr: _googleMapController,
                          mapController: mapController));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Container(
                      width: 130.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.iconsGpsLocation,
                                color: Colors.black),
                            8.horizontalSpace,
                            Text(
                              context.loc.locateMe,
                              style: FontPalette.f131A24_14SemiBold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : AbsorbPointer(
                  absorbing: true, child: SizedBox(width: 150.w, height: 45.h)),
          15.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(19.r),
                  topLeft: Radius.circular(19.r)),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model?.loaderState == LoaderState.loaded &&
                          (model?.cameraIdleCompleted ?? false) &&
                          (model?.selectedLoc != null) &&
                          enableLoader
                      ? bottomContainerInnerWidgets()
                      : const MapBottomShimmer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomContainerInnerWidgets() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.residenceLocation,
            style: FontPalette.f565F6C_12SemiBold.copyWith(fontSize: 12.sp)),
        14.verticalSpace,
        selectedLocationChange(),
        23.verticalSpace,
        confirmLocationBtn(),
        6.verticalSpace,
      ],
    );
  }

  Widget selectedLocationChange() {
    return Row(
      children: [
        SvgPicture.asset(Assets.iconsCheckMarkCircle,
            width: 15.r, height: 15.r),
        10.horizontalSpace,
        Expanded(
          child: Text(model?.selectedLoc?.placeName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontPalette.f131A24_14SemiBold.copyWith(fontSize: 14.sp)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, false);
          },
          child: Container(
            alignment: Alignment.center,
            height: 30.h,
            margin: EdgeInsets.only(left: 8.w, right: 6.h),
            padding: EdgeInsets.all(2.w),
            child: Text(context.loc.change,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    FontPalette.f2995E5_14ExtraBold.copyWith(fontSize: 14.sp)),
          ),
        )
      ],
    );
  }

  Widget confirmLocationBtn() {
    final mapProvider = Provider.of<LocationProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return CommonButton(
      title: context.loc.confirmLocation,
      fontStyle: FontPalette.white16Bold.copyWith(fontSize: 16.sp),
      onPressed: () async {
        mapProvider.onConfirmButtonClicked(context);
        profileProvider.enableContactDoneButton(context);
      },
    );
  }

  Widget requestLocation() {
    return LocationErrorView(
      subTitle: context.loc.oops,
      description: model?.locationErrMsg,
      buttonText: (model?.showLocReqBtn ?? false)
          ? context.loc.requestPermission
          : context.loc.retry,
      onTap: () {
        Future.microtask(() => context
            .read<LocationProvider>()
            .checkLocationPermission(context,
                googleMapControllerr: _googleMapController,
                mapController: mapController,
                requestService: true,
                openDeviceSetting: true));
      },
    );
  }

  Future<bool> _willPopCallback() async {
    if (model?.loaderState == LoaderState.loaded &&
        (model?.cameraIdleCompleted ?? false)) {
      return true;
    } else {
      Helpers.successToast('Processing your location data...');
      return false;
    }
  }

  void onCameraIdle() {
    if (markers.isNotEmpty) {
      final marker = markers.values.toList()[0];
      CommonFunctions.afterInit(() {
        if (mounted) {
          context.read<LocationProvider>()
            ..updateLocation(
                marker.position.latitude, marker.position.longitude)
            ..isCameraIdleCompleted(true);
        }
      });
    }
  }

  void onCameraMove(CameraPosition position) {
    CommonFunctions.afterInit(() {
      context.read<LocationProvider>().isCameraIdleCompleted(false);
    });
    if (markers.isNotEmpty) {
      MarkerId? markerId = MarkerId(_markerIdVal());
      Marker? marker = markers[markerId];
      Marker updatedMarker = marker!.copyWith(
        positionParam: position.target,
      );
      if (mounted) {
        setState(() {
          markers[markerId] = updatedMarker;
        });
      }
    }
  }

  void onMapCreated(GoogleMapController googleController) async {
    _googleMapController = googleController;
    if (!mapController!.isCompleted) mapController?.complete(googleController);
    MarkerId markerId = MarkerId(_markerIdVal());
    Marker marker = Marker(
      infoWindow: const InfoWindow(
          snippet: "Please place the pin accurately on the map"),
      markerId: markerId,
      position: model?.selectedLoc != null
          ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
              model?.selectedLoc?.long ?? Constants.lng)
          : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
              model?.currentLoc?.longitude ?? Constants.lng),
      draggable: false,
    );
    markers[markerId] = marker;
    GoogleMapController controller = await mapController!.future;
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: model?.selectedLoc != null
              ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
                  model?.selectedLoc?.long ?? Constants.lng)
              : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
                  model?.currentLoc?.longitude ?? Constants.lng),
          zoom: 17.0,
        ),
      ));
    }
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: model?.selectedLoc != null
              ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
                  model?.selectedLoc?.long ?? Constants.lng)
              : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
                  model?.currentLoc?.longitude ?? Constants.lng),
          zoom: 17.0,
        ),
      ),
    );
  }
}
