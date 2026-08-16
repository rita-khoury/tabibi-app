class ReferralDoctor {
  final int? id;
  final String name;

  const ReferralDoctor({this.id, required this.name});

  factory ReferralDoctor.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']);
    final fullName = _string(user['fullName']) ?? _string(json['fullName']);
    final firstName = _string(user['firstName']) ??
        _string(user['first_name']) ??
        _string(json['firstName']) ??
        _string(json['first_name']) ??
        '';
    final lastName = _string(user['lastName']) ??
        _string(user['last_name']) ??
        _string(json['lastName']) ??
        _string(json['last_name']) ??
        '';
    final composedName = [firstName, lastName]
        .where((part) => part.trim().isNotEmpty)
        .join(' ');

    return ReferralDoctor(
      id: _asInt(json['id'] ?? json['doctorId'] ?? json['doctor_id']),
      name: fullName?.trim().isNotEmpty == true
          ? fullName!.trim()
          : composedName.isNotEmpty
              ? composedName
              : 'Doctor',
    );
  }
}

class ReferralClinic {
  final int? id;
  final String name;

  const ReferralClinic({this.id, required this.name});

  factory ReferralClinic.fromJson(Map<String, dynamic> json) {
    return ReferralClinic(
      id: _asInt(json['id'] ?? json['clinicId'] ?? json['clinic_id']),
      name: _string(json['name'])?.trim().isNotEmpty == true
          ? _string(json['name'])!.trim()
          : 'Clinic',
    );
  }
}

class ReferralModel {
  final int id;
  final int? fromDoctorId;
  final int? toDoctorId;
  final int? toClinicId;
  final ReferralDoctor? fromDoctor;
  final ReferralDoctor? toDoctor;
  final ReferralClinic? toClinic;
  final String status;
  final String type;
  final String reason;
  final DateTime? expiresAt;

  const ReferralModel({
    required this.id,
    required this.status,
    required this.type,
    required this.reason,
    this.fromDoctorId,
    this.toDoctorId,
    this.toClinicId,
    this.fromDoctor,
    this.toDoctor,
    this.toClinic,
    this.expiresAt,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    final fromDoctorJson = _asMap(json['fromDoctor']);
    final toDoctorJson = _asMap(json['toDoctor']);
    final toClinicJson = _asMap(json['toClinic']);

    return ReferralModel(
      id: _asInt(json['id'] ?? json['referralId']) ?? 0,
      fromDoctorId: _asInt(
        json['fromDoctorId'] ??
            json['from_doctor_id'] ??
            fromDoctorJson['id'],
      ),
      toDoctorId: _asInt(
        json['toDoctorId'] ?? json['to_doctor_id'] ?? toDoctorJson['id'],
      ),
      toClinicId: _asInt(
        json['toClinicId'] ?? json['to_clinic_id'] ?? toClinicJson['id'],
      ),
      fromDoctor:
          fromDoctorJson.isEmpty ? null : ReferralDoctor.fromJson(fromDoctorJson),
      toDoctor:
          toDoctorJson.isEmpty ? null : ReferralDoctor.fromJson(toDoctorJson),
      toClinic:
          toClinicJson.isEmpty ? null : ReferralClinic.fromJson(toClinicJson),
      status: (_string(json['status']) ?? 'PENDING').toUpperCase(),
      type: (_string(json['type']) ?? 'EXTERNAL').toUpperCase(),
      reason: _string(json['reason']) ?? 'No specific reason provided',
      expiresAt: DateTime.tryParse(_string(json['expiresAt']) ??
          _string(json['expires_at']) ??
          ''),
    );
  }

  bool get isPending => status == 'PENDING';

  bool get isExpired =>
      status == 'EXPIRED' ||
      (expiresAt != null && !expiresAt!.isAfter(DateTime.now()));

  bool get isActionable => isPending && !isExpired;

  String get displayStatus {
    if (isExpired) return 'Expired';
    if (status == 'COMPLETED') return 'Completed';
    if (status == 'PENDING') return 'Pending';
    return status
        .toLowerCase()
        .split('_')
        .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String get destinationName {
    if (type == 'FOLLOW_UP') return 'Dr. ${fromDoctor?.name ?? 'Your doctor'}';
    if (toDoctor != null) return 'Dr. ${toDoctor!.name}';
    if (toClinic != null) return toClinic!.name;
    return 'Specialist Doctor';
  }

  String get sourceDoctorName => 'Dr. ${fromDoctor?.name ?? 'your doctor'}';
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

String? _string(dynamic value) {
  final text = value?.toString();
  return text == null || text.trim().isEmpty ? null : text;
}
