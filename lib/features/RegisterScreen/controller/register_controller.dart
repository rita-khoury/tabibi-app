import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailOrPhone = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final birthDate = ''.obs;

  /// 🌍 Country
  final selectedCountry = Rx<Country?>(null);

  /// 🖼️ Profile Image
  final profileImage = Rx<File?>(null);

  void setImage(File file) {
    profileImage.value = file;
  }

  void setEmailOrPhone(String val) => emailOrPhone.value = val;
  void setPassword(String val) => password.value = val;
  void setName(String val) => name.value = val;
  void setBirthDate(String val) => birthDate.value = val;

  void setCountry(Country country) {
    selectedCountry.value = country;
  }

  /// 🏥 REGISTER LOGIC
  void register() {
    if (profileImage.value == null) {
      _error("Profile image is required");
      return;
    }

    if (emailOrPhone.value.isEmpty) {
      _error("Email or Phone is required");
      return;
    }

    if (password.value.isEmpty) {
      _error("Password is required");
      return;
    }

    if (name.value.isEmpty) {
      _error("Full name is required");
      return;
    }

    if (birthDate.value.isEmpty) {
      _error("Birth date is required");
      return;
    }

    if (selectedCountry.value == null) {
      _error("Country is required");
      return;
    }

    /// ✅ SUCCESS
    Get.snackbar(
      "Success",
      "Account created successfully",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2F80ED),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );

    print("=== REGISTER DATA ===");
    print("Email/Phone: ${emailOrPhone.value}");
    print("Password: ${password.value}");
    print("Name: ${name.value}");
    print("BirthDate: ${birthDate.value}");
    print("Country: ${selectedCountry.value!.name}");
  }

  /// ❌ ERROR SNACKBAR
  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}