// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../auth/data/models/LookupModel.dart';
// import '../../auth/data/models/ProfileCompletionModel.dart';
// import '../../auth/repository/auth_repository.dart';
// import '../../auth/repository/AuthController.dart';
//
// class CompleteProfileController extends GetxController {
//   final AuthRepository _patientRepo = Get.find<AuthRepository>();
//   final AuthController _authController = Get.find<AuthController>();
//   final box = GetStorage();
//
//   var currentStep = 0.obs;
//   final int totalSteps = 6;
//   var isLoading = false.obs;
//   var isExistingProfile = false.obs;
//
//   final List<Map<String, dynamic>> greetings = [
//     {
//       "text": "Ready to manage your health?",
//       "icon": Icons.health_and_safety_outlined,
//     },
//     {
//       "text": "Your medical profile matters.",
//       "icon": Icons.favorite_border_rounded,
//     },
//     {
//       "text": "Let's get your details updated.",
//       "icon": Icons.edit_note_rounded,
//     },
//   ];
//
//   var currentText = "".obs;
//   var currentIcon = Icons.health_and_safety_outlined.obs;
//   Timer? timer;
//
//   var bloodTypes = <LookupModel>[].obs;
//   var allergyList = <LookupModel>[].obs;
//   var chronicList = <LookupModel>[].obs;
//   var surgeryList = <LookupModel>[].obs;
//   var medicationList = <LookupModel>[].obs;
//
//   var bloodType = 'O+'.obs;
//   var selectedAllergies = <String>[].obs;
//   var selectedChronic = <String>[].obs;
//   var selectedSurgeries = <String>[].obs;
//   var selectedMedications = <String>[].obs;
//
//   final symptomsController = TextEditingController();
//   final disabilityController = TextEditingController();
//   final familyHistoryController = TextEditingController();
//   final lifestyleController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     currentText.value = greetings[0]["text"];
//     currentIcon.value = greetings[0]["icon"];
//     timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       var randomItem = greetings[Random().nextInt(greetings.length)];
//       currentText.value = randomItem["text"];
//       currentIcon.value = randomItem["icon"];
//     });
//
//     loadLookups();
//     loadProfileData();
//   }
//
//   Future<void> loadLookups() async {
//     try {
//       try {
//         final bloodData = await _patientRepo.getLookupsByCategory('BLOOD_TYPE');
//         bloodTypes.value = bloodData
//             .map((e) => LookupModel.fromJson(e))
//             .toList();
//       } catch (e) {
//         debugPrint("خطأ في فصائل الدم: $e");
//       }
//
//       try {
//         final allergyData = await _patientRepo.getLookupsByCategory('ALLERGY');
//         allergyList.value = allergyData
//             .map((e) => LookupModel.fromJson(e))
//             .toList();
//       } catch (e) {
//         debugPrint("خطأ في الحساسية: $e");
//       }
//
//       try {
//         final chronicData = await _patientRepo.getLookupsByCategory(
//           'CHRONIC_CONDITIONS',
//         );
//         chronicList.value = chronicData
//             .map((e) => LookupModel.fromJson(e))
//             .toList();
//       } catch (e) {
//         debugPrint("خطأ في الأمراض المزمنة: $e");
//       }
//
//       try {
//         final surgeryData = await _patientRepo.getLookupsByCategory(
//           'COMMON_SURGERIES',
//         );
//         surgeryList.value = surgeryData
//             .map((e) => LookupModel.fromJson(e))
//             .toList();
//       } catch (e) {
//         debugPrint("خطأ في العمليات الجراحية: $e");
//       }
//
//       medicationList.clear();
//
//       debugPrint("✅ تم محاولة جلب القوائم المتاحة");
//     } catch (e) {
//       debugPrint("❌ تفاصيل خطأ الـ Lookups العام: $e");
//     }
//   }
//
//   Future<void> loadProfileData() async {
//     try {
//       final profile = await _patientRepo.getMedicalProfile();
//       if (profile != null) {
//         isExistingProfile.value = true;
//         bloodType.value = profile.bloodType ?? 'O+';
//
//         if (profile.allergies != null) {
//           selectedAllergies.value = List<String>.from(profile.allergies!);
//         }
//         if (profile.chronicConditions != null) {
//           selectedChronic.value = List<String>.from(profile.chronicConditions!);
//         }
//         if (profile.pastSurgeries != null) {
//           selectedSurgeries.value = List<String>.from(profile.pastSurgeries!);
//         }
//         if (profile.currentMedications != null) {
//           selectedMedications.value = List<String>.from(
//             profile.currentMedications!,
//           );
//         }
//
//         symptomsController.text = profile.currentSymptoms ?? '';
//         disabilityController.text = profile.disabilityInfo ?? '';
//         familyHistoryController.text = profile.familyHistory?.join(', ') ?? '';
//         lifestyleController.text = profile.lifestyleHabits?.join(', ') ?? '';
//       }
//     } catch (e) {
//       isExistingProfile.value = false;
//       debugPrint(
//         "Info: No existing medical profile found, will create a new one.",
//       );
//     }
//   }
//
//   List<String> _parseList(String text) {
//     if (text.isEmpty) return [];
//     return text
//         .split(',')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .toList();
//   }
//
//   Future<void> submitCompleteProfile() async {
//     if (isLoading.value) return;
//
//     isLoading.value = true;
//     try {
//       try {
//         await _patientRepo.createPatientProfile({
//           "maritalStatus": "single",
//           "occupation": "Not Specified",
//         });
//       } catch (e) {
//         debugPrint("Patient profile check passed.");
//       }
//
//       final profileData = CompleteProfileRequest(
//         bloodType: bloodType.value,
//         disabilityInfo: disabilityController.text.isEmpty
//             ? "None"
//             : disabilityController.text,
//         currentSymptoms: symptomsController.text.isEmpty
//             ? "None"
//             : symptomsController.text,
//         allergies: selectedAllergies.toList(),
//         chronicConditions: selectedChronic.toList(),
//         pastSurgeries: selectedSurgeries.toList(),
//         currentMedications: selectedMedications.toList(),
//         familyHistory: _parseList(familyHistoryController.text),
//         lifestyleHabits: _parseList(lifestyleController.text),
//         vaccinationStatus: ["Unknown"],
//         pregnancyStatus: "NOT_PREGNANT",
//       );
//
//       if (isExistingProfile.value) {
//         await _patientRepo.updateMedicalProfile(profileData);
//       } else {
//         await _patientRepo.createMedicalProfile(profileData);
//         isExistingProfile.value = true;
//       }
//
//       await _authController.updateProfileCompletionStatus(true);
//       box.write('profileCompleted', true);
//
//       Get.snackbar(
//         "نجاح",
//         "تم حفظ بياناتك بنجاح",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       Get.offAllNamed('/home');
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         "تعذر حفظ البيانات: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void nextStep() =>
//       currentStep.value < totalSteps - 1 ? currentStep.value++ : null;
//
//   void previousStep() => currentStep.value > 0 ? currentStep.value-- : null;
//
//   void skipProfile() => Get.offAllNamed('/home');
//
//   @override
//   void onClose() {
//     timer?.cancel();
//     symptomsController.dispose();
//     disabilityController.dispose();
//     familyHistoryController.dispose();
//     lifestyleController.dispose();
//     super.onClose();
//   }
// }


