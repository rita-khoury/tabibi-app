class PrescribedMedicineModel {
  final int id;
  final int userId;
  final int? medicalProfileId;
  final int? medicalHistoryId;
  final String medicineName;
  final String? dosage;
  final String? frequency;
  final String status;
  final String? startDate;
  final String? endDate;
  final String? notes;
  final String? createdAt;
  final Map<String, dynamic>? medicalHistory;

  const PrescribedMedicineModel({
    required this.id,
    required this.userId,
    required this.medicalProfileId,
    required this.medicalHistoryId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.createdAt,
    required this.medicalHistory,
  });

  factory PrescribedMedicineModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? history;
    if (json['medicalHistory'] is Map) {
      history = Map<String, dynamic>.from(json['medicalHistory'] as Map);
    }
    return PrescribedMedicineModel(
      id: _asInt(json['id']),
      userId: _asInt(json['userId'] ?? json['user_id']),
      medicalProfileId: _asNullableInt(
        json['medicalProfileId'] ?? json['medical_profile_id'],
      ),
      medicalHistoryId: _asNullableInt(
        json['medicalHistoryId'] ?? json['medical_history_id'],
      ),
      medicineName: json['medicineName']?.toString().trim() ?? '',
      dosage: _asNullableText(json['dosage']),
      frequency: _asNullableText(json['frequency']),
      status: json['status']?.toString().trim().toLowerCase() ?? 'active',
      startDate: _asNullableText(json['startDate'] ?? json['start_date']),
      endDate: _asNullableText(json['endDate'] ?? json['end_date']),
      notes: _asNullableText(json['notes']),
      createdAt: _asNullableText(json['createdAt'] ?? json['created_at']),
      medicalHistory: history,
    );
  }

  PrescribedMedicineModel copyWith({String? status}) {
    return PrescribedMedicineModel(
      id: id,
      userId: userId,
      medicalProfileId: medicalProfileId,
      medicalHistoryId: medicalHistoryId,
      medicineName: medicineName,
      dosage: dosage,
      frequency: frequency,
      status: status ?? this.status,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
      createdAt: createdAt,
      medicalHistory: medicalHistory,
    );
  }

  static int _asInt(dynamic value) =>
      int.tryParse(value?.toString() ?? '') ?? 0;

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static String? _asNullableText(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
