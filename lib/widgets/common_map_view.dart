import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/generated/assets.dart';

class CommonMapView extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const CommonMapView(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<CommonMapView> createState() => _CommonMapViewState();
}

class _CommonMapViewState extends State<CommonMapView> {
  GoogleMapController? mapController;
  final ValueNotifier<Map<String, Marker>> _markers = ValueNotifier({});
  String markerName = 'markerPoint';
  String? _mapStyle = '';

  late final LatLng _center;

  final Future _mapFuture =
      Future.delayed(const Duration(milliseconds: 250), () => true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mapFuture,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ClipRRect(
                borderRadius: BorderRadius.circular(7.r),
                child: ValueListenableBuilder<Map<String, Marker>>(
                    valueListenable: _markers,
                    builder: (context, value, _) {
                      return GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 16.0,
                        ),
                        markers: value.values.toSet(),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                      );
                    }),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  void initState() {
    _center = LatLng(
        widget.latitude ?? Constants.lat, widget.longitude ?? Constants.lng);
    rootBundle.loadString(Assets.jsonMapStyle).then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();
    _markers.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(Assets.iconsLocationPng, 120);
    setState(() {
      _markers.value.clear();
      final marker = Marker(
          markerId: MarkerId(markerName),
          position: _center,
          icon: BitmapDescriptor.fromBytes(markerIcon));
      _markers.value[markerName] = marker;
    });
    mapController = controller;
    mapController?.setMapStyle(_mapStyle);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
