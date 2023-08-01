import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/mail_box_response_model.dart';
import 'package:nest_matrimony/models/profile_detail_default_model.dart';
import 'package:nest_matrimony/models/profile_view_model.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/daily_recommendation_provider.dart';
import 'package:nest_matrimony/providers/interest_received_provider.dart';
import 'package:nest_matrimony/providers/new_join_provider.dart';
import 'package:nest_matrimony/providers/profile_handler_provider.dart';
import 'package:nest_matrimony/providers/similar_profiles_provider.dart';
import 'package:nest_matrimony/providers/user_viewed_profie_provider.dart';
import 'package:nest_matrimony/services/widget_handler/data_collection_alert_handler.dart';
import 'package:provider/provider.dart';

import '../common/common_functions.dart';
import '../models/basic_detail_model.dart';
import '../models/partner_interest_model.dart';
import '../models/profile_search_model.dart';
import '../services/base_provider_class.dart';
import '../services/http_requests.dart';
import 'matches_provider.dart';
import 'premium_members_provider.dart';
import 'search_filter_provider.dart';
import 'top_matches_provider.dart';

enum CardStatus { interested, skip, shortListed }

class PartnerDetailProvider extends ChangeNotifier with BaseProviderClass {
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  double _angle = 0;
  List<ProfileDetailDefaultModel> _defaultProfiles = [];
  int _currentIndex = 0;
  bool hideTransform = false;
  bool hideStatusLabel = false;

  int initialProfileId = -1;

  bool addBasicDetailsAlertVisibility = true;
  bool addPhotoAlertVisibility = true;
  bool addPartnerPrefAlertVisibility = true;
  bool addProfDetailAlertVisibility = true;
  bool addAddressDetailAlertVisibility = true;

  int get currentProfileId =>
      _defaultProfiles.isEmpty ? -1 : _defaultProfiles.last.id ?? -1;

  int? interestId;

  Map<int, List<String>> grahanilaData = {};
  Map<int, List<String>> navamshakamData = {};

  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;
  int get currentIndex => _currentIndex;
  NavToProfile? navToProfile;
  List<ProfileDetailDefaultModel> get defaultProfiles => _defaultProfiles;

  PartnerDetailModel? partnerDetailModel;

  LoaderState interestLoaderState = LoaderState.loaded;
  PartnerInterestModel? partnerInterestModel;

  BasicDetail? basicDetail;

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    if (hideTransform) hideTransform = false;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    if (_defaultProfiles.length > 1) {
      _position += details.delta;

      final x = _position.dx;
      _angle = 45 * (x / _screenSize.width);
      notifyListeners();
    }
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  void endPosition(BuildContext context) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.interested:
        interestRequest(context);
        break;
      case CardStatus.skip:
        skipAction(context);
        break;
      case CardStatus.shortListed:
        shortListRequest(context);
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void shortListRequest(BuildContext context) {
    int id = _defaultProfiles.isEmpty
        ? -1
        : _defaultProfiles[_defaultProfiles.length - 1].id ?? -1;
    context.read<ProfileHandlerProvider>().shortListProfileRequest(context, id,
        onSuccess: (val) {
      if (val) {
        shortListedAction(context);
      } else {
        resetPosition();
      }
    });
  }

  void interestRequest(BuildContext context,
      {Function? onSuccess, Function? onFailure}) {
    int id = _defaultProfiles.isEmpty
        ? -1
        : _defaultProfiles[_defaultProfiles.length - 1].id ?? -1;
    context
        .read<ProfileHandlerProvider>()
        .sendInterestRequest(context, profileId: id, onSuccess: (val) {
      if (val) {
        onSuccess != null ? onSuccess() : interestedAction(context);
      } else {
        if (onFailure != null) onFailure();
        resetPosition();
      }
    });
  }

  void resetUsers() {
    navToProfile = null;
    hideTransform = false;
    hideStatusLabel = false;
    _defaultProfiles = [];
    loaderState = LoaderState.loaded;
    partnerDetailModel = null;
    partnerInterestModel = null;
    initialProfileId = -1;
    basicDetail = null;
    notifyListeners();
  }

