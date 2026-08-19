import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/queue/controller/patient_queue_controller.dart';
import 'package:tabibi/features/queue/model/queue_patient.dart';

class PatientQueueView extends GetView<PatientQueueController> {
  const PatientQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Queue',
              style: TextStyle(
                color: Color(0xFF172033),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track Your Appointment Queue',
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 18), child: _LiveChip()),
        ],
      ),
      body: Obx(() {
        final current = controller.currentAppointment;
        if (controller.isLoading.value && current == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty && current == null) {
          return _QueueStatePanel(
            message: controller.errorMessage.value,
            actionLabel: 'Try again',
            onPressed: controller.fetchLiveStatus,
          );
        }
        if (current == null) {
          return _QueueStatePanel(
            message: 'No active queue appointment right now.',
            actionLabel: 'Refresh',
            onPressed: controller.fetchLiveStatus,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: () async {
            controller.now.value = DateTime.now();
            await Future<void>.delayed(const Duration(milliseconds: 300));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              _PatientOverview(
                current: current,
                patientsAhead: controller.patientsAhead,
              ),
              const SizedBox(height: 18),
              _QueueFilters(controller: controller),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    'Queue appointments',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CountBadge(count: controller.visibleAppointments.length),
                ],
              ),
              const SizedBox(height: 10),
              if (controller.visibleAppointments.isEmpty)
                const _EmptyState()
              else
                ...controller.visibleAppointments.map(
                  (appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PatientAppointmentCard(
                      appointment: appointment,
                      now: controller.now.value,
                      isCurrent: appointment.id == current.id,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFECFDF3),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: Color(0xFF22C55E), size: 9),
        SizedBox(width: 6),
        Text(
          'Live',
          style: TextStyle(
            color: Color(0xFF15803D),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _PatientOverview extends StatelessWidget {
  const _PatientOverview({required this.current, required this.patientsAhead});
  final QueuePatient current;
  final int patientsAhead;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primaryBlue, Color(0xFF47A8F5)],
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withValues(alpha: .22),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your appointment today',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _OverviewMetric(
              label: 'Your position',
              value: '#${current.position}',
            ),
            _Divider(),
            _OverviewMetric(label: 'Patients ahead', value: '$patientsAhead'),
            _Divider(),
            _OverviewMetric(
              label: 'Est. wait',
              value:
                  current.status == QueuePatientStatus.completed ||
                      current.status == QueuePatientStatus.skipped
                  ? '—'
                  : '${current.waitingTimeMinutes} min',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _StatusBadge(status: current.status, light: true),
      ],
    ),
  );
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    ),
  );
}

class _Divider extends Container {
  _Divider() : super(width: 1, height: 32, color: Colors.white24);
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.primaryBlue.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '$count',
      style: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w800,
        fontSize: 12,
      ),
    ),
  );
}

