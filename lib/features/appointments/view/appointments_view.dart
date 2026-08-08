// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import 'package:tabibi/features/appointments/widget/empty_appointment_state.dart';
// import '../controller/appointments_controller.dart';
// import '../model/appointment_model.dart';
// import '../widgets/appointment_card.dart';
//
// class AppointmentsView extends StatelessWidget {
//   const AppointmentsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: AppColors.lightGray,
//         body: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(
//                 top: 40,
//                 bottom: 15,
//                 left: 20,
//                 right: 20,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF33A9F1), Color(0xFF007BFF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const SizedBox(width: 40),
//                       const Text(
//                         "My Appointments",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.list_alt, color: Colors.white),
//                         tooltip: "قائمة الانتظار",
//                         onPressed: () {
//                           Get.to(() => const WaitlistBottomSheetView());
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: const TabBar(
//                       dividerColor: Colors.transparent,
//                       indicator: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                       ),
//                       indicatorSize: TabBarIndicatorSize.tab,
//                       labelColor: Color(0xFF007BFF),
//                       unselectedLabelColor: Colors.white,
//                       labelStyle: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                       tabs: [
//                         Tab(
//                           child: Text(
//                             "Upcoming",
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Tab(
//                           child: Text(
//                             "Completed",
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Tab(
//                           child: Text(
//                             "Canceled",
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: GetBuilder<AppointmentsController>(
//                 init: AppointmentsController(),
//                 builder: (controller) {
//                   if (controller.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   return TabBarView(
//                     children: [
//                       _buildAppointmentList(
//                         controller,
//                         controller.upcomingAppointments,
//                         "assets/images/photo8.png",
//                         "No Upcoming Appointments",
//                       ),
//                       _buildAppointmentList(
//                         controller,
//                         controller.completedAppointments,
//                         "assets/images/photo7.png",
//                         "No Completed Appointments",
//                       ),
//                       _buildAppointmentList(
//                         controller,
//                         controller.canceledAppointments,
//                         "assets/images/photo6.png",
//                         "No Canceled Appointments",
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppointmentList(
//     AppointmentsController controller,
//     List<AppointmentModel> list,
//     String img,
//     String title,
//   ) {
//     if (list.isEmpty) {
//       return EmptyAppointmentState(
//         imagePath: img,
//         title: title,
//         subtitle: "Check back later",
//       );
//     }
//
//     return ListView.builder(
//       key: UniqueKey(),
//       padding: const EdgeInsets.all(16),
//       itemCount: list.length,
//       itemBuilder: (context, index) {
//         final appointment = list[index];
//         return AppointmentCard(
//           appointment: appointment,
//
//           onCancel: appointment.status.toLowerCase() == 'confirmed'
//               ? () => controller.cancelAppointmentById(appointment.id)
//               : null,
//         );
//       },
//     );
//   }
// }
//
// class WaitlistBottomSheetView extends StatelessWidget {
//   const WaitlistBottomSheetView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGray,
//       appBar: AppBar(
//         title: const Text("Your Waitlist"),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: AppColors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: GetBuilder<AppointmentsController>(
//         builder: (controller) {
//           if (controller.waitlistAppointments.isEmpty) {
//             return const Center(
//               child: Text(
//                 "لا توجد عناصر في قائمة الانتظار",
//                 style: TextStyle(fontSize: 16, color: AppColors.gray),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.waitlistAppointments.length,
//             itemBuilder: (context, index) {
//               final waitlistItem = controller.waitlistAppointments[index];
//
//               final doctorName = waitlistItem.doctor?.user?.fullName ?? 'طبيب';
//               final requestedDate = waitlistItem.requestedDate;
//               final doctorId = waitlistItem.doctorId;
//               final clinicId = waitlistItem.clinicId;
//
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "د. $doctorName",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primaryBlue,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.calendar_today,
//                                 size: 14,
//                                 color: AppColors.gray,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 "التاريخ المطلوب: $requestedDate",
//                                 style: const TextStyle(
//                                   color: AppColors.gray,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.exit_to_app, color: Colors.red),
//                         tooltip: "مغادرة القائمة",
//                         onPressed: () {
//                           controller.leaveWaitlist(
//                             doctorId: doctorId,
//                             clinicId: clinicId,
//                             requestedDate: requestedDate,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/widget/empty_appointment_state.dart';
import '../controller/appointments_controller.dart';
import '../model/appointment_model.dart';
import '../widgets/appointment_card.dart';

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 15,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF33A9F1), Color(0xFF007BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      const Text(
                        "My Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.list_alt, color: Colors.white),
                        tooltip: "قائمة الانتظار",
                        onPressed: () {
                          if (Get.isRegistered<AppointmentsController>()) {
                            Get.find<AppointmentsController>().fetchWaitlist();
                          }
                          Get.to(() => const WaitlistBottomSheetView());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Color(0xFF007BFF),
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            "Upcoming",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Completed",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Canceled",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GetBuilder<AppointmentsController>(
                init: AppointmentsController(),
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    children: [
                      _buildAppointmentList(
                        controller,
                        controller.upcomingAppointments,
                        "assets/images/photo8.png",
                        "No Upcoming Appointments",
                      ),
                      _buildAppointmentList(
                        controller,
                        controller.completedAppointments,
                        "assets/images/photo7.png",
                        "No Completed Appointments",
                      ),
                      _buildAppointmentList(
                        controller,
                        controller.canceledAppointments,
                        "assets/images/photo6.png",
                        "No Canceled Appointments",
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
      AppointmentsController controller,
      List<AppointmentModel> list,
      String img,
      String title,
      ) {
    if (list.isEmpty) {
      return EmptyAppointmentState(
        imagePath: img,
        title: title,
        subtitle: "Check back later",
      );
    }

    return ListView.builder(
      key: UniqueKey(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final appointment = list[index];
        return AppointmentCard(
          appointment: appointment,
          onCancel: appointment.status.toLowerCase() == 'confirmed'
              ? () => controller.cancelAppointmentById(appointment.id)
              : null,
        );
      },
    );
  }
}
class WaitlistBottomSheetView extends StatelessWidget {
  const WaitlistBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<AppointmentsController>()) {
      Get.find<AppointmentsController>().fetchWaitlist();
    }

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text(
          "Your Waitlist",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        backgroundColor: AppColors.lightGray,
        foregroundColor: AppColors.primaryBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<AppointmentsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.waitlistAppointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No items in the waitlist",
                    style: TextStyle(fontSize: 16, color: AppColors.gray),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => controller.fetchWaitlist(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.waitlistAppointments.length,
            itemBuilder: (context, index) {
              final waitlistItem = controller.waitlistAppointments[index];

              // استخراج البيانات من كائن الدكتور واليوزر بأمان تام
              String doctorName = 'Doctor';
              String? avatarUrl;
              String specialization = 'Specialist';

              final dynamic doctorData = waitlistItem.doctor;

              if (doctorData != null && doctorData is Map) {
                specialization = doctorData['specialization']?.toString() ?? 'Specialist';

                final userData = doctorData['user'];
                if (userData != null && userData is Map) {
                  doctorName = userData['full_name']?.toString() ??
                      userData['fullName']?.toString() ??
                      userData['name']?.toString() ??
                      'Doctor';
                  avatarUrl = userData['avatarUrl']?.toString();
                } else {
                  doctorName = doctorData['full_name']?.toString() ??
                      doctorData['fullName']?.toString() ??
                      doctorData['name']?.toString() ??
                      'Doctor';
                }
              }

              final requestedDate = waitlistItem.requestedDate ?? '';

              int doctorId = 0;
              if (doctorData != null && doctorData is Map) {
                doctorId = int.tryParse(doctorData['id']?.toString() ?? '0') ?? 0;
              }

              final int clinicId = waitlistItem.clinicId ?? 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // صورة الطبيب دائرية أو الأيقونة الافتراضية
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: avatarUrl != null && avatarUrl.isNotEmpty
                                ? Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultAvatar(),
                            )
                                : _buildDefaultAvatar(),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // الاسم والتخصص
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dr. $doctorName",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                specialization,
                                style: const TextStyle(
                                  color: AppColors.gray,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // زر الحذف (سلة المهملات الحمراء)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                          tooltip: "Leave List",
                          onPressed: () {
                            controller.leaveWaitlist(
                              doctorId: doctorId,
                              clinicId: clinicId,
                              requestedDate: requestedDate,
                            );
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.black12, height: 1),
                    ),
                    // التاريخ المطلوب
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: AppColors.gray,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Requested Date: $requestedDate",
                          style: const TextStyle(
                            color: AppColors.gray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primaryBlue.withValues(alpha: 0.1),
      child: const Icon(
        Icons.person,
        color: AppColors.primaryBlue,
        size: 30,
      ),
    );
  }
}