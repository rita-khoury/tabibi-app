import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/data/models/RatingModel.dart';
import '../../auth/repository/auth_repository.dart';
import '../../appointments/model/appointment_model.dart'; // تأكد من مسار نموذج الموعد الصحيح

import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class DoctorRatingsController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final int doctorId;
  final int? initialAppointmentId;

  DoctorRatingsController({required this.doctorId, this.initialAppointmentId});

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

  /// دالة لاستخراج معرف الموعد بأمان من المصادر المتاحة
  int? resolveAppointmentId(int? passedId) {
    if (passedId != null) return passedId;
    if (initialAppointmentId != null) return initialAppointmentId;

    if (Get.arguments != null) {
      if (Get.arguments is int) {
        return Get.arguments as int;
      } else if (Get.arguments is Map) {
        final map = Get.arguments as Map;
        var idVal = map['appointmentId'] ?? map['id'] ?? map['appointment_id'];
        if (idVal != null) {
          return int.tryParse(idVal.toString());
        }
      }
    }
    return null;
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

  /// **دالة التشخيص الأقوى (Deep Debugging):** تفحص كل موعد وتقارنه مع الطبيب الحالي وتطبع السبب بالتفصيل
  Future<void> checkAndCreateRating() async {
    int? finalAppointmentId = resolveAppointmentId(null);

    print("==================================================");
    print("🔍 [DEBUG START] checkAndCreateRating called");
    print("🎯 Target Current Doctor ID: $doctorId");
    print("📌 initialAppointmentId: $initialAppointmentId");
    print("📌 resolved appointmentId: $finalAppointmentId");
    print("==================================================");

    // إذا كان الموعد موجوداً مسبقاً (قادم من شاشة المواعيد)، نفتح نافذة الإضافة مباشرة
    if (finalAppointmentId != null) {
      print("✅ [DEBUG]: Found direct appointment ID without fetching appointments list: $finalAppointmentId");
      _showRatingDialog(finalAppointmentId);
      return;
    }

    // إذا لم يكن موجوداً (قادم من بروفايل الدكتور العام)، نبحث في مواعيد المريض
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      List<AppointmentModel> appointments = await _authRepository.getMyAppointments();
      print("📦 [DEBUG]: Total appointments fetched from server = ${appointments.length}");

      Get.back(); // إغلاق مؤشر التحميل

      if (appointments.isEmpty) {
        print("❌ [DEBUG]: The appointments list returned from server is completely EMPTY!");
      }

      // طباعة تفصيلية لكل موعد يجلبه السيرفر لكي نرى ما هي حالته ولمن يتبع
      for (int i = 0; i < appointments.length; i++) {
        var app = appointments[i];
        print("--------------------------------------------------");
        print("Appointment [#$i]:");
        print("  - ID: ${app.id}");
        print("  - Doctor ID inside appointment: ${app.doctorId}");
        print("  - Doctor Name: ${app.doctorName}");
        print("  - Status string raw: '${app.status}'");
        print("  - Status lower/trimmed: '${app.status.toLowerCase().trim()}'");
        print("  - Matches Target Doctor ID (${app.doctorId == doctorId})?");
        print("  - Is Status Completed (${app.status.toLowerCase().trim() == 'completed'})?");
      }
      print("--------------------------------------------------");

      AppointmentModel? completedAppointment;
      try {
        completedAppointment = appointments.firstWhere(
              (appointment) =>
          appointment.doctorId == doctorId &&
              appointment.status.toLowerCase().trim() == 'completed',
        );
      } catch (e) {
        completedAppointment = null;
      }

      if (completedAppointment != null) {
        print("🎉 [DEBUG SUCCESS]: Found a matching completed appointment! ID: ${completedAppointment.id}");
        _showRatingDialog(completedAppointment.id);
      } else {
        print("❌ [DEBUG FAILED]: No appointment matched BOTH conditions (doctorId == $doctorId && status == 'completed').");

        // فحص تقريبي لتسهيل معرفة أين تكمن المشكلة هل في الحالة أم في رقم الطبيب
        bool hasAnyCompletedWithOtherDoctor = appointments.any((a) => a.status.toLowerCase().trim() == 'completed');
        bool hasAnyWithThisDoctor = appointments.any((a) => a.doctorId == doctorId);

        if (hasAnyCompletedWithOtherDoctor && !hasAnyWithThisDoctor) {
          print("💡 [DEBUG HINT]: You have completed appointments, but none of them belong to doctorId: $doctorId!");
        } else if (hasAnyWithThisDoctor && !hasAnyCompletedWithOtherDoctor) {
          print("💡 [DEBUG HINT]: You have appointments with this doctor, but none of them have the status 'completed'!");
        }

        AppAlerts.showError(
          title: AppMessages.ratingErrorTitle,
          message: "يجب أن يكون لديك موعد مكتمل سابق مع هذا الطبيب لكي تتمكن من تقييمه. (راجع الـ Console لمعرفة السبب بالتفصيل)",
        );
      }
    } catch (e, stackTrace) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("🚨 [DEBUG ERROR] Exception occurred in checkAndCreateRating: $e");
      print(stackTrace);
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: "حدث خطأ أثناء التحقق من المواعيد: ${e.toString()}",
      );
    }
  }

  /// عرض دايالوج إدخال التقييم
  void _showRatingDialog(int appointmentId) {
    commentController.clear();
    scoreController.value = 5.0;

    Get.defaultDialog(
      title: "إضافة تقييم للطبيب",
      content: Column(
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  scoreController.value = (index + 1).toDouble();
                },
                icon: Icon(
                  index < scoreController.value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              );
            }),
          )),
          const SizedBox(height: 10),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: "اكتب تعليقك هنا...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              createRating(appointmentId);
            },
            child: const Text("إرسال التقييم"),
          ),
        ],
      ),
    );
  }

  // إضافة تقييم جديد للسيرفر مع طباعة الـ Payload واستجابة الخطأ بالتفصيل
  Future<void> createRating(int? appointmentId) async {
    int? finalAppointmentId = resolveAppointmentId(appointmentId);

    print("🚀 [DEBUG createRating]: finalAppointmentId = $finalAppointmentId");
    print("🚀 [DEBUG createRating]: score = ${scoreController.value.toInt()}");
    print("🚀 [DEBUG createRating]: comment = ${commentController.text.trim()}");

    if (finalAppointmentId == null) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: "لا يمكن إضافة التقييم بدون تحديد الموعد المكتمل.",
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final payload = {
        "appointmentId": finalAppointmentId,
        "score": scoreController.value.toInt(),
        "comment": commentController.text.trim(),
      };

      print("📤 [DEBUG createRating]: Sending payload -> $payload");

      await _authRepository.createRating(payload);

      if (Get.isDialogOpen ?? false) Get.back(); // إغلاق التحميل
      if (Get.isDialogOpen ?? false) Get.back(); // إغلاق دايالوج الإدخال

      commentController.clear();
      scoreController.value = 5.0;

      AppAlerts.showSuccess(
        title: AppMessages.ratingSuccessTitle,
        message: AppMessages.ratingSuccessBody,
      );
      fetchDoctorRatings(isRefresh: true);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("🚨 [DEBUG createRating ERROR] Server Error Response: $e");
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: e.toString(),
      );
    }
  }

  // تعديل تقييم
  Future<void> updateRating(int ratingId, int? appointmentId) async {
    int? finalAppointmentId = resolveAppointmentId(appointmentId);

    if (finalAppointmentId == null) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: "معرف الموعد مطلوب لتعديل التقييم.",
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _authRepository.updateRating(ratingId, {
        "appointmentId": finalAppointmentId,
        "score": scoreController.value.toInt(),
        "comment": commentController.text.trim(),
      });

      Get.back();
      Get.back();

      commentController.clear();
      scoreController.value = 5.0;

      AppAlerts.showSuccess(
        title: "Success",
        message: "Rating updated successfully",
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

  // حذف تقييم
  Future<void> deleteRating(int ratingId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _authRepository.deleteRating(ratingId);

      Get.back();

      AppAlerts.showSuccess(
        title: "Success",
        message: "Rating deleted successfully",
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