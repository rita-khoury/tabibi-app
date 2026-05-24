import 'package:get/get.dart';

import '../model/appointment_model.dart';

class AppointmentsController extends GetxController {

  RxList<AppointmentModel> appointments =
      <AppointmentModel>[].obs;

  // ================= FILTERS =================

  List<AppointmentModel> get upcomingAppointments =>
      appointments
          .where((e) => e.status ==
              AppointmentStatus.upcoming)
          .toList();

  List<AppointmentModel> get completedAppointments =>
      appointments
          .where((e) => e.status ==
              AppointmentStatus.completed)
          .toList();

  List<AppointmentModel> get canceledAppointments =>
      appointments
          .where((e) => e.status ==
              AppointmentStatus.canceled)
          .toList();

  // ================= ADD =================

  void addAppointment(
      AppointmentModel appointment) {

    appointments.add(appointment);
  }

  // ================= COMPLETE =================

  void completeAppointment(int index) {

    upcomingAppointments[index].status =
        AppointmentStatus.completed;

    appointments.refresh();
  }

  // ================= CANCEL =================

  void cancelAppointment(int index) {

    upcomingAppointments[index].status =
        AppointmentStatus.canceled;

    appointments.refresh();
  }
}