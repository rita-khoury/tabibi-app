enum PatientQueueStatus { waiting, calling, inProgress, completed, skipped }

enum PatientQueuePriorityGroup { normal, late }

class PatientQueueModel {
  const PatientQueueModel({
    required this.id,
    required this.appointmentId,
    required this.clinicId,
    required this.doctorId,
    required this.currentPosition,
    required this.patientsAhead,
    required this.priorityGroup,
    required this.status,
    required this.checkInAt,
    required this.calledAt,
    required this.consultationStartedAt,
    required this.completedAt,
    required this.skippedAt,
    required this.expectedWaitingTimeMinutes,
    required this.patientDelayMinutes,
    required this.actualConsultationDurationMinutes,
    required this.clinic,
    required this.doctor,
    required this.appointment,
  });

  final int id;
  final int appointmentId;
  final int clinicId;
  final int doctorId;
  final int? currentPosition;
  final int? patientsAhead;
  final PatientQueuePriorityGroup priorityGroup;
  final PatientQueueStatus status;
  final DateTime? checkInAt;
  final DateTime? calledAt;
  final DateTime? consultationStartedAt;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final int? expectedWaitingTimeMinutes;
  final int? patientDelayMinutes;
  final int? actualConsultationDurationMinutes;
  final PatientQueueClinic? clinic;
  final PatientQueueDoctor? doctor;
  final PatientQueueAppointment? appointment;

  factory PatientQueueModel.fromJson(Map<String, dynamic> json) {
    return PatientQueueModel(
      id: _requiredInt(json, 'id'),
      appointmentId: _requiredInt(json, 'appointmentId'),
      clinicId: _requiredInt(json, 'clinicId'),
      doctorId: _requiredInt(json, 'doctorId'),
      currentPosition: _nullableInt(json['currentPosition']),
      patientsAhead: _nullableInt(json['patientsAhead']),
      priorityGroup: _priorityGroup(json['priorityGroup']),
      status: _status(json['status']),
      checkInAt: _nullableDate(json['checkInAt'], 'checkInAt'),
      calledAt: _nullableDate(json['calledAt'], 'calledAt'),
      consultationStartedAt: _nullableDate(
        json['consultationStartedAt'],
        'consultationStartedAt',
      ),
      completedAt: _nullableDate(json['completedAt'], 'completedAt'),
      skippedAt: _nullableDate(json['skippedAt'], 'skippedAt'),
      expectedWaitingTimeMinutes: _nullableInt(
        json['expectedWaitingTimeMinutes'],
      ),
      patientDelayMinutes: _nullableInt(json['patientDelayMinutes']),
      actualConsultationDurationMinutes: _nullableInt(
        json['actualConsultationDurationMinutes'],
      ),
      clinic: _nullableMap(
        json['clinic'],
        'clinic',
        PatientQueueClinic.fromJson,
      ),
      doctor: _nullableMap(
        json['doctor'],
        'doctor',
        PatientQueueDoctor.fromJson,
      ),
      appointment: _nullableMap(
        json['appointment'],
        'appointment',
        PatientQueueAppointment.fromJson,
      ),
    );
  }

  static PatientQueueStatus _status(dynamic value) {
    return switch (value) {
      'waiting' => PatientQueueStatus.waiting,
      'calling' => PatientQueueStatus.calling,
      'in_progress' => PatientQueueStatus.inProgress,
      'completed' => PatientQueueStatus.completed,
      'skipped' => PatientQueueStatus.skipped,
      _ => throw FormatException('Unsupported Queue status: $value'),
    };
  }

  static PatientQueuePriorityGroup _priorityGroup(dynamic value) {
    return switch (value) {
      'normal' => PatientQueuePriorityGroup.normal,
      'late' => PatientQueuePriorityGroup.late,
      _ => throw FormatException('Unsupported Queue priority group: $value'),
    };
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = _nullableInt(json[key]);
    if (value == null) {
      throw FormatException('Queue response is missing a valid $key.');
    }
    return value;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _nullableDate(dynamic value, String key) {
    if (value == null) return null;
    final parsed = DateTime.tryParse(value.toString())?.toLocal();
    if (parsed == null) {
      throw FormatException(
        'Queue response contains an invalid $key timestamp.',
      );
    }
    return parsed;
  }

  static T? _nullableMap<T>(
    dynamic value,
    String key,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (value == null) return null;
    if (value is! Map) {
      throw FormatException('Queue response contains an invalid $key object.');
    }
    return mapper(Map<String, dynamic>.from(value));
  }
}

class PatientQueueClinic {
  const PatientQueueClinic({required this.id, required this.name});

  final int id;
  final String name;

  factory PatientQueueClinic.fromJson(Map<String, dynamic> json) {
    return PatientQueueClinic(
      id: PatientQueueModel._requiredInt(json, 'id'),
      name: json['name']?.toString() ?? '',
    );
  }
}

class PatientQueueDoctor {
  const PatientQueueDoctor({
    required this.id,
    required this.fullName,
    required this.specialization,
  });

  final int id;
  final String? fullName;
  final String? specialization;

  factory PatientQueueDoctor.fromJson(Map<String, dynamic> json) {
    return PatientQueueDoctor(
      id: PatientQueueModel._requiredInt(json, 'id'),
      fullName: json['fullName']?.toString(),
      specialization: json['specialization']?.toString(),
    );
  }
}

class PatientQueueAppointment {
  const PatientQueueAppointment({
    required this.id,
    required this.requestedDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.status,
    required this.patient,
  });

  final int id;
  final DateTime? requestedDate;
  final String? startTime;
  final String? endTime;
  final String? type;
  final String? status;
  final PatientQueuePatient? patient;

  factory PatientQueueAppointment.fromJson(Map<String, dynamic> json) {
    return PatientQueueAppointment(
      id: PatientQueueModel._requiredInt(json, 'id'),
      requestedDate: PatientQueueModel._nullableDate(
        json['requestedDate'],
        'appointment.requestedDate',
      ),
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      patient: PatientQueueModel._nullableMap(
        json['patient'],
        'appointment.patient',
        PatientQueuePatient.fromJson,
      ),
    );
  }
}

class PatientQueuePatient {
  const PatientQueuePatient({required this.id, required this.fullName});

  final int id;
  final String? fullName;

  factory PatientQueuePatient.fromJson(Map<String, dynamic> json) {
    return PatientQueuePatient(
      id: PatientQueueModel._requiredInt(json, 'id'),
      fullName: json['fullName']?.toString(),
    );
  }
}
