import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/data/models/RatingModel.dart';
import '../../auth/repository/auth_repository.dart';
import '../../appointments/model/appointment_model.dart';
import '../../appointments/controller/appointments_controller.dart'; // ØªØ£ÙƒØ¯ Ù…Ù† Ù…Ø³Ø§Ø± Ù†Ù…ÙˆØ°Ø¬ Ø§Ù„Ù…ÙˆØ¹Ø¯ Ø§Ù„ØµØ­ÙŠØ­

import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

enum ReportRatingResult { success, duplicate, failure }

class DoctorRatingsController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final int doctorId;
  final int? initialAppointmentId;

  DoctorRatingsController({required this.doctorId, this.initialAppointmentId});

  var ratingsList = <RatingModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  final reportedRatingIds = <int>{}.obs;

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

  /// Ø¯Ø§Ù„Ø© Ù„Ø§Ø³ØªØ®Ø±Ø§Ø¬ Ù…Ø¹Ø±Ù Ø§Ù„Ù…ÙˆØ¹Ø¯ Ø¨Ø£Ù…Ø§Ù† Ù…Ù† Ø§Ù„Ù…ØµØ§Ø¯Ø± Ø§Ù„Ù…ØªØ§Ø­Ø©
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
      reportedRatingIds.addAll(
        fetchedRatings
            .where((rating) => rating.isReportedByMe)
            .map((rating) => rating.id),
      );
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

  /// **Ø¯Ø§Ù„Ø© Ø§Ù„ØªØ´Ø®ÙŠØµ Ø§Ù„Ø£Ù‚ÙˆÙ‰ (Deep Debugging):** ØªÙØ­Øµ ÙƒÙ„ Ù…ÙˆØ¹Ø¯ ÙˆØªÙ‚Ø§Ø±Ù†Ù‡ Ù…Ø¹ Ø§Ù„Ø·Ø¨ÙŠØ¨ Ø§Ù„Ø­Ø§Ù„ÙŠ ÙˆØªØ·Ø¨Ø¹ Ø§Ù„Ø³Ø¨Ø¨ Ø¨Ø§Ù„ØªÙØµÙŠÙ„
  Future<void> checkAndCreateRating() async {
    int? finalAppointmentId = resolveAppointmentId(null);

    print("==================================================");
    print("ðŸ” [DEBUG START] checkAndCreateRating called");
    print("ðŸŽ¯ Target Current Doctor ID: $doctorId");
    print("ðŸ“Œ initialAppointmentId: $initialAppointmentId");
    print("ðŸ“Œ resolved appointmentId: $finalAppointmentId");
    print("==================================================");

    // Ø¥Ø°Ø§ ÙƒØ§Ù† Ø§Ù„Ù…ÙˆØ¹Ø¯ Ù…ÙˆØ¬ÙˆØ¯Ø§Ù‹ Ù…Ø³Ø¨Ù‚Ø§Ù‹ (Ù‚Ø§Ø¯Ù… Ù…Ù† Ø´Ø§Ø´Ø© Ø§Ù„Ù…ÙˆØ§Ø¹ÙŠØ¯)ØŒ Ù†ÙØªØ­ Ù†Ø§ÙØ°Ø© Ø§Ù„Ø¥Ø¶Ø§ÙØ© Ù…Ø¨Ø§Ø´Ø±Ø©
    if (finalAppointmentId != null) {
      print(
        "âœ… [DEBUG]: Found direct appointment ID without fetching appointments list: $finalAppointmentId",
      );
      _showRatingDialog(finalAppointmentId);
      return;
    }

    // Ø¥Ø°Ø§ Ù„Ù… ÙŠÙƒÙ† Ù…ÙˆØ¬ÙˆØ¯Ø§Ù‹ (Ù‚Ø§Ø¯Ù… Ù…Ù† Ø¨Ø±ÙˆÙØ§ÙŠÙ„ Ø§Ù„Ø¯ÙƒØªÙˆØ± Ø§Ù„Ø¹Ø§Ù…)ØŒ Ù†Ø¨Ø­Ø« ÙÙŠ Ù…ÙˆØ§Ø¹ÙŠØ¯ Ø§Ù„Ù…Ø±ÙŠØ¶
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      List<AppointmentModel> appointments = await _authRepository
          .getMyAppointments();
      print(
        "ðŸ“¦ [DEBUG]: Total appointments fetched from server = ${appointments.length}",
      );

      Get.back(); // Ø¥ØºÙ„Ø§Ù‚ Ù…Ø¤Ø´Ø± Ø§Ù„ØªØ­Ù…ÙŠÙ„

      if (appointments.isEmpty) {
        print(
          "âŒ [DEBUG]: The appointments list returned from server is completely EMPTY!",
        );
      }

      // Ø·Ø¨Ø§Ø¹Ø© ØªÙØµÙŠÙ„ÙŠØ© Ù„ÙƒÙ„ Ù…ÙˆØ¹Ø¯ ÙŠØ¬Ù„Ø¨Ù‡ Ø§Ù„Ø³ÙŠØ±ÙØ± Ù„ÙƒÙŠ Ù†Ø±Ù‰ Ù…Ø§ Ù‡ÙŠ Ø­Ø§Ù„ØªÙ‡ ÙˆÙ„Ù…Ù† ÙŠØªØ¨Ø¹
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
        print(
          "  - Is Status Completed (${app.status.toLowerCase().trim() == 'completed'})?",
        );
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
        print(
          "ðŸŽ‰ [DEBUG SUCCESS]: Found a matching completed appointment! ID: ${completedAppointment.id}",
        );
        _showRatingDialog(completedAppointment.id);
      } else {
        print(
          "âŒ [DEBUG FAILED]: No appointment matched BOTH conditions (doctorId == $doctorId && status == 'completed').",
        );

        // ÙØ­Øµ ØªÙ‚Ø±ÙŠØ¨ÙŠ Ù„ØªØ³Ù‡ÙŠÙ„ Ù…Ø¹Ø±ÙØ© Ø£ÙŠÙ† ØªÙƒÙ…Ù† Ø§Ù„Ù…Ø´ÙƒÙ„Ø© Ù‡Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ù„Ø© Ø£Ù… ÙÙŠ Ø±Ù‚Ù… Ø§Ù„Ø·Ø¨ÙŠØ¨
        bool hasAnyCompletedWithOtherDoctor = appointments.any(
          (a) => a.status.toLowerCase().trim() == 'completed',
        );
        bool hasAnyWithThisDoctor = appointments.any(
          (a) => a.doctorId == doctorId,
        );

        if (hasAnyCompletedWithOtherDoctor && !hasAnyWithThisDoctor) {
          print(
            "ðŸ’¡ [DEBUG HINT]: You have completed appointments, but none of them belong to doctorId: $doctorId!",
          );
        } else if (hasAnyWithThisDoctor && !hasAnyCompletedWithOtherDoctor) {
          print(
            "ðŸ’¡ [DEBUG HINT]: You have appointments with this doctor, but none of them have the status 'completed'!",
          );
        }

        AppAlerts.showError(
          title: AppMessages.ratingErrorTitle,
          message:
              "ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† Ù„Ø¯ÙŠÙƒ Ù…ÙˆØ¹Ø¯ Ù…ÙƒØªÙ…Ù„ Ø³Ø§Ø¨Ù‚ Ù…Ø¹ Ù‡Ø°Ø§ Ø§Ù„Ø·Ø¨ÙŠØ¨ Ù„ÙƒÙŠ ØªØªÙ…ÙƒÙ† Ù…Ù† ØªÙ‚ÙŠÙŠÙ…Ù‡. (Ø±Ø§Ø¬Ø¹ Ø§Ù„Ù€ Console Ù„Ù…Ø¹Ø±ÙØ© Ø§Ù„Ø³Ø¨Ø¨ Ø¨Ø§Ù„ØªÙØµÙŠÙ„)",
        );
      }
    } catch (e, stackTrace) {
      if (Get.isDialogOpen ?? false) Get.back();
      print(
        "ðŸš¨ [DEBUG ERROR] Exception occurred in checkAndCreateRating: $e",
      );
      print(stackTrace);
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message:
            "Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«Ù†Ø§Ø¡ Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ø§Ù„Ù…ÙˆØ§Ø¹ÙŠØ¯: ${e.toString()}",
      );
    }
  }

  /// Ø¹Ø±Ø¶ Ø¯Ø§ÙŠØ§Ù„ÙˆØ¬ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…
  void _showRatingDialog(int appointmentId) {
    commentController.clear();
    scoreController.value = 5.0;

    Get.defaultDialog(
      title: "Ø¥Ø¶Ø§ÙØ© ØªÙ‚ÙŠÙŠÙ… Ù„Ù„Ø·Ø¨ÙŠØ¨",
      content: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    scoreController.value = (index + 1).toDouble();
                  },
                  icon: Icon(
                    index < scoreController.value
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              labelText: "Ø§ÙƒØªØ¨ ØªØ¹Ù„ÙŠÙ‚Ùƒ Ù‡Ù†Ø§...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              createRating(appointmentId);
            },
            child: const Text("Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„ØªÙ‚ÙŠÙŠÙ…"),
          ),
        ],
      ),
    );
  }

  // Ø¥Ø¶Ø§ÙØ© ØªÙ‚ÙŠÙŠÙ… Ø¬Ø¯ÙŠØ¯ Ù„Ù„Ø³ÙŠØ±ÙØ± Ù…Ø¹ Ø·Ø¨Ø§Ø¹Ø© Ø§Ù„Ù€ Payload ÙˆØ§Ø³ØªØ¬Ø§Ø¨Ø© Ø§Ù„Ø®Ø·Ø£ Ø¨Ø§Ù„ØªÙØµÙŠÙ„
  Future<void> createRating(int? appointmentId) async {
    int? finalAppointmentId = resolveAppointmentId(appointmentId);

    print(
      "ðŸš€ [DEBUG createRating]: finalAppointmentId = $finalAppointmentId",
    );
    print(
      "ðŸš€ [DEBUG createRating]: score = ${scoreController.value.toInt()}",
    );
    print(
      "ðŸš€ [DEBUG createRating]: comment = ${commentController.text.trim()}",
    );

    if (finalAppointmentId == null) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message:
            "Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø¥Ø¶Ø§ÙØ© Ø§Ù„ØªÙ‚ÙŠÙŠÙ… Ø¨Ø¯ÙˆÙ† ØªØ­Ø¯ÙŠØ¯ Ø§Ù„Ù…ÙˆØ¹Ø¯ Ø§Ù„Ù…ÙƒØªÙ…Ù„.",
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

      print("ðŸ“¤ [DEBUG createRating]: Sending payload -> $payload");

      await _authRepository.createRating(payload);

      if (Get.isDialogOpen ?? false) Get.back(); // Ø¥ØºÙ„Ø§Ù‚ Ø§Ù„ØªØ­Ù…ÙŠÙ„
      if (Get.isDialogOpen ?? false)
        Get.back(); // Ø¥ØºÙ„Ø§Ù‚ Ø¯Ø§ÙŠØ§Ù„ÙˆØ¬ Ø§Ù„Ø¥Ø¯Ø®Ø§Ù„

      commentController.clear();
      scoreController.value = 5.0;

      AppAlerts.showSuccess(
        title: AppMessages.ratingSuccessTitle,
        message: AppMessages.ratingSuccessBody,
      );
      fetchDoctorRatings(isRefresh: true);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("ðŸš¨ [DEBUG createRating ERROR] Server Error Response: $e");
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: e.toString(),
      );
    }
  }

  // ØªØ¹Ø¯ÙŠÙ„ ØªÙ‚ÙŠÙŠÙ…
  Future<void> updateRating(int ratingId, int? appointmentId) async {
    int? finalAppointmentId = resolveAppointmentId(appointmentId);

    if (finalAppointmentId == null) {
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message:
            "Ù…Ø¹Ø±Ù Ø§Ù„Ù…ÙˆØ¹Ø¯ Ù…Ø·Ù„ÙˆØ¨ Ù„ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„ØªÙ‚ÙŠÙŠÙ….",
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

  // Ø­Ø°Ù ØªÙ‚ÙŠÙŠÙ…
  Future<void> deleteRating(int ratingId) async {
    var appointmentId = 0;
    for (final rating in ratingsList) {
      if (rating.id == ratingId) {
        appointmentId = rating.appointmentId;
        break;
      }
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _authRepository.deleteRating(ratingId);
      Get.back();
      if (appointmentId > 0 && Get.isRegistered<AppointmentsController>()) {
        Get.find<AppointmentsController>().markAppointmentUnrated(
          appointmentId,
        );
      }
      AppAlerts.showSuccess(
        title: 'Success',
        message: 'Rating deleted successfully',
      );
      await fetchDoctorRatings(isRefresh: true);
    } catch (error) {
      Get.back();
      AppAlerts.showError(
        title: AppMessages.ratingErrorTitle,
        message: error.toString(),
      );
    }
  }

  bool isRatingReported(int ratingId) => reportedRatingIds.contains(ratingId);

  void markRatingReported(int ratingId) {
    reportedRatingIds.add(ratingId);
    final index = ratingsList.indexWhere((rating) => rating.id == ratingId);
    if (index >= 0) {
      ratingsList[index].isReportedByMe = true;
      ratingsList.refresh();
    }
  }

  Future<ReportRatingResult> reportRating(
    int ratingId,
    String reason,
    String? explanation,
  ) async {
    try {
      await _authRepository.reportRating(ratingId, {
        'reason': reason,
        'explanation': explanation,
      });
      markRatingReported(ratingId);
      return ReportRatingResult.success;
    } catch (error) {
      return _isDuplicateReportError(error)
          ? ReportRatingResult.duplicate
          : ReportRatingResult.failure;
    }
  }

  bool _isDuplicateReportError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('already reported') ||
        message.contains('already reviewed') ||
        message.contains('report already exists') ||
        message.contains('duplicate') ||
        message.contains('status code: 400') ||
        message.contains('status code: 409') ||
        message.contains('bad request') ||
        message.contains('conflict');
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
