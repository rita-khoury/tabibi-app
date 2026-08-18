// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:tabibi/features/profile/model/profile_model.dart';
//
// import '../../auth/repository/AuthController.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class ProfileController extends GetxController {
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//   final AuthController _authController = Get.find<AuthController>();
//
//   Rxn<ProfileModel> profile = Rxn<ProfileModel>();
//   RxInt selectedIndex = 0.obs;
//
//   var violationsList = <dynamic>[].obs;
//   var violationsCount = 0.obs;
//
//   bool get isLoggedIn => _authController.isLoggedIn;
//
//   String get userName => _authController.currentUser.value?.fullName ?? "Guest";
//
//   String get email =>
//       _authController.currentUser.value?.email ?? "Not logged in";
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     ever(_authController.currentUser, (user) {
//       if (user != null) {
//         fetchProfile(user.id.toString());
//         fetchViolations();
//       } else {
//         profile.value = null;
//         violationsList.clear();
//         violationsCount.value = 0;
//       }
//     });
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     if (isLoggedIn && _authController.currentUser.value != null) {
//       String userId = _authController.currentUser.value!.id.toString();
//       fetchProfile(userId);
//       fetchViolations();
//     }
//   }
//
//   Future<void> fetchProfile(String id) async {
//     try {
//       final response = await _authRepository.dio.get('/users/$id');
//       profile.value = ProfileModel.fromJson(response.data);
//
//       if (response.data['violations'] != null) {
//         violationsList.assignAll(response.data['violations']);
//         violationsCount.value = violationsList.length;
//       }
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 401) {
//         logout();
//       }
//       throw ProfileRepositoryException(_handleDioError(e));
//     } catch (e) {
//       throw ProfileRepositoryException('Failed to load profile: $e');
//     }
//   }
//
//   Future<void> fetchViolations() async {
//     try {
//       final violations = await _authRepository.getMyViolations();
//       violationsList.assignAll(violations);
//       violationsCount.value = violationsList.length;
//       print("✅ تم جلب عدد مخالفات: ${violationsCount.value}");
//     } catch (e) {
//       print("⚠️ خطأ في جلب المخالفات: $e");
//     }
//   }
//
//   String _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.receiveTimeout:
//         return 'Connection timed out. Please check your internet.';
//       case DioExceptionType.badResponse:
//         return 'Server error: ${error.response?.statusCode}';
//       case DioExceptionType.connectionError:
//         return 'No internet connection.';
//       default:
//         return 'Unexpected error: ${error.message}';
//     }
//   }
//
//   void changeBottomNav(int index) {
//     selectedIndex.value = index;
//   }
//
//   void logout() {
//     _authController.logout();
//   }
// }
//
// class ProfileRepositoryException implements Exception {
//   final String message;
//
//   ProfileRepositoryException(this.message);
//
//   @override
//   String toString() => message;
// }

import 'package:dio/dio.dart';
import '../../../core/constance/api_constants.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/profile/model/profile_model.dart';

import '../../auth/repository/AuthController.dart';
import '../../auth/repository/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();

  Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  RxInt selectedIndex = 0.obs;

  var violationsList = <dynamic>[].obs;
  var violationsCount = 0.obs;

  // متغير خاص برابط أو مسار الصورة الشخصية للمستخدم في البروفايل
  var profileAvatarUrl = ''.obs;

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
        fetchViolations();
      } else {
        profile.value = null;
        violationsList.clear();
        violationsCount.value = 0;
        profileAvatarUrl.value = '';
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (isLoggedIn && _authController.currentUser.value != null) {
      String userId = _authController.currentUser.value!.id.toString();
      fetchProfile(userId);
      fetchViolations();
    }
  }

  Future<void> fetchProfile(String id) async {
    try {
      final response = await _authRepository.dio.get('/users/$id');

      // طباعة الـ Response في الـ Console للتأكد من شكل البيانات القادمة من السيرفر
      print("📦 Response Data: ${response.data}");

      profile.value = ProfileModel.fromJson(response.data);

      // التقاط رابط الصورة بالاعتماد على الحقل الصحيح القادم من الـ Backend (avatarUrl)
      final data = response.data;
      final extractedAvatar =
          data['avatarUrl'] ??
          data['avatar'] ??
          data['image'] ??
          data['profile_image'];

      profileAvatarUrl.value = ApiConstants.getFullImageUrl(
        extractedAvatar?.toString(),
      );

      if (data['violations'] != null) {
        violationsList.assignAll(data['violations']);
        violationsCount.value = violationsList.length;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _authController.logout();
      }
      throw ProfileRepositoryException(_handleDioError(e));
    } catch (e) {
      throw ProfileRepositoryException('Failed to load profile: $e');
    }
  }

  Future<void> fetchViolations() async {
    try {
      final violations = await _authRepository.getMyViolations();
      violationsList.assignAll(violations);
      violationsCount.value = violationsList.length;
      print("✅ تم جلب عدد مخالفات: ${violationsCount.value}");
    } catch (e) {
      print("⚠️ خطأ في جلب المخالفات: $e");
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
    _authController.logout(navigateToGuestHome: true);
  }
}

class ProfileRepositoryException implements Exception {
  final String message;

  ProfileRepositoryException(this.message);

  @override
  String toString() => message;
}
