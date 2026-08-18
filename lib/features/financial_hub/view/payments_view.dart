import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/doctor_profile/view/doctor_profile_view.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/financial_hub/controller/payments_controller.dart';

class PaymentsView extends GetView<PaymentsController> {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text(
          'Payments',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.payments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.errorMessage.value != null &&
            controller.payments.isEmpty) {
          return _PaymentStateView(
            icon: Icons.cloud_off_outlined,
            title: 'Unable to load payments',
            message: controller.errorMessage.value!,
            actionLabel: 'Try again',
            onAction: controller.fetchPayments,
          );
        }

        if (controller.payments.isEmpty) {
          return _PaymentStateView(
            icon: Icons.payments_outlined,
            title: 'No payments yet',
            message:
                'Your appointment and operation payments will appear here.',
            actionLabel: 'Refresh',
            onAction: controller.fetchPayments,
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: controller.fetchPayments,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            itemCount: controller.payments.length + 1,
            separatorBuilder: (_, index) =>
                SizedBox(height: index == 0 ? 18 : 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _PageHeader();
              }
              return _PaymentCard(payment: controller.payments[index - 1]);
            },
          ),
        );
      }),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Your appointment and operation payment history',
      style: TextStyle(color: AppColors.gray, fontSize: 14, height: 1.45),
    );
  }
}

