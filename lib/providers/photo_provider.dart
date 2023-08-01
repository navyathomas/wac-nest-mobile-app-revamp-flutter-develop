import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/common/route_generator.dart';
import 'package:nest_matrimony/providers/app_data_provider.dart';
import 'package:nest_matrimony/providers/account_provider.dart';
import 'package:nest_matrimony/services/app_config.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:nest_matrimony/services/shared_preference_helper.dart';
import 'package:nest_matrimony/utils/multipart.dart';
import 'package:provider/provider.dart';

class PhotoProvider extends ChangeNotifier {
  XFile? _pickedFile;
  String? _downloadPic;
  CroppedFile? croppedFile;
  List<CroppedFile> croppedFileList = [];
  //

  bool isUploading = false;
  uploading(bool status) {
    isUploading = status;
    notifyListeners();
  }

  //UPLOADING VARIABLE
  int progressPercentage = 0;
  updatePercentage({int? percentage}) {
    progressPercentage = percentage ?? 0;
    notifyListeners();
  }

// UPLOAD MY PHOTO
  Future uploadPhotos(BuildContext context, {Function? onSuccess}) async {
    var token = await SharedPreferenceHelper.getToken();
    log(token);
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}image-upload');
      final request = MultipartRequest(
        'POST',
        uri,
        onProgress: (int bytes, int total) {
          final progress = (bytes / total) * 100;
          updatePercentage(percentage: progress.toInt());
          debugPrint('progress: $progress ($bytes/$total)');
        },
      );

      for (int i = 0; i < croppedFileList.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image[$i]',
            croppedFileList[i].path,
          ),
        );
      }

      // request.files.add(
      //   await http.MultipartFile.fromPath(
      //     'image[0]',
      //     '/storage/emulated/0/Download/18188680570211560.jpg',
      //   ),
      // );

      request.headers['Authorization'] = 'Bearer $token';
      try {
        if (token != "") {
          uploading(true);
          final streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          debugPrint(response.body.toString());
          if (response.statusCode == 200) {
            await Future.microtask(
                () => context.read<AppDataProvider>().getBasicDetails());
            uploading(false);
            if (onSuccess != null) onSuccess(true);
          } else {
            Helpers.successToast(Constants.imageErrorMsg);
            croppedFileList.clear();
            uploading(false);
          }
        } else {
          log("ISSUE NO AUTH TOKEN");
          Helpers.successToast("NO AUTH TOKEN");
          croppedFileList.clear();
          uploading(false);
        }
      } catch (error) {
        log("Catch: SERVER ISSUE $error");
        Helpers.successToast("SOMETHING WENT WRONG");
        croppedFileList.clear();
        uploading(false);
      }
    } catch (e) {
      croppedFileList.clear();
      uploading(false);
      Helpers.successToast("SERVER ERROR");
      log("ISSUE: $e");
    }
  }