import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/data/models/LookupModel.dart';
import '../../auth/data/models/ProfileCompletionModel.dart';
import '../../auth/repository/auth_repository.dart';
import '../../auth/repository/AuthController.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

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

  var bloodTypes = <LookupModel>[].obs;
  var allergyList = <LookupModel>[].obs;
  var chronicList = <LookupModel>[].obs;
  var surgeryList = <LookupModel>[].obs;
  var medicationList = <LookupModel>[].obs;

  var bloodType = 'O+'.obs;
  var selectedAllergies = <String>[].obs;
  var selectedChronic = <String>[].obs;
  var selectedSurgeries = <String>[].obs;
  var selectedMedications = <String>[].obs;

  final symptomsController = TextEditingController();
  final disabilityController = TextEditingController();
  final familyHistoryController = TextEditingController();
  final lifestyleController = TextEditingController();

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

    loadLookups();
    loadProfileData();
  }

  Future<void> loadLookups() async {
    try {
      try {
        final bloodData = await _patientRepo.getLookupsByCategory('BLOOD_TYPE');
        bloodTypes.value = bloodData
            .map((e) => LookupModel.fromJson(e))
            .toList();
      } catch (e) {
        debugPrint("خطأ في فصائل الدم: $e");
      }

      try {
        final allergyData = await _patientRepo.getLookupsByCategory('ALLERGY');
        allergyList.value = allergyData
            .map((e) => LookupModel.fromJson(e))
            .toList();
      } catch (e) {
        debugPrint("خطأ في الحساسية: $e");
      }

      try {
        final chronicData = await _patientRepo.getLookupsByCategory(
          'CHRONIC_CONDITIONS',
        );
        chronicList.value = chronicData
            .map((e) => LookupModel.fromJson(e))
            .toList();
      } catch (e) {
        debugPrint("خطأ في الأمراض المزمنة: $e");
      }

      try {
        final surgeryData = await _patientRepo.getLookupsByCategory(
          'COMMON_SURGERIES',
        );
        surgeryList.value = surgeryData
            .map((e) => LookupModel.fromJson(e))
            .toList();
      } catch (e) {
        debugPrint("خطأ في العمليات الجراحية: $e");
      }

      medicationList.clear();

      debugPrint("✅ تم محاولة جلب القوائم المتاحة");
    } catch (e) {
      debugPrint("❌ تفاصيل خطأ الـ Lookups العام: $e");
    }
  }

  Future<void> loadProfileData() async {
    try {
      final profile = await _patientRepo.getMedicalProfile();
      if (profile != null) {
        isExistingProfile.value = true;
        bloodType.value = profile.bloodType ?? 'O+';

        if (profile.allergies != null) {
          selectedAllergies.value = List<String>.from(profile.allergies!);
        }
        if (profile.chronicConditions != null) {
          selectedChronic.value = List<String>.from(profile.chronicConditions!);
        }
        if (profile.pastSurgeries != null) {
          selectedSurgeries.value = List<String>.from(profile.pastSurgeries!);
        }
        if (profile.currentMedications != null) {
          selectedMedications.value = List<String>.from(
            profile.currentMedications!,
          );
        }

        symptomsController.text = profile.currentSymptoms ?? '';
        disabilityController.text = profile.disabilityInfo ?? '';
        familyHistoryController.text = profile.familyHistory?.join(', ') ?? '';
        lifestyleController.text = profile.lifestyleHabits?.join(', ') ?? '';
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
        allergies: selectedAllergies.toList(),
        chronicConditions: selectedChronic.toList(),
        pastSurgeries: selectedSurgeries.toList(),
        currentMedications: selectedMedications.toList(),
        familyHistory: _parseList(familyHistoryController.text),
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

      AppAlerts.showSuccess(
        title: AppMessages.profileSaveSuccessTitle,
        message: AppMessages.profileSaveSuccessBody,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.profileSaveErrorTitle,
        message: "${AppMessages.profileSaveErrorBody}$e",
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
    symptomsController.dispose();
    disabilityController.dispose();
    familyHistoryController.dispose();
    lifestyleController.dispose();
    super.onClose();
  }
}