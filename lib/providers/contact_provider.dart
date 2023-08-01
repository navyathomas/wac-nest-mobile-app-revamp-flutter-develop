import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/branches_model.dart';
import 'package:nest_matrimony/models/policy_model.dart';
import 'package:nest_matrimony/models/response_model.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/http_requests.dart';

class ContactProvider extends ChangeNotifier with BaseProviderClass {
// static String mainBranchCode="MOC";
  static String mainBranchCode = "COR";
  BranchesModel? branchesModel;
  List<Datum>? data;
  Datum? mainBranch;

// GET BRANCHES
  getContactBranches({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.getContactBranches();
    if (res.isValue) {
      branchesModel = res.asValue!.value;
      data = branchesModel?.data ?? [];
      if (data != null) {
        data?.forEach((element) {
          if (element.branchCode == mainBranchCode) {
            mainBranch = element;
            notifyListeners();
          }
        });
      }
      log("SUCCESS : ${branchesModel?.message}");
      updateLoaderState(LoaderState.loaded);
    } else {
      if (res.asError!.error is ResponseModel) {
        ResponseModel errorRes = res.asError!.error as ResponseModel;
        log(errorRes.errors.toString());
        updateLoaderState(LoaderState.loaded);
      } else {
        debugPrint('Exceptions');
        updateLoaderState(LoaderState.error);
      }
    }
    notifyListeners();
  }

//.. make call
  Future<void> makePhoneCall({String? phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber ?? '',
    );
    await launchUrl(launchUri);
  }

// SUBMIT SUPPORT
  String fullname = "";
  String countryCode = "+91";
  String mobileNumber = "";
  String email = "";
  String message = "";
  PlatformFile? image;
  String countryFlagUrl = "";

  initSupport() {
    fullname = "";
    countryCode = "+91";
    mobileNumber = "";
    email = "";
    message = "";
    image = null;
    countryFlagUrl = "";
    notifyListeners();
  }

  updateFullname(String val) {
    fullname = val;
    debugPrint(fullname);
    notifyListeners();
  }

  updateMobile(String val) {
    mobileNumber = val;
    debugPrint(mobileNumber);
    notifyListeners();
  }

  updateEmail(String val) {
    email = val;
    debugPrint(email);
    notifyListeners();
  }

  updateMsg(String val) {
    message = val;
    debugPrint(message);
    notifyListeners();
  }

  updateContryFlag(String flagURL, String code) {
    countryFlagUrl = flagURL;
    countryCode = code;
    debugPrint(countryCode);
    notifyListeners();
  }

  updateAttachFile(PlatformFile? file) {
    image = file;

    print(image);
    notifyListeners();
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      debugPrint(file.name);
      debugPrint(file.bytes.toString());
      debugPrint(file.size.toString());
      debugPrint(file.extension);
      debugPrint(file.path);
      updateAttachFile(file);
    } else {
      image = null;
    }
  }

  support({Function? onSuccess}) async {
    var res = await submitSupport(
        onSuccess: onSuccess,
        image: image,
        fullName: fullname,
        codeCode: countryCode,
        email: email,
        msg: message,
        phNumber: mobileNumber);
  }

// test
  submitSupport(
      {String? fullName,
      String? codeCode,
      String? phNumber,
      String? email,
      PlatformFile? image,
      String? msg,
      Function? onSuccess}) async {
    var token = await SharedPreferenceHelper.getToken();
    try {
      bool networkStat = await Helpers.isInternetAvailable();
      if (!networkStat) {
        return;
      }
      updateLoaderState(LoaderState.loading);
      btnLoader = true;
      notifyListeners();
      Map<String, String> param = {
        "name": fullName ?? "",
        "country_code_id": codeCode ?? "",
        "phone": phNumber ?? "",
        "email": email ?? "",
        "message": msg ?? ""
      };
      // Map<String, String> param = {
      //   "full_name": fullName ?? "",
      //   "country_code_id": codeCode ?? "",
      //   "phone_number": phNumber ?? "",
      //   "email": email ?? "",
      // };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConfig.baseUrl}support-request"),
      );

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-type": "multipart/form-data"
      };

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path ?? '',
            contentType: MediaType('file', image.extension ?? ""),
          ),
        );
      }

      request.headers.addAll(headers);
      request.fields.addAll(param);
      debugPrint("request: $request");
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      debugPrint(response.body);

      ResponseModel success =
          ResponseModel.fromJson(jsonDecode(response.body.toString()));
      if (success.statusCode == 200) {
        updateLoaderState(LoaderState.loaded);
        btnLoader = false;
        notifyListeners();

        Helpers.successToast(success.message ?? "");
        if (onSuccess != null) onSuccess();
      } else {
        updateLoaderState(LoaderState.loaded);
        btnLoader = false;
        notifyListeners();
        Helpers.successToast(success.errors?.countryCode ??
            success.errors?.email ??
            success.errors?.phoneNumber ??
            "");
      }

      debugPrint(success.message ?? "");
    } catch (error) {
      updateLoaderState(LoaderState.error);
      btnLoader = false;
      notifyListeners();
      debugPrint("Exception");
    }
  }

// TERMS AND PRIVACY POLICY

  String? termsData;
  getTerms({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.getTermsOfUse();
    if (res.isValue) {
      PolicyModel terms = res.asValue!.value;
      termsData = terms.data ?? "";

      log("SUCCESS : ${terms.message}");
      updateLoaderState(LoaderState.loaded);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
      // if (res.asError!.error is ResponseModel) {
      //   ResponseModel errorRes = res.asError!.error as ResponseModel;
      //   log(errorRes.errors.toString());
      //   updateLoaderState(fetchError(res.asError!.error as Exceptions));
      // } else {
      //   debugPrint('Exceptions');
      //   updateLoaderState(LoaderState.error);
      // }
    }
    notifyListeners();
  }

  String? policyData;
  getPolicy({Function? onSuccess}) async {
    updateLoaderState(LoaderState.loading);
    var res = await serviceConfig.getPolicy();
    if (res.isValue) {
      PolicyModel terms = res.asValue!.value;
      policyData = terms.data ?? "";

      log("SUCCESS : ${terms.message}");
      updateLoaderState(LoaderState.loaded);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
      // if (res.asError!.error is ResponseModel) {
      //   ResponseModel errorRes = res.asError!.error as ResponseModel;
      //   log(errorRes.errors.toString());
      // updateLoaderState(fetchError(res.asError!.error as Exceptions));
      // } else {
      //   debugPrint('Exceptions');
      //   updateLoaderState(LoaderState.error);
      // }
    }
    notifyListeners();
  }

  clearTermsAndPolicy() {
    termsData = null;
    policyData = null;
    notifyListeners();
  }

  //

  init() {
    branchesModel = null;
    data = null;
    mainBranch = null;
    fullname = "";
    countryCode = "+91";
    mobileNumber = "";
    email = "";
    message = "";
    countryFlagUrl = "";
    image = null;
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
