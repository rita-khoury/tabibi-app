import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:tabibi/core/routes/app_routes.dart';
import '../data/models/user_model.dart';
import '../repository/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final box = GetStorage();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  final isProfileCompleted = false.obs;

  final isLoading = false.obs;

  bool _loggingOut = false;

  @override
  void onInit() {
    super.onInit();

    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('auth_token');

      final logged = box.read('isLoggedIn') == true;

      if (token == null || !logged) {
        return;
      }

      final data = box.read('userData');

      if (data != null) {
        currentUser.value = UserModel.fromJson(data);
      }

      try {
        final status = await _authRepository.getCompletionStatus();

        isProfileCompleted.value = status.completed;

        await box.write('profileCompleted', status.completed);
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          await logout();
        }
      }
    } catch (e) {
      debugPrint("Startup error: $e");
    }
  }

  Future<void> loginSuccess(
    UserModel user,
    String accessToken,
    String refreshToken,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('auth_token', accessToken);

    await prefs.setString('refresh_token', refreshToken);

    currentUser.value = user;

    await box.write('isLoggedIn', true);

    await box.write('userData', user.toJson());

    debugPrint(" Login data saved");
  }

  Future<void> updateProfileCompletionStatus(bool completed) async {
    isProfileCompleted.value = completed;

    await box.write('profileCompleted', completed);
  }

  Future<void> logout({bool navigateToGuestHome = false}) async {
    if (_loggingOut) {
      return;
    }

    _loggingOut = true;

    isLoading.value = true;

    try {
      await _authRepository.logout();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      await _clearLocalData();

      _loggingOut = false;

      Get.offAllNamed(navigateToGuestHome ? AppRoutes.home : AppRoutes.login);
    }
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');

    await prefs.remove('refresh_token');

    await box.remove('isLoggedIn');

    await box.remove('userData');

    await box.remove('profileCompleted');

    currentUser.value = null;

    isProfileCompleted.value = false;

    isLoading.value = false;
  }

  bool get isLoggedIn =>
      currentUser.value != null && box.read('isLoggedIn') == true;
}
