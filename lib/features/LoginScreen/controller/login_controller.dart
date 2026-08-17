import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constance/app_messages.dart';
import '../../auth/repository/auth_repository.dart';
import '../../auth/repository/AuthController.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final _storage = GetStorage();
  final String _historyKey = 'email_history';

  // 1. التعديل هنا: تحويلها لـ late لعدم إعطائها قيمة أولية
  late TextEditingController emailOrPhoneController;
  late TextEditingController passwordController;
  late TextEditingController forgotPasswordController;

  final isPasswordObscured = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 2. التعديل هنا: إعطاء القيم داخل onInit لضمان إنشاء نسخ جديدة كلما فُتحت الشاشة
    emailOrPhoneController = TextEditingController();
    passwordController = TextEditingController();
    forgotPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    forgotPasswordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    String identifier = emailOrPhoneController.text.trim();
    String password = passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      Get.snackbar(
        AppMessages.noticeTitle,
        AppMessages.loginEmptyFieldsError,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final authResponse = await _authRepository.login(identifier, password);
      if (!_isPatientRole(authResponse.role)) {
        Get.snackbar(
          AppMessages.errorTitle,
          'Access denied. Only patient accounts are allowed to log in to this app.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _authController.loginSuccess(
        authResponse.user,
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      await _saveEmailToHistory();

      try {
        final status = await _authRepository.getCompletionStatus();
        final bool isCompleted = status.completed;
        await _storage.write('profileCompleted', isCompleted);
        _authController.updateProfileCompletionStatus(isCompleted);

        if (isCompleted) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(
            '/medical-profile',
            arguments: {
              "completionPercentage": status.completionPercentage,
              "missingFields": status.missingFields,
            },
          );
        }
      } catch (e) {
        debugPrint("Error checking profile status (New user likely): $e");
        Get.offAllNamed('/medical-profile');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        AppMessages.errorTitle,
        _messageFromError(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _messageFromError(Object error) {
    if (error is DioException) {
      final message = _messageFromPayload(error.response?.data);
      if (message != null) return message;
    }

    final value = error
        .toString()
        .replaceFirst(RegExp(r'^Exception:\s*'), '')
        .trim();
    return value.isEmpty || value == 'null'
        ? AppMessages.loginInvalidCredentials
        : value;
  }

  String? _messageFromPayload(dynamic data) {
    if (data is Map) {
      for (final key in <String>['message', 'error']) {
        final value = data[key];
        if (value is List) {
          final message = value
              .whereType<Object>()
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .join('\n');
          if (message.isNotEmpty) return message;
        } else if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }
  bool _isPatientRole(String? role) =>
      role?.trim().toUpperCase() == 'PATIENT';

  Future<void> _saveEmailToHistory() async {
    List<String> history = _getSavedEmails();
    String identifier = emailOrPhoneController.text.trim();

    if (!history.contains(identifier) && identifier.isNotEmpty) {
      history.add(identifier);
      if (history.length > 10) history.removeAt(0);
      await _storage.write(_historyKey, history);
    }
  }

  List<String> _getSavedEmails() {
    final List<dynamic>? history = _storage.read<List<dynamic>>(_historyKey);
    return history != null ? List<String>.from(history) : [];
  }

  Future<bool> handleForgotPassword(String value) async {
    final identifier = value.trim();
    if (identifier.isEmpty) {
      Get.snackbar(
        AppMessages.noticeTitle,
        AppMessages.loginEmptyIdentifierError,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    try {
      await _authRepository.requestOtp(identifier, 'reset-password');
      return true;
    } catch (e) {
      Get.snackbar(
        AppMessages.errorTitle,
        AppMessages.otpSendError,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void togglePassword() => isPasswordObscured.value = !isPasswordObscured.value;
}