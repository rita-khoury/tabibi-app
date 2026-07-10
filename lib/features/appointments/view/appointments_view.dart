import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/widget/empty_appointment_state.dart';
import '../controller/appointments_controller.dart';
import '../widgets/appointment_card.dart';

class AppointmentsView extends GetView<AppointmentsController> {
  const AppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "My Appointments",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Canceled"),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  Obx(
                    () => _buildAppointmentList(
                      list: controller.upcomingAppointments,
                      emptyImage: "assets/images/photo8.png",
                      emptyTitle: "No Upcoming Appointments",
                      isUpcoming: true,
                    ),
                  ),

                  Obx(
                    () => _buildAppointmentList(
                      list: controller.completedAppointments,
                      emptyImage: "assets/images/photo7.png",
                      emptyTitle: "No Completed Appointments",
                    ),
                  ),

                  Obx(
                    () => _buildAppointmentList(
                      list: controller.canceledAppointments,
                      emptyImage: "assets/images/photo6.png",
                      emptyTitle: "No Canceled Appointments",
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

  Widget _buildAppointmentList({
    required List<dynamic> list,
    required String emptyImage,
    required String emptyTitle,
    bool isUpcoming = false,
  }) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (list.isEmpty) {
      return EmptyAppointmentState(
        imagePath: emptyImage,
        title: emptyTitle,
        subtitle: "Check back later",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final appointment = list[index];
        return AppointmentCard(
          appointment: appointment,
          onCancel: () => controller.cancelAppointmentById(appointment['id']),

          onComplete: isUpcoming
              ? () => controller.completeAppointmentById(appointment['id'])
              : null,
        );
      },
    );
  }
}
