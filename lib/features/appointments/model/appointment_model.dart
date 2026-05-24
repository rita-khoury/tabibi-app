enum AppointmentStatus {
  upcoming,
  completed,
  canceled,
}

class AppointmentModel {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;

  AppointmentStatus status;

  AppointmentModel({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
  });
}