import 'package:async/src/result/result.dart';
import 'package:flutter/material.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/views/mail_box/mail_box_interests/mail_box_interests.dart';

import '../generated/assets.dart';
import '../models/button_style_model.dart';
import '../models/custom_tab_model.dart';
import '../models/mail_box_response_model.dart';
import '../models/response_model.dart';
import '../services/http_requests.dart';
import '../utils/color_palette.dart';
import '../views/mail_box/await_alert_tile.dart';
import '../views/mail_box/mail_box_address.dart';
import '../views/mail_box/mail_box_interests/mail_box_interest_accepted.dart';
import '../views/mail_box/mail_box_interests/mail_box_interest_declined.dart';
import '../views/mail_box/mail_box_interests/mail_box_interest_received.dart';
import '../views/mail_box/mail_box_interests/mail_box_interest_sent.dart';
import '../views/mail_box/mail_box_shortlist.dart';
import '../views/mail_box/mail_box_viewed.dart';
import '../widgets/common_alert_view.dart';

class MailBoxProvider extends ChangeNotifier with BaseProviderClass {
  int selectedIndex = 0;
  int selectedChildIndex = 0;
  int tabLength = 4;
  int subTabLength = 4;
  int length = 20;
  int pageCount = 1;
  int totalPageLength = 0;
  int? totalRecords;
  int acceptedTabIndex = 0;
  int declinedTabIndex = 0;
  int subControllerIndex = 0;
  int tabControllerIndex = 0;
  int childTabControllerIndex = 0;
  int totalViewedCount = 0;
  int interestReceivedTotalRecords = 0;
  int interestReceivedTotalPageLength = 0;
  int interestSentTotalRecords = 0;
  int interestSentTotalPageLength = 0;
  int interestAcceptedTotalRecords = 0;
  int interestAcceptedTotalPageLength = 0;
  int interestAcceptedByMeTotalRecords = 0;
  int interestAcceptedByMeTotalPageLength = 0;
  int interestDeclinedTotalRecords = 0;
  int interestDeclinedTotalPageLength = 0;
  int interestDeclinedByMeTotalRecords = 0;
  int interestDeclinedByMeTotalPageLength = 0;
  int interestProfileViewedTotalRecords = 0;
  int interestProfileViewedTotalPageLength = 0;
  int interestProfileViewedByMeTotalRecords = 0;
  int interestProfileViewedByMeTotalPageLength = 0;
  int interestAddressViewedTotalRecords = 0;
  int interestAddressViewedTotalPageLength = 0;
  int interestAddressViewedByMeTotalRecords = 0;
  int interestAddressViewedBtMeTotalPageLength = 0;
  int interestShortlistViewedTotalRecords = 0;
  int interestShortlistViewedTotalPageLength = 0;
  int interestShortlistViewedByMeTotalRecords = 0;
  int interestShortlistViewedByMeTotalPageLength = 0;
  int updatePageIndex = -1;

  bool paginationLoader = false;
  bool isFromHomeScreen = false;

  List<InterestUserData> interestUserDataList = [];
  List<InterestUserData> mailBoxInterestReceivedDataList = [];
  List<InterestUserData> mailBoxInterestSentDataList = [];
  List<InterestUserData> mailBoxInterestAcceptedDataList = [];
  List<InterestUserData> mailBoxInterestAcceptedByMeDataList = [];
  List<InterestUserData> mailBoxInterestDeclinedDataList = [];
  List<InterestUserData> mailBoxInterestDeclinedByMeDataList = [];
  List<InterestUserData> mailBoxInterestProfileViewedDataList = [];
  List<InterestUserData> mailBoxInterestProfileViewedByMeDataList = [];
  List<InterestUserData> mailBoxInterestAddressViewedDataList = [];
  List<InterestUserData> mailBoxInterestAddressViewedByMeDataList = [];
  List<InterestUserData> mailBoxInterestShortListViewedDataList = [];
  List<InterestUserData> mailBoxInterestShortListViewedByMeDataList = [];

