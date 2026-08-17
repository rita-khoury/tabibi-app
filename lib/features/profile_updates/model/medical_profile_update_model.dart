class MedicalProfileUpdateModel {
  final int id;
  final String fieldName;
  final dynamic oldValue;
  final dynamic newValue;
  final String? changeReason;
  final int? appointmentId;
  final String? createdAt;
  final ProfileUpdateActor? changedBy;

  const MedicalProfileUpdateModel({
    required this.id,
    required this.fieldName,
    required this.oldValue,
    required this.newValue,
    required this.changeReason,
    required this.appointmentId,
    required this.createdAt,
    required this.changedBy,
  });

  factory MedicalProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileUpdateModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      fieldName: json['fieldName']?.toString().trim() ?? '',
      oldValue: json.containsKey('oldValue') ? json['oldValue'] : null,
      newValue: json.containsKey('newValue') ? json['newValue'] : null,
      changeReason: _text(json['changeReason']),
      appointmentId: int.tryParse(json['appointmentId']?.toString() ?? ''),
      createdAt: _text(json['createdAt'] ?? json['created_at']),
      changedBy: json['changedBy'] is Map
          ? ProfileUpdateActor.fromJson(
              Map<String, dynamic>.from(json['changedBy'] as Map),
            )
          : null,
    );
  }

  static String? _text(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

class ProfileUpdateActor {
  final String id;
  final String role;
  final String fullName;

  const ProfileUpdateActor({
    required this.id,
    required this.role,
    required this.fullName,
  });

  factory ProfileUpdateActor.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateActor(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString().trim() ?? '',
      fullName: json['fullName']?.toString().trim() ?? '',
    );
  }
}
