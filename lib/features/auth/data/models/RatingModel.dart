class RatingModel {
  const RatingModel({
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
    this.isReportedByMe = false,
  });

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
  final bool isReportedByMe;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: _asInt(json['id']),
      appointmentId: _asInt(json['appointmentId'] ?? json['appointment_id']),
      patientProfileId: _asInt(
        json['patientProfileId'] ?? json['patient_profile_id'],
      ),
      doctorProfileId: _asInt(
        json['doctorProfileId'] ?? json['doctor_profile_id'],
      ),
      score: _asInt(json['score']),
      comment: json['comment']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      patientProfile: _asMap(json['patientProfile'] ?? json['patient_profile']),
      doctorProfile: _asMap(json['doctorProfile'] ?? json['doctor_profile']),
      isReportedByMe: _asBool(
        json['isReportedByMe'] ??
            json['is_reported_by_me'] ??
            json['reportedByMe'] ??
            json['reported_by_me'] ??
            (json['myReport'] != null ? true : null) ??
            (json['my_report'] != null ? true : null),
      ),
    );
  }

  /// The account ID of the review author. It accepts both direct API fields and
  /// the nested patient-profile shape used by the ratings endpoint.
  int get authorUserId {
    final profile = patientProfile;
    final nestedUser = _asMap(profile?['user']);
    return _asInt(
      nestedUser?['id'] ??
          nestedUser?['userId'] ??
          profile?['userId'] ??
          profile?['user_id'] ??
          profile?['id'] ??
          patientProfileId,
    );
  }

  // Aliases for ownership-aware UI and backward-compatible consumers.
  int get userId => authorUserId;
  int get patientId => authorUserId;

  String get reviewerName {
    final profile = patientProfile;
    final user = _asMap(profile?['user']);
    final candidate =
        user?['fullName'] ??
        user?['full_name'] ??
        user?['name'] ??
        profile?['fullName'] ??
        profile?['full_name'] ??
        profile?['name'];
    final name = candidate?.toString().trim() ?? '';
    return name.isEmpty ? 'Patient' : name;
  }

  String? get userAvatarUrl {
    final profile = patientProfile;
    final user = _asMap(profile?['user']);
    final candidate =
        user?['avatarUrl'] ??
        user?['avatar'] ??
        user?['image'] ??
        user?['photo'] ??
        user?['profileImage'] ??
        profile?['avatarUrl'] ??
        profile?['avatar'] ??
        profile?['image'] ??
        profile?['photo'] ??
        profile?['patientPhoto'] ??
        profile?['profileImage'];
    final value = candidate?.toString().trim() ?? '';
    return value.isEmpty ? null : value;
  }

  String? get patientPhoto => userAvatarUrl;

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
