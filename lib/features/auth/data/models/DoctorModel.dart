import 'package:flutter/cupertino.dart' show debugPrint;

class ClinicModel {
  final int id;
  final String name;

  ClinicModel({required this.id, required this.name});

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    return ClinicModel(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? 'Clinic',
    );
  }
}

class DoctorModel {
  final int id;
  final String name;
  final String image;
  final String specialization;
  final String? subSpecialization;
  final String? bio;
  final String? initialVisitFee;
  final List<String> languagesSpoken;
  final bool isApproved;
  final int experienceYears;
  final double averageRating;
  final int clinicsCount;
  final ClinicModel? clinic;

  final Map<String, List<String>> scheduleMap;

  bool isFavorite;

  DoctorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.specialization,
    this.subSpecialization,
    this.bio,
    this.initialVisitFee,
    required this.languagesSpoken,
    required this.isApproved,
    required this.experienceYears,
    required this.averageRating,
    required this.clinicsCount,
    this.clinic,
    required this.scheduleMap,
    this.isFavorite = false,
  });

  static String _parseDoctorName(dynamic userJson) {
    if (userJson == null) return 'Unknown Doctor';

    if (userJson['full_name'] != null &&
        userJson['full_name'].toString().trim().isNotEmpty) {
      return userJson['full_name'].toString();
    }

    final firstName = userJson['firstName'] ?? userJson['first_name'] ?? '';
    final lastName = userJson['lastName'] ?? userJson['last_name'] ?? '';

    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) {
      return 'د. $fullName';
    }

    return 'Unknown Doctor';
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    try {
      final parsedId = int.tryParse(json['id']?.toString() ?? '0') ?? 0;

      ClinicModel? parsedClinic;
      if (json['clinic'] != null && json['clinic'] is Map<String, dynamic>) {
        parsedClinic = ClinicModel.fromJson(json['clinic']);
      } else if (json['clinics'] != null &&
          (json['clinics'] is List) &&
          (json['clinics'] as List).isNotEmpty) {
        parsedClinic = ClinicModel.fromJson(json['clinics'][0]);
      } else if (json['clinicId'] != null) {
        parsedClinic = ClinicModel(
          id: int.tryParse(json['clinicId'].toString()) ?? 0,
          name: 'Clinic',
        );
      }

      final parsedClinicsCount =
          int.tryParse(
            json['clinics_count']?.toString() ??
                json['clinicsCount']?.toString() ??
                '0',
          ) ??
          0;

      Map<String, List<String>> parsedSchedule = {};
      if (json['schedule'] != null && json['schedule'] is Map) {
        (json['schedule'] as Map<String, dynamic>).forEach((key, value) {
          if (value is List) {
            parsedSchedule[key] = value.map((e) => e.toString()).toList();
          }
        });
      }

      return DoctorModel(
        id: parsedId,
        name: _parseDoctorName(json['user']),
        image:
            json['user']?['avatarUrl']?.toString() ??
            'https://via.placeholder.com/150',
        specialization: json['specialization']?.toString() ?? 'General',
        subSpecialization: json['subSpecialization']?.toString(),
        bio: json['bio']?.toString(),
        initialVisitFee: json['initialVisitFee']?.toString(),
        languagesSpoken: List<String>.from(json['languagesSpoken'] ?? []),
        isApproved: json['isApproved'] == true || json['isApproved'] == 'true',
        experienceYears:
            int.tryParse(json['experienceYears']?.toString() ?? '0') ?? 0,
        averageRating:
            double.tryParse(json['averageRating']?.toString() ?? '0.0') ?? 0.0,
        clinicsCount: parsedClinicsCount,
        clinic: parsedClinic,
        scheduleMap: parsedSchedule,
        isFavorite: json['isFavorite'] == true || json['isFavorite'] == 'true',
      );
    } catch (e) {
      debugPrint("🚨 خطأ في معالجة الموديل: $e");
      rethrow;
    }
  }
}
