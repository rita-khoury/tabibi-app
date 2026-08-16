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
//                           if (Get.isRegistered<AppointmentsController>()) {
//                             Get.find<AppointmentsController>().fetchWaitlist();
//                           }
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
//                       // Upcoming Tab
//                       _buildAppointmentList(
//                         controller,
//                         controller.upcomingAppointments,
//                         "assets/images/photo8.png",
//                         "No Upcoming Appointments",
//                         isCompletedTab: false,
//                       ),
//                       // Completed Tab (مع زر التقييم)
//                       _buildAppointmentList(
//                         controller,
//                         controller.completedAppointments,
//                         "assets/images/photo7.png",
//                         "No Completed Appointments",
//                         isCompletedTab: true,
//                       ),
//                       // Canceled Tab
//                       _buildAppointmentList(
//                         controller,
//                         controller.canceledAppointments,
//                         "assets/images/photo6.png",
//                         "No Canceled Appointments",
//                         isCompletedTab: false,
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
//       AppointmentsController controller,
//       List<AppointmentModel> list,
//       String img,
//       String title, {
//         required bool isCompletedTab,
//       }) {
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
//         return Column(
//           children: [
//             AppointmentCard(
//               appointment: appointment,
//               onCancel: appointment.status.toLowerCase() == 'confirmed'
//                   ? () => controller.cancelAppointmentById(appointment.id)
//                   : null,
//             ),
//             if (isCompletedTab) ...[
//               const SizedBox(height: 8),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () => _showRatingDialog(context, appointment),
//                   icon: const Icon(Icons.star, size: 16, color: Colors.amber),
//                   label: const Text("تقييم الطبيب"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryBlue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             const SizedBox(height: 12),
//           ],
//         );
//       },
//     );
//   }
//
//   // دالة لإظهار نافذة التقييم المنبثقة
//   void _showRatingDialog(BuildContext context, AppointmentModel appointment) {
//     double selectedRating = 5.0;
//     final TextEditingController commentController = TextEditingController();
//     final AppointmentsController controller = Get.find<AppointmentsController>();
//
//     Get.defaultDialog(
//       title: "تقييم الطبيب",
//       titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
//       content: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           children: [
//             const Text("ما مدى رضاك عن استشارتك مع الطبيب؟"),
//             const SizedBox(height: 10),
//             Slider(
//               value: selectedRating,
//               min: 1,
//               max: 5,
//               divisions: 4,
//               activeColor: Colors.amber,
//               label: selectedRating.toStringAsFixed(0),
//               onChanged: (val) {
//                 selectedRating = val;
//               },
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: commentController,
//               decoration: const InputDecoration(
//                 hintText: "اكتب تعليقك هنا (اختياري)",
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back(); // إغلاق النافذة
//                     controller.rateDoctorForAppointment(
//                       appointmentId: appointment.id,
//                       rating: selectedRating,
//                       comment: commentController.text,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
//                   child: const Text("إرسال", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WaitlistBottomSheetView extends StatelessWidget {
//   const WaitlistBottomSheetView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     if (Get.isRegistered<AppointmentsController>()) {
//       Get.find<AppointmentsController>().fetchWaitlist();
//     }
//
//     return Scaffold(
//       backgroundColor: AppColors.lightGray,
//       appBar: AppBar(
//         title: const Text(
//           "Your Waitlist",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.primaryBlue,
//           ),
//         ),
//         backgroundColor: AppColors.lightGray,
//         foregroundColor: AppColors.primaryBlue,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryBlue),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: GetBuilder<AppointmentsController>(
//         builder: (controller) {
//           if (controller.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (controller.waitlistAppointments.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "No items in the waitlist",
//                     style: TextStyle(fontSize: 16, color: AppColors.gray),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                     onPressed: () => controller.fetchWaitlist(),
//                     child: const Text("Retry"),
//                   ),
//                 ],
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
//               String doctorName = 'Doctor';
//               String? avatarUrl;
//               String specialization = 'Specialist';
//
//               final dynamic doctorData = waitlistItem.doctor;
//
//               if (doctorData != null && doctorData is Map) {
//                 specialization = doctorData['specialization']?.toString() ?? 'Specialist';
//
//                 final userData = doctorData['user'];
//                 if (userData != null && userData is Map) {
//                   doctorName = userData['full_name']?.toString() ??
//                       userData['fullName']?.toString() ??
//                       userData['name']?.toString() ??
//                       'Doctor';
//                   avatarUrl = userData['avatarUrl']?.toString();
//                 } else {
//                   doctorName = doctorData['full_name']?.toString() ??
//                       doctorData['fullName']?.toString() ??
//                       doctorData['name']?.toString() ??
//                       'Doctor';
//                 }
//               }
//
//               final requestedDate = waitlistItem.requestedDate ?? '';
//
//               int doctorId = 0;
//               if (doctorData != null && doctorData is Map) {
//                 doctorId = int.tryParse(doctorData['id']?.toString() ?? '0') ?? 0;
//               }
//
//               final int clinicId = waitlistItem.clinicId ?? 0;
//
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.04),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: SizedBox(
//                             width: 60,
//                             height: 60,
//                             child: avatarUrl != null && avatarUrl.isNotEmpty
//                                 ? Image.network(
//                               avatarUrl,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   _buildDefaultAvatar(),
//                             )
//                                 : _buildDefaultAvatar(),
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Dr. $doctorName",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 specialization,
//                                 style: const TextStyle(
//                                   color: AppColors.gray,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
//                           tooltip: "Leave List",
//                           onPressed: () {
//                             controller.leaveWaitlist(
//                               doctorId: doctorId,
//                               clinicId: clinicId,
//                               requestedDate: requestedDate,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Divider(color: Colors.black12, height: 1),
//                     ),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_today_outlined,
//                           size: 15,
//                           color: AppColors.gray,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "Requested Date: $requestedDate",
//                           style: const TextStyle(
//                             color: AppColors.gray,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildDefaultAvatar() {
//     return Container(
//       color: AppColors.primaryBlue.withValues(alpha: 0.1),
//       child: const Icon(
//         Icons.person,
//         color: AppColors.primaryBlue,
//         size: 30,
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
    final appointmentsController = Get.isRegistered<AppointmentsController>()
        ? Get.find<AppointmentsController>()
        : Get.put(AppointmentsController());
    return Obx(
      () => DefaultTabController(
        key: ValueKey(appointmentsController.upcomingTabRevision.value),
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
                          tooltip: "Waitlist",
                          onPressed: () {
                            if (Get.isRegistered<AppointmentsController>()) {
                              Get.find<AppointmentsController>()
                                  .fetchWaitlist();
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
                          isCompletedTab: false,
                        ),
                        _buildAppointmentList(
                          controller,
                          controller.completedAppointments,
                          "assets/images/photo7.png",
                          "No Completed Appointments",
                          isCompletedTab: true,
                        ),
                        _buildAppointmentList(
                          controller,
                          controller.canceledAppointments,
                          "assets/images/photo6.png",
                          "No Canceled Appointments",
                          isCompletedTab: false,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
    AppointmentsController controller,
    List<AppointmentModel> list,
    String img,
    String title, {
    required bool isCompletedTab,
  }) {
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
        return Column(
          children: [
            AppointmentCard(
              appointment: appointment,
              onCancel: appointment.status.toLowerCase() == 'confirmed'
                  ? () => controller.cancelAppointmentById(appointment.id)
                  : null,
            ),
            if (isCompletedTab) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showRatingDialog(context, appointment),
                  icon: const Icon(Icons.star, size: 16, color: Colors.amber),
                  label: const Text("Rate Doctor"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context, AppointmentModel appointment) {
    double selectedRating = 5.0;
    final TextEditingController commentController = TextEditingController();
    final AppointmentsController controller =
        Get.find<AppointmentsController>();

    Get.defaultDialog(
      title: "Rate Doctor",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const Text("How satisfied are you with your consultation?"),
            const SizedBox(height: 10),
            Slider(
              value: selectedRating,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.amber,
              label: selectedRating.toStringAsFixed(0),
              onChanged: (val) {
                selectedRating = val;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: "Write your comment here (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.rateDoctorForAppointment(
                      appointmentId: appointment.id,
                      rating: selectedRating,
                      comment: commentController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryBlue,
          ),
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

              String doctorName = 'Doctor';
              String? avatarUrl;
              String specialization = 'Specialist';

              final dynamic doctorData = waitlistItem.doctor;

              if (doctorData != null && doctorData is Map) {
                specialization =
                    doctorData['specialization']?.toString() ?? 'Specialist';

                final userData = doctorData['user'];
                if (userData != null && userData is Map) {
                  doctorName =
                      userData['full_name']?.toString() ??
                      userData['fullName']?.toString() ??
                      userData['name']?.toString() ??
                      'Doctor';
                  avatarUrl = userData['avatarUrl']?.toString();
                } else {
                  doctorName =
                      doctorData['full_name']?.toString() ??
                      doctorData['fullName']?.toString() ??
                      doctorData['name']?.toString() ??
                      'Doctor';
                }
              }

              final requestedDate = waitlistItem.requestedDate ?? '';

              int doctorId = 0;
              if (doctorData != null && doctorData is Map) {
                doctorId =
                    int.tryParse(doctorData['id']?.toString() ?? '0') ?? 0;
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: avatarUrl != null && avatarUrl.isNotEmpty
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildDefaultAvatar(),
                                  )
                                : _buildDefaultAvatar(),
                          ),
                        ),
                        const SizedBox(width: 14),
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
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 24,
                          ),
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
      child: const Icon(Icons.person, color: AppColors.primaryBlue, size: 30),
    );
  }
}
