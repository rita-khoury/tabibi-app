import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final GetStorage _box = GetStorage();

  RxBool darkMode = false.obs;
  RxBool notifications = true.obs;
  RxString language = "English".obs;

  @override
  void onInit() {
    super.onInit();

    darkMode.value = _box.read('isDarkMode') ?? false;
    notifications.value = _box.read('notifications') ?? true;
    language.value = _box.read('language') ?? "English";
  }

  void changeDarkMode(bool value) {
    darkMode.value = value;
    _box.write('isDarkMode', value);

    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  void changeNotifications(bool value) {
    notifications.value = value;
    _box.write('notifications', value);
  }

  void changeLanguage(String value) {
    language.value = value;
    _box.write('language', value);
  }
}
