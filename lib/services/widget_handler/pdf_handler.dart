// import 'dart:convert' as utf8;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nest_matrimony/common/extensions.dart';
import 'package:nest_matrimony/providers/partner_detail_provider.dart';
import 'package:nest_matrimony/services/helpers.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/assets.dart';
import '../../models/profile_view_model.dart';
import '../../providers/app_data_provider.dart';
import 'package:http/http.dart' as http;

class PdfHandler {
  static PdfHandler? _instance;

  static PdfHandler get instance {
    _instance ??= PdfHandler();
    return _instance!;
  }

  Future<bool> validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  final Uri _url =
      Uri.parse('https://play.google.com/store/search?q=pdf+viewer&c=apps');

  Future<void> _searchPdfViewers() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? 'YOUR_ANDROID_PACKAGE_ID' : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(Platform.isAndroid
          ? "https://play.google.com/store/search?q=pdf+viewer&c=apps"
          : "https://apps.apple.com/app/id$appId");
      if (!await launchUrl(
        _url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $_url';
      }
    }
  }

  Font? fontSemiBold;
  Font? fontMedium;
  Font? fontBold;
  Font? malayalamFontMedium;

  Future<void> generatePdf(
      BuildContext context,
      PartnerDetailModel? partnerDetailModel,
      Map<int, List<String>>? grahanilaData,
      Map<int, List<String>>? navamshakamData,
      String? baseImagePath) async {
    PartnerDetailModel? user = partnerDetailModel;
    BasicDetails? basicDetail = user?.data?.basicDetails;
    int? noOfchild = user?.data?.numberOfChild;
    DateFormat formater = DateFormat('dd-MMM-yyyy');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final pdf = pw.Document();

    final topTagImage = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesTopTag)).buffer.asUint8List(),
    );
    final nestLogo = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesLogoWithBrand)).buffer.asUint8List(),
    );

    final bottomImage = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesBottomTag)).buffer.asUint8List(),
    );

    final contactIcon = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesContactSmallIcon))
          .buffer
          .asUint8List(),
    );
    final religionIcon = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesReligionSmallIcon))
          .buffer
          .asUint8List(),
    );
    final locationIcon = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesLocationSmallIcon))
          .buffer
          .asUint8List(),
    );

    final maleHolder = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesMaleMock)).buffer.asUint8List(),
    );

    final femaleHolder = pw.MemoryImage(
      (await rootBundle.load(Assets.imagesFemaleMock)).buffer.asUint8List(),
    );

    String profileURL = '';
    bool checkvalidStatus = true;
    late pw.ImageProvider placeHolders;

    if (basicDetail?.userImage != null && basicDetail!.userImage!.length != 0) {
      String? path = baseImagePath;
      String? extenstion = basicDetail.userImage?[0].imageFile;

      if (path != null && extenstion != null) {
        profileURL = path + extenstion;
        // profileURL = "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg";
        checkvalidStatus = await validateImage(profileURL);

        if (!checkvalidStatus) {
          placeHolders =
              (basicDetail.isMale ?? false) ? maleHolder : femaleHolder;
        }
      } else {
        placeHolders =
            (basicDetail.isMale ?? false) ? maleHolder : femaleHolder;
      }
    } else {
      placeHolders = (basicDetail?.isMale ?? false) ? maleHolder : femaleHolder;
    }

    final netImage = checkvalidStatus
        ? profileURL.contains('https')
            ? await networkImage(profileURL)
            : placeHolders
        : placeHolders;

    String dobMalayalam =basicDetail?.dateOfBirth ?? DateTime.now().toString();
    
    // String dobMalayalam = formater.format(
    //     DateTime.parse(basicDetail?.dateOfBirth ?? DateTime.now().toString()));

    final semiBold =
        await rootBundle.load("assets/fonts/PlusJakartaSans_SemiBold.ttf");
    fontSemiBold = Font.ttf(semiBold);

    final medium =
        await rootBundle.load("assets/fonts/PlusJakartaSans_Medium.ttf");
    fontMedium = Font.ttf(medium);

    final bold = await rootBundle.load("assets/fonts/PlusJakartaSans_Bold.ttf");
    fontBold = Font.ttf(bold);

    final malayalamFont =
        await rootBundle.load("assets/fonts/Manjari_Regular.ttf");
    malayalamFontMedium = Font.ttf(malayalamFont);

    pdf.addPage(pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: //PdfPageFormat.a4,
            // const PdfPageFormat(1240, 1754), a4 150 ppi
            // const PdfPageFormat(1030, 1532), // ui size
            // const PdfPageFormat(1060, 1580), // custom -- mainly custom
            const PdfPageFormat(1040, 1580), // custom
        build: (pw.Context pwContext) {
          return pdfPage(
            pwContext,
            topTagImage,
            nestLogo,
            bottomImage,
            contactIcon,
            religionIcon,
            locationIcon,
            context,
            profileImage: netImage,
            name: basicDetail?.name ?? "---",
            regNo: basicDetail?.registerId ?? "---",
            ageAndHeight:
                '${basicDetail?.age != null ? '${basicDetail!.age} Yrs' : ''}($dobMalayalam), ${basicDetail?.userHeight?.height ?? ''}',
            religionInfo:
                '${'${(basicDetail?.userReligion?.religionName ?? "").isNotEmpty ? basicDetail?.userReligion?.religionName : ""}'
                    ', ${basicDetail?.userCaste?.casteName ?? ""}'} ',
            district:
                (basicDetail?.userFamilyInfo?.userDistrict?.districtName ?? "")
                        .isNotEmpty
                    ? basicDetail?.userFamilyInfo?.userDistrict?.districtName
                    : "---",
            eduQualification:
                (basicDetail?.userEducationCategory?.eduCategoryTitle ?? "")
                        .isNotEmpty
                    ? basicDetail?.userEducationCategory?.eduCategoryTitle
                    : "---",
            eduDetails:
                (basicDetail?.userEducationSubcategory?.eduCategoryTitle ?? "")
                        .isNotEmpty
                    ? basicDetail?.userEducationSubcategory?.eduCategoryTitle
                    : "---",
            job: (basicDetail?.userJobCategory?.categoryName ?? "").isNotEmpty
                ? basicDetail?.userJobCategory?.categoryName
                : "---",
            jobDetails: (basicDetail?.userJobSubCategory?.subcategoryName ?? "")
                    .isNotEmpty
                ? basicDetail?.userJobSubCategory?.subcategoryName
                : "---",
            genderAndStatus:
                '${(basicDetail?.gender ?? "").isNotEmpty ? basicDetail?.gender : ""}${(basicDetail?.maritalStatus?.maritalStatus ?? "").isNotEmpty ? "/ ${basicDetail?.maritalStatus?.maritalStatus}" : ""}  ${(basicDetail?.maritalStatus?.haveChildren != 0 && basicDetail?.maritalStatus?.haveChildren != null) ? '- No of Children : ${noOfchild ?? "Nil"}' : ""}',
            complexion:
                (user?.data?.userPartnerPreference?.complexionUnserialize ?? [])
                        .isNotEmpty
                    ? user?.data?.userPartnerPreference?.complexionUnserialize
                        ?.join(',')
                    : "---",
            countryAndState: (basicDetail?.countryData?.countryName ?? "").isEmpty && (basicDetail?.userFamilyInfo?.userState?.stateName ?? "").isEmpty ?"---":
                '${(basicDetail?.countryData?.countryName ?? "").isNotEmpty ? basicDetail?.countryData?.countryName : "---"}'
                '${(basicDetail?.userFamilyInfo?.userState?.stateName ?? "").isNotEmpty ? '/${basicDetail?.userFamilyInfo?.userState?.stateName}' : "---"}',

            phone: (basicDetail?.phoneNo ?? "").isNotEmpty
                ? basicDetail?.phoneNo
                : "---",
            address:
                (basicDetail?.userFamilyInfo?.houseAddress ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.houseAddress
                    : "---",
            routeTohome:
                (basicDetail?.userFamilyInfo?.residenceRoute ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.residenceRoute
                    : '---',
            fathersName:
                (basicDetail?.userFamilyInfo?.fatherName ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.fatherName
                    : "---",
            fathersJob:
                (basicDetail?.userFamilyInfo?.fatherJob ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.fatherJob
                    : "---",
            mothersName:
                (basicDetail?.userFamilyInfo?.motherName ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.motherName
                    : "---",
            mothersJob:
                (basicDetail?.userFamilyInfo?.motherJob ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.motherJob
                    : "---",
            sibilingsInfo:
                (basicDetail?.userFamilyInfo?.sibilingsInfo ?? "").isNotEmpty
                    ? basicDetail?.userFamilyInfo?.sibilingsInfo
                    : "---",
            star: (basicDetail?.userReligiousInfo?.userStars?.starName ?? "")
                    .isNotEmpty
                ? basicDetail?.userReligiousInfo?.userStars?.starName
                : "---",
            dobMalayalam:
                (basicDetail?.userReligiousInfo?.malayalamDob ?? "").isNotEmpty
                    ? basicDetail?.userReligiousInfo?.malayalamDob
                    : "---",
            timeOfBirth:
                (basicDetail?.userReligiousInfo?.timeOfBirth ?? "").isNotEmpty
                    ? basicDetail?.userReligiousInfo?.timeOfBirth
                    : "---",
            janmaSistaDasa:
                (basicDetail?.userReligiousInfo?.dhasaName ?? "").isNotEmpty
                    ? basicDetail?.userReligiousInfo?.dhasaName
                    : "---",
            janmaSistaDasaEnd:
                (basicDetail?.userReligiousInfo?.janmaSistaDasaEnd ?? "")
                        .isNotEmpty
                    ? basicDetail?.userReligiousInfo?.janmaSistaDasaEnd
                    : '---',
            staffName: (basicDetail?.userStaff?.staffName ?? "").isNotEmpty
                ? basicDetail?.userStaff?.staffName
                : '---',
            staffMob: (basicDetail?.userStaff?.officeNumber ?? "").isNotEmpty
                ? basicDetail?.userStaff?.officeNumber
                : '---',
            staffBranch: (basicDetail?.userBranch?.branchName ?? "").isNotEmpty
                ? basicDetail?.userBranch?.branchName
                : '---',
            horoscopeData: grahanilaData,
            navamshakamData: navamshakamData,
            isHindu: basicDetail?.isHindu ?? false,
          );
        })); //
    //

    try {
      final file = File(
          '$appDocPath/${basicDetail?.name ?? "example"}_${basicDetail?.registerId ?? ""}.pdf');
      await file.writeAsBytes(await pdf.save()).then((value) async {
        await OpenFile.open(value.path).then((value) {
          // Helpers.successToast("Please install a PDF viewer");
          if (value.type == ResultType.noAppToOpen) {
            Helpers.successToast("There is no app to view the pdf file");
            context.read<PartnerDetailProvider>().pdfLoader(false);
          } else if (value.type == ResultType.permissionDenied) {
            Helpers.successToast("Allow Permission to PDF viewer");
            context.read<PartnerDetailProvider>().pdfLoader(false);
          } else if (value.type == ResultType.error) {
            Helpers.successToast(value.message);
            context.read<PartnerDetailProvider>().pdfLoader(false);
          }
        });
      });
    } on Exception catch (e) {
      Helpers.successToast("Something went wrong on device $e");
    }
  }

  pw.Widget pdfPage(
    pwContext,
    image,
    logo,
    bottomImage,
    contactIcon,
    religionIcon,
    locationIcon,
    BuildContext cxt, {
    pw.ImageProvider? profileImage,
    String? name,
    String? regNo,
    String? ageAndHeight,
    String? religionInfo,
    String? district,
    String? eduQualification,
    String? eduDetails,
    String? job,
    String? jobDetails,
    String? genderAndStatus,
    String? complexion,
    String? countryAndState,
    String? phone,
    String? address,
    String? routeTohome,
    String? fathersName,
    String? fathersJob,
    String? mothersName,
    String? mothersJob,
    String? sibilingsInfo,
    String? star,
    String? dobMalayalam,
    String? timeOfBirth,
    String? janmaSistaDasa,
    String? janmaSistaDasaEnd,
    String? staffName,
    String? staffMob,
    String? staffBranch,
    Map<int, List<String>>? horoscopeData,
    Map<int, List<String>>? navamshakamData,
    bool isHindu = false,
  }) {
    return pw.Container(
        margin: pw.EdgeInsets.zero,
        child: pw.Stack(
          children: [
            pw.Container(
              width: 1060,
              height: 1580,
            ),
            pw.Image(image),
            pw.Positioned(
              top: 33,
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          //image
                          pw.Container(
                              width: 430.17,
                              height: 494.4,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 18.65,
                              ),
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 13.38, vertical: 12.7),
                              decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  borderRadius: pw.BorderRadius.circular(6.r)),
                              child: pw.Container(
                                height: 481.7,
                                child: pw.Image(profileImage!,
                                    fit: pw.BoxFit.cover, alignment: pw.Alignment.topCenter),
                              )),

                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Center(
                                child: pw.Container(
                                    width: 100,
                                    padding: const pw.EdgeInsets.only(left: 15),
                                    margin: const pw.EdgeInsets.only(left: 15),
                                    height: 41.81,
                                    child: pw.Center(
                                        child: pw.Image(
                                      logo,
                                      width: 163.09,
                                      height: 41.81,
                                    ))),
                              ),
                              pw.SizedBox(height: 32.86),
                              pw.SizedBox(height: 32.86),
                              pw.Text(name ?? "",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontSize: 24,
                                      font: fontBold,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColor.fromHex("000000"))),
                              pw.SizedBox(height: 8.92),
                              pw.Text(regNo ?? "",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      font: fontSemiBold,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColor.fromHex("000000"))),
                              pw.SizedBox(height: 25),
                              //divider
                              pw.Container(
                                  color: PdfColor.fromHex('#707070'),
                                  width: 439.93,
                                  height: 1),
                              pw.SizedBox(height: 25),
                              //age and height
                              pw.Container(
                                  child: pw.Row(children: [
                                pw.Image(contactIcon, width: 22, height: 22),
                                pw.SizedBox(width: 15.77),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Age and height",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17,
                                            font: fontMedium,
                                            fontWeight: pw.FontWeight.normal,
                                            color:
                                                PdfColor.fromHex("#7B7B7B"))),
                                    pw.SizedBox(height: 10.09),
                                    pw.Text(ageAndHeight ?? '',
                                        // "25 Yrs( 27 Oct 1998), 5 3 (162 cm)",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17,
                                            font: fontSemiBold,
                                            fontWeight: pw.FontWeight.normal,
                                            color: PdfColor.fromHex("000000"))),
                                  ],
                                )
                              ])),
                              //age and height close ...
                              pw.SizedBox(height: 25),
                              //religion icon
                              pw.Container(
                                  child: pw.Row(children: [
                                pw.Image(religionIcon, width: 22, height: 22),
                                pw.SizedBox(width: 15.77),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Religion info",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17.sp,
                                            font: fontMedium,
                                            fontWeight: pw.FontWeight.normal,
                                            color:
                                                PdfColor.fromHex("#7B7B7B"))),
                                    pw.SizedBox(height: 10.09),
                                    pw.Text(religionInfo ?? "",
                                        // "Hindu,Ezhava",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17.sp,
                                            font: fontSemiBold,
                                            fontWeight: pw.FontWeight.normal,
                                            color: PdfColor.fromHex("000000"))),
                                  ],
                                )
                              ])),
                              //religion icon close
                              pw.SizedBox(height: 25),
                              // location
                              pw.Container(
                                  child: pw.Row(children: [
                                pw.Image(locationIcon, width: 22, height: 22),
                                pw.SizedBox(width: 15.77),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("District",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17,
                                            font: fontMedium,
                                            fontWeight: pw.FontWeight.normal,
                                            color:
                                                PdfColor.fromHex("#7B7B7B"))),
                                    pw.SizedBox(height: 10.09),
                                    pw.Text(district ?? "",
                                        // "Ernakulam",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: 17,
                                            font: fontSemiBold,
                                            fontWeight: pw.FontWeight.normal,
                                            color: PdfColor.fromHex("000000"))),
                                  ],
                                )
                              ])),
                              // location close
                              //divider
                              pw.SizedBox(height: 25),
                              pw.Container(
                                  color: PdfColor.fromHex('#707070'),
                                  width: 439.93,
                                  height: 1),
                            ],
                          ),
                        ]),
                    pw.Container(
                      width: 1030,
                      margin: const pw.EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // pw.SizedBox(height: 25 - 13),
                          pw.SizedBox(
                            height: 25,
                          ),
                          //proffesional info
                          titleHead(title: "Professional info"),

                          pw.SizedBox(height: 10),
                          keyPairValue(
                            leadingText: "Edu. Qualification",
                            trailingText: eduQualification ?? "",
                            // "Master of Human Resource Management",
                          ),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Edu. Details",
                              trailingText: eduDetails ?? ""
                              // "MBA Human Resource Management"
                              ),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Job", trailingText: job ?? ""
                              // "Human Resource Management"
                              ),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Job Details",
                              trailingText: jobDetails ?? ""
                              // "Associate talent acquisition"
                              ),
                          pw.SizedBox(height: 24),
                          // basic detail
                          titleHead(title: "Basic Details"),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Gender / Status",
                              trailingText: genderAndStatus ?? ""
                              //  "Female / Never Married"
                              ),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Complexion",
                              trailingText: complexion ?? ""
                              // "Fair"
                              ),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Country / State",
                              trailingText: countryAndState ?? ""
                              // "India/Kerala"
                              ),
                          //contact detail -- // commented as per client
                          // pw.SizedBox(height: 24),
                          // titleHead(title: "Contact Details"),
                          // pw.SizedBox(height: 8),
                          // keyPairValue(
                          //     leadingText: "Phone", trailingText: phone ?? ""),
                          // pw.SizedBox(height: 8),
                          // keyPairValue(
                          //     leadingText: "Address",
                          //     trailingText: address ?? ""),
                          // pw.SizedBox(height: 8),
                          // keyPairValue(
                          //     leadingText: "Route to home",
                          //     trailingText: routeTohome ?? ""),

                          //more detail
                          pw.SizedBox(height: 24),
                          titleHead(title: "More Details"),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Father Name",
                              trailingText: fathersName ?? ""),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Father\u0027s Job",
                              trailingText: fathersJob ?? ""),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Mother Name",
                              trailingText: mothersName ?? ""),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Mother\u0027s Job",
                              trailingText: mothersJob ?? ""),
                          pw.SizedBox(height: 8),
                          keyPairValue(
                              leadingText: "Siblings Info",
                              trailingText: sibilingsInfo ?? ""),
                          //horoscope detail and more detail

                          pw.SizedBox(height: 24),

                          if (!isHindu)
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  //  pw.SizedBox(height: 24),
                                  titleHead(title: "Other Details"),
                                  pw.SizedBox(height: 8),
                                  keyPairValue(
                                      leadingText: "Staff Name",
                                      trailingText: staffName ?? ""),
                                  pw.SizedBox(height: 8),
                                  keyPairValue(
                                      leadingText: "Staff Contact No",
                                      trailingText: staffMob ?? ""),
                                  pw.SizedBox(height: 8),
                                  keyPairValue(
                                      leadingText: "Staff Branch",
                                      trailingText: staffBranch ?? ""),
                                  pw.SizedBox(height: 8),
                                ]),

                          if (isHindu)
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  titleHead(title: "Horoscope Details"),
                                  pw.SizedBox(height: 8),
                                  keyPairDoubleValue(
                                      leadingText: "Star",
                                      trailingText: star ?? "",
                                      // "Vishagam",
                                      hideHeading: false,
                                      secondLeadingText: " "),
                                  pw.SizedBox(height: 8),
                                  keyPairDoubleValue(
                                      leadingText: "Date of birth (Malayalam)",
                                      trailingText: dobMalayalam ?? "",
                                      // "27 Oct 1998",
                                      hideHeading: false),
                                  pw.SizedBox(height: 8),
                                  keyPairDoubleValue(
                                    leadingText: "Time of birth",
                                    trailingText: timeOfBirth ?? "",
                                    // "08:35:00 PM",
                                    secondLeadingText: "Staff Name",
                                    secondTrailingText: staffName ?? "",
                                  ),
                                  pw.SizedBox(height: 8),
                                  keyPairDoubleValue(
                                    leadingText: "Janma sista dasa",
                                    trailingText: janmaSistaDasa ?? "",
                                    secondLeadingText: "Staff Contact No",
                                    secondTrailingText: staffMob ?? "",
                                  ),
                                  pw.SizedBox(height: 8),
                                  keyPairDoubleValue(
                                    leadingText: "Janma sista dasa end",
                                    trailingText: janmaSistaDasaEnd ?? "",
                                    // "1 year 5 month 23 days",
                                    secondLeadingText: "Staff Branch",
                                    secondTrailingText: staffBranch ?? "",
                                  ),
                                  pw.SizedBox(height: 24),
                                  if (isHindu)
                                    pw.Row(children: [
                                      if ((horoscopeData ?? {}).isNotEmpty)
                                        pw.Container(
                                            width: 380,
                                            height: 250,
                                            child: horoCard(
                                                title: "Grahanila",
                                                horoscopeData: horoscopeData)),
                                      pw.SizedBox(width: 30),
                                      if ((navamshakamData ?? {}).isNotEmpty)
                                        pw.Container(
                                            width: 380,
                                            height: 250,
                                            child: horoCard(
                                                title: "Navamshkam",
                                                horoscopeData: navamshakamData))
                                    ])
                                ])
                        ],
                      ),
                    ),
                  ]),
            ),
            pw.Positioned(
              bottom: -30,
              child: pw.Image(bottomImage),
            )
          ],
        ));
  }

  pw.Widget keyPairDoubleValue({
    bool hideHeading = true,
    String? leadingText,
    String? trailingText,
    String? secondLeadingText,
    String? secondTrailingText,
  }) {
    return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 0.w),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Flexible(
              fit: pw.FlexFit.tight,
              flex: 9,
              child: pw.Text(
                "$leadingText",
                maxLines: 3,
                style: const pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.Text(':'),
            pw.SizedBox(width: 35), //original 35
            pw.Flexible(
              fit: pw.FlexFit.tight,
              flex: 8,
              child: pw.Text(
                trailingText ?? '',
                maxLines: 3,
                style: const pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.SizedBox(width: 100),
            pw.Flexible(
              fit: pw.FlexFit.tight,
              flex: 6,
              child: pw.Text(
                secondLeadingText ?? "Other Details",
                maxLines: 3,
                style: pw.TextStyle(fontSize: !hideHeading ? 17 : 14),
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.Text(!hideHeading ? "" : ':'),
            pw.SizedBox(width: 25), //original 35
            pw.Flexible(
              fit: pw.FlexFit.tight,
              flex: 8,
              child: pw.Text(
                secondTrailingText ?? "",
                maxLines: 3,
                style: const pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.SizedBox(width: 15), // addded a margin as new
          ],
        ));
  }

  pw.Widget keyPairValue({
    String? leadingText,
    String? trailingText,
  }) {
    return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 0.w),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Flexible(
              fit: pw.FlexFit.tight,
              flex: 2,
              child: pw.Text(
                "$leadingText",
                maxLines: 3,
                style: pw.TextStyle(fontSize: 14, font: fontMedium),
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.Text(':'),
            pw.SizedBox(width: 35),
            pw.Flexible(
              // fit: pw.FlexFit.tight,
              flex: 6,
              child: pw.Text(
                trailingText ?? '',
                maxLines: 3,
                style: pw.TextStyle(fontSize: 14, font: fontMedium),
                textAlign: pw.TextAlign.left,
              ),
            )
          ],
        ));
  }

  pw.Widget titleHead({
    String? title,
  }) {
    return pw.Text(title ?? "",
        textAlign: pw.TextAlign.left,
        style: pw.TextStyle(
            fontSize: 14,
            font: fontSemiBold,
            // fontWeight: pw.FontWeight.normal,
            color: PdfColor.fromHex("000000")));
  }

  pw.Widget horoCard({String? title, Map<int, List<String>>? horoscopeData}) {
    PdfColor lineColor = PdfColor.fromHex('#C1C9D2');
    return pw.LayoutBuilder(builder: (context, constraints) {
      double width = constraints!.maxHeight / 4;
      return pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(color: lineColor)),
        child: pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        _boxContainer(width, 12, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 1, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 2, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 3, horoscopeData: horoscopeData))
              ],
            ),
            pw.Row(children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    children: [
                      _boxContainer(width, 11, horoscopeData: horoscopeData),
                      _boxContainer(width, 10, horoscopeData: horoscopeData)
                    ],
                  )),
              pw.Expanded(
                  flex: 2,
                  child: _box((width) * 2,
                      child: pw.Center(
                        child: pw.Text(
                          title ?? '',
                          textAlign: pw.TextAlign.center,
                          // style: FontPalette.f565F6C_14Medium,
                        ),
                      ))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    children: [
                      _boxContainer(width, 4, horoscopeData: horoscopeData),
                      _boxContainer(width, 5, horoscopeData: horoscopeData)
                    ],
                  )),
            ]),
            pw.Row(
              children: [
                pw.Expanded(
                    child:
                        _boxContainer(width, 9, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 6, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 7, horoscopeData: horoscopeData)),
                pw.Expanded(
                    child:
                        _boxContainer(width, 6, horoscopeData: horoscopeData))
              ],
            ),
          ],
        ),
      );
    });
  }

  pw.Widget _boxContainer(double width, int boxId,
      {bool disableRightBorder = false,
      bool disableBottomBorder = false,
      Map<int, List<String>>? horoscopeData}) {
    Map<int, List<String>> value = horoscopeData ?? {};
    List<String> data = value[boxId] ?? [];
    return _box(width,
        disableRightBorder: disableRightBorder,
        disableBottomBorder: disableBottomBorder,
        child: pw.Center(
          child: pw.Wrap(
            direction: pw.Axis.vertical,
            runSpacing: 8.w,
            children: List.generate(data.length, (subIndex) {
              Uint8List myUint8List = utf8.encode(data[subIndex]) as Uint8List;
              String s = utf8.decode(myUint8List.toList());
              return pw.Text(s,
                  //  data[subIndex],
                  style: pw.TextStyle(font: malayalamFontMedium, fontSize: 14)
                  // style: FontPalette.f565F6C_14Medium,
                  );
            }),
          ),
        ));
  }

  pw.Widget _box(double height,
      {bool disableRightBorder = false,
      bool disableBottomBorder = false,
      pw.Widget? child}) {
    PdfColor lineColor = PdfColor.fromHex('#C1C9D2');
    return pw.Container(
      height: height,
      width: double.maxFinite,
      alignment: pw.Alignment.topCenter,
      decoration: pw.BoxDecoration(
          border: pw.Border(
              right: pw.BorderSide(
                  color: disableRightBorder
                      ? PdfColor.fromHex("FFFFFF")
                      : lineColor),
              bottom: pw.BorderSide(
                  color: disableBottomBorder
                      ? PdfColor.fromHex("FFFFFF")
                      : lineColor))),
      child: child,
    );
  }
}
