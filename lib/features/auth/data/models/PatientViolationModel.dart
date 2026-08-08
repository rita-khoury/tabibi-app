class PatientViolationModel {
  final int id;
  final String reason;
  final String createdAt;

  PatientViolationModel({
    required this.id,
    required this.reason,
    required this.createdAt,
  });

  factory PatientViolationModel.fromJson(Map<String, dynamic> json) {
    return PatientViolationModel(
      id: json['id'],
      reason: json['reason'] ?? 'مخالفة لسياسة المواعيد',
      createdAt: json['created_at'] ?? '',
    );
  }
}
