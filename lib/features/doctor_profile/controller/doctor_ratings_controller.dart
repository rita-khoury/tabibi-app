// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../auth/data/models/RatingModel.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class DoctorRatingsController extends GetxController {
//   final AuthRepository _authRepository = AuthRepository();
//
//   final int doctorId;
//
//   DoctorRatingsController({required this.doctorId});
//
//   var ratingsList = <RatingModel>[].obs;
//   var isLoading = false.obs;
//   var isMoreLoading = false.obs;
//
//   int page = 1;
//   int limit = 10;
//   bool hasMore = true;
//
//   final scoreController = 5.0.obs;
//   final commentController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchDoctorRatings();
//   }
//
//   Future<void> fetchDoctorRatings({bool isRefresh = false}) async {
//     if (isRefresh) {
//       page = 1;
//       hasMore = true;
//       ratingsList.clear();
//     }
//
//     if (!hasMore) return;
//
//     try {
//       if (page == 1) {
//         isLoading.value = true;
//       } else {
//         isMoreLoading.value = true;
//       }
//
//       final response = await _authRepository.getDoctorRatings(
//         doctorId,
//         page: page,
//         limit: limit,
//       );
//       final List data = response['data'] ?? [];
//       final int total = response['total'] ?? 0;
//
//       final fetchedRatings = data
//           .map((json) => RatingModel.fromJson(json))
//           .toList();
//
//       if (ratingsList.length + fetchedRatings.length >= total ||
//           fetchedRatings.isEmpty) {
//         hasMore = false;
//       }
//
//       ratingsList.addAll(fetchedRatings);
//       page++;
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         e.toString(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//       isMoreLoading.value = false;
//     }
//   }
//
//   Future<void> createRating(int appointmentId) async {
//     try {
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );
//
//       await _authRepository.createRating({
//         "appointmentId": appointmentId,
//         "score": scoreController.value.toInt(),
//         "comment": commentController.text.trim(),
//       });
//
//       Get.back();
//       Get.back();
//
//       commentController.clear();
//       scoreController.value = 5.0;
//
//       Get.snackbar(
//         "نجاح",
//         "تم إضافة تقييمك بنجاح",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       fetchDoctorRatings(isRefresh: true);
//     } catch (e) {
//       Get.back();
//       Get.snackbar(
//         "خطأ",
//         e.toString(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> reportRating(
//     int ratingId,
//     String reason,
//     String? explanation,
//   ) async {
//     try {
//       await _authRepository.reportRating(ratingId, {
//         "reason": reason,
//         "explanation": explanation,
//       });
//       Get.snackbar(
//         "تم",
//         "تم إرسال البلاغ بنجاح",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         e.toString(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   void onClose() {
//     commentController.dispose();
//     super.onClose();
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/data/models/RatingModel.dart';
import '../../auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class DoctorRatingsController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final int doctorId;

  DoctorRatingsController({required this.doctorId});

  var ratingsList = <RatingModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;

  int page = 1;
  int limit = 10;
  bool hasMore = true;

  final scoreController = 5.0.obs;
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDoctorRatings();
  }

  Future<void> fetchDoctorRatings({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      hasMore = true;
      ratingsList.clear();
    }

    if (!hasMore) return;

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _authRepository.getDoctorRatings(
        doctorId,
        page: page,
        limit: limit,
      );
      final List data = response['data'] ?? [];
      final int total = response['total'] ?? 0;

      final fetchedRatings = data
          .map((json) => RatingModel.fromJson(json))
          .toList();

      if (ratingsList.length + fetchedRatings.length >= total ||
          fetchedRatings.isEmpty) {
        hasMore = false;
      }

      ratingsList.addAll(fetchedRatings);
      page++;
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> createRating(int appointmentId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _authRepository.createRating({
        "appointmentId": appointmentId,
        "score": scoreController.value.toInt(),
        "comment": commentController.text.trim(),
      });

      Get.back();
      Get.back();

      commentController.clear();
      scoreController.value = 5.0;

      AppAlerts.showSuccess(
        title: AppMessages.ratingSuccessTitle,
        message: AppMessages.ratingSuccessBody,
      );
      fetchDoctorRatings(isRefresh: true);
    } catch (e) {
      Get.back();
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: e.toString(),
      );
    }
  }

  Future<void> reportRating(
      int ratingId,
      String reason,
      String? explanation,
      ) async {
    try {
      await _authRepository.reportRating(ratingId, {
        "reason": reason,
        "explanation": explanation,
      });
      AppAlerts.showSuccess(
        title: AppMessages.reportSuccessTitle,
        message: AppMessages.reportSuccessBody,
      );
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}