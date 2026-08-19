enum QueuePatientStatus {
  waiting,
  calling,
  inProgress,
  completed,
  skipped,
  expired,
  noShow,
}

enum QueueAppointmentType { consultation, followUp, operation }

enum QueueSort { positionAscending, checkInTimeAscending }

class QueuePatient {
  const QueuePatient({
    required this.id,
    required this.position,
    required this.patientName,
    required this.appointmentId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.clinicName,
    required this.appointmentType,
    required this.status,
    this.scheduledAt,
    this.checkedInAt,
    this.startedAt,
    this.completedAt,
    this.estimatedRemainingMinutes = 0,
    this.waitingTimeMinutes = 0,
    this.consultationDurationMinutes = 0,
    this.delayFromAppointmentMinutes = 0,
    this.isNext = false,
    this.queueLabel,
  });

  final String id;
  final int position;
  final String patientName;
  final String appointmentId;
  final String doctorName;
  final String doctorSpecialty;
  final String clinicName;
  final QueueAppointmentType appointmentType;
  final QueuePatientStatus status;
  final DateTime? scheduledAt;
  final DateTime? checkedInAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int estimatedRemainingMinutes;
  final int waitingTimeMinutes;
  final int consultationDurationMinutes;
  final int delayFromAppointmentMinutes;
  final bool isNext;
  final String? queueLabel;

  factory QueuePatient.fromJson(Map<String, dynamic> json) {
    final appointment = _map(json['appointment']);
    final doctor = _map(json['doctor']);
    final clinic = _map(json['clinic']);
    final doctorUser = _map(doctor['user']);
    final patient = _map(appointment['patient']);
    final patientUser = _map(patient['user']);

    return QueuePatient(
      id: '${json['id'] ?? ''}',
      position: _asInt(json['position']),
      patientName: '${patientUser['fullName'] ?? ''}',
      appointmentId: '${json['appointmentId'] ?? appointment['id'] ?? ''}',
      doctorName: '${doctorUser['fullName'] ?? doctor['fullName'] ?? 'Doctor'}',
      doctorSpecialty:
          '${doctor['specialty'] ?? doctor['specialization'] ?? 'Specialist'}',
      clinicName: '${clinic['name'] ?? 'Clinic'}',
      appointmentType: _appointmentType(appointment['type']?.toString()),
      status: _status(json['status']?.toString()),
      scheduledAt: _dateOrNull(appointment['requestedDate']),
      checkedInAt: _dateOrNull(json['checkinTime']),
      startedAt: _dateOrNull(json['startedTime']),
      completedAt: _dateOrNull(json['finishedTime']),
      estimatedRemainingMinutes: _asInt(json['estimatedWaitMinutes']),
      waitingTimeMinutes: _asInt(json['waiting_time_minutes']),
      consultationDurationMinutes:
          _asInt(json['consultation_duration_minutes']),
      delayFromAppointmentMinutes:
          _asInt(json['delay_from_appointment_minutes']),
      isNext: json['is_next'] == true,
      queueLabel: json['queue_label']?.toString(),
    );
  }

  String get statusLabel => queueLabel?.trim().isNotEmpty == true
      ? queueLabel!
      : switch (status) {
          QueuePatientStatus.waiting => 'Waiting',
          QueuePatientStatus.calling => 'Calling',
          QueuePatientStatus.inProgress => 'In Progress',
          QueuePatientStatus.completed => 'Completed',
          QueuePatientStatus.skipped => 'Skipped',
          QueuePatientStatus.expired => 'Expired',
          QueuePatientStatus.noShow => 'No Show',
        };

  String get appointmentTypeLabel => switch (appointmentType) {
        QueueAppointmentType.consultation => 'Consultation',
        QueueAppointmentType.followUp => 'Follow-up',
        QueueAppointmentType.operation => 'Operation',
      };

  static Map<String, dynamic> _map(dynamic value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};

  static QueuePatientStatus _status(String? value) => switch (value) {
        'calling' => QueuePatientStatus.calling,
        'in_progress' => QueuePatientStatus.inProgress,
        'completed' => QueuePatientStatus.completed,
        'skipped' => QueuePatientStatus.skipped,
        'expired' => QueuePatientStatus.expired,
        'no_show' => QueuePatientStatus.noShow,
        _ => QueuePatientStatus.waiting,
      };

  static QueueAppointmentType _appointmentType(String? value) => switch (value) {
        'follow_up' => QueueAppointmentType.followUp,
        'operation' => QueueAppointmentType.operation,
        _ => QueueAppointmentType.consultation,
      };

  static int _asInt(dynamic value) => value is num
      ? value.toInt()
      : int.tryParse(value?.toString() ?? '') ?? 0;

  static DateTime? _dateOrNull(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '');
}
