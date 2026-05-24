
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/appointments_controller.dart';
import '../widgets/appointment_card.dart';

class AppointmentsView extends GetView<AppointmentsController> {
  const AppointmentsView({super.key});

  Widget _emptyState(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "No $title Appointments",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List list, Widget Function(int index) itemBuilder) {
    if (list.isEmpty) return _emptyState(" ");

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }

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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Column(
          children: [
            // ===== TABS =====
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelColor: AppColors.primaryBlue,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Canceled"),
                  ],
                ),
              ),
            ),

            // ===== GAP (white separation) =====
            Container(
              height: 12,
              color: Colors.white,
            ),

            // ===== CONTENT =====
            Expanded(
              child: TabBarView(
                children: [
                  // UPCOMING
                  Obx(() {
                    final list = controller.upcomingAppointments;
                    if (list.isEmpty) return _emptyState("Upcoming");

                    return _buildList(list, (index) {
                      final appointment = list[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onComplete: () =>
                            controller.completeAppointment(index),
                        onCancel: () =>
                            controller.cancelAppointment(index),
                      );
                    });
                  }),

                  // COMPLETED
                  Obx(() {
                    final list = controller.completedAppointments;
                    if (list.isEmpty) return _emptyState("Completed");

                    return _buildList(list, (index) {
                      final appointment = list[index];
                      return AppointmentCard(
                        appointment: appointment,
                      );
                    });
                  }),

                  // CANCELED
                  Obx(() {
                    final list = controller.canceledAppointments;
                    if (list.isEmpty) return _emptyState("Canceled");

                    return _buildList(list, (index) {
                      final appointment = list[index];
                      return AppointmentCard(
                        appointment: appointment,
                      );
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}