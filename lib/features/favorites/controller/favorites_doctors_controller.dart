// // import 'package:get/get.dart';
// // import '../../auth/data/models/DoctorModel.dart';
// // import '../../auth/repository/auth_repository.dart';
// //
// // class FavoritesDoctorsController extends GetxController {
// //   final AuthRepository _authRepo;
// //
// //   FavoritesDoctorsController(this._authRepo);
// //
// //   RxList<DoctorModel> favoriteDoctors = <DoctorModel>[].obs;
// //   var isLoading = true.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //
// //     fetchMyFavorites();
// //   }
// //
// //   @override
// //   void onReady() {
// //     super.onReady();
// //
// //     if (favoriteDoctors.isEmpty) {
// //       fetchMyFavorites();
// //     }
// //   }
// //
// //   Future<void> fetchMyFavorites() async {
// //     try {
// //       isLoading.value = true;
// //       final List<dynamic> response = await _authRepo.getMyFavorites();
// //
// //       final list = response.map((item) {
// //         final doctorJson = item['doctor'];
// //         doctorJson['isFavorite'] = true;
// //         return DoctorModel.fromJson(doctorJson);
// //       }).toList();
// //
// //       favoriteDoctors.assignAll(list);
// //     } catch (e) {
// //       print("Error fetching favorites: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   Future<void> removeFavorite(DoctorModel doctor) async {
// //     final int index = favoriteDoctors.indexOf(doctor);
// //     if (index == -1) return;
// //
// //     favoriteDoctors.removeAt(index);
// //
// //     try {
// //       await _authRepo.removeFavorite(doctor.id);
// //     } catch (e) {
// //       favoriteDoctors.insert(index, doctor);
// //       Get.snackbar("خطأ", "تعذرت الإزالة");
// //     }
// //   }
// //
// //   Future<void> toggleFavorite(DoctorModel doctor) async {
// //     final bool oldStatus = doctor.isFavorite;
// //     doctor.isFavorite = !oldStatus;
// //     favoriteDoctors.refresh();
// //
// //     try {
// //       if (oldStatus) {
// //         await _authRepo.removeFavorite(doctor.id);
// //       } else {
// //         await _authRepo.addFavorite(doctor.id);
// //       }
// //     } catch (e) {
// //       doctor.isFavorite = oldStatus;
// //       favoriteDoctors.refresh();
// //       Get.snackbar("خطأ", "حدث خطأ أثناء التحديث");
// //     }
// //   }
// // }
//
//
// import 'package:get/get.dart';
// import '../../auth/data/models/DoctorModel.dart';
// import '../../auth/repository/auth_repository.dart';
//
// // استيراد ملفات الرسائل والتنبيهات المركزية
// import '../../../core/constance/app_messages.dart';
// import '../../../core/constance/app_alerts.dart';
//
// class FavoritesDoctorsController extends GetxController {
//   final AuthRepository _authRepo;
//
//   FavoritesDoctorsController(this._authRepo);
//
//   RxList<DoctorModel> favoriteDoctors = <DoctorModel>[].obs;
//   var isLoading = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     fetchMyFavorites();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//
//     if (favoriteDoctors.isEmpty) {
//       fetchMyFavorites();
//     }
//   }
//
//   Future<void> fetchMyFavorites() async {
//     try {
//       isLoading.value = true;
//       final List<dynamic> response = await _authRepo.getMyFavorites();
//
//       final list = response.map((item) {
//         final doctorJson = item['doctor'];
//         doctorJson['isFavorite'] = true;
//         return DoctorModel.fromJson(doctorJson);
//       }).toList();
//
//       favoriteDoctors.assignAll(list);
//     } catch (e) {
//       print("Error fetching favorites: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> removeFavorite(DoctorModel doctor) async {
//     final int index = favoriteDoctors.indexOf(doctor);
//     if (index == -1) return;
//
//     favoriteDoctors.removeAt(index);
//
//     try {
//       await _authRepo.removeFavorite(doctor.id);
//     } catch (e) {
//       favoriteDoctors.insert(index, doctor);
//       AppAlerts.showError(
//         title: AppMessages.favoritesErrorTitle,
//         message: AppMessages.removeFavoriteError,
//       );
//     }
//   }
//
//   Future<void> toggleFavorite(DoctorModel doctor) async {
//     final bool oldStatus = doctor.isFavorite;
//     doctor.isFavorite = !oldStatus;
//     favoriteDoctors.refresh();
//
//     try {
//       if (oldStatus) {
//         await _authRepo.removeFavorite(doctor.id);
//       } else {
//         await _authRepo.addFavorite(doctor.id);
//       }
//     } catch (e) {
//       doctor.isFavorite = oldStatus;
//       favoriteDoctors.refresh();
//       AppAlerts.showError(
//         title: AppMessages.favoritesErrorTitle,
//         message: AppMessages.updateFavoriteError,
//       );
//     }
//   }
// }

import 'package:get/get.dart';

import '../../../core/constance/app_alerts.dart';
import '../../../core/constance/app_messages.dart';
import '../../auth/data/models/DoctorModel.dart';
import '../../auth/repository/auth_repository.dart';

class FavoritesDoctorsController extends GetxController {
  final AuthRepository _authRepo;

  FavoritesDoctorsController(this._authRepo);

  final favoriteDoctors = <DoctorModel>[].obs;
  final favoriteDoctorIds = <int>{}.obs;
  final isLoading = true.obs;

  bool isFavorite(int doctorId) => favoriteDoctorIds.contains(doctorId);

  @override
  void onInit() {
    super.onInit();
    fetchMyFavorites();
  }

  @override
  void onReady() {
    super.onReady();
    fetchMyFavorites();
  }

  Future<void> fetchMyFavorites() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.getMyFavorites();
      final doctors = response.map<DoctorModel>((item) {
        final doctorJson = Map<String, dynamic>.from(item['doctor'] as Map);
        doctorJson['isFavorite'] = true;
        return DoctorModel.fromJson(doctorJson);
      }).toList();

      favoriteDoctors.assignAll(doctors);
      favoriteDoctorIds.assignAll(doctors.map((doctor) => doctor.id));
    } catch (e) {
      Get.log('Error fetching favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setFavoriteState(int doctorId, bool isFavorite) {
    if (isFavorite) {
      favoriteDoctorIds.add(doctorId);
    } else {
      favoriteDoctorIds.remove(doctorId);
    }
  }

  Future<void> removeFavorite(DoctorModel doctor) async {
    final index = favoriteDoctors.indexOf(doctor);
    if (index == -1) return;

    favoriteDoctors.removeAt(index);
    try {
      await _authRepo.removeFavorite(doctor.id);
      setFavoriteState(doctor.id, false);
    } catch (e) {
      favoriteDoctors.insert(index, doctor);
      AppAlerts.showError(
        title: AppMessages.favoritesErrorTitle,
        message: AppMessages.removeFavoriteError,
      );
    }
  }

  Future<void> toggleFavorite(DoctorModel doctor) async {
    final wasFavorite = isFavorite(doctor.id);
    doctor.isFavorite = !wasFavorite;
    favoriteDoctors.refresh();

    try {
      if (wasFavorite) {
        await _authRepo.removeFavorite(doctor.id);
      } else {
        await _authRepo.addFavorite(doctor.id);
      }
      setFavoriteState(doctor.id, !wasFavorite);
    } catch (e) {
      doctor.isFavorite = wasFavorite;
      favoriteDoctors.refresh();
      AppAlerts.showError(
        title: AppMessages.favoritesErrorTitle,
        message: AppMessages.updateFavoriteError,
      );
    }
  }
}