//

  Future<void> cropImage(BuildContext context, {Function? onResponse}) async {
    if (_pickedFile != null) {
      final croppedFileLocal = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        maxHeight: 50,
        uiSettings: [
          AndroidUiSettings(
            cropGridRowCount: 3,
            cropGridColor: Colors.yellow,
            cropFrameColor: Colors.yellow,
            activeControlsWidgetColor: const Color(0xFF950053),
            dimmedLayerColor: Colors.black,
            backgroundColor: Colors.white,
            statusBarColor: Colors.white,
            toolbarTitle: 'Crop photo',
            toolbarColor: Colors.white,
            hideBottomControls: false,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop photo',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      ).then((value) {
        if (value != null) {
          log("cropped done! $value");
          croppedFileList.add(value);
          onResponse != null ? onResponse() : routeToPhotoGridView(context);
        } else {
          log("cropped NOT done :( ");
        }
      });
      if (croppedFileLocal != null) {
        croppedFile = croppedFileLocal;
        croppedFileList.add(croppedFile!);
        notifyListeners();
      }
    }
  }

  Future<void> cropDownloadedImage(BuildContext context,
      {bool isFromManage = false}) async {
    if (_downloadPic != null) {
      final croppedFileLocal = await ImageCropper().cropImage(
        sourcePath: _downloadPic!,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        maxHeight: 50,
        uiSettings: [
          AndroidUiSettings(
            cropGridRowCount: 3,
            cropGridColor: Colors.yellow,
            cropFrameColor: Colors.yellow,
            activeControlsWidgetColor: const Color(0xFF950053),
            dimmedLayerColor: Colors.black,
            backgroundColor: Colors.white,
            statusBarColor: Colors.white,
            toolbarTitle: 'Crop photo',
            toolbarColor: Colors.white,
            hideBottomControls: false,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop photo',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      ).then((value) {
        if (value != null) {
          log("cropped done! $value");

          croppedFileList.add(value);

          // uploading from manage photos
          if (isFromManage) {
            if (imageCategoryType != "") {
              if (imageCategoryType == "3") {
                // from id proof
                log("insta upload from id proof ");
                uploadAnyPhotos(
                    imageType: "3",
                    isFeatured: "0",
                    filesList: croppedFileList,
                    onSuccess: (val) {
                      if (val ?? false) {
                        context.read<AppDataProvider>().getBasicDetails();
                      }
                    }).then((value) {
                  clearUploadAnyPhoto();
                  context.read<AccountProvider>().clearIdProofSection();
                  context.read<AccountProvider>().getIDproofPhotos();
                  Navigator.popUntil(context,
                      ModalRoute.withName(RouteGenerator.routeManagePhotos));
                });
              } else if (imageCategoryType == "2") {
                // from house
                log("insta upload from house");
                uploadAnyPhotos(
                        imageType: "2",
                        isFeatured: "0",
                        filesList: croppedFileList)
                    .then((value) {
                  clearUploadAnyPhoto();
                  context.read<AccountProvider>().clearHouseSection();
                  context.read<AccountProvider>().getMyhousePhoto();
                  Navigator.popUntil(context,
                      ModalRoute.withName(RouteGenerator.routeManagePhotos));
                });
              }
            } else {
              log("insta upload from my photos ");
              context.read<PhotoProvider>().uploadPhotos(context,
                  onSuccess: (val) {
                if (val ?? false) {
                  Helpers.successToast("profile Image Upload successfully");
                  context.read<AppDataProvider>().getBasicDetails();
                  context.read<AccountProvider>().clearAllManagePhotoSections();
                  context.read<PhotoProvider>().clearUploadAnyPhoto();
                  context
                      .read<AccountProvider>()
                      .getMyOWnPhotos(context)
                      .then((value) {
                    Navigator.popUntil(context,
                        ModalRoute.withName(RouteGenerator.routeManagePhotos));
                  });
                }
              });
            }
            // uploading from manage photos close

          } else {
            routeToPhotoGridView(context);
          }
        } else {
          log("cropped NOT done :( ");
        }
      });
      if (croppedFileLocal != null) {
        croppedFile = croppedFileLocal;
        croppedFileList.add(croppedFile!);
        notifyListeners();
      }
    }
  }

  pickFromGallery(BuildContext context, {Function? onResponse}) {
    clear();
    uploadImageGallery().then((value) {
      if (croppedFile == null) {
        cropImage(context, onResponse: onResponse);
      }
    });
  }

  pickFromCamera(BuildContext context, {Function? onResponse}) {
    clear();
    uploadImageCamera().then((value) {
      if (croppedFile == null) {
        cropImage(context, onResponse: onResponse);
      }
    });
  }

//insta photo download
  pickDownloadedPhoto(BuildContext context, String filePath,
      {bool isFromManage = false}) {
    if (isFromManage) {
      clear();
    }

    _downloadPic = filePath;
    cropDownloadedImage(context, isFromManage: isFromManage);
  }

  Future<void> uploadImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedFile = pickedFile;
      notifyListeners();
    }
  }

  Future<void> uploadImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _pickedFile = pickedFile;
      notifyListeners();
    }
  }

  routeToPhotoGridView(BuildContext context) {
    Navigator.pushNamed(context, RouteGenerator.routePhotoGridView);
  }

  remove({var filePath, int? index}) {
    croppedFileList.removeAt(index!);
    log("Removed");
    if (croppedFileList.isEmpty) {
      clear();
    }
    notifyListeners();
  }

  clear() {
    _pickedFile = null;
    croppedFile = null;
    _downloadPic = null;
    notifyListeners();
  }

  String imageCategoryType = "";
  updateImageCategoryType({String? id}) {
    //  "id": 2 ---- "House"
    //  "id": 3 ---- "Id Proof"
    imageCategoryType = id ?? "";
    if (id == "2") {
      log("House id =$id");
    } else if (id == "3") {
      log("id Proof id =$id");
    } else {
      log("id= $id");
    }

    // notifyListeners();
  }

// Upload PHOTO
  bool uploadButtonLoading = false;
  updateUploadButtonStatus(bool value) {
    uploadButtonLoading = value;
    notifyListeners();
  }

  clearUploadAnyPhoto() {
    croppedFileList = [];
    notifyListeners();
  }

  Future uploadAnyPhotos(
      {Function? onSuccess,
      List<dynamic>? filesList,
      String? imageType,
      String? isFeatured}) async {
    var token = await SharedPreferenceHelper.getToken();
    log(token);
    try {
      final uri =
          Uri.parse('${AppConfig.baseUrl}category-image-upload');

      final request = MultipartRequest(
        'POST',
        uri,
        onProgress: (int bytes, int total) {
          final progress = (bytes / total) * 100;
          updatePercentage(percentage: progress.toInt());
          debugPrint('progress: $progress ($bytes/$total)');
        },
      );

      for (int i = 0; i < filesList!.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image[$i]',
            filesList[i].path,
          ),
        );
      }

      request.fields['user_image_type'] = imageType ?? "";
      request.fields['is_featured'] = isFeatured ?? "";

      request.headers['Authorization'] = 'Bearer $token';
      try {
        if (token != "") {
          updateUploadButtonStatus(true);
          final streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          debugPrint(response.body.toString());
          updateUploadButtonStatus(false);
          var map = jsonDecode(response.body);
          Helpers.successToast(map['message'].toString());
          if (onSuccess != null) onSuccess(true);
        } else {
          log("ISSUE NO AUTH TOKEN");
          Helpers.successToast("NO AUTH TOKEN");
          updateUploadButtonStatus(false);
        }
      } catch (error) {
        log("Catch: SERVER ISSUE $error");
        Helpers.successToast("SOMETHING WENT WRONG");
        updateUploadButtonStatus(false);
      }
    } catch (e) {
      updateUploadButtonStatus(false);
      Helpers.successToast("SERVER ERROR");
      log("ISSUE: $e");
    }
  }
//

}
