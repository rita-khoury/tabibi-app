// // import 'package:get/get.dart';
// // import '../../../features/auth/data/models/DoctorModel.dart';
// // import '../../../features/auth/repository/auth_repository.dart';
// //
// // class DoctorProfileController extends GetxController {
// //   final AuthRepository _authRepo = Get.find<AuthRepository>();
// //
// //   var doctor = Rxn<DoctorModel>();
// //   var isLoading = true.obs;
// //   var isFavoriteLoading = false.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeDoctor();
// //   }
// //
// //   Future<void> _initializeDoctor() async {
// //     isLoading.value = true;
// //
// //     if (Get.arguments is DoctorModel) {
// //       doctor.value = Get.arguments as DoctorModel;
// //     } else if (Get.arguments is Map<String, dynamic>) {
// //       doctor.value = DoctorModel.fromJson(Get.arguments);
// //     } else if (Get.parameters['doctorId'] != null) {
// //       int id = int.parse(Get.parameters['doctorId']!);
// //       doctor.value = await _authRepo.getDoctorById(id);
// //     }
// //
// //     isLoading.value = false;
// //   }
// //
// //   Future<void> toggleFavorite() async {
// //     final currentDoctor = doctor.value;
// //     if (currentDoctor == null) return;
// //
// //     try {
// //       isFavoriteLoading.value = true;
// //
// //       final bool wasFavorite = currentDoctor.isFavorite;
// //       final int doctorId = currentDoctor.id;
// //
// //       if (wasFavorite) {
// //         await _authRepo.removeFavorite(doctorId);
// //       } else {
// //         await _authRepo.addFavorite(doctorId);
// //       }
// //
// //       doctor.update((val) {
// //         val?.isFavorite = !wasFavorite;
// //       });
// //     } catch (e) {
// //       Get.snackbar(
// //         "خطأ",
// //         "تعذر تحديث القائمة المفضلة، يرجى المحاولة لاحقاً",
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     } finally {
// //       isFavoriteLoading.value = false;
// //     }
// //   }
// // }
//
//
// import 'package:get/get.dart';
// import '../../../features/auth/data/models/DoctorModel.dart';
// import '../../../features/auth/repository/auth_repository.dart';
//
// // استيراد ملفات الرسائل والتنبيهات المركزية
// import '../../../core/constance/app_messages.dart';
// import '../../../core/constance/app_alerts.dart';
//
// class DoctorProfileController extends GetxController {
//   final AuthRepository _authRepo = Get.find<AuthRepository>();
//
//   var doctor = Rxn<DoctorModel>();
//   var isLoading = true.obs;
//   var isFavoriteLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeDoctor();
//   }
//
//   Future<void> _initializeDoctor() async {
//     isLoading.value = true;
//
//     if (Get.arguments is DoctorModel) {
//       doctor.value = Get.arguments as DoctorModel;
//     } else if (Get.arguments is Map<String, dynamic>) {
//       doctor.value = DoctorModel.fromJson(Get.arguments);
//     } else if (Get.parameters['doctorId'] != null) {
//       int id = int.parse(Get.parameters['doctorId']!);
//       doctor.value = await _authRepo.getDoctorById(id);
//     }
//
//     isLoading.value = false;
//   }
//
//   Future<void> toggleFavorite() async {
//     final currentDoctor = doctor.value;
//     if (currentDoctor == null) return;
//
//     try {
//       isFavoriteLoading.value = true;
//
//       final bool wasFavorite = currentDoctor.isFavorite;
//       final int doctorId = currentDoctor.id;
//
//       if (wasFavorite) {
//         await _authRepo.removeFavorite(doctorId);
//       } else {
//         await _authRepo.addFavorite(doctorId);
//       }
//
//       doctor.update((val) {
//         val?.isFavorite = !wasFavorite;
//       });
//     } catch (e) {
//       AppAlerts.showError(
//         title: AppMessages.favoriteErrorTitle,
//         message: AppMessages.favoriteUpdateError,
//       );
//     } finally {
//       isFavoriteLoading.value = false;
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/constance/app_alerts.dart';
import '../../../core/constance/app_messages.dart';
import '../../auth/data/models/DoctorModel.dart';
import '../../auth/repository/auth_repository.dart';
import '../../favorites/controller/favorites_doctors_controller.dart';

class DoctorProfileController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  late final FavoritesDoctorsController _favoritesController;
  Worker? _favoriteStateWorker;

  final doctor = Rxn<DoctorModel>();
  final isLoading = true.obs;
  final isFavoriteLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _favoritesController = Get.isRegistered<FavoritesDoctorsController>()
        ? Get.find<FavoritesDoctorsController>()
        : Get.put(FavoritesDoctorsController(_authRepo));
    _favoriteStateWorker = ever(
      _favoritesController.favoriteDoctorIds,
      (_) => _syncFavoriteStateFromSharedController(),
    );
    _initializeDoctor();
  }

  @override
  void onClose() {
    _favoriteStateWorker?.dispose();
    super.onClose();
  }

  Future<void> _initializeDoctor() async {
    var didLoadDoctor = false;
    try {
      isLoading.value = true;

      if (Get.arguments is DoctorModel) {
        doctor.value = Get.arguments as DoctorModel;
      } else if (Get.arguments is Map<String, dynamic>) {
        doctor.value = DoctorModel.fromJson(Get.arguments);
      } else if (Get.parameters['doctorId'] != null) {
        final id = int.tryParse(Get.parameters['doctorId']!);
        if (id != null) {
          doctor.value = await _authRepo.getDoctorById(id);
        }
      }
      didLoadDoctor = doctor.value != null;
    } catch (e) {
      debugPrint('Error initializing doctor profile: $e');
      AppAlerts.showError(
        title: AppMessages.favoriteErrorTitle,
        message: 'Unable to load doctor information. Please try again later.',
      );
    } finally {
      isLoading.value = false;
    }

    if (didLoadDoctor) {
      await _refreshFavoriteState();
    }
  }

  Future<void> refreshDoctor() async {
    await _initializeDoctor();
  }

  Future<void> _refreshFavoriteState() async {
    try {
      isFavoriteLoading.value = true;
      await _favoritesController.fetchMyFavorites();
      _syncFavoriteStateFromSharedController();
    } catch (e) {
      debugPrint('Error refreshing doctor favorite state: $e');
    } finally {
      isFavoriteLoading.value = false;
    }
  }

  void _syncFavoriteStateFromSharedController() {
    final currentDoctor = doctor.value;
    if (currentDoctor == null) return;

    final isFavorite = _favoritesController.isFavorite(currentDoctor.id);
    if (currentDoctor.isFavorite != isFavorite) {
      doctor.update((value) {
        value?.isFavorite = isFavorite;
      });
    }
  }

  Future<void> toggleFavorite() async {
    final currentDoctor = doctor.value;
    if (currentDoctor == null || isFavoriteLoading.value) return;

    try {
      isFavoriteLoading.value = true;
      final wasFavorite = _favoritesController.isFavorite(currentDoctor.id);

      if (wasFavorite) {
        await _authRepo.removeFavorite(currentDoctor.id);
      } else {
        await _authRepo.addFavorite(currentDoctor.id);
      }

      _favoritesController.setFavoriteState(currentDoctor.id, !wasFavorite);
      _syncFavoriteStateFromSharedController();
    } catch (e) {
      _syncFavoriteStateFromSharedController();
      AppAlerts.showError(
        title: AppMessages.favoriteErrorTitle,
        message: AppMessages.favoriteUpdateError,
      );
    } finally {
      isFavoriteLoading.value = false;
    }
  }
}
