import 'dart:developer';

import 'package:async/async.dart' show Result;
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/service_chat_list_response_model.dart';
import 'package:nest_matrimony/models/services_reponse_model.dart';
import 'package:nest_matrimony/models/staff_report_model.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';

import '../services/http_requests.dart';

class ServicesProvider extends ChangeNotifier with BaseProviderClass {
  List<ListData> serviceDataList = [];
  List<ServicesData> serviceDataListToday = [];
  List<ServicesData> serviceDataListThisWeek = [];
  List<ServicesData> serviceDataListOlder = [];
  List<ServiceChatData> serviceChatDataList = [];
  int pageCount = 1;
  int length = 10;
  int tabIndex = 0;
  int totalPageLength = 0;
  bool paginationLoader = false;
  bool bottomSheetLoader = false;
  bool sendMessageLoader = false;
  String message = '';
  int recordsFiltered = 0;
  updateMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  Future<void> getServices(ServiceType serviceType, bool enableLoader) async {
    if (enableLoader) updateLoaderState(LoaderState.loading);
    Result res =
        await serviceConfig.getServices(pageCount, length, serviceType);
    if (res.isValue) {
      ServicesResponseModel servicesResponseModel = res.asValue?.value;
      recordsFiltered =
          servicesResponseModel.data?.original?.recordsFiltered ?? 0;
      await updateServiceDataList(servicesResponseModel);
      paginationLoader = false;
    } else {
      paginationLoader = false;
      if (enableLoader) {
        updateLoaderState(fetchError(res.asError!.error as Exceptions));
      }
    }
    notifyListeners();
  }