  PageController pageViewController = PageController();
  ScrollController scrollController = ScrollController();
  List<CustomTabModel> mailBoxMenuList(BuildContext context,
      {TabController? tabController}) {
    return [
      CustomTabModel(
          buttonStyleModel: ButtonStyleModel(
              title: context.loc.interests,
              icon: Assets.iconsInterestsGrey,
              gradiantColor: [HexColor('#9AA6FF'), HexColor('#344CFF')]),
          tabBarTitles: interestTabTitles(context),
          tabBarViews: mailBoxInterestsViews(),
          tabBarChild: MailBoxInterests(
            tabController: tabController,
          )),
      CustomTabModel(
          buttonStyleModel: ButtonStyleModel(
              title: context.loc.viewed,
              icon: Assets.iconsViewedWhite,
              gradiantColor: [HexColor('#A5DDFF'), HexColor('#00A7FF')]),
          tabBarTitles: viewedTabTitles(context),
          tabBarViews: mailBoxViewedViews(),
          tabBarChild: MailBoxViewed(
            tabController: tabController,
          )),
      CustomTabModel(
          buttonStyleModel: ButtonStyleModel(
              title: context.loc.address,
              icon: Assets.iconsPhoneSearch,
              gradiantColor: [HexColor('#B6EDD5'), HexColor('#00BC76')]),
          tabBarTitles: addressTabTitles(context),
          tabBarViews: mailBoxAddressViews(),
          tabBarChild: MailBoxAddress(
            tabController: tabController,
          )),
      CustomTabModel(
          buttonStyleModel: ButtonStyleModel(
              title: context.loc.shortlist,
              icon: Assets.iconsShortlistedWhite,
              gradiantColor: [HexColor('#E8D1FF'), HexColor('#8B0EF7')]),
          tabBarTitles: shortListTabTitles(context),
          tabBarViews: mailBoxShortListViews(),
          tabBarChild: MailBoxShortList(
            tabController: tabController,
          )),
    ];
  }

  List<String> interestTabTitles(BuildContext context) => [
        context.loc.received,
        context.loc.sent,
        context.loc.accepted,
        context.loc.declined
      ];

  List<String> matchesMenuTitleList(BuildContext context) => [
        context.loc.interests,
        context.loc.viewed,
        context.loc.address,
        context.loc.shortlist,
      ];

  List<Color> tabSelectedColors = [
    HexColor('#354DFF'),
    HexColor('#15A7FF'),
    HexColor('#1FBD77'),
    HexColor('#8B0EF7')
  ];

  List<String> viewedTabTitles(BuildContext context) =>
      [context.loc.whoViewedMyProfile, context.loc.viewedByMe];

  List<String> addressTabTitles(BuildContext context) =>
      [context.loc.whoViewedMyAddress, context.loc.viewedByMe];

  List<String> shortListTabTitles(BuildContext context) =>
      [context.loc.whoShortListedMyProfile, context.loc.shortListedByMe];

  List<Widget> mailBoxInterestsViews() => [
        MailBoxInterestReceived(),
        MailBoxInterestSend(),
        MailBoxInterestAccepted(),
        MailBoxInterestDeclined()
      ];

  List<Widget> mailBoxViewedViews() => [MailBoxViewed(), MailBoxViewed()];

  List<Widget> mailBoxAddressViews() => [MailBoxAddress(), MailBoxAddress()];

  List<Widget> mailBoxShortListViews() =>
      [MailBoxShortList(), MailBoxShortList()];

  void pageInit() {
    selectedIndex = 0;
    selectedChildIndex = 0;
    tabLength = 4;
    subTabLength = 4;
    notifyListeners();
  }

