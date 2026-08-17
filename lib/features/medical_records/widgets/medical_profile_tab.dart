import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/medical_records/model/medical_record_model.dart';

class MedicalProfileTab extends GetView<MedicalRecordController> {
  const MedicalProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isProfileLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      }

      final profile = controller.medicalProfile.value;
      if (profile == null) return _emptyState();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _completionCard(),
            const SizedBox(height: 20),
            _profileCard(profile),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.medical_information_outlined,
              color: AppColors.primaryBlue,
              size: 58,
            ),
            const SizedBox(height: 16),
            const Text(
              'No medical profile yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use Create Profile to add your medical profile information.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Medical Profile Completion',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray,
                ),
              ),
              Text(
                '${(controller.completionRate.value * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: controller.completionRate.value.clamp(0.0, 1.0),
            backgroundColor: AppColors.lightBlue.withValues(alpha: 0.3),
            color: AppColors.primaryBlue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _profileCard(MedicalProfileModel profile) {
    final rows = <_ProfileRowData>[
      _ProfileRowData(Icons.bloodtype, 'Blood type', _one(profile.bloodType)),
      _ProfileRowData(
        Icons.pregnant_woman_outlined,
        'Pregnancy status',
        _one(profile.pregnancyStatus),
      ),
      _ProfileRowData(
        Icons.accessible_outlined,
        'Disability information',
        _one(profile.disabilityInfo),
      ),
      _ProfileRowData(
        Icons.monitor_heart_outlined,
        'Current symptoms',
        _currentSymptoms(profile.currentSymptoms),
      ),
      _ProfileRowData(
        Icons.warning_amber_rounded,
        'Allergies',
        _many(profile.allergies),
      ),
      _ProfileRowData(
        Icons.healing_outlined,
        'Chronic conditions',
        _many(profile.chronicConditions),
      ),
      _ProfileRowData(
        Icons.medical_services_outlined,
        'Past surgeries',
        _many(profile.pastSurgeries),
      ),
      _ProfileRowData(
        Icons.family_restroom,
        'Family history',
        _many(profile.familyHistory),
      ),
      _ProfileRowData(
        Icons.medication_outlined,
        'Current medications',
        _many(profile.currentMedications),
      ),
      _ProfileRowData(
        Icons.directions_walk_outlined,
        'Lifestyle habits',
        _many(profile.lifestyleHabits),
      ),
      _ProfileRowData(
        Icons.vaccines_outlined,
        'Vaccination status',
        _many(profile.vaccinationStatus),
      ),
    ];

    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          return Column(
            children: [
              _profileTile(row.icon, row.title, row.value),
              if (index != rows.length - 1)
                const Divider(height: 1, color: AppColors.lightGray),
            ],
          );
        }),
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, color: AppColors.gray),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
      ],
    );
  }

  String _one(String? value) {
    final result = value?.trim() ?? '';
    return result.isEmpty ? 'Not provided' : result;
  }

  String _currentSymptoms(String? value) {
    if (value == null) return 'Not provided';
    if (value.isEmpty) return 'No current symptoms';
    return value;
  }

  String _many(List<String>? values) {
    if (values == null || values.isEmpty) return 'Not provided';
    return values.join(', ');
  }
}

class _ProfileRowData {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileRowData(this.icon, this.title, this.value);
}