  void resetAlertStat() {
    _currentIndex = 0;
    addBasicDetailsAlertVisibility = true;
    addPhotoAlertVisibility = true;
    addPartnerPrefAlertVisibility = true;
    addProfDetailAlertVisibility = true;
    addAddressDetailAlertVisibility = true;
    notifyListeners();
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      const delta = 100;
      if (x >= delta) {
        return CardStatus.interested;
      } else if (x <= -delta) {
        return CardStatus.skip;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.shortListed;
      } else {
        return null;
      }
    } else {
      const delta = 20;
      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.shortListed;
      } else if (x >= delta) {
        return CardStatus.interested;
      } else if (x <= -delta) {
        return CardStatus.skip;
      } else {
        return null;
      }
    }
  }

  void interestedAction(BuildContext context) async {
    if (_defaultProfiles.length > 1) {
      _angle = -20;
      _position += Offset(2 * _screenSize.width, 0);
      _nextCard(context);
      notifyListeners();
    }
  }

  void skipAction(BuildContext context) {
    if (_defaultProfiles.length > 1) {
      _angle = 20;
      _position -= Offset(2 * _screenSize.width, 0);
      notifyListeners();
      _nextCard(context);
    }
  }

  void sliderLeftCard(BuildContext context) {
    if (currentIndex > 0) {
      _angle = 0;
      _position += Offset(_screenSize.width, 0);
      hideStatusLabel = true;
      _leftCard(context);
      notifyListeners();
    }
  }

  void sliderRightCard(BuildContext context) {
    if (_defaultProfiles.length > 1) {
      _angle = 0;
      _position -= Offset(_screenSize.width, 0);
      hideStatusLabel = true;
      _rightCard(context);
      notifyListeners();
    }
  }

  void shortListedAction(BuildContext context) {
    if (_defaultProfiles.length > 1) {
      _angle = 0;
      _position -= Offset(0, _screenSize.height);
      _nextCard(context);
      notifyListeners();
    }
  }

  Future _nextCard(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _defaultProfiles.removeLast();
    _currentIndex++;
    resetPosition();
    addProfileToLast(context: context);
  }

  Future _leftCard(BuildContext context) async {
    if (_defaultProfiles.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    // _defaultProfiles.removeAt(0);
    _currentIndex--;
    resetPosition();
    hideTransform = true;
    addProfileToFirst(context: context);
    updateHideStatusLabel();
  }

  Future _rightCard(BuildContext context) async {
    if (_defaultProfiles.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    _defaultProfiles.removeLast();
    _currentIndex++;
    resetPosition();
    hideTransform = true;
    addProfileToLast(context: context);
    updateHideStatusLabel();
  }

  void updateProfileList(ProfileDetailDefaultModel profile) {
    _defaultProfiles.add(profile);
    notifyListeners();
  }

  Future<void> fetchDataFromPages(
      {required BuildContext context,
      NavToProfile? navFrom,
      int? index}) async {
    updateCurrentIndex(index);
    if (navFrom != null) {
      updateNavToProfile(navFrom);
      switch (navFrom) {
        case NavToProfile.navFromDailyRec:
          final model = context.read<DailyRecommendationProvider>();
          updateProfileFromUserData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromTopMatches:
          final model = context.read<TopMatchesProvider>();
          updateProfileFromUserData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromNewJoin:
          final model = context.read<NewJoinProvider>();
          updateProfileFromUserData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromPremiumMembers:
          final model = context.read<PremiumMembersProvider>();
          updateProfileFromUserData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromRecentlyViewed:
          final model = context.read<UserViewedProfileProvider>();
          updateProfileFromInterestData(
              context, model.interestUserDataList ?? []);
          break;
        case NavToProfile.navFromInterestRecommendations:
          final model = context.read<InterestRecievedProvider>();
          updateProfileFromInterestData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromSimilarProfiles:
          final model = context.read<SimilarProfilesProvider>();
          updateProfileFromUserData(context, model.userDataList ?? []);
          break;
        case NavToProfile.navFromSearch:
          final model = context.read<SearchFilterProvider>();
          updateProfileFromUserData(context, model.userDataList);
          break;
        case NavToProfile.navFromSearchById:
          final model = context.read<SearchFilterProvider>();
          updateProfileFromUserData(context, model.userDataList);
          break;
        case NavToProfile.navFromMatches:
          final model = context.read<MatchesProvider>();
          updateProfileFromUserData(context, model.userDataList);
          break;
        default:
          debugPrint("not in list");
      }
    }
  }

  Future<void> addProfileToLast({required BuildContext context}) async {
    if (navToProfile != null) {
      switch (navToProfile) {
        case NavToProfile.navFromDailyRec:
          updateFromDailyRecommendations(context);
          break;
        case NavToProfile.navFromTopMatches:
          updateFromTopMatches(context);
          break;
        case NavToProfile.navFromNewJoin:
          updateFromNewJoins(context);
          break;
        case NavToProfile.navFromPremiumMembers:
          updateFromPremiumMembers(context);
          break;
        case NavToProfile.navFromRecentlyViewed:
          updateFromRecentlyViewed(context);
          break;
        case NavToProfile.navFromInterestRecommendations:
          updateFromInterestRecommendations(context);
          break;
        case NavToProfile.navFromSimilarProfiles:
          updateFromSimilarProfiles(context);
          break;
        case NavToProfile.navFromSearch:
          updateFromSearch(context);
          break;
        case NavToProfile.navFromSearchById:
          updateFromSearch(context);
          break;
        case NavToProfile.navFromMatches:
          updateFromMatches(context);
          break;
        default:
          debugPrint("not in list");
      }
    }
  }

  Future<void> addProfileToFirst({required BuildContext context}) async {
    if (navToProfile != null) {
      switch (navToProfile) {
        case NavToProfile.navFromDailyRec:
          updateFromDailyRecommendations(context, addToLast: false);
          break;
        case NavToProfile.navFromTopMatches:
          updateFromTopMatches(context, addToLast: false);
          break;
        case NavToProfile.navFromNewJoin:
          updateFromNewJoins(context, addToLast: false);
          break;
        case NavToProfile.navFromPremiumMembers:
          updateFromPremiumMembers(context, addToLast: false);
          break;
        case NavToProfile.navFromRecentlyViewed:
          updateFromRecentlyViewed(context, addToLast: false);
          break;
        case NavToProfile.navFromInterestRecommendations:
          updateFromInterestRecommendations(context, addToLast: false);
          break;
        case NavToProfile.navFromSimilarProfiles:
          updateFromSimilarProfiles(context, addToLast: false);
          break;
        case NavToProfile.navFromSearch:
          updateFromSearch(context, addToLast: false);
          break;
        case NavToProfile.navFromSearchById:
          updateFromSearch(context, addToLast: false);
          break;
        case NavToProfile.navFromMatches:
          updateFromMatches(context, addToLast: false);
          break;
        default:
          debugPrint("not in list");
      }
    }
  }

  void updateCurrentIndex(int? index) {
    if (index != null) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void updateNavToProfile(NavToProfile? navFrom) {
    navToProfile = navFrom;
    notifyListeners();
  }

  void updateHideTransform({bool val = false}) {
    hideTransform = val;
    notifyListeners();
  }

  void updateHideStatusLabel() {
    if (hideStatusLabel) {
      hideStatusLabel = false;
      notifyListeners();
    }
  }

  /// fetch partner details using profile id

  Future<void> getPartnerDetailData(BuildContext context, {int? userId}) async {
    updatePartnerDetailModel(null);
    updateLoaderState(LoaderState.loading);
    int? id = _defaultProfiles.isEmpty
        ? null
        : _defaultProfiles[_defaultProfiles.length - 1].id ?? -1;
    if (userId != null) {
      Result res = await serviceConfig.getPartnerDetailsData(userId);
      if (res.isValue) {
        PartnerDetailModel model = res.asValue!.value;
        await Future.microtask(
            () async => context.read<SimilarProfilesProvider>()
              ..pageInit()
              ..getSimilarProfiles(model.data?.basicDetails?.id ?? -1));
        updatePartnerDetailModel(model);
        updateLoaderState(LoaderState.loaded);
      } else {
        updatePartnerDetailModel(null);
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      }
    } else if (id != null) {
      Result res = await serviceConfig.getPartnerDetailsData(id);
      if (res.isValue) {
        PartnerDetailModel model = res.asValue?.value;
        await Future.microtask(
            () async => context.read<SimilarProfilesProvider>()
              ..pageInit()
              ..getSimilarProfiles(model.data?.basicDetails?.id ?? -1));
        updatePartnerDetailModel(model);
        updateLoaderState(LoaderState.loaded);
      } else {
        updatePartnerDetailModel(null);
        updateLoaderState(fetchError(res.asError?.error as Exceptions));
      }
    }
  }

  ///sent profile view stat-----------------------------------------------------

  Future<void> profileViewed() async {
    //ToDo: need to check
    int id = _defaultProfiles.isEmpty
        ? -1
        : _defaultProfiles[_defaultProfiles.length - 1].id ?? -1;
    Result res = await serviceConfig.profileViewed(id);
    if (res.isValue) {}
  }

  ///update from other providers -----------------------------------------------

  void updateFromDailyRecommendations(BuildContext context,
      {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<DailyRecommendationProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromTopMatches(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<TopMatchesProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromNewJoins(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<NewJoinProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromPremiumMembers(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<PremiumMembersProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromRecentlyViewed(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<UserViewedProfileProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.interestUserDataList?.length ?? 0)) {
        _addToFirstInterestDataList(context, model.interestUserDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.interestUserDataList?.length ?? 0)) {
              _addToFirstInterestDataList(context, model.interestUserDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.interestUserDataList?.length ?? 0)) {
        _addToLastInterestDataList(context, model.interestUserDataList);
      }
    }
  }

  void updateFromInterestRecommendations(BuildContext context,
      {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<InterestRecievedProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstInterestDataList(context, model.userDataList);
      } else {
        model.onLoadMore().then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstInterestDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastInterestDataList(context, model.userDataList);
      }
    }
  }

  void updateFromSearch(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<SearchFilterProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList.length)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model
            .loadMore(context,
                fromSearchById: navToProfile == NavToProfile.navFromSearchById)
            .then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList.length)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 && _currentIndex <= (model.userDataList.length)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromSimilarProfiles(BuildContext context,
      {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<SimilarProfilesProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        model
            .onLoadMore(partnerDetailModel?.data?.basicDetails?.id ?? -1)
            .then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList?.length ?? 0)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 &&
          _currentIndex <= (model.userDataList?.length ?? 0)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  void updateFromMatches(BuildContext context, {bool addToLast = true}) {
    updateLoaderState(LoaderState.loading);
    final model = context.read<MatchesProvider>();
    if (addToLast) {
      if (_currentIndex + 2 < (model.userDataList.length)) {
        _addToFirstUserDataList(context, model.userDataList);
      } else {
        matchesLoadMore(model, context).then((value) {
          if (value != null) {
            if (_currentIndex + 2 < (model.userDataList.length)) {
              _addToFirstUserDataList(context, model.userDataList);
            }
          } else {
            getPartnerDetailData(context);
          }
        });
      }
    } else {
      if (_currentIndex != -1 && _currentIndex <= (model.userDataList.length)) {
        _addToLastUserDataList(context, model.userDataList);
      }
    }
  }

  Future<void> updateProfileFromUserData(
      BuildContext context, List<UserData> usersData) async {
    int length = usersData.length > _currentIndex + 3
        ? _currentIndex + 3
        : usersData.length;
    Iterable<UserData> users =
        [...usersData.getRange((_currentIndex), length)].reversed;
    for (var data in users) {
      updateProfileList(ProfileDetailDefaultModel(
          id: data.id,
          userName: data.name,
          isMale: data.isMale,
          userImage: data.userImage,
          nestId: data.registerId,
          age: data.age));
    }
    getPartnerDetailData(context);
    if (users.isNotEmpty) updateInitialProfileId(users.last.id ?? -1);
  }

  ///---------------------------------------------------------------------------

  Future<void> updateProfileForSingleData(BuildContext context,
      ProfileDetailDefaultModel profileDetailModel) async {
    updateProfileList(profileDetailModel);
    getPartnerDetailData(context);
    updateInitialProfileId(profileDetailModel.id ?? -1);
  }

  void _addToFirstUserDataList(BuildContext context, List<UserData>? userData) {
    UserData? data = userData?[_currentIndex + 2];
    hideTransform = true;
    _defaultProfiles.insert(
        0,
        ProfileDetailDefaultModel(
            id: data?.id,
            userName: data?.name,
            isMale: data?.isMale,
            userImage: data?.userImage,
            nestId: data?.registerId,
            age: data?.age));
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 350))
        .then((value) => updateHideTransform());
    getPartnerDetailData(context);
  }

  void _addToLastUserDataList(BuildContext context, List<UserData>? userData) {
    UserData? data = userData?[_currentIndex];
    if (_defaultProfiles.length > 2) _defaultProfiles.removeAt(0);
    _defaultProfiles = [
      ..._defaultProfiles,
      ProfileDetailDefaultModel(
          id: data?.id,
          userName: data?.name,
          isMale: data?.isMale,
          userImage: data?.userImage,
          nestId: data?.registerId,
          age: data?.age)
    ];
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 350))
        .then((value) => updateHideTransform());
    getPartnerDetailData(context);
  }

  ///InterestData-------------------------------------------------------------
  Future<void> updateProfileFromInterestData(
      BuildContext context, List<InterestUserData> usersData) async {
    int length = usersData.length > _currentIndex + 3
        ? _currentIndex + 3
        : usersData.length;
    Iterable<InterestUserData> users =
        [...usersData.getRange((_currentIndex), length)].reversed;
    for (var data in users) {
      updateProfileList(ProfileDetailDefaultModel(
          id: data.userDetails?.id,
          userName: data.userDetails?.name,
          isMale: data.userDetails?.isMale,
          userImage: data.userDetails?.userImage,
          nestId: data.userDetails?.registerId,
          age: data.userDetails?.age));
    }
    getPartnerDetailData(context);
    if (users.isNotEmpty) updateInitialProfileId(users.last.id ?? -1);
  }

  void _addToFirstInterestDataList(
      BuildContext context, List<InterestUserData>? userData) {
    UserDetails? data = userData?[_currentIndex + 2].userDetails;
    hideTransform = true;
    _defaultProfiles.insert(
        0,
        ProfileDetailDefaultModel(
            id: data?.id,
            userName: data?.name,
            isMale: data?.isMale,
            userImage: data?.userImage,
            nestId: data?.registerId,
            age: data?.age));
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 350))
        .then((value) => updateHideTransform());
    getPartnerDetailData(context);
  }

  void _addToLastInterestDataList(
      BuildContext context, List<InterestUserData>? userData) {
    UserDetails? data = userData?[_currentIndex].userDetails;
    if (_defaultProfiles.length > 2) _defaultProfiles.removeAt(0);
    _defaultProfiles = [
      ..._defaultProfiles,
      ProfileDetailDefaultModel(
          id: data?.id,
          userName: data?.name,
          isMale: data?.isMale,
          userImage: data?.userImage,
          nestId: data?.registerId,
          age: data?.age)
    ];
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 350))
        .then((value) => updateHideTransform());
    getPartnerDetailData(context);
  }

  ///-------------------------------------------------------------------------

  void fetchGrahanilla() {
    Map<int, List<String>> tempGrahamilaData = {};
    Map<int, List<String>> tempNavamshakamData = {};
    grahanilaData = tempGrahamilaData;
    navamshakamData = tempNavamshakamData;
    if (partnerDetailModel?.data?.basicDetails?.userGrahanila != null) {
      for (var userGrahanilla
          in partnerDetailModel!.data!.basicDetails!.userGrahanila!) {
        switch (userGrahanilla.horoscopeColumnsId ?? -1) {
          case 1:
            List<String> datas = tempGrahamilaData[1] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[1] = datas;
            break;
          case 2:
            List<String> datas = tempGrahamilaData[2] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[2] = datas;
            break;
          case 3:
            List<String> datas = tempGrahamilaData[3] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[3] = datas;
            break;
          case 4:
            List<String> datas = tempGrahamilaData[4] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[4] = datas;
            break;
          case 5:
            List<String> datas = tempGrahamilaData[5] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[5] = datas;
            break;
          case 6:
            List<String> datas = tempGrahamilaData[6] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[6] = datas;
            break;
          case 7:
            List<String> datas = tempGrahamilaData[7] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[7] = datas;
            break;
          case 8:
            List<String> datas = tempGrahamilaData[8] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[8] = datas;
            break;
          case 9:
            List<String> datas = tempGrahamilaData[9] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[9] = datas;
            break;
          case 10:
            List<String> datas = tempGrahamilaData[10] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[10] = datas;
            break;
          case 11:
            List<String> datas = tempGrahamilaData[11] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[11] = datas;
            break;
          case 12:
            List<String> datas = tempGrahamilaData[12] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempGrahamilaData[12] = datas;
            break;
        }
      }

      for (var userGrahanilla
          in partnerDetailModel!.data!.basicDetails!.navamshakamList!) {
        switch (userGrahanilla.horoscopeColumnsId ?? -1) {
          case 1:
            List<String> datas = tempNavamshakamData[1] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[1] = datas;
            break;
          case 2:
            List<String> datas = tempNavamshakamData[2] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[2] = datas;
            break;
          case 3:
            List<String> datas = tempNavamshakamData[3] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[3] = datas;
            break;
          case 4:
            List<String> datas = tempNavamshakamData[4] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[4] = datas;
            break;
          case 5:
            List<String> datas = tempNavamshakamData[5] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[5] = datas;
            break;
          case 6:
            List<String> datas = tempNavamshakamData[6] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[6] = datas;
            break;
          case 7:
            List<String> datas = tempNavamshakamData[7] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[7] = datas;
            break;
          case 8:
            List<String> datas = tempNavamshakamData[8] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[8] = datas;
            break;
          case 9:
            List<String> datas = tempNavamshakamData[9] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[9] = datas;
            break;
          case 10:
            List<String> datas = tempNavamshakamData[10] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[10] = datas;
            break;
          case 11:
            List<String> datas = tempNavamshakamData[11] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[11] = datas;
            break;
          case 12:
            List<String> datas = tempNavamshakamData[12] ?? [];
            datas.add(userGrahanilla.grahasList?.grahaName ?? '');
            tempNavamshakamData[12] = datas;
            break;
        }
      }
    }
    grahanilaData = tempGrahamilaData;
    navamshakamData = tempNavamshakamData;
    notifyListeners();
  }

  /// Matches provider handler
  Future<ProfileSearchModel?> matchesLoadMore(
      MatchesProvider provider, BuildContext context) async {
    ProfileSearchModel? profileSearchModel;
    switch (provider.selectedIndex) {
      case 0:
        profileSearchModel = await provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.allMatchesNotViewed
                : MatchesTypes.allMatchesViewed,
            totalPages: provider.selectedChildIndex == 0
                ? provider.allMatchesNotViewedTotalPageLength
                : provider.allMatchesViewedTotalPageLength);
        break;
      case 1:
        profileSearchModel = await provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.topMatchesNotViewed
                : MatchesTypes.topMatchesViewed,
            totalPages: provider.selectedChildIndex == 0
                ? provider.topMatchesNotViewedTotalPageLength
                : provider.topMatchesViewedTotalPageLength);
        break;
      case 2:
        profileSearchModel = await provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.newProfileNotViewed
                : MatchesTypes.newProfileViewed,
            totalPages: provider.selectedChildIndex == 0
                ? provider.newProfilesNotViewedTotalPageLength
                : provider.newProfilesViewedTotalPageLength);
        break;
      case 3:
        profileSearchModel = await provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.premiumProfilesNotViewed
                : MatchesTypes.premiumProfilesViewed,
            totalPages: provider.selectedChildIndex == 0
                ? provider.premiumProfilesNotViewedTotalPageLength
                : provider.premiumProfilesViewedTotalPageLength);
        break;
      case 4:
        profileSearchModel = await provider.loadMore(
            context,
            provider.selectedChildIndex == 0
                ? MatchesTypes.nearByMatchesNotViewed
                : MatchesTypes.nearByMatchesViewed,
            totalPages: provider.selectedChildIndex == 0
                ? provider.nearByProfilesNotViewedTotalPageLength
                : provider.nearByProfilesViewedTotalPageLength);
        break;
    }
    return profileSearchModel;
  }

  ///Interest data ----------------------------------------------------------

  Future<void> getPartnerInterestData() async {
    updateInterestLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getPartnerInterestData();
    if (res.isValue) {
      PartnerInterestModel model = res.asValue!.value;
      updateInterestDataModel(model);
      updateInterestLoaderState(LoaderState.loaded);
    } else {
      updateInterestLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void updateInterestLoaderState(LoaderState state) {
    if (state == loaderState) return;
    loaderState = state;
    notifyListeners();
  }

  void updateInterestDataModel(PartnerInterestModel? model) {
    partnerInterestModel = model;
    notifyListeners();
  }

  void updateInterestId(int? id) {
    interestId = id;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  /// fetch current user profile data ---------------------------------------

  Future<void> getProfilePreviewData() async {
    grahanilaData.clear();
    navamshakamData.clear();
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.profileDetails(fromProfilePreview: true);
    if (res.isValue) {
      PartnerDetailModel model = res.asValue!.value;
      updatePartnerDetailModel(model);
      updateLoaderState(LoaderState.loaded);
    } else {
      updatePartnerDetailModel(null);
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
  }

  void profilePreviewInit() {
    loaderState = LoaderState.loading;
    partnerDetailModel = null;
    notifyListeners();
  }

  /// -----------------------------------------------------------------------

  void updatePartnerDetailModel(PartnerDetailModel? model) {
    partnerDetailModel = model;
    if (model != null && _defaultProfiles.isEmpty) {
      updateProfileList(ProfileDetailDefaultModel(
          id: partnerDetailModel?.data?.basicDetails?.id,
          userName: partnerDetailModel?.data?.basicDetails?.name,
          isMale: partnerDetailModel?.data?.basicDetails?.isMale,
          userImage: partnerDetailModel?.data?.basicDetails?.userImage,
          nestId: partnerDetailModel?.data?.basicDetails?.registerId,
          age: partnerDetailModel?.data?.basicDetails?.age));
    }
    notifyListeners();
    fetchGrahanilla();
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void launchWhatsapp() {
    if (partnerDetailModel?.data?.staffNumber != null) {
      String userData = basicDetail?.registerId != null
          ? ' ${basicDetail?.name} (ID:${basicDetail?.registerId})'
          : '';
      CommonFunctions.launchWhatsapp("${partnerDetailModel?.data?.staffNumber}",
          "Hi, \nI'm $userData, I would like to communicate further with ${partnerDetailModel?.data?.basicDetails?.name ?? ''} (ID: ${partnerDetailModel?.data?.basicDetails?.registerId ?? ''})");
    }
  }

  void checkBasicDetailsUpdated(BuildContext context, {Function? onSuccess}) {
    if (addBasicDetailsAlertVisibility) {
      Future.delayed(const Duration(minutes: 1)).then((value) {
        if (defaultProfiles.isNotEmpty) {
          if (initialProfileId == currentProfileId &&
              (basicDetail?.isBasicProfileUpdated ?? true) == false) {
            addPhotoAlertVisibility = false;
            notifyListeners();
            if (onSuccess != null) {
              onSuccess();
            }
          }
        }
      });
    }
  }

  void checkProfilePhotoUpdated(BuildContext context) {
    if (addPhotoAlertVisibility) {
      if ((basicDetail?.isImageUploaded ?? true) == false) {
        addPhotoAlertVisibility = false;
        notifyListeners();
        DataCollectionAlertHandler.instance.openAddPhotoAlert(context);
      }
    }
  }

  void checkPartnerDetailUpdated(BuildContext context) {
    if (addPartnerPrefAlertVisibility) {
      if ((basicDetail?.isPartnerDetailsUpdated ?? true) == false) {
        addPartnerPrefAlertVisibility = false;
        notifyListeners();
        DataCollectionAlertHandler.instance
            .openAddPartnerPreferenceAlert(context);
      } else {
        shortListRequest(context);
      }
    } else {
      shortListRequest(context);
    }
  }

  bool checkProfessionalDetailUpdated(BuildContext context) {
    bool resFlag = true;
    if (addProfDetailAlertVisibility) {
      if ((basicDetail?.isProfessionalDetailsUpdated ?? true) == false) {
        addProfDetailAlertVisibility = false;
        resFlag = false;
        notifyListeners();
      } else {
        resFlag = true;
      }
    } else {
      resFlag = true;
    }
    return resFlag;
  }

  bool checkAddressDetailUpdated(BuildContext context) {
    bool resFlag = true;
    if (addAddressDetailAlertVisibility) {
      if ((basicDetail?.isAddressDetailsUpdated ?? true) == false) {
        addAddressDetailAlertVisibility = false;
        resFlag = false;
        notifyListeners();
      } else {
        resFlag = true;
      }
    } else {
      resFlag = true;
    }
    return resFlag;
  }

  void updateBasicDetails(BuildContext cxt) {
    basicDetail = cxt.read<AppDataProvider>().basicDetailModel?.basicDetail;
    notifyListeners();
  }

  void updateInitialProfileId(int id) {
    initialProfileId = id;
    notifyListeners();
  }

  void updateFromSimilarDetails(
      {required BuildContext context,
      List<UserData>? usersData,
      int? index,
      NavToProfile? navFrom}) {
    updateCurrentIndex(index);
    if (navFrom != null) updateNavToProfile(navFrom);
    updateProfileFromUserData(context, usersData ?? []);
  }

  bool pdfLoading = false;
  void pdfLoader(bool status) {
    pdfLoading = status;
    notifyListeners();
  }

  void clearDefaultProfiles() {
    _defaultProfiles.clear();
    notifyListeners();
  }
}
