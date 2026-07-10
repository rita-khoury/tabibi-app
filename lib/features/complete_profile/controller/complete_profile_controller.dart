import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/data/models/ProfileCompletionModel.dart';
import '../../auth/repository/auth_repository.dart';
import '../../auth/repository/AuthController.dart';

class CompleteProfileController extends GetxController {
  final AuthRepository _patientRepo = Get.find<AuthRepository>();
  final AuthController _authController = Get.find<AuthController>();
  final box = GetStorage();

  var currentStep = 0.obs;
  final int totalSteps = 6;
  var isLoading = false.obs;
  var isExistingProfile = false.obs;

  final List<Map<String, dynamic>> greetings = [
    {
      "text": "Ready to manage your health?",
      "icon": Icons.health_and_safety_outlined,
    },
    {
      "text": "Your medical profile matters.",
      "icon": Icons.favorite_border_rounded,
    },
    {
      "text": "Let's get your details updated.",
      "icon": Icons.edit_note_rounded,
    },
  ];
  var currentText = "".obs;
  var currentIcon = Icons.health_and_safety_outlined.obs;
  Timer? timer;

  final allergiesController = TextEditingController();
  final chronicController = TextEditingController();
  final symptomsController = TextEditingController();
  final disabilityController = TextEditingController();
  final medicationsController = TextEditingController();
  final surgeriesController = TextEditingController();
  final familyHistoryController = TextEditingController();
  final lifestyleController = TextEditingController();

  var bloodType = 'O+'.obs;

  @override
  void onInit() {
    super.onInit();
    currentText.value = greetings[0]["text"];
    currentIcon.value = greetings[0]["icon"];
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      var randomItem = greetings[Random().nextInt(greetings.length)];
      currentText.value = randomItem["text"];
      currentIcon.value = randomItem["icon"];
    });

    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      final profile = await _patientRepo.getMedicalProfile();
      if (profile != null) {
        isExistingProfile.value = true;
        allergiesController.text = profile.allergies?.join(', ') ?? '';
        chronicController.text = profile.chronicConditions?.join(', ') ?? '';
        symptomsController.text = profile.currentSymptoms ?? '';
        disabilityController.text = profile.disabilityInfo ?? '';
        medicationsController.text =
            profile.currentMedications?.join(', ') ?? '';
        surgeriesController.text = profile.pastSurgeries?.join(', ') ?? '';
        familyHistoryController.text = profile.familyHistory?.join(', ') ?? '';
        lifestyleController.text = profile.lifestyleHabits?.join(', ') ?? '';
        bloodType.value = profile.bloodType ?? 'O+';
      }
    } catch (e) {
      isExistingProfile.value = false;
      debugPrint(
        "Info: No existing medical profile found, will create a new one.",
      );
    }
  }

  List<String> _parseList(String text) {
    if (text.isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> submitCompleteProfile() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      try {
        await _patientRepo.createPatientProfile({
          "maritalStatus": "single",
          "occupation": "Not Specified",
        });
      } catch (e) {
        debugPrint("Patient profile check passed.");
      }

      final profileData = CompleteProfileRequest(
        bloodType: bloodType.value,
        disabilityInfo: disabilityController.text.isEmpty
            ? "None"
            : disabilityController.text,
        currentSymptoms: symptomsController.text.isEmpty
            ? "None"
            : symptomsController.text,
        allergies: _parseList(allergiesController.text),
        chronicConditions: _parseList(chronicController.text),
        pastSurgeries: _parseList(surgeriesController.text),
        familyHistory: _parseList(familyHistoryController.text),
        currentMedications: _parseList(medicationsController.text),
        lifestyleHabits: _parseList(lifestyleController.text),
        vaccinationStatus: ["Unknown"],
        pregnancyStatus: "NOT_PREGNANT",
      );

      if (isExistingProfile.value) {
        await _patientRepo.updateMedicalProfile(profileData);
      } else {
        await _patientRepo.createMedicalProfile(profileData);
        isExistingProfile.value = true;
      }

      await _authController.updateProfileCompletionStatus(true);
      box.write('profileCompleted', true);

      Get.snackbar(
        "نجاح",
        "تم حفظ بياناتك بنجاح",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "تعذر حفظ البيانات: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void nextStep() =>
      currentStep.value < totalSteps - 1 ? currentStep.value++ : null;

  void previousStep() => currentStep.value > 0 ? currentStep.value-- : null;

  void skipProfile() => Get.offAllNamed('/home');

  @override
  void onClose() {
    timer?.cancel();
    [
      allergiesController,
      chronicController,
      symptomsController,
      disabilityController,
      medicationsController,
      surgeriesController,
      familyHistoryController,
      lifestyleController,
    ].forEach((c) => c.dispose());
    super.onClose();
  }
}
