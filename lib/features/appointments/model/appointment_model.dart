// class AppointmentModel {
//   final int id;
//   final String status;
//   final String doctorName;
//   final String specialty;
//   final String date;
//   final String startTime;
//   final String endTime;
//   final String? clinicName;
//   final Map<String, dynamic>? referral;
//
//   String get time =>
//       "${startTime.length >= 5 ? startTime.substring(0, 5) : startTime} - "
//       "${endTime.length >= 5 ? endTime.substring(0, 5) : endTime}";
//
//   AppointmentModel({
//     required this.id,
//     required this.status,
//     required this.doctorName,
//     required this.specialty,
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     this.clinicName,
//     this.referral,
//   });
//
//   factory AppointmentModel.fromJson(Map<String, dynamic> json) {
//     final doctorData = json['doctor'] is Map
//         ? json['doctor'] as Map<String, dynamic>
//         : null;
//     final userData = doctorData?['user'] is Map
//         ? doctorData!['user'] as Map<String, dynamic>
//         : null;
//     final clinicData = json['clinic'] is Map
//         ? json['clinic'] as Map<String, dynamic>
//         : null;
//
//     return AppointmentModel(
//       id: (json['id'] is int)
//           ? json['id']
//           : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//
//       status: json['status']?.toString() ?? 'pending',
//
//       doctorName: userData?['full_name']?.toString() ?? 'طبيب غير معروف',
//
//       specialty: doctorData?['specialization']?.toString() ?? 'غير محدد',
//
//       date: (json['requestedDate'] ?? '').toString(),
//       startTime: (json['startTime'] ?? '').toString(),
//       endTime: (json['endTime'] ?? '').toString(),
//
//       clinicName: clinicData?['name']?.toString() ?? 'عيادة غير محددة',
//
//       referral: json['referral'] is Map
//           ? json['referral'] as Map<String, dynamic>
//           : null,
//     );
//   }
//
//   AppointmentModel copyWith({
//     int? id,
//     String? status,
//     String? doctorName,
//     String? specialty,
//     String? date,
//     String? startTime,
//     String? endTime,
//     String? clinicName,
//     Map<String, dynamic>? referral,
//   }) {
//     return AppointmentModel(
//       id: id ?? this.id,
//       status: status ?? this.status,
//       doctorName: doctorName ?? this.doctorName,
//       specialty: specialty ?? this.specialty,
//       date: date ?? this.date,
//       startTime: startTime ?? this.startTime,
//       endTime: endTime ?? this.endTime,
//       clinicName: clinicName ?? this.clinicName,
//       referral: referral ?? this.referral,
//     );
//   }
// }


class AppointmentModel {
  final int id;
  final int? doctorId; // <-- إضافة معرف الطبيب لتجنب خطأ undefined_getter
  final String status;
  final String doctorName;
  final String specialty;
  final String date;
  final String startTime;
  final String endTime;
  final String? clinicName;
  final Map<String, dynamic>? referral;

  String get time =>
      "${startTime.length >= 5 ? startTime.substring(0, 5) : startTime} - "
          "${endTime.length >= 5 ? endTime.substring(0, 5) : endTime}";

  // الـ Getter لفحص الحالة مع طباعة الـ Debugging
  bool get isCompleted {
    print("Appointment Status is: $status");
    return status.toLowerCase().trim() == 'completed';
  }

  AppointmentModel({
    required this.id,
    this.doctorId,
    required this.status,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.clinicName,
    this.referral,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctorData = json['doctor'] is Map
        ? json['doctor'] as Map<String, dynamic>
        : null;

    // استخراج معرف الطبيب سواء كان مبعوثاً بشكل مستقل أو داخل كائن الـ doctor
    int? extractedDoctorId;
    if (json['doctorId'] != null) {
      extractedDoctorId = int.tryParse(json['doctorId'].toString());
    } else if (doctorData != null && doctorData['id'] != null) {
      extractedDoctorId = int.tryParse(doctorData['id'].toString());
    }

    final userData = doctorData?['user'] is Map
        ? doctorData!['user'] as Map<String, dynamic>
        : null;
    final clinicData = json['clinic'] is Map
        ? json['clinic'] as Map<String, dynamic>
        : null;

    return AppointmentModel(
      id: (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      doctorId: extractedDoctorId,
      status: json['status']?.toString() ?? 'pending',
      doctorName: userData?['full_name']?.toString() ?? 'طبيب غير معروف',
      specialty: doctorData?['specialization']?.toString() ?? 'غير محدد',
      date: (json['requestedDate'] ?? '').toString(),
      startTime: (json['startTime'] ?? '').toString(),
      endTime: (json['endTime'] ?? '').toString(),
      clinicName: clinicData?['name']?.toString() ?? 'عيادة غير محددة',
      referral: json['referral'] is Map
          ? json['referral'] as Map<String, dynamic>
          : null,
    );
  }

  AppointmentModel copyWith({
    int? id,
    int? doctorId,
    String? status,
    String? doctorName,
    String? specialty,
    String? date,
    String? startTime,
    String? endTime,
    String? clinicName,
    Map<String, dynamic>? referral,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      clinicName: clinicName ?? this.clinicName,
      referral: referral ?? this.referral,
    );
  }
}