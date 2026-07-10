import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final int id;
  final String firstName;
  final String? fatherName;
  final String lastName;
  final String email;
  final String? phone;
  final String gender;
  final String address;
  final String? avatarUrl;
  final String? preferredLanguage;
  final String? themeMode;
  final String role;
  final bool isVerified;
  final PatientProfileModel? patientProfile;

  ProfileModel({
    required this.id,
    required this.firstName,
    this.fatherName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.gender,
    required this.address,
    this.avatarUrl,
    this.preferredLanguage,
    this.themeMode,
    required this.role,
    required this.isVerified,
    this.patientProfile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"] ?? 0,
    firstName: json["firstName"] ?? "",
    fatherName: json["fatherName"],
    lastName: json["lastName"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"],
    gender: json["gender"] ?? "male",
    address: json["address"] ?? "",
    avatarUrl: json["avatarUrl"],
    preferredLanguage: json["preferredLanguage"],
    themeMode: json["themeMode"],
    role: json["role"] ?? "PATIENT",
    isVerified: json["isVerified"] ?? false,
    patientProfile: json["patientProfile"] == null
        ? null
        : PatientProfileModel.fromJson(json["patientProfile"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "fatherName": fatherName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "address": address,
    "avatarUrl": avatarUrl,
    "preferredLanguage": preferredLanguage,
    "themeMode": themeMode,
    "role": role,
    "isVerified": isVerified,
    "patientProfile": patientProfile?.toJson(),
  };
}

class PatientProfileModel {
  final int id;
  final int userId;
  final String? maritalStatus;
  final String? occupation;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  PatientProfileModel({
    required this.id,
    required this.userId,
    this.maritalStatus,
    this.occupation,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) =>
      PatientProfileModel(
        id: json["id"] ?? 0,
        userId: json["userId"] ?? 0,
        maritalStatus: json["maritalStatus"],
        occupation: json["occupation"],
        emergencyContactName: json["emergencyContactName"],
        emergencyContactPhone: json["emergencyContactPhone"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "maritalStatus": maritalStatus,
    "occupation": occupation,
    "emergencyContactName": emergencyContactName,
    "emergencyContactPhone": emergencyContactPhone,
  };
}
