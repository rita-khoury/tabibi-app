import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

class AccountController extends GetxController {
  var selectedCountryCode = "DE".obs;
  var selectedCountryName = "Germany".obs;

  void pickCountry(Country c) {
    selectedCountryCode.value = c.countryCode;
    selectedCountryName.value = c.name;
  }

  String get countryDisplay =>
      "${selectedCountryCode.value} (${selectedCountryName.value.substring(0, 3)})";
}