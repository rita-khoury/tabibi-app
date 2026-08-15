// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../../features/auth/data/models/DoctorModel.dart';
// // import '../../../core/services/doctor_service.dart';
// // import '../../../features/auth/repository/auth_repository.dart';
// // import '../../auth/data/models/LookupModel.dart';
// //
// // class HomeController extends GetxController {
// //   final DoctorService _service = DoctorService();
// //   final AuthRepository _authRepository = Get.find<AuthRepository>();
// //
// //   List<DoctorModel> _allDoctorsCache = [];
// //   var specialities = <LookupModel>[].obs;
// //   var topDoctors = <DoctorModel>[].obs;
// //   var filteredDoctors = <DoctorModel>[].obs;
// //   var isSearching = false.obs;
// //   var isLoading = true.obs;
// //   var isLoggedIn = false.obs;
// //
// //   var activeAppointmentId = RxnInt();
// //
// //   var referralsCount = 0.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     checkLoginStatus();
// //     loadData();
// //     loadSpecialities();
// //     checkActiveQueueStatus();
// //   }
// //
// //   Future<void> checkLoginStatus() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     isLoggedIn.value = prefs.getString('auth_token') != null;
// //     if (isLoggedIn.value) {
// //       checkActiveQueueStatus();
// //       //fetchReferralsCount();
// //     } else {
// //       activeAppointmentId.value = null;
// //       referralsCount.value = 0;
// //     }
// //   }
// //
// //   // Future<void> fetchReferralsCount() async {
// //   //   try {
// //   //     final count = await _authRepository.getReferralsCount();
// //   //     if (count != null) {
// //   //       referralsCount.value = int.tryParse(count.toString()) ?? 0;
// //   //     }
// //   //   } catch (e) {
// //   //     print("خطأ في جلب عدد التحويلات: $e");
// //   //   }
// //   // }
// //
// //   Future<void> handleAuthAction() async {
// //     if (isLoggedIn.value) {
// //       await _authRepository.logout();
// //       isLoggedIn.value = false;
// //       activeAppointmentId.value = null;
// //       referralsCount.value = 0;
// //       Get.snackbar(
// //         "Logout",
// //         "Logged out successfully",
// //         backgroundColor: Colors.blue,
// //         colorText: Colors.white,
// //       );
// //       Get.offAllNamed('/home');
// //     } else {
// //       await Get.toNamed('/login');
// //       await checkLoginStatus();
// //     }
// //   }
// //
// //   Future<void> loadData() async {
// //     try {
// //       isLoading.value = true;
// //       final rawData = await _service.getAll();
// //       _allDoctorsCache = rawData.map((e) => DoctorModel.fromJson(e)).toList();
// //       topDoctors.assignAll(
// //         _allDoctorsCache.where((doc) => doc.averageRating >= 4.8).toList(),
// //       );
// //       filteredDoctors.assignAll(topDoctors);
// //     } catch (e) {
// //       Get.snackbar("Error", "Failed to load data: ${e.toString()}");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   Future<void> loadSpecialities() async {
// //     try {
// //       final data = await _authRepository.getLookupsByCategory(
// //         'MEDICAL_SPECIALTY',
// //       );
// //       if (data != null) {
// //         specialities.assignAll(
// //           data.map((e) => LookupModel.fromJson(e)).toList(),
// //         );
// //       }
// //     } catch (e) {
// //       print("خطأ في جلب التخصصات: $e");
// //       Get.snackbar("خطأ", "تعذر تحميل التخصصات");
// //     }
// //   }
// //
// //   Future<void> checkActiveQueueStatus() async {
// //     try {
// //       final response = await _authRepository.getActiveCheckedInAppointment();
// //       print("API Response for Active Appointment: $response"); // طباعة الرد كاملاً للتاكد
// //
// //       if (response != null && response['appointmentId'] != null) {
// //         activeAppointmentId.value = int.tryParse(
// //           response['appointmentId'].toString(),
// //         );
// //         print("Active Appointment ID is set to: ${activeAppointmentId.value}");
// //       } else {
// //         activeAppointmentId.value = null;
// //         print("No active appointment found, set to null");
// //       }
// //     } catch (e) {
// //       print("Error checking active queue: $e");
// //       activeAppointmentId.value = null;
// //     }
// //   }
// //   void searchDoctor(String query) {
// //     isSearching.value = query.isNotEmpty;
// //     if (query.isEmpty) {
// //       filteredDoctors.assignAll(topDoctors);
// //     } else {
// //       filteredDoctors.assignAll(
// //         _allDoctorsCache
// //             .where(
// //               (doc) =>
// //                   doc.name.toLowerCase().contains(query.toLowerCase()) ||
// //                   doc.specialization.toLowerCase().contains(
// //                     query.toLowerCase(),
// //                   ),
// //             )
// //             .toList(),
// //       );
// //     }
// //   }
// //
// //   void filterDoctorsBySpeciality(String specialityName) {
// //     isSearching.value = true;
// //     filteredDoctors.assignAll(
// //       _allDoctorsCache
// //           .where(
// //             (doc) =>
// //                 doc.specialization.toLowerCase() ==
// //                 specialityName.toLowerCase(),
// //           )
// //           .toList(),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../features/auth/data/models/DoctorModel.dart';
// import '../../../core/services/doctor_service.dart';
// import '../../../features/auth/repository/auth_repository.dart';
// import '../../auth/data/models/LookupModel.dart';
//
// // استيراد ملفات الرسائل والتنبيهات المركزية
// import '../../../core/constance/app_messages.dart';
// import '../../../core/constance/app_alerts.dart';
//
// class HomeController extends GetxController {
//   final DoctorService _service = DoctorService();
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//
//   List<DoctorModel> _allDoctorsCache = [];
//   var specialities = <LookupModel>[].obs;
//   var topDoctors = <DoctorModel>[].obs;
//   var filteredDoctors = <DoctorModel>[].obs;
//   var isSearching = false.obs;
//   var isLoading = true.obs;
//   var isLoggedIn = false.obs;
//
//   var activeAppointmentId = RxnInt();
//
//   var referralsCount = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkLoginStatus();
//     loadData();
//     loadSpecialities();
//     checkActiveQueueStatus();
//   }
//
//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     isLoggedIn.value = prefs.getString('auth_token') != null;
//     if (isLoggedIn.value) {
//       checkActiveQueueStatus();
//       //fetchReferralsCount();
//     } else {
//       activeAppointmentId.value = null;
//       referralsCount.value = 0;
//     }
//   }
//
//   // Future<void> fetchReferralsCount() async {
//   //   try {
//   //     final count = await _authRepository.getReferralsCount();
//   //     if (count != null) {
//   //       referralsCount.value = int.tryParse(count.toString()) ?? 0;
//   //     }
//   //   } catch (e) {
//   //     print("خطأ في جلب عدد التحويلات: $e");
//   //   }
//   // }
//
//   Future<void> handleAuthAction() async {
//     if (isLoggedIn.value) {
//       await _authRepository.logout();
//       isLoggedIn.value = false;
//       activeAppointmentId.value = null;
//       referralsCount.value = 0;
//       AppAlerts.showSuccess(
//         title: AppMessages.logoutTitle,
//         message: AppMessages.logoutSuccess,
//       );
//       Get.offAllNamed('/home');
//     } else {
//       await Get.toNamed('/login');
//       await checkLoginStatus();
//     }
//   }
//
//   Future<void> loadData() async {
//     try {
//       isLoading.value = true;
//       final rawData = await _service.getAll();
//       _allDoctorsCache = rawData.map((e) => DoctorModel.fromJson(e)).toList();
//       topDoctors.assignAll(
//         _allDoctorsCache.where((doc) => doc.averageRating >= 4.8).toList(),
//       );
//       filteredDoctors.assignAll(topDoctors);
//     } catch (e) {
//       AppAlerts.showError(
//         title: AppMessages.homeErrorTitle,
//         message: "${AppMessages.loadDataError}${e.toString()}",
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> loadSpecialities() async {
//     try {
//       final data = await _authRepository.getLookupsByCategory(
//         'MEDICAL_SPECIALTY',
//       );
//       if (data != null) {
//         specialities.assignAll(
//           data.map((e) => LookupModel.fromJson(e)).toList(),
//         );
//       }
//     } catch (e) {
//       print("خطأ في جلب التخصصات: $e");
//       AppAlerts.showError(
//         title: AppMessages.specialitiesErrorTitle,
//         message: AppMessages.loadSpecialitiesError,
//       );
//     }
//   }
//   Future<void> checkActiveQueueStatus() async {
//     try {
//       final response = await _authRepository.getActiveCheckedInAppointment();
//       print("API Response for Active Appointment: $response");
//
//       if (response != null && response['appointmentId'] != null) {
//         activeAppointmentId.value = int.tryParse(
//           response['appointmentId'].toString(),
//         );
//         print("Active Appointment ID is set to: ${activeAppointmentId.value}");
//       } else {
//         activeAppointmentId.value = null;
//         print("No active appointment found, set to null");
//       }
//     } catch (e) {
//       print("Error checking active queue: $e");
//       activeAppointmentId.value = null;
//     }
//   }
//   void searchDoctor(String query) {
//     isSearching.value = query.isNotEmpty;
//     if (query.isEmpty) {
//       filteredDoctors.assignAll(topDoctors);
//     } else {
//       filteredDoctors.assignAll(
//         _allDoctorsCache
//             .where(
//               (doc) =>
//           doc.name.toLowerCase().contains(query.toLowerCase()) ||
//               doc.specialization.toLowerCase().contains(
//                 query.toLowerCase(),
//               ),
//         )
//             .toList(),
//       );
//     }
//   }
// // دالة لتنفيذ الـ Check-in للموعد الحالي
//   Future<void> performCheckIn(int appointmentId) async {
//     try {
//       isLoading.value = true;
//       bool success = await _authRepository.checkInPatient(appointmentId);
//
//       if (success) {
//         AppAlerts.showSuccess(
//           title: "نجاح",
//           message: "تم تسجيل الحضور بنجاح وانضممت إلى الطابور!",
//         );
//         // إعادة فحص حالة الطابور النشط لتحديث الواجهة فوراً
//         await checkActiveQueueStatus();
//       }
//     } catch (e) {
//       AppAlerts.showError(
//         title: "خطأ",
//         message: e.toString().replaceAll("Exception: ", ""),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   void filterDoctorsBySpeciality(String specialityName) {
//     isSearching.value = true;
//     filteredDoctors.assignAll(
//       _allDoctorsCache
//           .where(
//             (doc) =>
//         doc.specialization.toLowerCase() ==
//             specialityName.toLowerCase(),
//       )
//           .toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../core/services/doctor_service.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../../auth/data/models/LookupModel.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class HomeController extends GetxController {
  final DoctorService _service = DoctorService();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  List<DoctorModel> _allDoctorsCache = [];
  var specialities = <LookupModel>[].obs;
  var topDoctors = <DoctorModel>[].obs;
  var filteredDoctors = <DoctorModel>[].obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isLoggedIn = false.obs;

  var referralsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadData();
    loadSpecialities();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('auth_token') != null;
    if (!isLoggedIn.value) {
      referralsCount.value = 0;
    }
  }

  // Future<void> fetchReferralsCount() async {
  //   try {
  //     final count = await _authRepository.getReferralsCount();
  //     if (count != null) {
  //       referralsCount.value = int.tryParse(count.toString()) ?? 0;
  //     }
  //   } catch (e) {
  //     print("خطأ في جلب عدد التحويلات: $e");
  //   }
  // }

  Future<void> handleAuthAction() async {
    if (isLoggedIn.value) {
      await _authRepository.logout();
      isLoggedIn.value = false;
      referralsCount.value = 0;
      AppAlerts.showSuccess(
        title: AppMessages.logoutTitle,
        message: AppMessages.logoutSuccess,
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
      topDoctors.assignAll(
        _allDoctorsCache.where((doc) => doc.averageRating >= 4.8).toList(),
      );
      filteredDoctors.assignAll(topDoctors);
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.homeErrorTitle,
        message: "${AppMessages.loadDataError}${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSpecialities() async {
    try {
      final data = await _authRepository.getLookupsByCategory(
        'MEDICAL_SPECIALTY',
      );
      if (data != null) {
        specialities.assignAll(
          data.map((e) => LookupModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      print("خطأ في جلب التخصصات: $e");
      AppAlerts.showError(
        title: AppMessages.specialitiesErrorTitle,
        message: AppMessages.loadSpecialitiesError,
      );
    }
  }

  void searchDoctor(String query) {
    isSearching.value = query.isNotEmpty;
    if (query.isEmpty) {
      filteredDoctors.assignAll(topDoctors);
    } else {
      filteredDoctors.assignAll(
        _allDoctorsCache
            .where(
              (doc) =>
          doc.name.toLowerCase().contains(query.toLowerCase()) ||
              doc.specialization.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
            .toList(),
      );
    }
  }

  void filterDoctorsBySpeciality(String specialityName) {
    isSearching.value = true;
    filteredDoctors.assignAll(
      _allDoctorsCache
          .where(
            (doc) =>
        doc.specialization.toLowerCase() ==
            specialityName.toLowerCase(),
      )
          .toList(),
    );
  }
}