class _PaymentStateView extends StatelessWidget {
  const _PaymentStateView({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final Future<void> Function() onAction;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: onAction,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
          Icon(icon, size: 58, color: AppColors.primaryBlue),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.gray,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    final appearance = _StatusAppearance.fromStatus(payment.status);
    final doctorName = payment.doctorName.trim().isEmpty
        ? 'Doctor not available'
        : payment.doctorName;
    final clinicName = payment.clinicName.trim().isEmpty
        ? 'Clinic not available'
        : payment.clinicName;
    final appointmentType = payment.appointmentType.trim().isEmpty
        ? 'Appointment'
        : payment.appointmentType;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EEF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
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
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointmentType,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(payment.paidAt),
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(
                label: payment.displayStatus,
                appearance: appearance,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InformationRow(icon: Icons.person_outline, label: doctorName),
          const SizedBox(height: 8),
          _InformationRow(icon: Icons.location_on_outlined, label: clinicName),
          const SizedBox(height: 8),
          _InformationRow(
            icon: Icons.credit_card_outlined,
            label: payment.displayMethod,
          ),
          if (payment.hasFailureReason) ...[
            const SizedBox(height: 14),
            _FailureReasonBanner(reason: payment.failureReason!),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFE8EEF5)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _PaymentAmountSummary(payment: payment),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => showPaymentDetailsBottomSheet(payment),
              icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
              label: const Text('View payment details'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Date not available';
    }
    return DateFormat('dd MMM yyyy • h:mm a').format(value);
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.gray),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentAmountSummary extends StatelessWidget {
  const _PaymentAmountSummary({required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    final refund = payment.refundAmount ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Refunded amount',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          '${refund.toStringAsFixed(2)} Pts',
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (payment.hasPenalty) ...[
          const SizedBox(height: 8),
          const Text(
            'Penalty amount',
            style: TextStyle(color: Color(0xFFDC2626), fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            '${payment.penaltyAmount!.toStringAsFixed(2)} Pts',
            style: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 8),
        const Text(
          'Amount paid',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          '${payment.displayAmount.toStringAsFixed(2)} Pts',
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FailureReasonBanner extends StatelessWidget {
  const _FailureReasonBanner({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reason,
              style: const TextStyle(
                color: Color(0xFF991B1B),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showPaymentDetailsBottomSheet(PaymentRecord payment) {
  Get.bottomSheet<void>(
    PaymentDetailsBottomSheet(payment: payment),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class PaymentDetailsBottomSheet extends StatelessWidget {
  const PaymentDetailsBottomSheet({super.key, required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    final appearance = _StatusAppearance.fromStatus(payment.status);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Payment Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF1F2937),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close, color: Color(0xFF475569)),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                children: [
                  _DetailsTile(
                    icon: Icons.person_outline,
                    title: payment.doctorName.trim().isEmpty
                        ? 'Doctor not available'
                        : payment.doctorName,
                    subtitle: payment.doctorSpecialty.trim().isEmpty
                        ? 'Doctor profile'
                        : payment.doctorSpecialty,
                    onTap: () => _openDoctorProfile(context, payment),
                  ),
                  const SizedBox(height: 12),
                  _DetailsTile(
                    icon: Icons.calendar_today_outlined,
                    title: _formatDate(payment.appointmentAt ?? payment.paidAt),
                    subtitle: payment.displayAppointmentStatus,
                    trailing: _StatusBadge(
                      label: payment.displayAppointmentStatus,
                      appearance: appearance,
                    ),
                    onTap: () => _openAppointmentDetails(payment),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Payment breakdown',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _BreakdownCard(payment: payment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDoctorProfile(
    BuildContext context,
    PaymentRecord payment,
  ) async {
    final doctorId = int.tryParse(payment.doctorId ?? '');
    if (doctorId == null || doctorId <= 0) {
      _showUnavailable(
        context,
        'This payment does not include a doctor profile reference.',
      );
      return;
    }

    final recordsController = Get.isRegistered<MedicalRecordController>()
        ? Get.find<MedicalRecordController>()
        : Get.put(MedicalRecordController());
    final doctor = await recordsController.getDoctorForVisit(doctorId);
    if (!context.mounted) return;
    if (doctor == null) {
      _showUnavailable(context, 'Doctor information is unavailable.');
      return;
    }
    Get.to(() => DoctorProfileView(), arguments: doctor);
  }

  void _showUnavailable(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _openAppointmentDetails(PaymentRecord payment) {
    if (payment.appointmentId == null) {
      Get.snackbar(
        'Appointment unavailable',
        'This payment does not include an appointment reference.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.back();
    Future<void>.delayed(
      Duration.zero,
      () => Get.bottomSheet<void>(
        AppointmentDetailsBottomSheet(payment: payment),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Appointment date not available';
    }
    return DateFormat('dd MMM yyyy • h:mm a').format(value);
  }
}

class AppointmentDetailsBottomSheet extends StatelessWidget {
  const AppointmentDetailsBottomSheet({super.key, required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    final appearance = _StatusAppearance.fromStatus(payment.appointmentStatus);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Appointment Details',
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close, color: Color(0xFF475569)),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _AppointmentSummaryRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date and time',
                    value: PaymentDetailsBottomSheet._formatDate(
                      payment.appointmentAt ?? payment.paidAt,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _AppointmentSummaryRow(
                    icon: Icons.person_outline,
                    label: 'Doctor',
                    value: payment.doctorName.trim().isEmpty
                        ? 'Doctor not available'
                        : payment.doctorName,
                  ),
                  const SizedBox(height: 14),
                  _AppointmentSummaryRow(
                    icon: Icons.local_hospital_outlined,
                    label: 'Clinic',
                    value: payment.clinicName.trim().isEmpty
                        ? 'Clinic not available'
                        : payment.clinicName,
                  ),
                  const SizedBox(height: 14),
                  _AppointmentSummaryRow(
                    icon: Icons.medical_services_outlined,
                    label: 'Appointment type',
                    value: payment.appointmentType.trim().isEmpty
                        ? 'Appointment'
                        : payment.appointmentType,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _StatusBadge(
                      label: payment.displayAppointmentStatus,
                      appearance: appearance,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsTile extends StatelessWidget {
  const _DetailsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.payment});

  final PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _BreakdownRow(label: 'Original amount', value: _egp(payment.amount)),
          _BreakdownRow(
            label: 'Refunded amount',
            value: _egp(payment.refundAmount ?? 0),
          ),
          if (payment.hasPenalty)
            _BreakdownRow(
              label: 'Penalty amount',
              value: _egp(payment.penaltyAmount!),
              valueColor: const Color(0xFFDC2626),
            ),
          _BreakdownRow(
            label: 'Final paid amount',
            value: _egp(payment.displayAmount),
            isEmphasized: true,
          ),
          const Divider(height: 24, color: Color(0xFFE8EEF5)),
          _BreakdownRow(label: 'Payment method', value: payment.displayMethod),
          _BreakdownRow(label: 'Status', value: payment.displayStatus),
          if (payment.hasFailureReason) ...[
            const SizedBox(height: 14),
            _FailureReasonBanner(reason: payment.failureReason!),
          ],
        ],
      ),
    );
  }

  String _egp(double value) => '${value.toStringAsFixed(2)} Pts';
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1F2937),
    this.isEmphasized = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: isEmphasized ? 15 : 13,
              fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentSummaryRow extends StatelessWidget {
  const _AppointmentSummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.appearance});

  final String label;
  final _StatusAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: appearance.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: appearance.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusAppearance {
  const _StatusAppearance({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  factory _StatusAppearance.fromStatus(String status) {
    switch (status.trim().toUpperCase()) {
      case 'SUCCESS':
      case 'COMPLETED':
      case 'PAID':
        return const _StatusAppearance(
          background: Color(0xFFE8F5E9),
          foreground: Color(0xFF2E7D32),
        );
      case 'PENDING':
      case 'HELD':
      case 'PROCESSING':
        return const _StatusAppearance(
          background: Color(0xFFFFF8E1),
          foreground: Color(0xFFF57F17),
        );
      case 'FAILED':
      case 'CANCELLED':
      case 'REJECTED':
        return const _StatusAppearance(
          background: Color(0xFFFFEBEE),
          foreground: Color(0xFFC62828),
        );
      default:
        return const _StatusAppearance(
          background: Color(0xFFE3F2FD),
          foreground: Color(0xFF1565C0),
        );
    }
  }
}
