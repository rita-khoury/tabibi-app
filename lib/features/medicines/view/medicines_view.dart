import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/model/appointment_model.dart';
import 'package:tabibi/features/appointments/widgets/appointment_card.dart';
import 'package:tabibi/features/medicines/controller/medicines_controller.dart';
import 'package:tabibi/features/medicines/model/prescribed_medicine_model.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MedicinesController>()
        ? Get.find<MedicinesController>()
        : Get.put(MedicinesController());
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Medicines'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.profileMedicines.isEmpty &&
            controller.historyMedicines.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        if (controller.errorMessage.value != null &&
            controller.profileMedicines.isEmpty &&
            controller.historyMedicines.isEmpty) {
          return _MedicinesLoadError(
            message: controller.errorMessage.value!,
            onRetry: controller.fetchMedicines,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: controller.fetchMedicines,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _MedicineSectionHeader(
                title: 'Permanent Medicines',
                subtitle: 'Medicines kept in your medical record',
              ),
              const SizedBox(height: 10),
              _MedicineSectionList(
                medicines: controller.profileMedicines,
                controller: controller,
                emptyMessage: 'No permanent medicines.',
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _showAddMedicineSheet(context, controller),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Medicine'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: BorderSide(
                    color: AppColors.primaryBlue.withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              _MedicineSectionHeader(
                title: 'Temporary Medicines',
                subtitle: 'Medicines prescribed during your medical visits',
              ),
              const SizedBox(height: 10),
              _MedicineSectionList(
                medicines: controller.historyMedicines,
                controller: controller,
                emptyMessage: 'No temporary medicines.',
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _MedicineSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MedicineSectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.gray, fontSize: 13),
        ),
      ],
    );
  }
}

class _MedicineSectionList extends StatelessWidget {
  final List<PrescribedMedicineModel> medicines;
  final MedicinesController controller;
  final String emptyMessage;

