import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../auth/repository/auth_repository.dart';

class AppointmentsController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  var upcomingAppointments = <dynamic>[].obs;
  var completedAppointments = <dynamic>[].obs;
  var canceledAppointments = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final all = await _repo.getMyAppointments();

      upcomingAppointments.value = all
          .where((a) => a['status'] == 'UPCOMING')
          .toList();
      completedAppointments.value = all
          .where((a) => a['status'] == 'COMPLETED')
          .toList();
      canceledAppointments.value = all
          .where((a) => a['status'] == 'CANCELLED')
          .toList();
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تحميل المواعيد: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointmentById(int id) async {
    try {
      await _repo.cancelAppointment(id, "User cancelled");
      Get.snackbar(
        "نجاح",
        "تم إلغاء الموعد بنجاح",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchAppointments();
    } catch (e) {
      Get.snackbar("خطأ", "فشل الإلغاء: ${e.toString()}");
    }
  }

  Future<void> completeAppointmentById(int id) async {
    try {
      await _repo.completeAppointment(id);
      Get.snackbar("نجاح", "تم إكمال الموعد");
      await fetchAppointments();
    } catch (e) {
      Get.snackbar("خطأ", "فشل إكمال الموعد: ${e.toString()}");
    }
  }
}
