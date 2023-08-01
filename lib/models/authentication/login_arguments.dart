import 'package:nest_matrimony/models/countries_data_model.dart';

class LoginArguments {
  String? mobileNumber;
  String? email;
  CountryData? countryData;

  LoginArguments({this.mobileNumber, this.countryData, this.email});
}
