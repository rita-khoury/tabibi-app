import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/data/models/CreateAppointmentModel.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

class AppointmentController extends GetxController {
  var dontShowAgain = false.obs;

  @override
  void onInit() {
    super.onInit();
    dontShowAgain.value = GetStorage().read('hideTerms') ?? false;
  }

  void saveTermsPreference() {
    GetStorage().write('hideTerms', dontShowAgain.value);
  }

  final AuthRepository _repo = Get.find<AuthRepository>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  RxBool isLoading = false.obs;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedPeriod = "Morning";

  final List<String> appointmentTypes = [
    "Advice",
    "Follow-up",
    "NORMAL",
    "Initial Visit",
  ];

  String selectedType = "Initial Visit";

  bool showTermsDialog = true;

  List<DateTime> get nextDays =>
      List.generate(5, (i) => DateTime.now().add(Duration(days: i)));

  void selectDate(DateTime date) {
    selectedDate = date;
    update();
  }

  void selectPeriod(String period) {
    selectedPeriod = period;
    update();
  }

  void selectType(String type) {
    selectedType = type;
    update();
  }

  String _getStartTime() {
    switch (selectedPeriod) {
      case "Morning":
        return "10:00:00";
      case "Afternoon":
        return "13:00:00";
      case "Evening":
        return "17:00:00";
      default:
        return "10:00:00";
    }
  }

  String _getEndTime() {
    String startTime = _getStartTime();
    DateTime start = DateFormat("HH:mm:ss").parse(startTime);

    int duration;

    switch (selectedType) {
      case "Advice":
        duration = 20;
        break;
      case "Follow-up":
        duration = 20;
        break;
      case "NORMAL":
        duration = 20;
        break;
      case "Initial Visit":
        duration = 30;
        break;
      default:
        duration = 30;
    }

    DateTime end = start.add(Duration(minutes: duration));
    return DateFormat("HH:mm:ss").format(end);
  }

  Future<void> submitAppointment({
    required int doctorId,
    required int clinicId,
  }) async {
    isLoading.value = true;

    try {
      final completion = await _repo.getCompletionStatus();

      if (!completion.completed) {
        Get.snackbar(
          "تنبيه",
          "يجب إكمال الملف الطبي أولاً",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final appointment = CreateAppointmentModel(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: DateFormat("yyyy-MM-dd").format(selectedDate),
        startTime: _getStartTime(),
        endTime: _getEndTime(),
        type: selectedType,
        priority: "1",
        reasonForVisit: "General checkup",
      );

      debugPrint("🚀 APPOINTMENT REQUEST: ${appointment.toJson()}");

      final success = await _repo.createAppointment(appointment);

      if (success) {
        await playSuccessEffect();
      }
    } on DioException catch (e) {
      debugPrint("❌ SERVER ERROR: ${e.response?.data}");
      Get.snackbar(
        "خطأ",
        e.response?.data['message']?.toString() ?? "حدث خطأ في الاتصال",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ ERROR: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ غير متوقع",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playSuccessEffect() async {
    Get.snackbar(
      "نجاح",
      "تم إنشاء الموعد بنجاح",
      backgroundColor: AppColors.primaryBlue,
      colorText: Colors.white,
    );
    await _audioPlayer.play(AssetSource("sounds/notification_sound.mp3"));
  }
}
