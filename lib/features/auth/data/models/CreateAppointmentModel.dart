class CreateAppointmentModel {
  final int doctorId;
  final int clinicId;
  final String requestedDate;
  final String startTime;
  final String endTime;
  final String type;
  final String priority;
  final String reasonForVisit;

  CreateAppointmentModel({
    required this.doctorId,
    required this.clinicId,
    required this.requestedDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.priority,
    required this.reasonForVisit,
  });

  Map<String, dynamic> toJson() {
    return {
      "doctorId": doctorId,
      "clinicId": clinicId,
      "requestedDate": requestedDate,
      "startTime": startTime,
      "endTime": endTime,
      "type": type,
      "priority": priority,
      "reasonForVisit": reasonForVisit,
    };
  }
}
