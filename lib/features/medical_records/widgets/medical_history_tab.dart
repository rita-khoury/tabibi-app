import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/model/appointment_model.dart';
import 'package:tabibi/features/appointments/widgets/appointment_card.dart';
import 'package:tabibi/features/doctor_profile/view/doctor_profile_view.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';

class MedicalHistoryTab extends StatelessWidget {
  final MedicalRecordController controller = Get.find();

  MedicalHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isHistoryLoading.value &&
          controller.medicalHistories.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      }

      if (controller.medicalHistories.isEmpty) {
        return const _VisitsEmptyState();
      }

      return RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: controller.fetchMedicalHistories,
        child: ListView.builder(
          controller: controller.historyScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount:
              controller.medicalHistories.length +
              (controller.hasMoreHistories.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.medicalHistories.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                ),
              );
            }
            return _VisitCard(
              history: controller.medicalHistories[index],
              controller: controller,
            );
          },
        ),
      );
    });
  }
}

class _VisitCard extends StatelessWidget {
  final dynamic history;
  final MedicalRecordController controller;

  const _VisitCard({required this.history, required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = history is Map
        ? Map<String, dynamic>.from(history)
        : <String, dynamic>{};
    final doctorId = _asId(data['doctorProfileId']);
    final appointmentId = _asId(data['appointmentId']);
    final doctor = doctorId == null
        ? null
        : controller.doctorForVisit(doctorId);
    final appointment = appointmentId == null
        ? null
        : controller.appointmentForVisit(appointmentId);
    final diagnosis = _text(
      data['diagnosis'],
      fallback: 'Diagnosis not recorded',
    );
    final treatment = _text(
      data['treatmentPlan'] ?? data['treatment'],
      fallback: 'Treatment plan not recorded',
    );
    final created = _formatDateTime(data['createdAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.medical_information_rounded,
                    color: AppColors.primaryBlue,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DoctorReference(
                    doctorId: doctorId,
                    doctorName: doctor?.name,
                    specialty: doctor?.specialization,
                    onTap: doctorId == null
                        ? null
                        : () => _openDoctor(context, doctorId),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _CardTextSection(label: 'Diagnosis', value: diagnosis),
            const SizedBox(height: 10),
            _CardTextSection(label: 'Treatment plan', value: treatment),
            const SizedBox(height: 12),
            _AppointmentReference(
              appointment: appointment,
              available: appointmentId != null,
              onTap: appointmentId == null
                  ? null
                  : () => _showAppointmentSheet(context, appointmentId),
            ),
            if (created.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 15,
                    color: AppColors.gray,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Created  $created',
                    style: const TextStyle(fontSize: 12, color: AppColors.gray),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showVisitDetailsSheet(context, data),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('View visit details'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDoctor(BuildContext context, int doctorId) async {
    final doctor = await controller.getDoctorForVisit(doctorId);
    if (!context.mounted) return;
    if (doctor == null) {
      _showUnavailable(context, 'Doctor information is unavailable.');
      return;
    }
    Get.to(() => DoctorProfileView(), arguments: doctor);
  }

  Future<void> _showAppointmentSheet(
    BuildContext context,
    int appointmentId,
  ) async {
    final appointment = await controller.getAppointmentForVisit(appointmentId);
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) =>
          _AppointmentDetailsSheet(appointment: appointment),
    );
  }

  void _showVisitDetailsSheet(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _VisitDetailsSheet(
        history: data,
        controller: controller,
        onOpenDoctor: (doctorId) => _openDoctor(sheetContext, doctorId),
        onOpenAppointment: (appointmentId) =>
            _showAppointmentSheet(sheetContext, appointmentId),
      ),
    );
  }
}

class _DoctorReference extends StatelessWidget {
  final int? doctorId;
  final String? doctorName;
  final String? specialty;
  final VoidCallback? onTap;

  const _DoctorReference({
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDoctor = doctorName != null && doctorName!.trim().isNotEmpty;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasDoctor
                          ? doctorName!.trim()
                          : 'Doctor information unavailable',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasDoctor &&
                              specialty != null &&
                              specialty!.trim().isNotEmpty
                          ? specialty!.trim()
                          : 'Medical visit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (doctorId != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentReference extends StatelessWidget {
  final AppointmentModel? appointment;
  final bool available;
  final VoidCallback? onTap;

  const _AppointmentReference({
    required this.appointment,
    required this.available,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final details = appointment == null
        ? (available
              ? 'Appointment information unavailable'
              : 'No linked appointment')
        : _appointmentDateTime(appointment!);
    final status = appointment?.status.trim();
    return Material(
      color: AppColors.primaryBlue.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                color: AppColors.primaryBlue,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    if (status != null && status.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (available)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTextSection extends StatelessWidget {
  final String label;
  final String value;

  const _CardTextSection({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

class _VisitDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> history;
  final MedicalRecordController controller;
  final ValueChanged<int> onOpenDoctor;
  final ValueChanged<int> onOpenAppointment;

  const _VisitDetailsSheet({
    required this.history,
    required this.controller,
    required this.onOpenDoctor,
    required this.onOpenAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final doctorId = _asId(history['doctorProfileId']);
    final appointmentId = _asId(history['appointmentId']);
    final diagnosis = _text(
      history['diagnosis'],
      fallback: 'Diagnosis not recorded',
    );
    final treatment = _text(
      history['treatmentPlan'] ?? history['treatment'],
      fallback: 'Treatment plan not recorded',
    );
    final notes = _text(history['doctorNotes'] ?? history['notes']);
    final created = _formatDateTime(history['createdAt']);

    return Obx(() {
      final doctor = doctorId == null
          ? null
          : controller.doctorForVisit(doctorId);
      final appointment = appointmentId == null
          ? null
          : controller.appointmentForVisit(appointmentId);
      return _RoundedSheet(
        title: 'Visit Details',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailReferenceRow(
              icon: Icons.person_outline_rounded,
              label: 'Doctor',
              value: doctor?.name ?? 'Doctor information unavailable',
              subtitle: doctor?.specialization,
              onTap: doctorId == null ? null : () => onOpenDoctor(doctorId),
            ),
            const SizedBox(height: 12),
            _DetailReferenceRow(
              icon: Icons.event_available_outlined,
              label: 'Appointment',
              value: appointment == null
                  ? 'Appointment information unavailable'
                  : _appointmentDateTime(appointment),
              subtitle: appointment?.status.toUpperCase(),
              onTap: appointmentId == null
                  ? null
                  : () => onOpenAppointment(appointmentId),
            ),
            const SizedBox(height: 18),
            _DetailTextSection(label: 'Diagnosis', value: diagnosis),
            const SizedBox(height: 14),
            _DetailTextSection(label: 'Treatment Plan', value: treatment),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 14),
              _DetailTextSection(label: 'Doctor Notes', value: notes),
            ],
            if (created.isNotEmpty) ...[
              const SizedBox(height: 14),
              _DetailTextSection(
                label: 'Created',
                value: created,
                secondary: true,
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _AppointmentDetailsSheet extends StatelessWidget {
  final AppointmentModel? appointment;

  const _AppointmentDetailsSheet({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return _RoundedSheet(
      title: 'Appointment Details',
      child: appointment == null
          ? const _UnavailableSheetMessage(
              message: 'This appointment could not be loaded.',
            )
          : AppointmentCard(
              appointment: appointment!,
              showCancellationAction: false,
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
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailReferenceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const _DetailReferenceRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!.trim(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTextSection extends StatelessWidget {
  final String label;
  final String value;
  final bool secondary;

  const _DetailTextSection({
    required this.label,
    required this.value,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: secondary ? AppColors.gray : AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: secondary
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _UnavailableSheetMessage extends StatelessWidget {
  final String message;

  const _UnavailableSheetMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _VisitsEmptyState extends StatelessWidget {
  const _VisitsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_rounded,
                color: AppColors.primaryBlue,
                size: 45,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No medical visits found.',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int? _asId(dynamic value) => int.tryParse(value?.toString() ?? '');

String _text(dynamic value, {String fallback = ''}) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

String _shortTime(String value) {
  final time = value.trim();
  return time.length >= 5 ? time.substring(0, 5) : time;
}

String _appointmentDateTime(AppointmentModel appointment) {
  final date = _formatDate(appointment.date);
  final time = [
    _shortTime(appointment.startTime),
    _shortTime(appointment.endTime),
  ].where((part) => part.isNotEmpty).join(' - ');
  if (date.isEmpty) {
    return time.isEmpty ? 'Appointment information unavailable' : time;
  }
  return time.isEmpty ? date : '$date · $time';
}

String _formatDateTime(dynamic rawDate) {
  final date = DateTime.tryParse(rawDate?.toString() ?? '')?.toLocal();
  if (date == null) return '';
  final dateText = '${_monthName(date.month)} ${date.day}, ${date.year}';
  final timeText =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  return '$dateText · $timeText';
}

String _formatDate(String rawDate) {
  final date = DateTime.tryParse(rawDate)?.toLocal();
  if (date == null) return '';
  return '${_monthName(date.month)} ${date.day}, ${date.year}';
}

String _monthName(int month) {
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
  return month >= 1 && month <= 12 ? months[month - 1] : '';
}

void _showUnavailable(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
