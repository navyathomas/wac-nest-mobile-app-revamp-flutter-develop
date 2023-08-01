import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/models/route_arguments.dart';
import 'package:uni_links/uni_links.dart';

import 'helpers.dart';

class UriLinkService {
  UriLinkService._privateConstructor();

  static final UriLinkService _instance = UriLinkService._privateConstructor();

  static UriLinkService get instance => _instance;

  Uri? _initialURI;
  Uri? _currentURI;
  StreamSubscription? _streamSubscription;
  bool _initialURILinkHandled = false;
  String path = 'services/uri_link_services';

  Future<void> initURIHandler(BuildContext context, bool mounted) async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      log('Invoked _initURIHandler');
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          if (!mounted) {
            return;
          }
          _initialURI = initialURI;
          navToDetails(_initialURI?.path ?? '', context);
        } else {
          log('Null Initial URI received');
        }
      } on PlatformException {
        log('Failed to receive initial uri');
      } on FormatException catch (_) {
        if (!mounted) {
          return;
        }
        log('Malformed Initial URI received');
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void incomingLinkHandler(BuildContext context, bool mounted) {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        log('Received URI: $uri');
        _currentURI = uri;
        navToDetails(_currentURI?.path ?? '', context);
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        log('Error occurred: $err');
        _currentURI = null;
      });
    }
  }

  void navToDetails(String path, BuildContext context) {
    if (path.contains('/')) {
      String id = path.split('/').last;
      Navigator.pushNamed(
          context, RouteGenerator.routePartnerSingleProfileDetail,
          arguments: RouteArguments(profileId: Helpers.convertToInt(id)));
    }
  }

  void dispose() {
    _initialURI = null;
    _currentURI = null;
    _streamSubscription?.cancel();
  }
}
