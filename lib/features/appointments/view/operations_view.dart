import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/routes/app_routes.dart';

import '../controller/appointments_controller.dart';
import '../model/appointment_model.dart';
import '../widgets/appointment_card.dart';

class OperationsView extends GetView<AppointmentsController> {
  const OperationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Operations',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<AppointmentsController>(
        builder: (controller) {
          final operations = _operationsFrom(controller);

          if (controller.isLoading && operations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryBlue,
            onRefresh: controller.fetchAppointments,
            child: operations.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: const [
                      SizedBox(height: 96),
                      Icon(
                        Icons.medical_services_outlined,
                        size: 56,
                        color: AppColors.gray,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No operation appointments found.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: operations.length,
                    itemBuilder: (context, index) {
                      final appointment = operations[index];
                      return AppointmentCard(
                        appointment: appointment,
                        showCancellationAction: false,
                        onTap: () =>
                            _showOperationDetails(context, appointment),
                        onPayOperation:
                            appointment.status.trim().toLowerCase() == 'pending'
                            ? () => _showOperationPayment(context, appointment)
                            : null,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  List<AppointmentModel> _operationsFrom(AppointmentsController controller) {
    return controller.allAppointments
        .where((appointment) => appointment.isOperation)
        .toList();
  }

  void _showOperationDetails(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OperationDetailsSheet(appointment: appointment),
    );
  }

  void _showOperationPayment(
    BuildContext context,
    AppointmentModel appointment,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OperationPaymentSheet(appointment: appointment),
    );
  }
}

class _OperationDetailsSheet extends StatelessWidget {
  const _OperationDetailsSheet({required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final operationCost = appointment.operationCost;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Operation Details',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailCard(
              icon: Icons.medical_services_outlined,
              label: 'Appointment type',
              value: appointment.type,
            ),
            _DetailCard(
              icon: Icons.person_outline,
              label: 'Doctor',
              value: appointment.doctorName,
            ),
            _DetailCard(
              icon: Icons.local_hospital_outlined,
              label: 'Clinic',
              value: appointment.clinicName ?? 'Clinic not available',
            ),
            _DetailCard(
              icon: Icons.calendar_today_outlined,
              label: 'Requested date',
              value: appointment.date,
            ),
            _DetailCard(
              icon: Icons.access_time_outlined,
              label: 'Time',
              value: appointment.time,
            ),
            _DetailCard(
              icon: Icons.info_outline,
              label: 'Appointment status',
              value: appointment.status,
            ),
            _DetailCard(
              icon: Icons.payments_outlined,
              label: 'Operation cost',
              value: operationCost == null
                  ? 'Not provided'
                  : operationCost.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? 'Not provided' : value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationPaymentSheet extends StatefulWidget {
  const _OperationPaymentSheet({required this.appointment});

  final AppointmentModel appointment;

  @override
  State<_OperationPaymentSheet> createState() => _OperationPaymentSheetState();
}

class _OperationPaymentSheetState extends State<_OperationPaymentSheet> {
  late final AppointmentsController _controller;
  late Future<OperationWalletBalance> _walletFuture;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AppointmentsController>();
    _walletFuture = _controller.fetchOperationWalletBalance();
  }

  void _reloadWallet() {
    setState(() => _walletFuture = _controller.fetchOperationWalletBalance());
  }

  Future<void> _confirmPayment() async {
    if (_isPaying) return;
    setState(() => _isPaying = true);
    final error = await _controller.payForOperation(widget.appointment.id);
    if (!mounted) return;
    if (error != null) {
      setState(() => _isPaying = false);
      Get.snackbar(
        'Payment failed',
        error,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    Get.back();
    Get.snackbar(
      'Payment confirmed',
      'Operation payment confirmed successfully.',
      backgroundColor: AppColors.primaryBlue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cost = widget.appointment.operationCost ?? 0;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: FutureBuilder<OperationWalletBalance>(
          future: _walletFuture,
          builder: (context, snapshot) {
            final wallet = snapshot.data;
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final availableBalance = wallet?.availableBalance;
            final canPay = availableBalance != null && availableBalance >= cost;
            final isInsufficient =
                availableBalance != null && availableBalance < cost;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Confirm Operation Payment',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _PaymentSummaryRow(
                  label: 'Doctor',
                  value: widget.appointment.doctorName,
                ),
                _PaymentSummaryRow(
                  label: 'Date & time',
                  value:
                      '${widget.appointment.date} • ${widget.appointment.time}',
                ),
                _PaymentSummaryRow(
                  label: 'Operation cost',
                  value: cost.toStringAsFixed(2),
                  emphasized: true,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: isLoading
                      ? const Row(
                          children: [
                            SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text('Checking wallet balance...'),
                          ],
                        )
                      : wallet?.hasError == true
                      ? Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(wallet!.errorMessage!)),
                            IconButton(
                              tooltip: 'Retry',
                              onPressed: _reloadWallet,
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Available balance',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              (availableBalance ?? 0).toStringAsFixed(2),
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
                if (isInsufficient) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Insufficient Balance. Please top up your wallet to continue.',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.wallet);
                    },
                    icon: const Icon(Icons.add_card_outlined),
                    label: const Text('Top-Up Wallet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: canPay && !_isPaying ? _confirmPayment : null,
                    icon: _isPaying
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.lock_outline),
                    label: Text(_isPaying ? 'Processing...' : 'Confirm & Pay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.gray)),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: emphasized ? AppColors.primaryBlue : Colors.black87,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
