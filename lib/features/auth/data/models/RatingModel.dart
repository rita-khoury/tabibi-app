import 'package:flutter/foundation.dart';
import 'package:tabibi/core/constance/api_constants.dart';

class RatingModel {
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
    this.user,
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
  final Map<String, dynamic>? user;

  /// This intentionally stays mutable so a successful report can disable the
  /// action immediately, before any subsequent server refresh completes.
  bool isReportedByMe;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final rating = RatingModel(
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
      user: _asMap(json['user'] ?? json['author'] ?? json['patient']),
      isReportedByMe: _asBool(
        json['isReportedByMe'] ??
            json['is_reported_by_me'] ??
            json['isReported'] ??
            json['is_reported'] ??
            json['reportedByMe'] ??
            json['reported_by_me'] ??
            (json['myReport'] != null ? true : null) ??
            (json['my_report'] != null ? true : null),
      ),
    );

    // Debug-only trace requested for verifying backend avatar values and the
    // resulting absolute URL. It is stripped from release behavior.
    if (kDebugMode) {
      debugPrint(
        '[DoctorRatings] rating=${rating.id} avatarRaw="${rating.rawUserAvatarPath ?? ''}" '
        'avatarUrl="${rating.userAvatarUrl ?? ''}"',
      );
    }
    return rating;
  }

  Map<String, dynamic>? get _profileUser => _asMap(patientProfile?['user']);

  Map<String, dynamic>? get _author =>
      _profileUser ?? _asMap(user?["user"]) ?? user;
  int get authorUserId => _asInt(
    _author?['id'] ??
        _author?['userId'] ??
        patientProfile?['userId'] ??
        patientProfile?['user_id'] ??
        patientProfile?['id'] ??
        patientProfileId,
  );

  int get userId => authorUserId;
  int get patientId => authorUserId;

  String get reviewerName {
    final candidate =
        _author?['fullName'] ??
        _author?['full_name'] ??
        _author?['name'] ??
        patientProfile?['fullName'] ??
        patientProfile?['full_name'] ??
        patientProfile?['name'];
    final name = candidate?.toString().trim() ?? '';
    return name.isEmpty ? 'Patient' : name;
  }

  /// The raw API value is retained for diagnostics, while [userAvatarUrl]
  /// always exposes an absolute URL when the backend provides a relative path.
  String? get rawUserAvatarPath {
    final candidate =
        _author?['avatarUrl'] ??
        _author?['avatar'] ??
        _author?['image'] ??
        _author?['photo'] ??
        _author?['profileImage'] ??
        _author?['profile_image'] ??
        patientProfile?['avatarUrl'] ??
        patientProfile?['avatar'] ??
        patientProfile?['image'] ??
        patientProfile?['photo'] ??
        patientProfile?['patientPhoto'] ??
        patientProfile?['profileImage'];
    final value = candidate?.toString().trim() ?? '';
    return value.isEmpty ? null : value;
  }

  String? get userAvatarUrl {
    final rawPath = rawUserAvatarPath;
    if (rawPath == null) return null;
    final normalized = ApiConstants.getFullImageUrl(rawPath);
    return normalized.trim().isEmpty ? null : normalized;
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
