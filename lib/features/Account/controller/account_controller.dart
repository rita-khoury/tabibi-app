import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

class AccountController extends GetxController {
  Rxn<Country> selectedCountry = Rxn<Country>();

  void pickCountry(Country c) {
    selectedCountry.value = c;
  }


  String get countryDisplay {
    if (selectedCountry.value == null) return "Select Country";
    return "${selectedCountry.value!.countryCode} (${selectedCountry.value!.name.substring(0, 3)})";
  }
}