import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool darkMode = false.obs;

  RxBool notifications = true.obs;

  RxString language = "English".obs;

  void changeDarkMode(bool value) {
    darkMode.value = value;
  }

  void changeNotifications(bool value) {
    notifications.value = value;
  }

  void changeLanguage(String value) {
    language.value = value;
  }
}