  loadMore(BuildContext context, ServiceType serviceType) {
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      getServices(serviceType, false);
    }
    notifyListeners();
  }

  Future<void> updateServiceDataList(
      ServicesResponseModel servicesResponseModel) async {
    if (pageCount == 1) {
      serviceDataListToday.clear();
      serviceDataListThisWeek.clear();
      serviceDataListOlder.clear();
      serviceDataList = servicesResponseModel.data?.original?.data ?? [];
      if ((servicesResponseModel.data!.original!.data ?? []).isNotEmpty) {
        serviceDataListToday =
            servicesResponseModel.data!.original!.data![0].data ?? [];
        serviceDataListThisWeek =
            servicesResponseModel.data!.original!.data![2].data ?? [];
        serviceDataListOlder =
            servicesResponseModel.data!.original!.data![3].data ?? [];
      }
      debugPrint('service data list $serviceDataListOlder');
      if (serviceDataListThisWeek.isEmpty &&
          serviceDataListOlder.isEmpty &&
          serviceDataListToday.isEmpty) {
        updateLoaderState(LoaderState.noData);
      } else {
        updateLoaderState(LoaderState.loaded);
      }
    } else {
      List<ServicesData> tempServiceDataListToday = [...serviceDataListToday];
      List<ServicesData> tempServiceDataListThisWeek = [
        ...serviceDataListThisWeek
      ];
      List<ServicesData> tempServiceDataListOlder = [...serviceDataListOlder];
      serviceDataListToday = [
        ...tempServiceDataListToday,
        ...servicesResponseModel.data!.original!.data![0].data ?? []
      ];
      serviceDataListThisWeek = [
        ...tempServiceDataListThisWeek,
        ...servicesResponseModel.data!.original!.data![2].data ?? []
      ];
      serviceDataListOlder = [
        ...tempServiceDataListOlder,
        ...servicesResponseModel.data!.original!.data![3].data ?? []
      ];
      debugPrint('service data list load more $serviceDataListOlder');
      if (serviceDataListThisWeek.isEmpty &&
          serviceDataListOlder.isEmpty &&
          serviceDataListToday.isEmpty) {
        updateLoaderState(LoaderState.noData);
      } else {
        updateLoaderState(LoaderState.loaded);
      }
    }

    totalPageLength =
        ((servicesResponseModel.data?.original?.recordsTotal ?? 10) / 10)
            .ceil();

    notifyListeners();
  }

  // Future<void> updateServiceDataList(
  //     ServicesResponseModel servicesResponseModel) async {
  //   serviceDataListToday = [];
  //   serviceDataListThisWeek = [];
  //   serviceDataListOlder = [];
  //   if (pageCount == 1) {
  //     serviceDataList = servicesResponseModel.data?.original?.data ?? [];
  //     var todayDate = convertDate(DateTime.now());
  //     var thisWeekDate =
  //         convertDate(DateTime.now().subtract(const Duration(days: 7)));
  //     for (int i = 0; i < serviceDataList.length; i++) {
  //       var date = convertDate(serviceDataList[i].createdAt);
  //       debugPrint('normal date ${serviceDataList[i].createdAt}');
  //       debugPrint('converted date $i $date');
  //       if (date['date'] == todayDate['date'] &&
  //           date['month'] == todayDate['month'] &&
  //           date['year'] == todayDate['year']) {
  //         serviceDataListToday.add(serviceDataList[i]);
  //       } else if (date['month'] == thisWeekDate['month'] &&
  //           date['year'] == thisWeekDate['year'] &&
  //           int.parse(date['date']) >= int.parse(thisWeekDate['date'])) {
  //         serviceDataListThisWeek.add(serviceDataList[i]);
  //       } else {
  //         serviceDataListOlder.add(serviceDataList[i]);
  //       }
  //     }
  //     updateLoaderState(LoaderState.loaded);
  //   } else {
  //     List<ServicesData> tempServiceDataList = [...serviceDataList];
  //     serviceDataList = [
  //       ...tempServiceDataList,
  //       ...servicesResponseModel.data?.original?.data ?? []
  //     ];
  //     var todayDate = convertDate(DateTime.now());
  //     var thisWeekDate =
  //         convertDate(DateTime.now().subtract(const Duration(days: 7)));
  //     for (int i = 0; i < serviceDataList.length; i++) {
  //       var date = convertDate(serviceDataList[i].createdAt);
  //       debugPrint('normal date ${serviceDataList[i].createdAt}');
  //       debugPrint('converted date $i $date');
  //       if (date['date'] == todayDate['date'] &&
  //           date['month'] == todayDate['month'] &&
  //           date['year'] == todayDate['year']) {
  //         serviceDataListToday.add(serviceDataList[i]);
  //       } else if (date['month'] == thisWeekDate['month'] &&
  //           date['year'] == thisWeekDate['year'] &&
  //           date['week'] == thisWeekDate['week']) {
  //         serviceDataListThisWeek.add(serviceDataList[i]);
  //       } else {
  //         serviceDataListOlder.add(serviceDataList[i]);
  //       }
  //     }
  //     updateLoaderState(LoaderState.loaded);
  //   }
  //
  //   totalPageLength =
  //       ((servicesResponseModel.data?.original?.recordsTotal ?? 10) / 10)
  //           .ceil();
  //
  //   notifyListeners();
  // }

  Future<void> getServicesChatList(int serviceId, bool isFromChat) async {
    if (!isFromChat) bottomSheetLoader = true;
    Result res = await serviceConfig.getServiceChat(serviceId);
    if (res.isValue) {
      ServiceChatListResponseModel serviceChatListResponseModel =
          res.asValue?.value;
      serviceChatDataList = serviceChatListResponseModel.data ?? [];
      for (var i = 0; i < serviceChatDataList.length / 2; i++) {
        var temp = serviceChatDataList[i];
        serviceChatDataList[i] =
            serviceChatDataList[serviceChatDataList.length - 1 - i];
        serviceChatDataList[serviceChatDataList.length - 1 - i] = temp;
      }

      if (!isFromChat) bottomSheetLoader = false;
    } else {
      if (!isFromChat) bottomSheetLoader = false;
    }
    notifyListeners();
  }

  Future<void> sendChatMessage(Map<String, dynamic> params) async {
    sendMessageLoader = true;
    Result res = await serviceConfig.sendChatMessage(params);
    if (res.isValue) {
      getServicesChatList(params['service_id'], true);
    } else {
      sendMessageLoader = false;
    }
    notifyListeners();
  }

  convertDate(var dates) {
    var date = Jiffy(dates).format('dd');
    var month = Jiffy(dates).format('MM');
    var year = Jiffy(dates).format('yyyy');
    var week = Jiffy(dates).format('EEEE');
    Map<String, String> dateCalender = {
      'date': date,
      'month': month,
      'year': year,
      'week': week
    };
    return dateCalender;
  }

  updateTabIndex(int index) {
    tabIndex = index;
    pageCount = 1;
    notifyListeners();
  }

  @override
  void pageInit() {
    serviceDataList = [];
    serviceDataListToday = [];
    serviceDataListThisWeek = [];
    serviceDataListOlder = [];
    serviceChatDataList = [];
    pageCount = 1;
    length = 10;
    totalPageLength = 0;
    notifyListeners();
  }

  Future<void> reportStaff(String staffID, String reason) async {
    updateBtnLoader(true);
    Result res = await serviceConfig.reportStaff(staffID, reason);
    if (res.isValue) {
      StaffReportModel staffReportResponseModel = res.asValue?.value;
      log(staffReportResponseModel.data.toString());
      updateBtnLoader(false);
    } else {
      updateBtnLoader(false);
    }
    notifyListeners();
  }

  @override
  void updateBtnLoader(bool val) {
    btnLoader = val;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
