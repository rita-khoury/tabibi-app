// class DoctorModel {
//   final int id;
//   final String name;
//   final String image;
//   final String specialization;
//   final String? subSpecialization;
//   final String? bio;
//   final String? initialVisitFee;
//   final List<String> languagesSpoken;
//   final bool isApproved;
//   final int experienceYears;
//   final double averageRating;
//   final int clinicsCount;
//
//   DoctorModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.specialization,
//     this.subSpecialization,
//     this.bio,
//     this.initialVisitFee,
//     required this.languagesSpoken,
//     required this.isApproved,
//     required this.experienceYears,
//     required this.averageRating,
//     required this.clinicsCount,
//   });
//
//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     return DoctorModel(
//       id: int.parse(json['id'].toString()),
//       name: json['user']?['full_name'] ?? 'Unknown Doctor',
//       image: json['user']?['avatarUrl'] ?? 'https://via.placeholder.com/150',
//       specialization: json['specialization'] ?? 'General',
//       subSpecialization: json['subSpecialization'],
//       bio: json['bio'],
//       initialVisitFee: json['initialVisitFee']?.toString(),
//       languagesSpoken: List<String>.from(json['languagesSpoken'] ?? []),
//       isApproved: json['isApproved'] ?? false,
//       experienceYears: json['experienceYears'] ?? 0,
//       averageRating: double.tryParse(json['averageRating'].toString()) ?? 0.0,
//       clinicsCount: json['clinics_count'] ?? 0,
//     );
//   }
// }

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
    this.isFavorite = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];

    return DoctorModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: userData?['full_name'] ?? 'Unknown Doctor',
      image: userData?['avatarUrl'] ?? 'https://via.placeholder.com/150',
      specialization: json['specialization'] ?? 'General',
      subSpecialization: json['subSpecialization'],
      bio: json['bio'],
      initialVisitFee: json['initialVisitFee']?.toString(),
      languagesSpoken: List<String>.from(json['languagesSpoken'] ?? []),
      isApproved: json['isApproved'] ?? false,
      experienceYears: json['experienceYears'] ?? 0,
      averageRating:
          double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0,
      clinicsCount: json['clinics_count'] ?? 0,

      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
