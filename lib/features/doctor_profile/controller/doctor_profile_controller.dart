// import 'package:get/get.dart';
// import '../../../features/auth/data/models/DoctorModel.dart';
//
// class DoctorProfileController extends GetxController {
//   var doctor = Rxn<DoctorModel>();
//   var isLoading = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     if (Get.arguments is DoctorModel) {
//       doctor.value = Get.arguments as DoctorModel;
//       isLoading.value = false;
//     }
//     else if (Get.arguments is Map<String, dynamic>) {
//       final Map<String, dynamic> data = Get.arguments;
//       doctor.value = DoctorModel.fromJson(data);
//       isLoading.value = false;
//     }
//
//     else {
//       // fetchDoctorById(...);
//     }
//   }
// }

import 'package:get/get.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../features/auth/repository/auth_repository.dart';

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

  void _initializeDoctor() {
    isLoading.value = true;

    if (Get.arguments is DoctorModel) {
      doctor.value = Get.arguments as DoctorModel;
    } else if (Get.arguments is Map<String, dynamic>) {
      doctor.value = DoctorModel.fromJson(Get.arguments);
    } else {}

    isLoading.value = false;
  }

  Future<void> toggleFavorite() async {
    if (doctor.value == null) return;

    try {
      isFavoriteLoading.value = true;

      final bool currentStatus = doctor.value!.isFavorite;
      final int doctorId = doctor.value!.id;

      if (currentStatus) {
        await _authRepo.removeFavorite(doctorId);
      } else {
        await _authRepo.addFavorite(doctorId);
      }

      doctor.update((val) {
        val?.isFavorite = !currentStatus;
      });
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "تعذر تحديث المفضلة",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFavoriteLoading.value = false;
    }
  }
}