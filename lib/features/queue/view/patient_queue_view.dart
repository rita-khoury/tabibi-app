import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/navigation/controller/navigation_controller.dart';
import 'package:tabibi/features/queue/controller/patient_queue_state_controller.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';

class PatientQueueView extends StatefulWidget {
  const PatientQueueView({super.key});

  @override
  State<PatientQueueView> createState() => _PatientQueueViewState();
}

class _PatientQueueViewState extends State<PatientQueueView> {
  static const _queueTabIndex = 3;

  late final PatientQueueStateController _controller = Get.find();
  NavigationController? _navigationController;
  Worker? _navigationWorker;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<NavigationController>()) {
      _navigationController = Get.find<NavigationController>();
      _navigationWorker = ever<int>(
        _navigationController!.selectedIndex,
        (_) => _syncQueueScreenVisibility(),
      );
      _syncQueueScreenVisibility();
    } else {
      _controller.activateQueueScreen();
    }
  }

  void _syncQueueScreenVisibility() {
    if (_navigationController?.selectedIndex.value == _queueTabIndex) {
      _controller.activateQueueScreen();
    } else {
      _controller.deactivateQueueScreen();
    }
  }

  @override
  void dispose() {
    _navigationWorker?.dispose();
    _controller.deactivateQueueScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'الطابور',
          style: TextStyle(
            color: Color(0xFF172033),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: _controller.loadActiveQueue,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        final state = _controller.loadState.value;
        final queue = _controller.activeQueue.value;

        if ((state == PatientQueueLoadState.initial ||
                state == PatientQueueLoadState.loading) &&
            queue == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state == PatientQueueLoadState.error) {
          return _QueueErrorState(onRetry: _controller.loadActiveQueue);
        }

        if (state == PatientQueueLoadState.empty || queue == null) {
          return const _QueueEmptyState();
        }

        return _ActiveQueueContent(
          queue: queue,
          isRefreshing: state == PatientQueueLoadState.loading,
        );
      }),
    );
  }
}

class _ActiveQueueContent extends StatelessWidget {
  const _ActiveQueueContent({required this.queue, required this.isRefreshing});

  final PatientQueueModel queue;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    if (queue.status == PatientQueueStatus.completed ||
        queue.status == PatientQueueStatus.skipped) {
      return const _QueueEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        if (isRefreshing) const LinearProgressIndicator(minHeight: 2),
        if (isRefreshing) const SizedBox(height: 14),
        _QueueHeader(queue: queue),
        const SizedBox(height: 16),
        switch (queue.status) {
          PatientQueueStatus.waiting => _WaitingQueueCard(queue: queue),
          PatientQueueStatus.calling => _CallingQueueCard(queue: queue),
          PatientQueueStatus.inProgress => _InProgressQueueCard(queue: queue),
          PatientQueueStatus.completed ||
          PatientQueueStatus.skipped => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader({required this.queue});

  final PatientQueueModel queue;

  @override
  Widget build(BuildContext context) {
    final doctorName = queue.doctor?.fullName ?? 'الطبيب';
    final clinicName = queue.clinic?.name ?? 'العيادة';
    final appointment = queue.appointment;
    final appointmentTime = appointment == null
        ? null
        : _formatAppointmentTime(
            appointment.requestedDate,
            appointment.startTime,
          );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E7F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doctorName,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            clinicName,
            style: const TextStyle(color: AppColors.gray, fontSize: 14),
          ),
          if (appointmentTime != null) ...[
            const Divider(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  appointmentTime,
                  style: const TextStyle(
                    color: Color(0xFF415168),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WaitingQueueCard extends StatelessWidget {
  const _WaitingQueueCard({required this.queue});

  final PatientQueueModel queue;

  @override
  Widget build(BuildContext context) {
    final position = queue.currentPosition;
    final patientsAhead = queue.patientsAhead;
    final waitMinutes = queue.expectedWaitingTimeMinutes;
    final delay = queue.patientDelayMinutes;

    return Container(
      key: const Key('queue-waiting'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
          const _StatusTitle(
            icon: Icons.hourglass_top_rounded,
            title: 'في الانتظار',
            subtitle: 'سيتم إشعارك عند حلول دورك',
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _Metric(
                label: 'موقعك',
                value: position == null ? '—' : '#$position',
              ),
              _Metric(
                label: 'أمامك',
                value: patientsAhead == null ? '—' : '$patientsAhead',
              ),
              _Metric(
                label: 'الانتظار',
                value: waitMinutes == null ? '—' : '$waitMinutes د',
              ),
            ],
          ),
          const Divider(height: 30),
          _DetailRow(
            icon: Icons.flag_outlined,
            label: 'التصنيف',
            value: queue.priorityGroup == PatientQueuePriorityGroup.normal
                ? 'عادي'
                : 'متأخر',
            valueColor: queue.priorityGroup == PatientQueuePriorityGroup.normal
                ? const Color(0xFF15803D)
                : const Color(0xFFB45309),
          ),
          if (queue.checkInAt != null) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.login_rounded,
              label: 'وقت تسجيل الوصول',
              value: _formatTime(queue.checkInAt!),
            ),
          ],
          if (delay != null && delay > 0) ...[
            const SizedBox(height: 12),
            Text(
              'متأخر عن موعدك بـ $delay دقائق',
              style: const TextStyle(
                color: Color(0xFFB45309),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CallingQueueCard extends StatelessWidget {
  const _CallingQueueCard({required this.queue});

  final PatientQueueModel queue;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('queue-calling'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.campaign_rounded,
            color: Color(0xFF15803D),
            size: 48,
          ),
          const SizedBox(height: 14),
          const Text(
            'حان دورك',
            style: TextStyle(
              color: Color(0xFF14532D),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى التوجه إلى الطبيب',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF166534), fontSize: 15),
          ),
          if (queue.calledAt != null) ...[
            const SizedBox(height: 18),
            Text(
              'تم النداء: ${_formatTime(queue.calledAt!)}',
              style: const TextStyle(
                color: Color(0xFF166534),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InProgressQueueCard extends StatelessWidget {
  const _InProgressQueueCard({required this.queue});

  final PatientQueueModel queue;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('queue-in-progress'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: AppColors.primaryBlue,
            size: 48,
          ),
          SizedBox(height: 14),
          Text(
            'أنت الآن مع الطبيب',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF172033),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'نتمنى لك دوام الصحة والعافية',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF5C6B82), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _StatusTitle extends StatelessWidget {
  const _StatusTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF172033),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.gray, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF172033),
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(color: AppColors.gray, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _QueueEmptyState extends StatelessWidget {
  const _QueueEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: Key('queue-empty'),
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              color: AppColors.primaryBlue,
              size: 52,
            ),
            SizedBox(height: 16),
            Text(
              'لا يوجد لديك طابور فعال حاليًا',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF172033),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'عندما يكون لديك موعد داخل الطابور، ستظهر حالته هنا.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueErrorState extends StatelessWidget {
  const _QueueErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('queue-error'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.gray,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'تعذر تحميل حالة الطابور',
              style: TextStyle(
                color: Color(0xFF172033),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى المحاولة مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

String? _formatAppointmentTime(DateTime? date, String? time) {
  final formattedDate = date == null
      ? null
      : DateFormat('d MMM y', 'ar').format(date);
  if (formattedDate == null && (time == null || time.isEmpty)) return null;
  if (formattedDate == null) return time;
  if (time == null || time.isEmpty) return formattedDate;
  return '$formattedDate · $time';
}

String _formatTime(DateTime date) => DateFormat('h:mm a', 'ar').format(date);
