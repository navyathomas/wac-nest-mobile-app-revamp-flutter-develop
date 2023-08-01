import 'package:nest_matrimony/models/res_status_model.dart';

class CountriesDataModel extends ResStatusModel {
  List<CountryData>? countryData;

  CountriesDataModel({this.countryData});

  CountriesDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      countryData = <CountryData>[];
      json['data'].forEach((v) {
        countryData!.add(CountryData.fromJson(v));
      });
    }
  }
}

class CountryData {
  int? id;
  String? countryName;
  String? isoAlpha2Code;
  String? isoAlpha3Code;
  String? dialCode;
  int? minLength;
  int? maxLength;
  String? countryFlag;

  CountryData(
      {this.id,
      this.countryName,
      this.isoAlpha2Code,
      this.isoAlpha3Code,
      this.dialCode,
      this.maxLength,
      this.minLength,
      this.countryFlag});

  CountryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    isoAlpha2Code = json['iso_alpha_2_code'];
    isoAlpha3Code = json['iso_alpha_3_code'];
    dialCode = json['dial_code'];
    countryFlag = json['country_flag'];
    minLength = json['min_length'];
    maxLength = json['max_length'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "country_flag": countryFlag,
      };
}
