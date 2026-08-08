// import 'package:get/get.dart';
// import '../../../features/auth/data/models/DoctorModel.dart';
// import '../../../features/auth/repository/auth_repository.dart';
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
//       Get.snackbar(
//         "خطأ",
//         "تعذر تحديث القائمة المفضلة، يرجى المحاولة لاحقاً",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isFavoriteLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../features/auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class DoctorProfileController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  var doctor = Rxn<DoctorModel>();
  var isLoading = true.obs;
  var isFavoriteLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDoctor();
  }

  Future<void> _initializeDoctor() async {
    isLoading.value = true;

    if (Get.arguments is DoctorModel) {
      doctor.value = Get.arguments as DoctorModel;
    } else if (Get.arguments is Map<String, dynamic>) {
      doctor.value = DoctorModel.fromJson(Get.arguments);
    } else if (Get.parameters['doctorId'] != null) {
      int id = int.parse(Get.parameters['doctorId']!);
      doctor.value = await _authRepo.getDoctorById(id);
    }

    isLoading.value = false;
  }

  Future<void> toggleFavorite() async {
    final currentDoctor = doctor.value;
    if (currentDoctor == null) return;

    try {
      isFavoriteLoading.value = true;

      final bool wasFavorite = currentDoctor.isFavorite;
      final int doctorId = currentDoctor.id;

      if (wasFavorite) {
        await _authRepo.removeFavorite(doctorId);
      } else {
        await _authRepo.addFavorite(doctorId);
      }

      doctor.update((val) {
        val?.isFavorite = !wasFavorite;
      });
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.favoriteErrorTitle,
        message: AppMessages.favoriteUpdateError,
      );
    } finally {
      isFavoriteLoading.value = false;
    }
  }
}