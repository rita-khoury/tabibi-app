import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/appointment_model.dart';
import '../model/waitlist_model.dart';

import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class AppointmentsController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final _storage = GetStorage();

  List<AppointmentModel> allAppointments = [];
  List<AppointmentModel> upcomingAppointments = [];
  List<AppointmentModel> completedAppointments = [];
  List<AppointmentModel> canceledAppointments = [];
  List<AppointmentModel> noShowAppointments = [];
  List<WaitlistModel> waitlistAppointments = [];
  final Set<int> ratedAppointmentIds = <int>{};

  bool isLoading = true;
  final RxInt upcomingTabRevision = 0.obs;

  void selectUpcomingTab() {
    upcomingTabRevision.value++;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
    fetchWaitlist();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading = true;
      update();
      final result = await _repo.getMyAppointments();
      allAppointments = result;

      upcomingAppointments = result
          .where(
            (appointment) =>
                appointment.status.toLowerCase() == 'pending' ||
                appointment.status.toLowerCase() == 'confirmed',
          )
          .toList();
      completedAppointments = result
          .where(
            (appointment) => appointment.status.toLowerCase() == 'completed',
          )
          .toList();
      canceledAppointments = result.where((appointment) {
        final status = appointment.status.toLowerCase();
        return status == 'cancelled' || status == 'canceled';
      }).toList();
      noShowAppointments = result
          .where((appointment) => appointment.status.toLowerCase() == 'no_show')
          .toList();

      await fetchRatedAppointmentIds();
    } catch (error) {
      debugPrint('Unable to load appointments: $error');
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isAppointmentRated(int appointmentId) =>
      ratedAppointmentIds.contains(appointmentId);

  Future<void> fetchRatedAppointmentIds() async {
    try {
      final reviews = await _repo.getMyReviews();
      final ids = <int>{};
      for (final review in reviews) {
        final status = (review['status'] ?? '').toString().toUpperCase();
        if (status == 'DELETED') continue;
        final nestedAppointment = review['appointment'];
        final value =
            review['appointmentId'] ??
            review['appointment_id'] ??
            (nestedAppointment is Map ? nestedAppointment['id'] : null);
        final appointmentId = int.tryParse(value?.toString() ?? '');
        if (appointmentId != null && appointmentId > 0) {
          ids.add(appointmentId);
        }
      }
      ratedAppointmentIds
        ..clear()
        ..addAll(ids);
    } catch (error) {
      debugPrint('Unable to load rating state: $error');
    }
  }

  void markAppointmentRated(int appointmentId) {
    ratedAppointmentIds.add(appointmentId);
    update();
  }

  void markAppointmentUnrated(int appointmentId) {
    ratedAppointmentIds.remove(appointmentId);
    update();
  }

  Future<bool> rateDoctorForAppointment({
    required int appointmentId,
    required double rating,
    String? comment,
  }) async {
    try {
      await _repo.rateDoctor(
        appointmentId: appointmentId,
        rating: rating,
        comment: comment,
      );
      markAppointmentRated(appointmentId);
      return true;
    } catch (error) {
      final message = error.toString().replaceFirst(
        RegExp(r'^Exception:\s*'),
        '',
      );
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: message.isNotEmpty ? message : 'Unable to submit your rating.',
      );
      return false;
    }
  }

  Future<void> fetchWaitlist() async {
    try {
      var result = await _repo.getMyWaitlists();

      debugPrint("🔥 RAW WAITLIST DATA: $result");

      waitlistAppointments = (result as List)
          .map((item) => WaitlistModel.fromJson(item))
          .toList();
      update();
    } catch (e) {
      debugPrint("❌ خطأ في جلب الويت ليست: $e");
    }
  }

  Future<void> joinWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      bool success = await _repo.joinWaitlist(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );

      if (success) {
        AppAlerts.showSuccess(
          title: AppMessages.waitlistSuccessTitle,
          message: AppMessages.waitlistSuccessBody,
        );
        await fetchWaitlist();
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(
        RegExp(r'^Exception:\s*'),
        '',
      );

      AppAlerts.showError(
        title: AppMessages.waitlistErrorTitle,
        message: errorMessage,
      );
    }
  }

  Future<void> leaveWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      await _repo.leaveWaitlist(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );

      AppAlerts.showSuccess(
        title: AppMessages.waitlistLeaveTitle,
        message: AppMessages.waitlistLeaveBody,
      );

      await fetchWaitlist();
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.waitlistLeaveErrorTitle,
        message: AppMessages.waitlistLeaveErrorBody,
      );
    }
  }

  Future<void> cancelAppointmentById(int id) async {
    var appointmentToCancel = upcomingAppointments.firstWhereOrNull(
      (a) => a.id == id,
    );
    if (appointmentToCancel == null) return;

    List<dynamic> localCanceledIds =
        _storage.read<List<dynamic>>('canceledIds') ?? [];
    if (!localCanceledIds.contains(id)) {
      localCanceledIds.add(id);
      await _storage.write('canceledIds', localCanceledIds);
    }

    upcomingAppointments.remove(appointmentToCancel);
    canceledAppointments.add(appointmentToCancel.copyWith(status: 'cancelled'));

    update();

    try {
      await _repo.cancelAppointment(id, "User cancelled");
      AppAlerts.showSuccess(
        title: AppMessages.successTitle,
        message: AppMessages.appointmentCancelSuccess,
      );
    } catch (e) {
      await fetchAppointments();
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: AppMessages.appointmentCancelError,
      );
    }
  }

  Future<void> completeAppointmentById(int id) async {
    try {
      await _repo.completeAppointment(id);
      AppAlerts.showSuccess(
        title: AppMessages.successTitle,
        message: AppMessages.appointmentCompleteSuccess,
      );
      await fetchAppointments();
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: AppMessages.appointmentCompleteError,
      );
    }
  }
}
