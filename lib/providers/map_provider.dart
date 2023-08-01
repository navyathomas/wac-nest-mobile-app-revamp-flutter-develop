// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/models/geocoding_response_model.dart';
import 'package:nest_matrimony/models/place_suggestion_model.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:http/http.dart' as http;
import 'package:nest_matrimony/services/helpers.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier with BaseProviderClass {
  LatLng? currentLoc;
  List<dynamic>? placeList = [];
  List<PlaceMarkSuggestion>? placesSuggestionList = [];

  bool showLocReqBtn = true;
  bool isLocationEnabled = true;
  bool serviceEnabled = false;
  bool checkPermission = false;
  bool isFromSearch = false;
  bool cameraIdleCompleted = false;

  String locationErrMsg = '';
  Position? position;
  PlaceMarkSuggestion? selectedLoc;
  GoogleMapController? googleMapController;

  ///Used for EditContact screen to check if location is selected or not.......
  PlaceMarkSuggestion? residenceLocation;

  checkLocationPermission(BuildContext context,
      {bool requestService = false,
      bool openDeviceSetting = false,
      GoogleMapController? googleMapControllerr,
      Completer<GoogleMapController>? mapController}) async {
    updateLoaderState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic status = await Permission.location.request();
        if (status == PermissionStatus.granted) {
          showLocReqBtn = false;
          await checkServiceEnabled(context,
              requestService: requestService,
              googleMapControllerr: googleMapControllerr,
              mapController: mapController);
        } else if (status == PermissionStatus.denied) {
          showLocReqBtn = true;
          isLocationEnabled = false;
          locationErrMsg = context.loc.permissionDenied;
          updateLoaderState(LoaderState.loaded);
        } else if (status == PermissionStatus.permanentlyDenied) {
          isLocationEnabled = false;
          showLocReqBtn = true;
          locationErrMsg = context.loc.permissionDeniedPermanently;
          if (serviceEnabled || openDeviceSetting) {
            AppSettings.openDeviceSettings().then((value) {
              updateCheckPermission(true);
            });
          }
          updateLoaderState(LoaderState.loaded);
        }
      } catch (e) {
        updateLoaderState(LoaderState.loaded);
      }
    } else {
      updateLoaderState(LoaderState.loaded);
    }
  }

  Future<void> checkServiceEnabled(BuildContext context,
      {bool requestService = false,
      GoogleMapController? googleMapControllerr,
      Completer<GoogleMapController>? mapController}) async {
    updateLoaderState(LoaderState.loading);

    ///loc.Location location = loc.Location();
    final network = await Helpers.isInternetAvailable();
    final service = await Helpers.isLocationServiceEnabled();
    LocationPermission? locationPermission;
    if (network) {
      try {
        if (!service) {
          isLocationEnabled = false;
          showLocReqBtn = false;
          locationErrMsg = context.loc.serviceDisabled;
          if (requestService) {
            locationPermission = await Geolocator.requestPermission();

            if (locationPermission == LocationPermission.denied) {
              isLocationEnabled = false;
              showLocReqBtn = false;
              locationErrMsg = context.loc.serviceDisabled;
            } else {
              isLocationEnabled = true;
              serviceEnabled = true;
              await getCurrentLocation(
                  googleMapController: googleMapControllerr,
                  mapController: mapController);
            }
          }
          updateLoaderState(LoaderState.loaded);
        } else {
          isLocationEnabled = true;
          serviceEnabled = requestService;
          await getCurrentLocation(
              googleMapController: googleMapControllerr,
              mapController: mapController);
          updateLoaderState(LoaderState.loaded);
        }
      } catch (e) {
        updateLoaderState(LoaderState.loaded);
      }
    } else {
      updateLoaderState(LoaderState.loaded);
    }
  }

  getCurrentLocation(
      {GoogleMapController? googleMapController,
      Completer<GoogleMapController>? mapController}) async {
    updateLoaderState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        if (position != null) {
          showLocReqBtn = false;
          isLocationEnabled = true;
          if (!isFromSearch) {
            currentLoc = LatLng(position?.latitude ?? Constants.lat,
                position?.longitude ?? Constants.lng);
          }
          await animateMapToLocation(mapController, googleMapController);
        }
        updateLoaderState(LoaderState.loaded);
      } catch (e) {
        debugPrint('getLocationError $e');
        updateLoaderState(LoaderState.loaded);
      }
    } else {
      updateLoaderState(LoaderState.loaded);
    }
  }

  animateMapToLocation(Completer<GoogleMapController>? mapController,
      GoogleMapController? _googleMapController) async {
    if (_googleMapController != null) {
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLoc?.latitude ?? Constants.lat,
              currentLoc?.longitude ?? Constants.lng),
          zoom: 17.0,
        ),
      ));
    }
    if (mapController != null) {
      GoogleMapController _controller = await mapController.future;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLoc?.latitude ?? Constants.lat,
                currentLoc?.longitude ?? Constants.lng),
            zoom: 17.0,
          ),
        ),
      );
    }
    googleMapController = _googleMapController;
    notifyListeners();
  }

  /// Update location OnCameraMoved .............................
  Future<void> updateLocation(double updatedLatitude, double updatedLongitude,
      {bool isButtonClicked = false}) async {
    updateLoaderState(LoaderState.loading);
    try {
      String request =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$updatedLatitude,$updatedLongitude&key=${AppConfig.mapApiKey}';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        GeocoderResModel geocoderResModel =
            GeocoderResModel.fromJson(json.decode(response.body));
        if (geocoderResModel.results != null &&
            geocoderResModel.results!.isNotEmpty) {
          await setUpdateCurrentLocation(
              geocoderResModel.results?[0].addressComponents ?? [],
              updatedLatitude,
              updatedLongitude);
          updateLoaderState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoaderState(LoaderState.loaded);
    }
  }

  /// PlaceSearch Suggestion List ...................
  Future<void> fetchPlaceSuggestions(String placeSearchInput) async {
    updateLoaderState(LoaderState.loading);
    try {
      final request =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeSearchInput'
          '&location=${currentLoc?.latitude},${currentLoc?.longitude}&sensor=true&key=${AppConfig.mapApiKey}';

      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        placeList = await json.decode(response.body)['predictions'];
        if (placeList != null && (placeList ?? []).isNotEmpty) {
          final geoCoding = GoogleMapsGeocoding(apiKey: AppConfig.mapApiKey);
          for (int i = 0; i < placeList!.length; i++) {
            try {
              final responseee =
                  await geoCoding.searchByPlaceId(placeList?[i]['place_id']);
              if (responseee.results.isNotEmpty) {
                final distance = await calculateDistance(
                    currentLoc?.latitude ?? Constants.lat,
                    currentLoc?.longitude ?? Constants.lng,
                    responseee.results[0].geometry.location.lat,
                    responseee.results[0].geometry.location.lng);
                PlaceMarkSuggestion suggestion = PlaceMarkSuggestion(
                    placeName: placeList?[i]['description'] ?? "",
                    lat: responseee.results[0].geometry.location.lat,
                    long: responseee.results[0].geometry.location.lng,
                    locality: responseee.results[0].formattedAddress,
                    distance: distance.toString());
                placesSuggestionList?.add(suggestion);
              }
            } catch (e) {
              debugPrint('placeId Error $e');
            }
          }
          updateLoaderState(LoaderState.loaded);
        } else {
          clearPlaceSuggestions();
          updateLoaderState(LoaderState.loaded);
        }
      } else {
        updateLoaderState(LoaderState.loaded);
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      updateLoaderState(LoaderState.loaded);
    }
  }

  Future<void> setUpdateCurrentLocation(
      List<AddressComponents>? addressComponent,
      double updatedLatitude,
      double updatedLongitude) async {
    String updatedSubLocality = '';
    String updatedState = '';
    String updatedLocality = '';
    String updatedCountry = '';
    String updatedDistrict = '';

    if (addressComponent != null && addressComponent.isNotEmpty) {
      for (int i = 0; i < addressComponent.length; i++) {
        if (addressComponent[i].types != null &&
            addressComponent[i].types!.isNotEmpty) {
          List<String> types = addressComponent[i].types!;
          for (int j = 0; j < types.length; j++) {
            if (types[j].toLowerCase().trim() == "sublocality_level_1" ||
                types[j].toLowerCase().trim() == "sublocality_level_2") {
              updatedSubLocality =
                  (addressComponent[i].longName ?? '').isNotEmpty
                      ? '${addressComponent[i].longName},'
                      : '';
            }
            if (types[j].toLowerCase().trim() ==
                "administrative_area_level_1") {
              updatedState = (addressComponent[i].longName ?? '').isNotEmpty
                  ? '${addressComponent[i].longName}'
                  : '';
            }

            if (types[j].toLowerCase().trim() ==
                "administrative_area_level_3") {
              updatedDistrict = (addressComponent[i].longName ?? '').isNotEmpty
                  ? '${addressComponent[i].longName},'
                  : '';
            }

            if (types[j].toLowerCase().trim() == "locality") {
              updatedLocality = (addressComponent[i].longName ?? '').isNotEmpty
                  ? '${addressComponent[i].longName},'
                  : '';
            }

            if (types[j].toLowerCase().trim() == "country") {
              updatedCountry = addressComponent[i].longName ?? '';
            }
          }
        }
      }
      selectedLoc = PlaceMarkSuggestion(
          placeName: updatedSubLocality +
              updatedLocality +
              updatedDistrict +
              updatedState,
          lat: updatedLatitude,
          long: updatedLongitude,
          state: updatedState,
          locality: updatedLocality,
          country: updatedCountry);
      notifyListeners();
    }
  }

  calculateDistance(currentLat, currentLong, endLat, endLong) {
    return GeolocatorPlatform.instance
        .distanceBetween(currentLat, currentLong, endLat, endLong);
  }

  ///On place tapped from search suggestion list.......
  void updateSearchedLocation(PlaceMarkSuggestion? placeMarkSuggestion) {
    currentLoc = LatLng(placeMarkSuggestion?.lat ?? Constants.lat,
        placeMarkSuggestion?.long ?? Constants.lng);
    selectedLoc = placeMarkSuggestion;
    notifyListeners();
  }

  void onConfirmButtonClicked(BuildContext context) async {
    residenceLocation = selectedLoc;
    Navigator.pop(context, true);
    notifyListeners();
  }

  void updateCheckPermission(bool val) {
    checkPermission = val;
    notifyListeners();
  }

  ///Enable locate me icon if and only if camera idle completed....///
  void isCameraIdleCompleted(val) {
    cameraIdleCompleted = val;
    notifyListeners();
  }

  void clearPlaceSuggestions() {
    placeList = [];
    placesSuggestionList = [];
    notifyListeners();
  }

  void clearFromSearch(val) {
    isFromSearch = val;
    notifyListeners();
  }

  void clearData() {
    selectedLoc = null;
    currentLoc = null;
    residenceLocation = null;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
