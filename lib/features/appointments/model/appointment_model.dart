class AppointmentModel {
  final int id;
  final String status;
  final String doctorName;
  final String specialty;
  final String date;
  final String time;

  AppointmentModel({
    required this.id,
    required this.status,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      status: json['status'] ?? 'PENDING',
      doctorName: json['doctor']?['name'] ?? 'Unknown',
      specialty: json['doctor']?['specialty'] ?? 'General',
      date: json['appointmentDate'] ?? '',
      time: json['appointmentTime'] ?? '',
    );
  }
}
