class AppointmentModel {
  final int id;
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

  AppointmentModel({
    required this.id,
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
