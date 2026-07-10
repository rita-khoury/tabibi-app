import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/data/models/ResetPasswordModel.dart';
import '../../auth/repository/auth_repository.dart';

class NewPasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  String? identifier;
  String? otp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    debugPrint(" [Debug]: Received Args: $args");
    if (args != null) {
      identifier = args['identifier'];
      otp = args['otp'];
    }
  }

  Future<void> resetPassword() async {
    if (identifier == null || otp == null) {
      Get.snackbar(
        "خطأ",
        "بيانات الجلسة مفقودة، يرجى المحاولة مجدداً",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.length < 8) {
      Get.snackbar(
        "خطأ",
        "كلمة المرور يجب ألا تقل عن 8 خانات",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "خطأ",
        "كلمات المرور غير متطابقة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final model = ResetPasswordModel(
        email: identifier!.contains('@') ? identifier : null,
        phone: !identifier!.contains('@') ? identifier : null,
        code: otp!,
        newPassword: newPasswordController.text,
      );

      await _authRepository.resetPassword(model);

      Get.snackbar(
        "نجاح",
        "تم تغيير كلمة المرور بنجاح",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = false;

      await Future.delayed(const Duration(milliseconds: 500));

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "خطأ من السيرفر",
        e.toString().replaceAll("Exception:", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
