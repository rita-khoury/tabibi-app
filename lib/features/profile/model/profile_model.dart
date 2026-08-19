class ProfileModel {
  final String id;
  final String firstName;
  final String fatherName;
  final String lastName;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String gender;
  final String birthDate;
  final String address;
  final int age;

  /// Legacy root-level fields retained as a fallback for older API responses.
  final String? occupation;
  final String? maritalStatus;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  /// Patient-only fields provided by the current profile API relation.
  final PatientProfileModel? patientProfile;

  const ProfileModel({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.age,
    this.occupation,
    this.maritalStatus,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.patientProfile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final patientJson =
        json['patientProfile'] ?? json['patient'] ?? json['patient_profile'];

    return ProfileModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      fullName: (json['full_name'] ?? json['fullName'])?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatarUrl: (json['avatarUrl'] ??
              json['avatar'] ??
              json['image'] ??
              json['profile_image'])
          ?.toString(),
      gender: json['gender']?.toString() ?? '',
      birthDate: json['birthDate']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      age: _asInt(json['age']),
      occupation: json['occupation']?.toString(),
      maritalStatus: json['maritalStatus']?.toString(),
      emergencyContactName: json['emergencyContactName']?.toString(),
      emergencyContactPhone: json['emergencyContactPhone']?.toString(),
      patientProfile: patientJson is Map
          ? PatientProfileModel.fromJson(Map<String, dynamic>.from(patientJson))
          : null,
    );
  }

  static int _asInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}

class PatientProfileModel {
  final String? occupation;
  final String? maritalStatus;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  const PatientProfileModel({
    this.occupation,
    this.maritalStatus,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) =>
      PatientProfileModel(
        occupation: json['occupation']?.toString(),
        maritalStatus: json['maritalStatus']?.toString(),
        emergencyContactName: json['emergencyContactName']?.toString(),
        emergencyContactPhone: json['emergencyContactPhone']?.toString(),
      );
}
