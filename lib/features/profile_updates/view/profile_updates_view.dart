import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/widgets/appointment_card.dart';
import 'package:tabibi/features/profile_updates/controller/profile_updates_controller.dart';
import 'package:tabibi/features/profile_updates/model/medical_profile_update_model.dart';

class ProfileUpdatesView extends StatelessWidget {
  const ProfileUpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileUpdatesController>()
        ? Get.find<ProfileUpdatesController>()
        : Get.put(ProfileUpdatesController());
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Profile Updates'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.updates.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        if (controller.errorMessage.value != null &&
            controller.updates.isEmpty) {
          return _ProfileUpdatesError(
            message: controller.errorMessage.value!,
            onRetry: controller.fetchUpdates,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: controller.fetchUpdates,
          child: controller.updates.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: const [
                    SizedBox(height: 110),
                    Icon(
                      Icons.article_outlined,
                      size: 52,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(height: 14),
                    Center(
                      child: Text(
                        'No profile updates yet.',
                        style: TextStyle(color: AppColors.gray, fontSize: 15),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  itemCount: controller.updates.length,
                  itemBuilder: (context, index) => _ProfileUpdateCard(
                    update: controller.updates[index],
                    controller: controller,
                  ),
                ),
        );
      }),
    );
  }
}

class _ProfileUpdateCard extends StatelessWidget {
  final MedicalProfileUpdateModel update;
  final ProfileUpdatesController controller;

  const _ProfileUpdateCard({required this.update, required this.controller});

  @override
  Widget build(BuildContext context) {
    final fieldLabel = _fieldLabel(update.fieldName);
    final oldValue = _valueLabel(
      update.oldValue,
      fieldName: update.fieldName,
      isOldValue: true,
    );
    final newValue = _valueLabel(
      update.newValue,
      fieldName: update.fieldName,
      isOldValue: false,
    );
    final reason = update.changeReason;
    final createdAt = _formatDateTime(update.createdAt);
    final attribution = _changedByLabel(update, controller.currentUserId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_note_outlined,
                    color: AppColors.primaryBlue,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fieldLabel,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$oldValue → $newValue',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            _MetaLine(icon: Icons.person_outline_rounded, text: attribution),
            if (createdAt.isNotEmpty) ...[
              const SizedBox(height: 7),
              _MetaLine(icon: Icons.schedule_rounded, text: createdAt),
            ],
            if (reason != null && reason.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ReasonBox(reason: reason),
            ],
            if (update.appointmentId != null) ...[
              const SizedBox(height: 12),
              _VisitLink(
                onTap: () => _showAppointmentSheet(
                  context,
                  controller,
                  update.appointmentId!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.gray, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ReasonBox extends StatelessWidget {
  final String reason;

  const _ReasonBox({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reason',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reason,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _VisitLink extends StatelessWidget {
  final VoidCallback onTap;

  const _VisitLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            children: [
              Icon(
                Icons.event_available_outlined,
                color: AppColors.primaryBlue,
                size: 17,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'From visit',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.primaryBlue),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileUpdatesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileUpdatesError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _RoundedSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _RoundedSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showAppointmentSheet(
  BuildContext context,
  ProfileUpdatesController controller,
  int appointmentId,
) async {
  final appointment = await controller.appointmentForId(appointmentId);
  if (!context.mounted) return;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RoundedSheet(
      title: 'Appointment Details',
      child: appointment == null
          ? const _UnavailableAppointmentMessage()
          : AppointmentCard(
              appointment: appointment,
              showCancellationAction: false,
            ),
    ),
  );
}

class _UnavailableAppointmentMessage extends StatelessWidget {
  const _UnavailableAppointmentMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Related appointment information is unavailable.',
        style: TextStyle(color: AppColors.gray),
      ),
    );
  }
}

String _fieldLabel(String fieldName) {
  const labels = <String, String>{
    'bloodType': 'Blood Type',
    'pregnancyStatus': 'Pregnancy Status',
    'disabilityInfo': 'Disability Information',
    'currentSymptoms': 'Current Symptoms',
    'allergies': 'Allergies',
    'chronicConditions': 'Chronic Conditions',
    'pastSurgeries': 'Past Surgeries',
    'familyHistory': 'Family History',
    'currentMedications': 'Current Medications',
    'lifestyleHabits': 'Lifestyle Habits',
    'vaccinationStatus': 'Vaccination Status',
  };
  final known = labels[fieldName];
  if (known != null) return known;
  final spaced = fieldName
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match[1]} ${match[2]}',
      )
      .replaceAll('_', ' ')
      .trim();
  if (spaced.isEmpty) return 'Profile Information';
  return spaced
      .split(RegExp(r'\s+'))
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}

String _valueLabel(
  dynamic value, {
  required String fieldName,
  required bool isOldValue,
}) {
  if (value == null) return _nullValueLabel(fieldName, isOldValue);
  if (value is List) {
    if (value.isEmpty) return _emptyValueLabel(fieldName);
    final entries = value
        .map(
          (entry) =>
              _valueLabel(entry, fieldName: fieldName, isOldValue: false),
        )
        .where((entry) => entry.isNotEmpty)
        .toList();
    return entries.isEmpty ? _emptyValueLabel(fieldName) : entries.join(', ');
  }
  if (value is String) {
    final text = value.trim();
    if (text.isEmpty) return _emptyValueLabel(fieldName);
    return text;
  }
  if (value is Map) {
    if (value.isEmpty) return _emptyValueLabel(fieldName);
    final entries = value.entries
        .map(
          (entry) =>
              '${_fieldLabel(entry.key.toString())}: ${_valueLabel(entry.value, fieldName: fieldName, isOldValue: false)}',
        )
        .toList();
    return entries.join(', ');
  }
  return value.toString();
}

String _nullValueLabel(String fieldName, bool isOldValue) {
  if (!isOldValue) return _emptyValueLabel(fieldName);
  if (fieldName == 'currentSymptoms') return 'No previous symptoms';
  if (fieldName == 'allergies') return 'No previous allergies';
  return 'No previous value';
}

String _emptyValueLabel(String fieldName) {
  const emptyLabels = <String, String>{
    'currentSymptoms': 'No current symptoms',
    'allergies': 'No allergies',
    'chronicConditions': 'No chronic conditions',
    'pastSurgeries': 'No past surgeries',
    'lifestyleHabits': 'No specific lifestyle habits',
    'familyHistory': 'No family history',
    'currentMedications': 'No current medications',
    'vaccinationStatus': 'No vaccination details',
  };
  return emptyLabels[fieldName] ?? 'No entries';
}

String _changedByLabel(
  MedicalProfileUpdateModel update,
  String? currentUserId,
) {
  final actor = update.changedBy;
  if (actor == null) return 'Updated by a care team member';
  if (currentUserId != null && currentUserId == actor.id) {
    return 'Updated by you';
  }
  if (actor.role.toLowerCase() == 'doctor' && actor.fullName.isNotEmpty) {
    return 'Updated by Dr. ${actor.fullName}';
  }
  if (actor.fullName.isNotEmpty) return 'Updated by $actor.fullName';
  return 'Updated by a care team member';
}

String _formatDateTime(String? raw) {
  final date = DateTime.tryParse(raw ?? '')?.toLocal();
  if (date == null) return '';
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final time =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  return '${months[date.month - 1]} ${date.day}, ${date.year} · $time';
}