class _QueueFilters extends StatelessWidget {
  const _QueueFilters({required this.controller});
  final PatientQueueController controller;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextField(
        onChanged: controller.updateSearch,
        decoration: InputDecoration(
          hintText: 'Search doctor, clinic, or appointment ID',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryBlue,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(AppColors.primaryBlue),
        ),
      ),
      const SizedBox(height: 11),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Filter(
              label: 'All',
              active: controller.selectedStatus.value == null,
              onTap: () => controller.selectStatus(null),
            ),
            ...QueuePatientStatus.values.map(
              (status) => _Filter(
                label: _label(status),
                active: controller.selectedStatus.value == status,
                color: _color(status),
                onTap: () => controller.selectStatus(status),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 11),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: const Color(0xFFE0E7F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.sort_rounded,
              color: AppColors.primaryBlue,
              size: 19,
            ),
            const SizedBox(width: 8),
            const Text('Sort', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<QueueSort>(
                  isExpanded: true,
                  value: controller.selectedSort.value,
                  items: const [
                    DropdownMenuItem(
                      value: QueueSort.positionAscending,
                      child: Text('Position: ASC'),
                    ),
                    DropdownMenuItem(
                      value: QueueSort.checkInTimeAscending,
                      child: Text('Check-in Time: ASC'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.changeSort(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
  OutlineInputBorder _border([Color color = const Color(0xFFE0E7F0)]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );
}

class _Filter extends StatelessWidget {
  const _Filter({
    required this.label,
    required this.active,
    required this.onTap,
    this.color = AppColors.primaryBlue,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => onTap(),
      selectedColor: color.withValues(alpha: .14),
      backgroundColor: AppColors.white,
      side: BorderSide(color: active ? color : const Color(0xFFE0E7F0)),
      labelStyle: TextStyle(
        color: active ? color : const Color(0xFF5C6B82),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _PatientAppointmentCard extends StatelessWidget {
  const _PatientAppointmentCard({
    required this.appointment,
    required this.now,
    required this.isCurrent,
  });
  final QueuePatient appointment;
  final DateTime now;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    final delay = appointment.delayFromAppointmentMinutes;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppColors.primaryBlue.withValues(alpha: .45)
              : const Color(0xFFE3EAF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#${appointment.position}',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${appointment.doctorSpecialty} • ${appointment.clinicName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: appointment.status),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 7,
            children: [
              _TypeChip(type: appointment.appointmentType),
              _Info(
                icon: Icons.login_rounded,
                label: 'Check-in ${appointment.checkedInAt == null ? '' : _time(appointment.checkedInAt!)}',
              ),
              _Info(
                icon: Icons.event_available_outlined,
                label: _delay(delay),
                color: delay > 0
                    ? const Color(0xFFEA580C)
                    : const Color(0xFF15803D),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Elapsed wait',
                    value:
                        '${appointment.waitingTimeMinutes} min',
                    icon: Icons.hourglass_bottom_rounded,
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Est. remaining',
                    value: appointment.waitingTimeMinutes == 0
                        ? '—'
                        : '${appointment.waitingTimeMinutes} min',
                    icon: Icons.timelapse_rounded,
                  ),
                ),
              ],
            ),
          ),
          if (appointment.startedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Started at ${_time(appointment.startedAt!)} • Duration ${appointment.consultationDurationMinutes} min',
                style: const TextStyle(
                  color: AppColors.gray,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 12),
          _StatusBanner(appointment: appointment, now: now),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, this.light = false});
  final QueuePatientStatus status;
  final bool light;
  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: light
            ? Colors.white.withValues(alpha: .2)
            : color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: light ? Colors.white54 : color.withValues(alpha: .3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: light ? Colors.white : color, size: 7),
          const SizedBox(width: 5),
          Text(
            _label(status),
            style: TextStyle(
              color: light ? Colors.white : color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});
  final QueueAppointmentType type;
  @override
  Widget build(BuildContext context) {
    final color = type == QueueAppointmentType.consultation
        ? AppColors.primaryBlue
        : type == QueueAppointmentType.followUp
        ? const Color(0xFF7C3AED)
        : const Color(0xFFDC2626);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type == QueueAppointmentType.consultation
            ? 'Consultation'
            : type == QueueAppointmentType.followUp
            ? 'Follow-up'
            : 'Operation',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.icon,
    required this.label,
    this.color = AppColors.gray,
  });
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.primaryBlue, size: 17),
      const SizedBox(width: 7),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 10),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF26334D),
            ),
          ),
        ],
      ),
    ],
  );
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.appointment, required this.now});
  final QueuePatient appointment;
  final DateTime now;
  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final String text;
    late final Color color;
    switch (appointment.status) {
      case QueuePatientStatus.calling:
        icon = Icons.campaign_rounded;
        text = "It's your turn! Please proceed to the doctor's room.";
        color = const Color(0xFFEA580C);
        break;
      case QueuePatientStatus.inProgress:
        icon = Icons.play_circle_fill_rounded;
        text = 'Your consultation is in progress • ${appointment.consultationDurationMinutes} min';
        color = const Color(0xFF5B21B6);
        break;
      case QueuePatientStatus.waiting:
        icon = Icons.schedule_rounded;
        text =
            'Estimated entry in ${appointment.waitingTimeMinutes} min.';
        color = AppColors.primaryBlue;
        break;
      case QueuePatientStatus.completed:
        icon = Icons.task_alt_rounded;
        text = 'Appointment completed. Thank you for visiting.';
        color = const Color(0xFF16A34A);
        break;
      case QueuePatientStatus.skipped:
        icon = Icons.info_outline_rounded;
        text = 'This appointment was marked as skipped.';
        color = const Color(0xFF64748B);
        break;
      case QueuePatientStatus.expired:
        icon = Icons.timer_off_outlined;
        text = 'This queue entry has expired.';
        color = const Color(0xFF94A3B8);
        break;
      case QueuePatientStatus.noShow:
        icon = Icons.person_off_outlined;
        text = 'This appointment was marked as no show.';
        color = const Color(0xFF991B1B);
        break;
    }
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(36),
    child: Center(
      child: Text(
        'No queue appointments match your search or filter.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.gray),
      ),
    ),
  );
}

Color _color(QueuePatientStatus status) {
  switch (status) {
    case QueuePatientStatus.waiting:
      return const Color(0xFF0284C7);
    case QueuePatientStatus.calling:
      return const Color(0xFFEA580C);
    case QueuePatientStatus.inProgress:
      return const Color(0xFF5B21B6);
    case QueuePatientStatus.completed:
      return const Color(0xFF16A34A);
    case QueuePatientStatus.skipped:
      return const Color(0xFF64748B);
    case QueuePatientStatus.expired:
      return const Color(0xFF94A3B8);
    case QueuePatientStatus.noShow:
      return const Color(0xFF991B1B);
  }
}

String _label(QueuePatientStatus status) => switch (status) {
  QueuePatientStatus.waiting => 'Waiting',
  QueuePatientStatus.calling => 'Calling',
  QueuePatientStatus.inProgress => 'In Progress',
  QueuePatientStatus.completed => 'Completed',
  QueuePatientStatus.skipped => 'Skipped',
  QueuePatientStatus.expired => 'Expired',
  QueuePatientStatus.noShow => 'No Show',
};
String _time(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  return '$hour:${value.minute.toString().padLeft(2, '0')} ${value.hour >= 12 ? 'PM' : 'AM'}';
}

String _delay(int value) => value == 0
    ? 'On time'
    : value > 0
    ? '$value min late'
    : '${value.abs()} min early';

class _QueueStatePanel extends StatelessWidget {
  const _QueueStatePanel({
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });
  final String message, actionLabel;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_busy_outlined,
            color: AppColors.primaryBlue,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
            label: Text(actionLabel),
          ),
        ],
      ),
    ),
  );
}
