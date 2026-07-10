import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/constance/appointment_status.dart';
import '../model/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onComplete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            appointment.doctorName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            appointment.specialty,
            style: const TextStyle(color: AppColors.gray),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.primaryBlue),

              const SizedBox(width: 8),

              Text(appointment.date),

              const Spacer(),

              Text(appointment.time),
            ],
          ),

          if (appointment.status == AppointmentStatus.upcoming) ...[
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),

                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                    ),

                    child: const Text("Complete"),
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
