import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/profile/model/profile_model.dart';

import '../../auth/repository/AuthController.dart';
import '../../auth/repository/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  RxInt selectedIndex = 0.obs;

  bool get isLoggedIn => _authController.isLoggedIn;

  String get userName => _authController.currentUser.value?.fullName ?? "Guest";

  String get email =>
      _authController.currentUser.value?.email ?? "Not logged in";

  @override
  void onInit() {
    super.onInit();

    ever(_authController.currentUser, (user) {
      if (user != null) {
        fetchProfile(user.id.toString());
      } else {
        profile.value = null;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (isLoggedIn) {
      fetchProfile(_authController.currentUser.value!.id.toString());
    }
  }

  Future<void> fetchProfile(String id) async {
    try {
      final response = await _authRepository.dio.get('/users/$id');
      profile.value = ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logout();
      }
      throw ProfileRepositoryException(_handleDioError(e));
    } catch (e) {
      throw ProfileRepositoryException('Failed to load profile: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Unexpected error: ${error.message}';
    }
  }

  void changeBottomNav(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    _authController.logout();
  }
}

class ProfileRepositoryException implements Exception {
  final String message;

  ProfileRepositoryException(this.message);

  @override
  String toString() => message;
}
