import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/data/models/ResetPasswordModel.dart';
import '../../auth/repository/AuthController.dart';
import '../../auth/repository/auth_repository.dart';

class NewPasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _storage = GetStorage();
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

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 8) {
      Get.snackbar(
        "خطأ",
        "كلمة المرور يجب ألا تقل عن 8 خانات",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
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
        newPassword: newPassword,
      );

      await _authRepository.resetPassword(model);

      final authResponse = await _authRepository.login(identifier!, newPassword);

      await _authController.loginSuccess(
        authResponse.user,
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      final status = await _authRepository.getCompletionStatus();
      final bool isCompleted = status.completed;
      await _storage.write('profileCompleted', isCompleted);
      await _authController.updateProfileCompletionStatus(isCompleted);

      Get.snackbar(
        "نجاح",
        "تم تغيير كلمة المرور بنجاح",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      FocusManager.instance.primaryFocus?.unfocus();

      if (isCompleted) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(
          '/medical-profile',
          arguments: {
            'completionPercentage': status.completionPercentage,
            'missingFields': status.missingFields,
          },
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ من السيرفر",
        e.toString().replaceAll("Exception:", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
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