  const _MedicineSectionList({
    required this.medicines,
    required this.controller,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return _SectionEmptyState(message: emptyMessage);
    }
    return Column(
      children: medicines
          .map(
            (medicine) =>
                _MedicineCard(medicine: medicine, controller: controller),
          )
          .toList(),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final PrescribedMedicineModel medicine;
  final MedicinesController controller;

  const _MedicineCard({required this.medicine, required this.controller});

  @override
  Widget build(BuildContext context) {
    final owned = controller.isOwnedByCurrentPatient(medicine);
    final doctor = controller.cachedDoctorFor(medicine);
    final appointment = controller.cachedAppointmentFor(medicine);
    final metadata = [
      medicine.dosage,
      medicine.frequency,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');
    final period = _datePeriod(medicine.startDate, medicine.endDate);
    final created = _formatDateTime(medicine.createdAt);
    final attribution = owned
        ? 'Added by you'
        : doctor == null
        ? 'Added by a doctor'
        : 'Added by Dr. ${doctor.name}';

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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showMedicineDetails(context, controller, medicine),
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
                        Icons.medication_outlined,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine.medicineName.isEmpty
                                ? 'Medicine'
                                : medicine.medicineName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (metadata.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              metadata,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _StatusBadge(status: medicine.status),
                  ],
                ),
                if (period.isNotEmpty) ...[
                  const SizedBox(height: 11),
                  _MetaLine(icon: Icons.event_outlined, text: period),
                ],
                if (medicine.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    medicine.notes!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
                if (created.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _MetaLine(
                    icon: Icons.history_rounded,
                    text: 'Created $created',
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  attribution,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.gray, fontSize: 12),
                ),
                if (medicine.medicalHistoryId != null) ...[
                  const SizedBox(height: 8),
                  _RelatedVisitRow(
                    appointment: appointment,
                    onTap: () =>
                        _showRelatedAppointment(context, controller, medicine),
                  ),
                ],
                if (owned) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: controller.updatingMedicineIds.contains(medicine.id)
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryBlue,
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () =>
                                _showStatusSheet(context, controller, medicine),
                            icon: const Icon(Icons.sync_alt_rounded, size: 16),
                            label: const Text('Change status'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                            ),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = switch (normalized) {
      'completed' => Colors.green,
      'stopped' => Colors.redAccent,
      _ => AppColors.primaryBlue,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _statusLabel(normalized),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
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
        const SizedBox(width: 6),
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

class _RelatedVisitRow extends StatelessWidget {
  final AppointmentModel? appointment;
  final VoidCallback onTap;

  const _RelatedVisitRow({required this.appointment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final detail = appointment == null
        ? 'From visit'
        : 'From visit · ${_appointmentDateTime(appointment!)}';
    return Material(
      color: AppColors.primaryBlue.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                color: AppColors.primaryBlue,
                size: 17,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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

class _SectionEmptyState extends StatelessWidget {
  final String message;

  const _SectionEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.45)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.gray, fontSize: 13),
      ),
    );
  }
}

class _MedicinesLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MedicinesLoadError({required this.message, required this.onRetry});

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

class _AddMedicineSheet extends StatefulWidget {
  final MedicinesController controller;

  const _AddMedicineSheet({required this.controller});

  @override
  State<_AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends State<_AddMedicineSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final payload = <String, dynamic>{
      'medicineName': _nameController.text.trim(),
      if (_dosageController.text.trim().isNotEmpty)
        'dosage': _dosageController.text.trim(),
      if (_frequencyController.text.trim().isNotEmpty)
        'frequency': _frequencyController.text.trim(),
      if (_notesController.text.trim().isNotEmpty)
        'notes': _notesController.text.trim(),
    };
    final saved = await widget.controller.addProfileMedicine(payload);
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine added successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.controller.errorMessage.value ?? 'Unable to add medicine.',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _RoundedSheet(
      title: 'Add Medicine',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Medicine name *'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Medicine name is required.'
                  : null,
            ),
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(labelText: 'Dosage'),
            ),
            TextFormField(
              controller: _frequencyController,
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            TextFormField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 18),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.controller.isSaving.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: widget.controller.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text('Add Medicine'),
                ),
              ),
            ),
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

class _MedicineDetailsSheet extends StatelessWidget {
  final MedicinesController controller;
  final PrescribedMedicineModel medicine;

  const _MedicineDetailsSheet({
    required this.controller,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    final owned = controller.isOwnedByCurrentPatient(medicine);
    final doctor = controller.cachedDoctorFor(medicine);
    final appointment = controller.cachedAppointmentFor(medicine);
    final attribution = owned
        ? 'Added by you'
        : doctor == null
        ? 'Added by a doctor'
        : 'Added by Dr. ${doctor.name}';
    return _RoundedSheet(
      title: 'Medicine Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailItem(label: 'Medicine', value: medicine.medicineName),
          if (medicine.dosage != null)
            _DetailItem(label: 'Dosage', value: medicine.dosage!),
          if (medicine.frequency != null)
            _DetailItem(label: 'Frequency', value: medicine.frequency!),
          _DetailItem(label: 'Status', value: _statusLabel(medicine.status)),
          if (_datePeriod(medicine.startDate, medicine.endDate).isNotEmpty)
            _DetailItem(
              label: 'Schedule',
              value: _datePeriod(medicine.startDate, medicine.endDate),
            ),
          if (medicine.notes != null)
            _DetailItem(label: 'Notes', value: medicine.notes!),
          if (_formatDateTime(medicine.createdAt).isNotEmpty)
            _DetailItem(
              label: 'Created',
              value: _formatDateTime(medicine.createdAt),
            ),
          _DetailItem(label: 'Added by', value: attribution),
          if (medicine.medicalHistoryId != null) ...[
            const SizedBox(height: 12),
            _RelatedVisitRow(
              appointment: appointment,
              onTap: () =>
                  _showRelatedAppointment(context, controller, medicine),
            ),
          ],
          if (owned) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    _showStatusSheet(context, controller, medicine),
                icon: const Icon(Icons.sync_alt_rounded),
                label: const Text('Change status'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
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
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

void _showAddMedicineSheet(
  BuildContext context,
  MedicinesController controller,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddMedicineSheet(controller: controller),
  );
}

void _showMedicineDetails(
  BuildContext context,
  MedicinesController controller,
  PrescribedMedicineModel medicine,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _MedicineDetailsSheet(controller: controller, medicine: medicine),
  );
}

void _showStatusSheet(
  BuildContext context,
  MedicinesController controller,
  PrescribedMedicineModel medicine,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _RoundedSheet(
      title: 'Change medicine status',
      child: Column(
        children: ['active', 'completed', 'stopped']
            .map(
              (status) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _StatusBadge(status: status),
                title: Text(_statusLabel(status)),
                trailing: medicine.status == status
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.primaryBlue,
                      )
                    : null,
                onTap: () async {
                  if (medicine.status == status) {
                    Navigator.of(sheetContext).pop();
                    return;
                  }
                  final updated = await controller.updateStatus(
                    medicine,
                    status,
                  );
                  if (!sheetContext.mounted) return;
                  if (updated) {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Medicine status updated.'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          controller.errorMessage.value ??
                              'Unable to update medicine status.',
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    ),
  );
}

Future<void> _showRelatedAppointment(
  BuildContext context,
  MedicinesController controller,
  PrescribedMedicineModel medicine,
) async {
  final appointmentId = controller.appointmentIdFor(medicine);
  if (appointmentId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Related visit information is unavailable.'),
      ),
    );
    return;
  }
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

String _statusLabel(String status) => switch (status.toLowerCase()) {
  'completed' => 'Completed',
  'stopped' => 'Stopped',
  _ => 'Active',
};

String _datePeriod(String? start, String? end) {
  final startText = start == null ? '' : _formatDate(start);
  final endText = end == null ? '' : _formatDate(end);
  if (startText.isNotEmpty && endText.isNotEmpty) {
    return '$startText → $endText';
  }
  if (startText.isNotEmpty) return 'From $startText';
  if (endText.isNotEmpty) return 'Until $endText';
  return '';
}

String _appointmentDateTime(AppointmentModel appointment) {
  final date = _formatDate(appointment.date);
  final start = _shortTime(appointment.startTime);
  final end = _shortTime(appointment.endTime);
  final time = [start, end].where((value) => value.isNotEmpty).join(' - ');
  if (date.isEmpty) return time.isEmpty ? 'Visit details unavailable' : time;
  return time.isEmpty ? date : '\$date · \$time';
}

String _shortTime(String value) {
  final time = value.trim();
  return time.length >= 5 ? time.substring(0, 5) : time;
}

String _formatDateTime(String? raw) {
  final date = DateTime.tryParse(raw ?? '')?.toLocal();
  if (date == null) return '';
  final dateText = _formatDate(date.toIso8601String());
  final timeText =
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  return '$dateText · $timeText';
}

String _formatDate(String raw) {
  final date = DateTime.tryParse(raw)?.toLocal();
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
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
