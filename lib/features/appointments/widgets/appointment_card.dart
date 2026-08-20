// import 'package:flutter/material.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import '../model/appointment_model.dart';
//
// class AppointmentCard extends StatelessWidget {
//   final AppointmentModel appointment;
//   final VoidCallback? onCancel;
//   final VoidCallback? onRate;
//
//   const AppointmentCard({
//     super.key,
//     required this.appointment,
//     this.onCancel,
//     this.onRate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Material(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(20),
//         elevation: 2,
//         shadowColor: Colors.grey.withValues(alpha: 0.08),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: () {},
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 55,
//                       height: 55,
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryBlue.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: const Icon(
//                         Icons.person,
//                         color: AppColors.primaryBlue,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   appointment.doctorName,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                               _buildStatusBadge(appointment.status),
//                             ],
//                           ),
//                           const SizedBox(height: 3),
//                           Text(
//                             appointment.specialty,
//                             style: const TextStyle(
//                               color: AppColors.gray,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (appointment.clinicName != null) ...[
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.local_hospital_outlined,
//                                   size: 13,
//                                   color: AppColors.primaryBlue,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   appointment.clinicName!,
//                                   style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//                 Divider(color: Colors.grey.shade100, height: 1),
//                 const SizedBox(height: 14),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryBlue.withValues(alpha: 0.06),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.calendar_month_rounded,
//                               color: AppColors.primaryBlue,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 6),
//                             Flexible(
//                               child: Text(
//                                 appointment.date,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryBlue.withValues(alpha: 0.06),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.access_time_rounded,
//                               color: AppColors.primaryBlue,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 6),
//                             Flexible(
//                               child: Text(
//                                 "${appointment.startTime} - ${appointment.endTime}",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//                 if (appointment.status.toLowerCase() == 'confirmed') ...[
//                   const SizedBox(height: 14),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 42,
//                     child: ElevatedButton.icon(
//                       onPressed: onCancel,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.withValues(alpha: 0.08),
//                         foregroundColor: Colors.redAccent,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       icon: const Icon(Icons.delete_outline_rounded, size: 18),
//                       label: const Text(
//                         "Cancel Appointment",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//
//
//                 if (onRate != null) ...[
//                   const SizedBox(height: 14),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 42,
//                     child: ElevatedButton.icon(
//                       onPressed: onRate,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.amber.withValues(alpha: 0.12),
//                         foregroundColor: Colors.amber.shade800,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       icon: const Icon(Icons.star_rounded, size: 18),
//                       label: const Text(
//                         "Rate Doctor",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String status) {
//     Color bgColor;
//     Color textColor;
//
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         bgColor = Colors.green.withValues(alpha: 0.1);
//         textColor = Colors.green;
//         break;
//       case 'cancelled':
//         bgColor = Colors.red.withValues(alpha: 0.1);
//         textColor = Colors.red;
//         break;
//       case 'completed':
//         bgColor = Colors.blue.withValues(alpha: 0.1);
//         textColor = Colors.blue;
//         break;
//       default:
//         bgColor = Colors.orange.withValues(alpha: 0.1);
//         textColor = Colors.orange;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: TextStyle(
//           color: textColor,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../model/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;
  final VoidCallback? onTap;
  final VoidCallback? onPayOperation;
  final bool showCancellationAction;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onRate,
    this.onTap,
    this.onPayOperation,
    this.showCancellationAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryBlue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.doctorName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(appointment.status),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            appointment.specialty,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (appointment.clinicName != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_hospital_outlined,
                                  size: 13,
                                  color: AppColors.primaryBlue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  appointment.clinicName!,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 1,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.primaryBlue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                appointment.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.primaryBlue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "${appointment.startTime} - ${appointment.endTime}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (appointment.isOperation &&
                    appointment.operationCost != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          color: AppColors.primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Operation cost',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          appointment.operationCost!.toStringAsFixed(2),
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (appointment.status.trim().toLowerCase() ==
                                'pending' &&
                            onPayOperation != null) ...[
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: onPayOperation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: const Text(
                                'Pay Now',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if (showCancellationAction &&
                    appointment.status.toLowerCase() == 'confirmed') ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.08),
                        foregroundColor: Colors.redAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text(
                        "Cancel Appointment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
                if (appointment.status.trim().toLowerCase() == 'completed' &&
                    onRate != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onRate,
                      icon: const Icon(
                        Icons.star_rounded,
                        size: 21,
                        color: Color(0xFFF59E0B),
                      ),
                      label: const Text('Rate Doctor'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        backgroundColor: AppColors.primaryBlue.withValues(
                          alpha: 0.04,
                        ),
                        side: BorderSide(
                          color: AppColors.primaryBlue.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
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

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'cancelled':
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        break;
      case 'completed':
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      default:
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
