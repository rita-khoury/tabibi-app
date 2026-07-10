import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../core/services/doctor_service.dart';
import '../../../features/auth/repository/auth_repository.dart';

class HomeController extends GetxController {
  final DoctorService _service = DoctorService();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  List<DoctorModel> _allDoctorsCache = [];

  var topDoctors = <DoctorModel>[].obs;
  var filteredDoctors = <DoctorModel>[].obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadData();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('auth_token') != null;
  }

  Future<void> handleAuthAction() async {
    if (isLoggedIn.value) {
      await _authRepository.logout();
      isLoggedIn.value = false;
      Get.snackbar(
        "Logout",
        "Logged out successfully",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      Get.offAllNamed('/home');
    } else {
      await Get.toNamed('/login');
      await checkLoginStatus();
    }
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final rawData = await _service.getAll();
      _allDoctorsCache = rawData.map((e) => DoctorModel.fromJson(e)).toList();
      topDoctors.assignAll(_allDoctorsCache.where((doc) => doc.averageRating >= 4.8).toList());
      filteredDoctors.assignAll(topDoctors);
    } catch (e) {
      Get.snackbar("Error", "Failed to load data: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void searchDoctor(String query) {
    isSearching.value = query.isNotEmpty;
    if (query.isEmpty) {
      filteredDoctors.assignAll(topDoctors);
    } else {
      filteredDoctors.assignAll(_allDoctorsCache.where((doc) =>
      doc.name.toLowerCase().contains(query.toLowerCase()) ||
          doc.specialization.toLowerCase().contains(query.toLowerCase())
      ).toList());
    }
  }
}