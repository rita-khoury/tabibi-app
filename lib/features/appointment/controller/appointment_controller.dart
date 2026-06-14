import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';

class AppointmentController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  DateTime today = DateTime.now();
  String selectedDate = DateTime.now().day.toString();
  String selectedPeriod = 'Morning';
  String selectedType = 'Consultation';
  bool showTermsDialog = true;


  void toggleShowTerms(bool? value) {
    showTermsDialog = value ?? true;
    update();
  }

  List<DateTime> get nextDays =>
      List.generate(5, (i) => today.add(Duration(days: i)));

  void selectDate(String date) {
    selectedDate = date;
    update();
  }

  void selectPeriod(String value) {
    selectedPeriod = value;
    update();
  }

  void selectType(String value) {
    selectedType = value;
    update();
  }

  Future<void> confirmAndPlaySound() async {
    // تم ضبط الـ Snackbar لتختفي بسرعة فائقة (نصف ثانية)
    Get.snackbar(
      "Success",
      "100 S.P has been deducted from your account.",
      backgroundColor: AppColors.primaryBlue,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 100), // ظهور لحظي
      duration: const Duration(milliseconds: 500),         // اختفاء بعد نصف ثانية
      margin: EdgeInsets.zero,
    );

    try {
      await _audioPlayer.play(AssetSource('sounds/notification_sound.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}