  void updateSelectedIndex(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  void updateSelectedChildIndex(int val) {
    selectedChildIndex = val;
    notifyListeners();
  }

  void updateSubTabControllerIndex(int val) {
    subControllerIndex = val;
    notifyListeners();
  }

  void updateTabControllerIndex(int val) {
    tabControllerIndex = val;
    notifyListeners();
  }

  void updateChildTabControllerIndex(int val) {
    childTabControllerIndex = val;
    notifyListeners();
  }

  void updatePageIndexValue(int index) {
    updatePageIndex = index;
    notifyListeners();
  }

  void updateIsFromHomeScreen(bool value) {
    isFromHomeScreen = value;
    notifyListeners();
  }

  getTabValues(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        if (mailBoxInterestReceivedDataList.isEmpty) {
          getInterestList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.received);
        }

        break;
      case 1:
        if (mailBoxInterestProfileViewedDataList.isEmpty) {
          getProfileViewedList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              profileViewedBy: ViewedBy.viewedByOthers);
        }

        break;
      case 2:
        if (mailBoxInterestAddressViewedDataList.isEmpty) {
          getAddressViewedList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              addressViewedBy: ViewedBy.viewedByOthers);
        }

        break;
      case 3:
        if (mailBoxInterestShortListViewedDataList.isEmpty) {
          getShortList(context,
              enableLoader: true,
              page: 1,
              length: 20,
              shortListedBy: ShortListedBy.shortListedByOthers);
        }
    }
  }

  Future<void> getChildTabValues(
      BuildContext context, bool enableLoader) async {
    switch (selectedIndex) {
      case 0:
        await getInterestLists(context, enableLoader);
        break;
      case 1:
        await getProfileValueLists(context, enableLoader);
        break;
      case 2:
        await getAddressValueLists(context, enableLoader);
        break;
      case 3:
        await getShortlist(context, enableLoader);
        break;
    }
  }

  loadChildTabValues(BuildContext context, bool enableLoader) {
    switch (selectedIndex) {
      case 0:
        loadInterestLists(context);
        break;
      case 1:
        loadProfileValueList(context);
        break;
      case 2:
        loadMoreAddressValueLists(context);
        break;
      case 3:
        loadMoreShortListValueLists(context);
        break;
    }
  }

  Future<void> getInterestLists(BuildContext context, bool enableLoader) async {
    switch (selectedChildIndex) {
      case 0:
        if (mailBoxInterestReceivedDataList.isEmpty) {
          await getInterestList(context,
                  enableLoader: enableLoader,
                  page: 1,
                  length: 20,
                  interestTypes: InterestTypes.received)
              .then((value) {
            if (value != null && interestUserDataList.isNotEmpty) {
              CommonAlertDialog.showDialogPopUp(
                  barrierDismissible: false,
                  context,
                  AwaitAlertDialog(
                    count: totalRecords ?? 0,
                  ));
            }
          });
        }

        break;
      case 1:
        if (mailBoxInterestSentDataList.isEmpty) {
          await getInterestList(context,
              enableLoader: enableLoader,
              page: 1,
              length: 20,
              interestTypes: InterestTypes.sent);
        }

        break;
      case 2:
        if (acceptedTabIndex == 0) {
          if (mailBoxInterestAcceptedDataList.isEmpty) {
            await getInterestList(context,
                enableLoader: enableLoader,
                page: 1,
                length: 20,
                interestTypes: InterestTypes.accepted);
          }
        } else {
          if (mailBoxInterestAcceptedByMeDataList.isEmpty) {
            await getInterestList(context,
                enableLoader: enableLoader,
                page: 1,
                length: 20,
                interestTypes: InterestTypes.acceptedByMe);
          }
        }

        break;
      case 3:
        if (declinedTabIndex == 0) {
          if (mailBoxInterestDeclinedDataList.isEmpty) {
            await getInterestList(context,
                enableLoader: enableLoader,
                page: 1,
                length: 20,
                interestTypes: InterestTypes.declined);
          }
        } else {
          if (mailBoxInterestDeclinedByMeDataList.isEmpty) {
            if (mailBoxInterestDeclinedDataList.isEmpty) {
              await getInterestList(context,
                  enableLoader: enableLoader,
                  page: 1,
                  length: 20,
                  interestTypes: InterestTypes.declinedByMe);
            }
          }
        }

        break;
    }
  }

  loadInterestLists(BuildContext context) {
    switch (selectedChildIndex) {
      case 0:
        loadMoreInterests(
            context, InterestTypes.received, interestReceivedTotalPageLength);
        break;
      case 1:
        loadMoreInterests(
            context, InterestTypes.sent, interestSentTotalPageLength);
        break;
      case 2:
        loadMoreInterests(
            context,
            acceptedTabIndex == 0
                ? InterestTypes.accepted
                : InterestTypes.acceptedByMe,
            acceptedTabIndex == 0
                ? interestAcceptedTotalPageLength
                : interestAcceptedByMeTotalPageLength);
        break;
      case 3:
        loadMoreInterests(
            context,
            declinedTabIndex == 0
                ? InterestTypes.declined
                : InterestTypes.declinedByMe,
            declinedTabIndex == 0
                ? interestDeclinedTotalPageLength
                : interestDeclinedByMeTotalPageLength);
        break;
    }
  }

  Future<void> getProfileValueLists(
      BuildContext context, bool enableLoader) async {
    if (selectedChildIndex == 0) {
      if (mailBoxInterestProfileViewedDataList.isEmpty) {
        await getProfileViewedList(context,
            enableLoader: enableLoader,
            page: 1,
            length: 20,
            profileViewedBy: ViewedBy.viewedByOthers);
      }
    } else {
      if (mailBoxInterestProfileViewedByMeDataList.isEmpty) {
        await getProfileViewedList(context,
            enableLoader: enableLoader,
            page: 1,
            length: 20,
            profileViewedBy: ViewedBy.viewedByMe);
      }
    }
  }

  loadProfileValueList(BuildContext context) {
    loadMoreProfile(
        context,
        selectedChildIndex == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe,
        selectedChildIndex == 0
            ? interestProfileViewedTotalPageLength
            : interestProfileViewedByMeTotalPageLength);
  }

  Future<void> getAddressValueLists(
      BuildContext context, bool enableLoader) async {
    if (selectedChildIndex == 0) {
      if (mailBoxInterestAddressViewedDataList.isEmpty) {
        await getAddressViewedList(context,
            enableLoader: enableLoader,
            page: 1,
            length: 20,
            addressViewedBy: ViewedBy.viewedByOthers);
      }
    } else {
      if (mailBoxInterestAddressViewedByMeDataList.isEmpty) {
        await getAddressViewedList(context,
            enableLoader: enableLoader,
            page: 1,
            length: 20,
            addressViewedBy: ViewedBy.viewedByMe);
      }
    }
  }

  loadMoreAddressValueLists(BuildContext context) {
    loadMoreAddress(
        context,
        selectedChildIndex == 0 ? ViewedBy.viewedByOthers : ViewedBy.viewedByMe,
        selectedChildIndex == 0
            ? interestAddressViewedTotalPageLength
            : interestAddressViewedBtMeTotalPageLength);
  }

  Future<void> getShortlist(
    BuildContext context,
    bool enableLoader,
  ) async {
    if (selectedChildIndex == 0) {
      if (mailBoxInterestShortListViewedDataList.isEmpty) {
        await getShortList(context,
            enableLoader: enableLoader,
            shortListedBy: ShortListedBy.shortListedByOthers);
      }
    } else {
      if (mailBoxInterestShortListViewedByMeDataList.isEmpty) {
        await getShortList(context,
            enableLoader: enableLoader,
            shortListedBy: ShortListedBy.shortListedByMe);
      }
    }
  }

  loadMoreShortListValueLists(BuildContext context) {
    loadMoreShortList(
        context,
        selectedChildIndex == 0
            ? ShortListedBy.shortListedByOthers
            : ShortListedBy.shortListedByMe,
        selectedChildIndex == 0
            ? interestShortlistViewedTotalPageLength
            : interestShortlistViewedByMeTotalPageLength);
  }

  Future<InterestResponseModel?> getInterestList(BuildContext context,
      {int? page,
      int? length,
      required bool enableLoader,
      required InterestTypes interestTypes}) async {
    InterestResponseModel? interestResponseModel;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getInterestList(
        page ?? 1, length ?? 20, interestTypes);
    if (res.isValue) {
      interestResponseModel = res.asValue?.value;
      updateUserDataList(interestResponseModel);

      paginationLoader = false;
    } else {
      updateLoaderState(fetchError(res.asError?.error as Exceptions));
      paginationLoader = false;
      // Helpers.successToast(context.loc.anErrorOccurred);
    }

    notifyListeners();
    return interestResponseModel;
  }

  Future<InterestResponseModel?> loadMoreInterests(
      BuildContext context, InterestTypes interestTypes, int pageLength) async {
    InterestResponseModel? interestResponseModel;
    if (pageLength >= pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      interestResponseModel = await getInterestList(context,
          enableLoader: false,
          page: pageCount,
          length: length,
          interestTypes: interestTypes);
    }
    notifyListeners();
    return interestResponseModel;
  }

  Future<void> updateUserDataList(
      InterestResponseModel? interestResponseModel) async {
    if (pageCount == 1) {
      switch (selectedIndex) {
        case 0:
          switch (selectedChildIndex) {
            case 0:
              mailBoxInterestReceivedDataList = [];
              mailBoxInterestReceivedDataList =
                  interestResponseModel?.datas?.original?.datas ?? [];
              interestReceivedTotalRecords =
                  interestResponseModel?.datas?.original?.recordsTotal ?? 0;
              interestReceivedTotalPageLength =
                  ((interestResponseModel?.datas?.original?.recordsTotal ??
                              20) /
                          20)
                      .ceil();
              break;
            case 1:
              mailBoxInterestSentDataList = [];
              mailBoxInterestSentDataList =
                  interestResponseModel?.datas?.original?.datas ?? [];
              interestSentTotalRecords =
                  interestResponseModel?.datas?.original?.recordsTotal ?? 0;
              interestSentTotalPageLength =
                  ((interestResponseModel?.datas?.original?.recordsTotal ??
                              20) /
                          20)
                      .ceil();
              break;
            case 2:
              if (acceptedTabIndex == 0) {
                mailBoxInterestAcceptedDataList = [];
                mailBoxInterestAcceptedDataList =
                    interestResponseModel?.datas?.original?.datas ?? [];
                interestAcceptedTotalRecords =
                    interestResponseModel?.datas?.original?.recordsTotal ?? 0;
                interestAcceptedTotalPageLength =
                    ((interestResponseModel?.datas?.original?.recordsTotal ??
                                20) /
                            20)
                        .ceil();
              } else {
                mailBoxInterestAcceptedByMeDataList = [];
                mailBoxInterestAcceptedByMeDataList =
                    interestResponseModel?.datas?.original?.datas ?? [];
                interestAcceptedByMeTotalRecords =
                    interestResponseModel?.datas?.original?.recordsTotal ?? 0;
                interestAcceptedByMeTotalPageLength =
                    ((interestResponseModel?.datas?.original?.recordsTotal ??
                                20) /
                            20)
                        .ceil();
              }
              break;
            case 3:
              if (declinedTabIndex == 0) {
                mailBoxInterestDeclinedDataList = [];
                mailBoxInterestDeclinedDataList =
                    interestResponseModel?.datas?.original?.datas ?? [];
                interestDeclinedTotalRecords =
                    interestResponseModel?.datas?.original?.recordsTotal ?? 0;
                interestDeclinedTotalPageLength =
                    ((interestResponseModel?.datas?.original?.recordsTotal ??
                                20) /
                            20)
                        .ceil();
              } else {
                mailBoxInterestDeclinedByMeDataList = [];
                mailBoxInterestDeclinedByMeDataList =
                    interestResponseModel?.datas?.original?.datas ?? [];
                interestDeclinedByMeTotalRecords =
                    interestResponseModel?.datas?.original?.recordsTotal ?? 0;
                interestDeclinedByMeTotalPageLength =
                    ((interestResponseModel?.datas?.original?.recordsTotal ??
                                20) /
                            20)
                        .ceil();
              }
          }
          break;
        case 1:
          if (selectedChildIndex == 0) {
            mailBoxInterestProfileViewedDataList = [];
            mailBoxInterestProfileViewedDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestProfileViewedTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestProfileViewedTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          } else {
            mailBoxInterestProfileViewedByMeDataList = [];
            mailBoxInterestProfileViewedByMeDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestProfileViewedByMeTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestProfileViewedByMeTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          }
          break;
        case 2:
          if (selectedChildIndex == 0) {
            mailBoxInterestAddressViewedDataList = [];
            mailBoxInterestAddressViewedDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestAddressViewedTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestAddressViewedTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          } else {
            mailBoxInterestAddressViewedByMeDataList = [];
            mailBoxInterestAddressViewedByMeDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestAddressViewedByMeTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestAddressViewedBtMeTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          }
          break;
        case 3:
          if (selectedChildIndex == 0) {
            mailBoxInterestShortListViewedDataList = [];
            mailBoxInterestShortListViewedDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestShortlistViewedTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestShortlistViewedTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          } else {
            mailBoxInterestShortListViewedByMeDataList = [];
            mailBoxInterestShortListViewedByMeDataList =
                interestResponseModel?.datas?.original?.datas ?? [];
            interestShortlistViewedByMeTotalRecords =
                interestResponseModel?.datas?.original?.recordsTotal ?? 0;
            interestShortlistViewedByMeTotalPageLength =
                ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) /
                        20)
                    .ceil();
          }
          break;
      }
      interestUserDataList = [];
      interestUserDataList =
          interestResponseModel?.datas?.original?.datas ?? [];
      debugPrint('interest data list= ${interestUserDataList.length}');
    } else {
      switch (selectedIndex) {
        case 0:
          switch (selectedChildIndex) {
            case 0:
              List<InterestUserData> tempUserDataList = [
                ...mailBoxInterestReceivedDataList
              ];
              mailBoxInterestReceivedDataList = [
                ...tempUserDataList,
                ...interestResponseModel?.datas?.original?.datas ?? []
              ];

              break;
            case 1:
              List<InterestUserData> tempUserDataList = [
                ...mailBoxInterestSentDataList
              ];
              mailBoxInterestSentDataList = [
                ...tempUserDataList,
                ...interestResponseModel?.datas?.original?.datas ?? []
              ];

              break;
            case 2:
              if (acceptedTabIndex == 0) {
                List<InterestUserData> tempUserDataList = [
                  ...mailBoxInterestAcceptedDataList
                ];
                mailBoxInterestAcceptedDataList = [
                  ...tempUserDataList,
                  ...interestResponseModel?.datas?.original?.datas ?? []
                ];
              } else {
                List<InterestUserData> tempUserDataList = [
                  ...mailBoxInterestAcceptedByMeDataList
                ];
                mailBoxInterestAcceptedByMeDataList = [
                  ...tempUserDataList,
                  ...interestResponseModel?.datas?.original?.datas ?? []
                ];
              }
              break;
            case 3:
              if (declinedTabIndex == 0) {
                List<InterestUserData> tempUserDataList = [
                  ...mailBoxInterestDeclinedDataList
                ];
                mailBoxInterestDeclinedDataList = [
                  ...tempUserDataList,
                  ...interestResponseModel?.datas?.original?.datas ?? []
                ];
              } else {
                List<InterestUserData> tempUserDataList = [
                  ...mailBoxInterestDeclinedByMeDataList
                ];
                mailBoxInterestDeclinedByMeDataList = [
                  ...tempUserDataList,
                  ...interestResponseModel?.datas?.original?.datas ?? []
                ];
              }
          }
          break;
        case 1:
          if (selectedChildIndex == 0) {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestProfileViewedDataList
            ];
            mailBoxInterestProfileViewedDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          } else {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestProfileViewedByMeDataList
            ];
            mailBoxInterestProfileViewedByMeDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          }
          break;
        case 2:
          if (selectedChildIndex == 0) {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestAddressViewedDataList
            ];
            mailBoxInterestAddressViewedDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          } else {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestAddressViewedByMeDataList
            ];
            mailBoxInterestAddressViewedByMeDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          }
          break;
        case 3:
          if (selectedChildIndex == 0) {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestShortListViewedDataList
            ];
            mailBoxInterestShortListViewedDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          } else {
            List<InterestUserData> tempUserDataList = [
              ...mailBoxInterestShortListViewedByMeDataList
            ];
            mailBoxInterestShortListViewedByMeDataList = [
              ...tempUserDataList,
              ...interestResponseModel?.datas?.original?.datas ?? []
            ];
          }
          break;
      }
      List<InterestUserData> tempUserDataList = [...interestUserDataList];
      interestUserDataList = [
        ...tempUserDataList,
        ...interestResponseModel?.datas?.original?.datas ?? []
      ];
    }
    totalRecords = interestResponseModel?.datas?.original?.recordsTotal ?? 0;
    totalPageLength =
        ((interestResponseModel?.datas?.original?.recordsTotal ?? 20) / 20)
            .ceil();

    updateLoaderState(LoaderState.loaded);
    notifyListeners();
  }

  void acceptOrDeclineInterest(
      BuildContext context, int interestId, InterestAction interestAction,
      {Function? onSuccess, Function? onFailure}) async {
    updateLoaderState(LoaderState.loading);
    Result res =
        await serviceConfig.acceptOrDeclineInterest(interestId, interestAction);
    if (res.isValue) {
      updateLoaderState(LoaderState.loaded);
      interestAction == InterestAction.accept
          ? Helpers.successToast('Interest accepted')
          : Helpers.successToast('Interest declined');
      if (onSuccess != null) onSuccess();
    } else {
      if (res.asError?.error is ResponseModel) {
        ResponseModel errorRes = res.asError?.error as ResponseModel;
        Helpers.successToast(errorRes.errors?.interestId ?? '');
        updateLoaderState(LoaderState.loaded);
        if (onFailure != null) onFailure();
      } else {
        Helpers.successToast('An error occurred');
        updateLoaderState(LoaderState.loaded);
        if (onFailure != null) onFailure();
      }
    }
  }

  Future<InterestResponseModel?> getProfileViewedList(BuildContext context,
      {int? page,
      int? length,
      required bool enableLoader,
      required ViewedBy profileViewedBy,
      Function? onSuccess,
      bool isFromHomePage = false}) async {
    InterestResponseModel? interestResponseModel;
    totalViewedCount = 0;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getProfileViewedList(
        page ?? 1, length ?? 20, profileViewedBy);
    if (res.isValue) {
      interestResponseModel = res.asValue?.value;
      if (profileViewedBy == ViewedBy.viewedByOthers) {
        totalViewedCount =
            interestResponseModel?.datas?.original?.recordsTotal ?? 0;
      }
      if (!isFromHomePage) {
        updateUserDataList(interestResponseModel);
      }

      if (enableLoader) updateLoaderState(LoaderState.loaded);
      paginationLoader = false;
    } else {
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError?.error as Exceptions));
      }
      paginationLoader = false;
      //Helpers.successToast(context.loc.anErrorOccurred);
    }
    notifyListeners();
    return interestResponseModel;
  }

  Future<InterestResponseModel?> loadMoreProfile(
      BuildContext context, ViewedBy viewedBy, int pageLength) async {
    InterestResponseModel? interestResponseModel;
    if (pageLength >= pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      interestResponseModel = await getProfileViewedList(context,
          enableLoader: false,
          page: pageCount,
          length: length,
          profileViewedBy: viewedBy);
    }
    notifyListeners();
    return interestResponseModel;
  }

  Future<InterestResponseModel?> getAddressViewedList(BuildContext context,
      {int? page,
      int? length,
      required bool enableLoader,
      required ViewedBy addressViewedBy,
      Function? onSuccess}) async {
    InterestResponseModel? interestResponseModel;
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getAddressViewedList(
        page ?? 1, length ?? 20, addressViewedBy);
    if (res.isValue) {
      InterestResponseModel interestResponseModel = res.asValue?.value;
      updateUserDataList(interestResponseModel);
      if (enableLoader) updateLoaderState(LoaderState.loaded);
      paginationLoader = false;
    } else {
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError?.error as Exceptions));
      }
      paginationLoader = false;
      //Helpers.successToast(context.loc.anErrorOccurred);
    }
    notifyListeners();
    return interestResponseModel;
  }

  void loadMoreAddress(
      BuildContext context, ViewedBy viewedBy, int pageLength) async {
    InterestResponseModel? interestResponseModel;
    if (pageLength >= pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      interestResponseModel = await getAddressViewedList(context,
          enableLoader: false,
          page: pageCount,
          length: length,
          addressViewedBy: viewedBy);
    }
    notifyListeners();
  }

  getShortList(BuildContext context,
      {int? page,
      int? length,
      required bool enableLoader,
      required ShortListedBy shortListedBy}) async {
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getShortList(
        page ?? 1, length ?? 20, shortListedBy);
    if (res.isValue) {
      InterestResponseModel interestResponseModel = res.asValue?.value;
      updateUserDataList(interestResponseModel);
      paginationLoader = false;
      if (enableLoader) updateLoaderState(LoaderState.loaded);
    } else {
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError?.error as Exceptions));
      }
      paginationLoader = false;
      // Helpers.successToast(context.loc.anErrorOccurred);
    }
    notifyListeners();
  }

  void loadMoreShortList(
      BuildContext context, ShortListedBy shortListedBy, int pageLength) async {
    InterestResponseModel? interestResponseModel;
    if (pageLength >= pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      interestResponseModel = await getShortList(context,
          enableLoader: false,
          page: pageCount,
          length: length,
          shortListedBy: shortListedBy);
    }
    notifyListeners();
  }

  void updateAcceptedTabIndex(int index) {
    acceptedTabIndex = index;
    notifyListeners();
  }

  void updateDeclinedTabIndex(int index) {
    declinedTabIndex = index;
    notifyListeners();
  }

  void clearPageLoader() {
    // updateLoaderState(LoaderState.loading);
    pageCount = 1;
    interestUserDataList = [];
    length = 20;
    notifyListeners();
  }

  void clearValues() {
    interestUserDataList.clear();
    mailBoxInterestReceivedDataList.clear();
    mailBoxInterestSentDataList.clear();
    mailBoxInterestAcceptedDataList.clear();
    mailBoxInterestAcceptedByMeDataList.clear();
    mailBoxInterestDeclinedDataList.clear();
    mailBoxInterestDeclinedByMeDataList.clear();
    mailBoxInterestProfileViewedDataList.clear();
    mailBoxInterestProfileViewedByMeDataList.clear();
    mailBoxInterestAddressViewedDataList.clear();
    mailBoxInterestAddressViewedByMeDataList.clear();
    mailBoxInterestShortListViewedDataList.clear();
    mailBoxInterestShortListViewedByMeDataList.clear();
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
