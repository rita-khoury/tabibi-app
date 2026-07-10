import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../auth/data/models/DoctorModel.dart';
import '../../auth/repository/auth_repository.dart';

class FavoritesDoctorsController extends GetxController {
  final AuthRepository _authRepo;

  FavoritesDoctorsController(this._authRepo);

  RxList<DoctorModel> favoriteDoctors = <DoctorModel>[].obs;
  var isLoading = true.obs;
  var isActionLoading = false.obs;

  @override
  void onInit() {
    fetchMyFavorites();
    super.onInit();
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
      Get.snackbar("خطأ", "فشل جلب قائمة المفضلات");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(DoctorModel doctor) async {
    try {
      isActionLoading.value = true;
      bool oldStatus = doctor.isFavorite;

      doctor.isFavorite = !oldStatus;

      favoriteDoctors.refresh();

      if (oldStatus) {
        await _authRepo.removeFavorite(doctor.id);
      } else {
        await _authRepo.addFavorite(doctor.id);
      }

      Get.snackbar("نجاح", "تم تحديث المفضلة");
    } catch (e) {
      doctor.isFavorite = !doctor.isFavorite;
      favoriteDoctors.refresh();

      print("خطأ: $e");
      Get.snackbar("خطأ", "تعذر التحديث");
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> removeFavorite(DoctorModel doctor) async {
    try {
      await _authRepo.removeFavorite(doctor.id);
      favoriteDoctors.removeWhere((item) => item.id == doctor.id);
      Get.snackbar("نجاح", "تمت إزالة الطبيب");
    } catch (e) {
      Get.snackbar("خطأ", "فشلت عملية الإزالة");
    }
  }
}
