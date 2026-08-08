class RatingReportModel {
  final int id;
  final int ratingId;
  final int reporterPatientId;
  final String reason;
  final String? explanation;
  final String status;
  final String createdAt;
  final Map<String, dynamic>? reporterPatient;
  final Map<String, dynamic>? rating;

  RatingReportModel({
    required this.id,
    required this.ratingId,
    required this.reporterPatientId,
    required this.reason,
    this.explanation,
    required this.status,
    required this.createdAt,
    this.reporterPatient,
    this.rating,
  });

  factory RatingReportModel.fromJson(Map<String, dynamic> json) {
    return RatingReportModel(
      id: _parseInt(json['id']),
      ratingId: _parseInt(json['ratingId'] ?? json['rating_id']),
      reporterPatientId: _parseInt(
        json['reporterPatientId'] ?? json['reporter_patient_id'],
      ),
      reason: json['reason']?.toString() ?? '',
      explanation: json['explanation']?.toString(),
      status: json['status']?.toString() ?? 'PENDING',
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      reporterPatient: json['reporterPatient'],
      rating: json['rating'],
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
