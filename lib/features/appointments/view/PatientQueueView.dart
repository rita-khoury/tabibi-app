// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constance/app_colors.dart';
// import '../controller/PatientQueueController.dart';
//
// class PatientQueueView extends StatefulWidget {
//   final int appointmentId;
//
//   const PatientQueueView({super.key, required this.appointmentId});
//
//   @override
//   State<PatientQueueView> createState() => _PatientQueueViewState();
// }
//
// class _PatientQueueViewState extends State<PatientQueueView>
//     with SingleTickerProviderStateMixin {
//   AnimationController? _waveController;
//
//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _waveController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       PatientQueueController(appointmentId: widget.appointmentId),
//       tag: widget.appointmentId.toString(),
//     );
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F7FC),
//       appBar: AppBar(
//         title: const Text(
//           "حالة الطابور الحي",
//           style: TextStyle(
//             color: AppColors.primaryBlue,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 20,
//             color: AppColors.primaryBlue,
//           ),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.blue),
//           );
//         }
//
//         final data = controller.queueStatus;
//         final status = data['status'] ?? 'waiting';
//
//         if (data.containsKey('message') || status == 'not_checked_in') {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withValues(alpha: 0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.hourglass_top_rounded,
//                       size: 50,
//                       color: Colors.orange,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "لم يتم تسجيل الحضور بعد",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "يرجى مراجعة الاستقبال لتسجيل الدخول (Check-in) للبدء في تتبع الطابور الحي.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         if (status == 'calling') {
//           return Center(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 _buildAnimatedRipples(Colors.red),
//                 Container(
//                   width: 200,
//                   height: 200,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [Colors.red, Colors.redAccent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(
//                         Icons.notifications_active_rounded,
//                         color: Colors.white,
//                         size: 48,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "حان دورك!",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (status == 'completed' || status == 'skipped') {
//           return Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 status == 'completed'
//                     ? "تمت الزيارة بنجاح ✓"
//                     : "تم تخطي الدور ✕",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: status == 'completed' ? Colors.green : Colors.grey,
//                 ),
//               ),
//             ),
//           );
//         }
//
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     _buildAnimatedRipples(const Color(0xff2F80ED)),
//
//                     Container(
//                       width: 210,
//                       height: 210,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(
//                               0xff2F80ED,
//                             ).withValues(alpha: 0.3),
//                             blurRadius: 15,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "دورك الحالي",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white70,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             "${data['currentPosition'] ?? '--'}",
//                             style: const TextStyle(
//                               fontSize: 56,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 50),
//
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 20,
//                     horizontal: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.04),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildStatItem(
//                         "المرضى أمامك",
//                         "${data['patientsAhead'] ?? 0}",
//                         Icons.people_outline,
//                         Colors.blue,
//                       ),
//                       Container(
//                         height: 35,
//                         width: 1,
//                         color: Colors.grey.shade200,
//                       ),
//                       _buildStatItem(
//                         "الانتظار المتوقع",
//                         "${data['estimatedWaitMinutes'] ?? 0} دقيقة",
//                         Icons.access_time_rounded,
//                         Colors.orange,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildAnimatedRipples(Color color) {
//     if (_waveController == null) return const SizedBox();
//     return AnimatedBuilder(
//       animation: _waveController!,
//       builder: (context, child) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             _buildSingleWave(
//               1.0 + (_waveController!.value * 0.4),
//               1.0 - _waveController!.value,
//               color,
//             ),
//             _buildSingleWave(
//               1.0 + (_waveController!.value * 0.8),
//               1.0 - _waveController!.value,
//               color,
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildSingleWave(double scale, double opacity, Color color) {
//     return Transform.scale(
//       scale: scale,
//       child: Opacity(
//         opacity: opacity.clamp(0.0, 1.0),
//         child: Container(
//           width: 210,
//           height: 210,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(
//     String title,
//     String value,
//     IconData icon,
//     Color iconColor,
//   ) {
//     return Column(
//       children: [
//         Icon(icon, color: iconColor, size: 22),
//         const SizedBox(height: 6),
//         Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constance/app_colors.dart';
import '../controller/PatientQueueController.dart';

class PatientQueueView extends StatefulWidget {
  final int? appointmentId;

  const PatientQueueView({super.key, this.appointmentId});

  @override
  State<PatientQueueView> createState() => _PatientQueueViewState();
}

class _PatientQueueViewState extends State<PatientQueueView>
    with SingleTickerProviderStateMixin {
  AnimationController? _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int finalAppointmentId = widget.appointmentId ?? 0;

    final controller = Get.put(
      PatientQueueController(appointmentId: finalAppointmentId),
      tag: finalAppointmentId.toString(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          "Live Queue Status",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchLiveStatus(isSilent: true),
        notificationPredicate: (notification) => notification.depth <= 1,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  }

                  final activeQueues = controller.activeQueueStatuses;

                  if (activeQueues.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.hourglass_top_rounded,
                                size: 50,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Check-in Not Completed Yet",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Please check-in at the reception desk to start tracking your live queue position.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (activeQueues.length > 1) {
                    return _buildMultipleActiveQueues(activeQueues);
                  }

                  final data = activeQueues.first;
                  final status =
                      data['status']?.toString().toLowerCase() ?? 'waiting';

                  if (status == 'calling') {
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildAnimatedRipples(Colors.red),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.redAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.notifications_active_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "It's Your Turn!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (status == 'completed' || status == 'skipped') {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          status == 'completed'
                              ? "Visit Completed Successfully ✓"
                              : "Turn Skipped ✕",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: status == 'completed'
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildAnimatedRipples(const Color(0xff2F80ED)),

                              Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff2F80ED),
                                      Color(0xff56CCF2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xff2F80ED,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Current Position",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${data['currentPosition'] ?? '--'}",
                                      style: const TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  "Patients Ahead",
                                  "${data['patientsAhead'] ?? 0}",
                                  Icons.people_outline,
                                  Colors.blue,
                                ),
                                Container(
                                  height: 35,
                                  width: 1,
                                  color: Colors.grey.shade200,
                                ),
                                _buildStatItem(
                                  "Estimated Wait",
                                  "${data['estimatedWaitMinutes'] ?? 0} mins",
                                  Icons.access_time_rounded,
                                  Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleActiveQueues(List<Map<String, dynamic>> activeQueues) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: activeQueues.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final data = activeQueues[index];
        final status = data['status']?.toString().toLowerCase() ?? 'waiting';
        final statusColor = _queueStatusColor(status);
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data['doctorName']?.toString() ?? 'Appointment',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _queueStatusLabel(status),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '${data['specialty'] ?? ''} • ${data['date'] ?? ''}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildQueueMetric(
                    'Position',
                    '${data['currentPosition'] ?? '--'}',
                  ),
                  _buildQueueMetric('Ahead', '${data['patientsAhead'] ?? 0}'),
                  _buildQueueMetric(
                    'Est. wait',
                    '${data['estimatedWaitMinutes'] ?? 0} min',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQueueMetric(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _queueStatusColor(String status) {
    switch (status) {
      case 'calling':
        return Colors.red;
      case 'in_progress':
        return Colors.deepPurple;
      case 'skipped':
        return Colors.orange;
      default:
        return AppColors.primaryBlue;
    }
  }

  String _queueStatusLabel(String status) {
    switch (status) {
      case 'calling':
        return 'Calling';
      case 'in_progress':
        return 'In progress';
      case 'skipped':
        return 'Skipped';
      default:
        return 'Waiting';
    }
  }

  Widget _buildAnimatedRipples(Color color) {
    if (_waveController == null) return const SizedBox();
    return AnimatedBuilder(
      animation: _waveController!,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildSingleWave(
              1.0 + (_waveController!.value * 0.4),
              1.0 - _waveController!.value,
              color,
            ),
            _buildSingleWave(
              1.0 + (_waveController!.value * 0.8),
              1.0 - _waveController!.value,
              color,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleWave(double scale, double opacity, Color color) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
