// // import 'dart:async';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import '../../auth/repository/auth_repository.dart';
// //
// // class PatientQueueController extends GetxController {
// //   final AuthRepository _authRepository = AuthRepository();
// //
// //   var isLoading = true.obs;
// //   var queueStatus = <String, dynamic>{}.obs;
// //   var isCheckedIn = false.obs;
// //   Timer? _timer;
// //
// //   final int appointmentId;
// //
// //   PatientQueueController({required this.appointmentId});
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchLiveStatus();
// //
// //     _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
// //       fetchLiveStatus(isSilent: true);
// //     });
// //   }
// //
// //   void fetchLiveStatus({bool isSilent = false}) async {
// //     try {
// //       if (!isSilent) isLoading.value = true;
// //
// //       final result = await _authRepository.getPatientLiveQueueStatus(
// //         appointmentId,
// //       );
// //
// //       queueStatus.assignAll(result);
// //       isCheckedIn.value = true;
// //     } catch (e) {
// //       debugPrint("❌ تفاصيل الخطأ الكاملة: $e");
// //
// //       if (e.toString().contains('not checked in') ||
// //           e.toString().contains('404')) {
// //         isCheckedIn.value = false;
// //         queueStatus.clear();
// //       } else {
// //         if (!isSilent) {
// //           Get.snackbar(
// //             "خطأ",
// //             "فشل في جلب حالة الطابور الحالية",
// //             backgroundColor: Colors.red,
// //             colorText: Colors.white,
// //           );
// //         }
// //       }
// //     } finally {
// //       if (!isSilent) isLoading.value = false;
// //     }
// //   }
// //
// //   Future<void> performCheckIn() async {
// //     try {
// //       isLoading.value = true;
// //
// //       Get.snackbar(
// //         "نجاح",
// //         "تم تسجيل الحضور بنجاح",
// //         backgroundColor: Colors.green,
// //         colorText: Colors.white,
// //       );
// //
// //       fetchLiveStatus();
// //     } catch (e) {
// //       Get.snackbar(
// //         "خطأ",
// //         "فشل في تسجيل الحضور: $e",
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     _timer?.cancel();
// //     super.onClose();
// //   }
// // }
//
//
//
// import 'dart:async';
// import 'package:dio/dio.dart'; // تأكد من استيراد dio
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../auth/repository/auth_repository.dart';
//
// class PatientQueueController extends GetxController {
//   // ملاحظة: الأفضل استخدام Get.find إذا كان الـ AuthRepository مسجلاً في الـ Bindings، أو إبقاؤه هكذا
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//
//   var isLoading = true.obs;
//   var queueStatus = <String, dynamic>{}.obs;
//   var isCheckedIn = false.obs;
//   Timer? _timer;
//
//   final int appointmentId;
//
//   PatientQueueController({required this.appointmentId});
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchLiveStatus();
//
//     _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       fetchLiveStatus(isSilent: true);
//     });
//   }
//
//   void fetchLiveStatus({bool isSilent = false}) async {
//     try {
//       if (!isSilent) isLoading.value = true;
//
//       final result = await _authRepository.getPatientLiveQueueStatus(
//         appointmentId,
//       );
//
//       queueStatus.assignAll(result);
//       isCheckedIn.value = true;
//     } catch (e) {
//       debugPrint("❌ تفاصيل الخطأ الكاملة: $e");
//
//       if (e.toString().contains('not checked in') ||
//           e.toString().contains('404')) {
//         isCheckedIn.value = false;
//         queueStatus.clear();
//       } else {
//         if (!isSilent) {
//           Get.snackbar(
//             "خطأ",
//             "فشل في جلب حالة الطابور الحالية",
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//       }
//     } finally {
//       if (!isSilent) isLoading.value = false;
//     }
//   }
//   Future<void> performCheckIn() async {
//     try {
//       isLoading.value = true;
//
//       // طباعة رقم الموعد للتأكد أنه ليس null
//       debugPrint("📌 محاولة عمل Check-in للموعد رقم: $appointmentId");
//
//       await _authRepository.checkInPatient(appointmentId);
//
//       debugPrint("✅ تم الـ Check-in بنجاح!");
//       isCheckedIn.value = true;
//       fetchLiveStatus();
//
//     } on DioException catch (e) {
//       // 🛑 هُنا يظهر الخطأ القادم من السيرفر بالتفصيل
//       debugPrint("❌ [DioException] Status Code: ${e.response?.statusCode}");
//       debugPrint("❌ [DioException] Response Data: ${e.response?.data}");
//       debugPrint("❌ [DioException] Message: ${e.message}");
//
//       Get.snackbar("خطأ من السيرفر", e.response?.data['message'] ?? "خطأ غير معروف",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } catch (e) {
//       debugPrint("❌ [Unexpected Error]: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class PatientQueueController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  var isLoading = true.obs;
  var queueStatus = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> activeQueueStatuses =
      <Map<String, dynamic>>[].obs;
  var isCheckedIn = false.obs;
  Timer? _timer;

  final int appointmentId;

  PatientQueueController({required this.appointmentId});

  @override
  void onInit() {
    super.onInit();
    fetchLiveStatus();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchLiveStatus(isSilent: true);
    });
  }

  Future<void> fetchLiveStatus({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final appointments = await _authRepository.getMyAppointments();
      final confirmedAppointments = appointments
          .where(
            (appointment) => appointment.status.toLowerCase() == 'confirmed',
          )
          .toList();

      final results = await Future.wait(
        confirmedAppointments.map((appointment) async {
          try {
            final result = await _authRepository.getPatientLiveQueueStatus(
              appointment.id,
            );
            if (_isNotCheckedInResponse(result)) {
              return null;
            }
            final status = result['status']?.toString().toLowerCase() ?? '';
            if (!_activeQueueStatuses.contains(status)) {
              return null;
            }
            return <String, dynamic>{
              ...result,
              'appointmentId': appointment.id,
              'doctorName': appointment.doctorName,
              'specialty': appointment.specialty,
              'date': appointment.date,
              'startTime': appointment.startTime,
              'endTime': appointment.endTime,
            };
          } catch (error) {
            if (!_isNotCheckedInError(error)) {
              debugPrint(
                'Unable to load queue status for appointment ${appointment.id}: $error',
              );
            }
            return null;
          }
        }),
      );

      activeQueueStatuses.assignAll(results.whereType<Map<String, dynamic>>());
      if (activeQueueStatuses.isEmpty) {
        isCheckedIn.value = false;
        queueStatus.clear();
      } else {
        isCheckedIn.value = true;
        queueStatus.assignAll(activeQueueStatuses.first);
      }
    } catch (error) {
      debugPrint('Unable to load patient appointments for live queue: $error');
      activeQueueStatuses.clear();
      queueStatus.clear();
      isCheckedIn.value = false;
      if (!isSilent) {
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: AppMessages.queueFetchError,
        );
      }
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  static const Set<String> _activeQueueStatuses = {
    'waiting',
    'calling',
    'in_progress',
    'skipped',
  };

  bool _isNotCheckedInResponse(Map<String, dynamic> response) {
    final message = response['message']?.toString().toLowerCase() ?? '';
    return response['statusCode'] == 404 &&
        message.contains('has not checked in');
  }

  bool _isNotCheckedInError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('has not checked in') || message.contains('404');
  }

  Future<void> performCheckIn() async {
    try {
      isLoading.value = true;

      debugPrint("📌 محاولة عمل Check-in للموعد رقم: $appointmentId");

      await _authRepository.checkInPatient(appointmentId);

      debugPrint("✅ تم الـ Check-in بنجاح!");

      AppAlerts.showSuccess(
        title: AppMessages.checkInSuccessTitle,
        message: AppMessages.checkInSuccessBody,
      );

      isCheckedIn.value = true;
      fetchLiveStatus();
    } on DioException catch (e) {
      debugPrint("❌ [DioException] Status Code: ${e.response?.statusCode}");
      debugPrint("❌ [DioException] Response Data: ${e.response?.data}");
      debugPrint("❌ [DioException] Message: ${e.message}");

      String serverMessage = "";
      var responseData = e.response?.data;
      if (responseData is Map && responseData.containsKey('message')) {
        serverMessage = responseData['message'].toString();
      } else if (responseData is String) {
        serverMessage = responseData;
      }

      AppAlerts.showError(
        title: AppMessages.serverErrorTitle,
        message: serverMessage.isNotEmpty
            ? serverMessage
            : AppMessages.unknownServerError,
      );
    } catch (e) {
      debugPrint("❌ [Unexpected Error]: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
