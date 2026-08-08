// import 'package:get/get.dart';
// import '../../auth/data/models/DoctorModel.dart';
// import '../../auth/repository/auth_repository.dart';
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
//       Get.snackbar("خطأ", "تعذرت الإزالة");
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
//       Get.snackbar("خطأ", "حدث خطأ أثناء التحديث");
//     }
//   }
// }


import 'package:get/get.dart';
import '../../auth/data/models/DoctorModel.dart';
import '../../auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class FavoritesDoctorsController extends GetxController {
  final AuthRepository _authRepo;

  FavoritesDoctorsController(this._authRepo);

  RxList<DoctorModel> favoriteDoctors = <DoctorModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    fetchMyFavorites();
  }

  @override
  void onReady() {
    super.onReady();

    if (favoriteDoctors.isEmpty) {
      fetchMyFavorites();
    }
  }

  Future<void> fetchMyFavorites() async {
    try {
      isLoading.value = true;
      final List<dynamic> response = await _authRepo.getMyFavorites();

      final list = response.map((item) {
        final doctorJson = item['doctor'];
        doctorJson['isFavorite'] = true;
        return DoctorModel.fromJson(doctorJson);
      }).toList();

      favoriteDoctors.assignAll(list);
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(DoctorModel doctor) async {
    final int index = favoriteDoctors.indexOf(doctor);
    if (index == -1) return;

    favoriteDoctors.removeAt(index);

    try {
      await _authRepo.removeFavorite(doctor.id);
    } catch (e) {
      favoriteDoctors.insert(index, doctor);
      AppAlerts.showError(
        title: AppMessages.favoritesErrorTitle,
        message: AppMessages.removeFavoriteError,
      );
    }
  }

  Future<void> toggleFavorite(DoctorModel doctor) async {
    final bool oldStatus = doctor.isFavorite;
    doctor.isFavorite = !oldStatus;
    favoriteDoctors.refresh();

    try {
      if (oldStatus) {
        await _authRepo.removeFavorite(doctor.id);
      } else {
        await _authRepo.addFavorite(doctor.id);
      }
    } catch (e) {
      doctor.isFavorite = oldStatus;
      favoriteDoctors.refresh();
      AppAlerts.showError(
        title: AppMessages.favoritesErrorTitle,
        message: AppMessages.updateFavoriteError,
      );
    }
  }
}