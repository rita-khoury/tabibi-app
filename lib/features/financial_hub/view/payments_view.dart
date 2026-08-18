import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/constance/app_colors.dart';
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
          return _StateView(
            icon: Icons.cloud_off_outlined,
            title: 'Unable to load payments',
            message: controller.errorMessage.value!,
            actionLabel: 'Try again',
            onAction: controller.fetchPayments,
          );
        }

        if (controller.payments.isEmpty) {
          return _StateView(
            icon: Icons.receipt_long_outlined,
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your appointment and operation payment history',
          style: TextStyle(color: AppColors.gray, fontSize: 14, height: 1.45),
        ),
        SizedBox(height: 6),
        Text(
          'Pull down to refresh your payment history.',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        ),
      ],
    );
  }
}

class _StateView extends StatelessWidget {
  const _StateView({
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
          Row(
            children: [
              const Icon(Icons.person_outline, size: 17, color: AppColors.gray),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doctorName,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.local_hospital_outlined,
                size: 17,
                color: AppColors.gray,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  clinicName,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFE8EEF5)),
          ),
          Row(
            children: [
              Expanded(
                child: _InfoLabel(
                  icon: Icons.credit_card_outlined,
                  label: 'Payment method',
                  value: payment.displayMethod,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Amount paid',
                    style: TextStyle(color: AppColors.gray, fontSize: 11),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'EGP ${payment.displayAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
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

class _InfoLabel extends StatelessWidget {
  const _InfoLabel({
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
      children: [
        Icon(icon, size: 17, color: AppColors.gray),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.gray, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
      case 'PAID':
      case 'COMPLETED':
      case 'SUCCESS':
        return const _StatusAppearance(
          background: Color(0xFFE8F5E9),
          foreground: Color(0xFF2E7D32),
        );
      case 'HELD':
      case 'PENDING':
      case 'PROCESSING':
        return const _StatusAppearance(
          background: Color(0xFFFFF8E1),
          foreground: Color(0xFFF57F17),
        );
      case 'REFUNDED':
      case 'FAILED':
      case 'CANCELLED':
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
