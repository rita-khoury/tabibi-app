class RatingModel {
  final int id;
  final int appointmentId;
  final int patientProfileId;
  final int doctorProfileId;
  final int score;
  final String? comment;
  final String status;
  final String createdAt;
  final Map<String, dynamic>? patientProfile;
  final Map<String, dynamic>? doctorProfile;

  RatingModel({
    required this.id,
    required this.appointmentId,
    required this.patientProfileId,
    required this.doctorProfileId,
    required this.score,
    this.comment,
    required this.status,
    required this.createdAt,
    this.patientProfile,
    this.doctorProfile,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: _parseInt(json['id']),
      appointmentId: _parseInt(json['appointmentId'] ?? json['appointment_id']),
      patientProfileId: _parseInt(
        json['patientProfileId'] ?? json['patient_profile_id'],
      ),
      doctorProfileId: _parseInt(
        json['doctorProfileId'] ?? json['doctor_profile_id'],
      ),
      score: _parseInt(json['score']),
      comment: json['comment'],
      status: json['status']?.toString() ?? 'VISIBLE',
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      patientProfile: json['patientProfile'],
      doctorProfile: json['doctorProfile'],
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
