import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/constance/app_messages.dart';
import 'package:tabibi/core/constance/app_alerts.dart';
import 'package:tabibi/features/appointment/binding/appointment_binding.dart';
import 'package:tabibi/features/appointment/view/appointment_view.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

import '../model/referral_model.dart';

class DoctorRemindersController extends GetxController {
  DoctorRemindersController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? Get.find<AuthRepository>();

  final AuthRepository _authRepository;
  final RxBool isLoading = false.obs;
  final RxList<ReferralModel> remindersList = <ReferralModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferrals();
  }

  Future<void> fetchReferrals() async {
    isLoading.value = true;
    try {
      final result = await _authRepository.getMyReferrals();
      remindersList.assignAll(
        result
            .whereType<Map>()
            .map((item) => ReferralModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .where((referral) => referral.id > 0),
      );
    } catch (error) {
      AppAlerts.showError(
        title: AppMessages.remindersErrorTitle,
        message: '${AppMessages.fetchReferralsError}${error.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openReferral(ReferralModel referral) async {
    if (!referral.isActionable) {
      Get.snackbar(
        'Referral unavailable',
        'This referral is no longer active.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final targetDoctorId = referral.type == 'FOLLOW_UP'
        ? referral.fromDoctorId
        : referral.toDoctorId;
    if (targetDoctorId != null) {
      _openBooking(referral, targetDoctorId);
      return;
    }

    if (referral.type == 'EXTERNAL' && referral.toClinicId != null) {
      await _selectClinicDoctor(referral);
      return;
    }

    Get.snackbar(
      'Referral unavailable',
      'This referral does not contain a bookable doctor or clinic.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _openBooking(ReferralModel referral, int doctorId) {
    Get.to(
      () => AppointmentView(
        doctorId: doctorId,
        clinicId: referral.toClinicId,
        referralId: referral.id,
        referralSourceName: referral.sourceDoctorName,
      ),
      binding: AppointmentBinding(),
    );
  }

  Future<void> _selectClinicDoctor(ReferralModel referral) async {
    final clinicId = referral.toClinicId;
    if (clinicId == null) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
      barrierDismissible: false,
    );
    try {
      final doctors = await _authRepository.getDoctorsInClinic(clinicId);
      if (Get.isDialogOpen == true) Get.back();
      if (doctors.isEmpty) {
        Get.snackbar(
          'No doctors available',
          'No bookable doctors are currently assigned to this clinic.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      Get.bottomSheet(
        SafeArea(
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Choose a doctor at ${referral.toClinic?.name ?? 'this clinic'}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Your referral will be attached to the booking.'),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: doctors.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final doctor = doctors[index];
                        final doctorId = _asInt(doctor['id'] ?? doctor['doctorId']);
                        if (doctorId == null) return const SizedBox.shrink();
                        final name = _doctorName(doctor);
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.lightGray,
                            child: Icon(Icons.medical_services_outlined,
                                color: AppColors.primaryBlue),
                          ),
                          title: Text(name),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () {
                            Get.back();
                            _openBooking(referral, doctorId);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        'Unable to load doctors',
        error.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _doctorName(Map<String, dynamic> doctor) {
    final user = doctor['user'] is Map
        ? Map<String, dynamic>.from(doctor['user'] as Map)
        : const <String, dynamic>{};
    final name = user['fullName'] ?? doctor['fullName'];
    if (name?.toString().trim().isNotEmpty == true) return 'Dr. ${name.toString().trim()}';
    final first = user['firstName'] ?? user['first_name'] ?? '';
    final last = user['lastName'] ?? user['last_name'] ?? '';
    final combined = '${first.toString()} ${last.toString()}'.trim();
    return combined.isEmpty ? 'Doctor' : 'Dr. $combined';
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
