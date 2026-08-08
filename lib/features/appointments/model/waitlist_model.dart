// class WaitlistModel {
//   final int id;
//   final int doctorId;
//   final int clinicId;
//   final String requestedDate;
//   final Doctor? doctor;
//
//   WaitlistModel({
//     required this.id,
//     required this.doctorId,
//     required this.clinicId,
//     required this.requestedDate,
//     this.doctor,
//   });
//
//   factory WaitlistModel.fromJson(Map<String, dynamic> json) {
//     return WaitlistModel(
//       id: json['id'] ?? 0,
//       doctorId: json['doctorId'] ?? 0,
//       clinicId: json['clinicId'] ?? 0,
//       requestedDate: json['requestedDate'] ?? '',
//       doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
//     );
//   }
// }
//
// class Doctor {
//   final User? user;
//
//   Doctor({this.user});
//
//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       user: json['user'] != null ? User.fromJson(json['user']) : null,
//     );
//   }
// }
//
// class User {
//   final String fullName;
//
//   User({required this.fullName});
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(fullName: json['fullName'] ?? 'طبيب');
//   }
// }

class WaitlistModel {
  final int id;
  final int patientProfileId;
  final int doctorProfileId;
  final int clinicId;
  final String requestedDate;
  final String? createdAt;

  // نجعل الـ doctor على شكل Map لضمان التقاط البيانات أياً كانت هيكلتها القادمة من السيرفر
  final Map<String, dynamic>? doctor;
  final Map<String, dynamic>? clinic;

  WaitlistModel({
    required this.id,
    required this.patientProfileId,
    required this.doctorProfileId,
    required this.clinicId,
    required this.requestedDate,
    this.createdAt,
    this.doctor,
    this.clinic,
  });

  factory WaitlistModel.fromJson(Map<String, dynamic> json) {
    print("🔍 بيانات الويت ليست الكاملة من السيرفر: $json");
    return WaitlistModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      patientProfileId: int.tryParse(json['patientProfileId']?.toString() ?? '0') ?? 0,
      doctorProfileId: int.tryParse(json['doctorProfileId']?.toString() ?? '0') ?? 0,
      clinicId: int.tryParse(json['clinicId']?.toString() ?? '0') ?? 0,
      requestedDate: json['requestedDate']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
      doctor: json['doctor'] is Map<String, dynamic> ? json['doctor'] : null,
      clinic: json['clinic'] is Map<String, dynamic> ? json['clinic'] : null,
    );
  }

  // **دالة ذكية لجلب اسم الدكتور المرتبط بالويت ليست حصراً**
  String get doctorName {
    if (doctor != null) {
      // 1. فحص ما إذا كان الاسم موجوداً داخل كائن الـ user (حسب هيكل بيانات الدكاترة لديك مثل full_name أو firstName)
      final userData = doctor!['user'];
      if (userData != null && userData is Map) {
        final fullName = userData['full_name']?.toString();
        if (fullName != null && fullName.trim().isNotEmpty) return fullName;

        final fName = userData['firstName'] ?? userData['first_name'] ?? '';
        final lName = userData['lastName'] ?? userData['last_name'] ?? '';
        final combined = '$fName $lName'.trim();
        if (combined.isNotEmpty) return combined;
      }

      // 2. فحص الحقول المباشرة داخل كائن الـ doctor نفسه
      final directName = doctor!['full_name']?.toString() ??
          doctor!['fullName']?.toString() ??
          doctor!['name']?.toString();
      if (directName != null && directName.trim().isNotEmpty) return directName;
    }

    // إذا لم توجد أي بيانات للدكتور
    return 'طبيب غير متوفر';
  }
}