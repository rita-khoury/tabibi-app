import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailOrPhone = ''.obs;
  final password = ''.obs;
  final isPasswordObscured = true.obs;
  final isLoading = false.obs;

  void togglePassword() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void setEmailOrPhone(String value) {
    emailOrPhone.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  Future<void> login() async {
    String input = emailOrPhone.value.trim();

    // التحقق من الحقول مع رسالة خطأ باللون الأحمر الداكن الاحترافي
    if (input.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        "Alert",
        "Please fill in all fields to continue",
        backgroundColor: Colors.redAccent.shade700, // لون أحمر متناسق
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP, // تظهر من الأعلى
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(15),
        borderRadius: 15,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      );
      return;
    }

    isLoading.value = true;

    // محاكاة الاتصال بالسيرفر
    await Future.delayed(const Duration(seconds: 2));

    bool isEmail = input.contains('@');
    Map<String, dynamic> loginData = {
      "password": password.value,
      isEmail ? "email" : "phone": input,
    };

    print("Sending data to API: $loginData");

    isLoading.value = false;

    // يمكنك إضافة منطق التنقل للصفحة التالية هنا
  }
}