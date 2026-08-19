import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';

import '../controller/appointments_controller.dart';
import '../model/appointment_model.dart';
import '../widgets/appointment_card.dart';

class OperationsView extends GetView<AppointmentsController> {
  const OperationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text(
          'Operations',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.lightGray,
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
