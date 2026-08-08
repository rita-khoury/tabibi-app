// class ProfileModel {
//   final String id;
//   final String firstName;
//   final String fatherName;
//   final String lastName;
//   final String fullName;
//   final String email;
//   final String? phone;
//   final String? avatarUrl;
//   final String gender;
//   final String birthDate;
//   final String address;
//   final int age;
//
//   ProfileModel({
//     required this.id,
//     required this.firstName,
//     required this.fatherName,
//     required this.lastName,
//     required this.fullName,
//     required this.email,
//     this.phone,
//     this.avatarUrl,
//     required this.gender,
//     required this.birthDate,
//     required this.address,
//     required this.age,
//   });
//
//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       id: json["id"],
//       firstName: json["firstName"],
//       fatherName: json["fatherName"],
//       lastName: json["lastName"],
//       fullName: json["full_name"],
//       email: json["email"],
//       phone: json["phone"],
//       avatarUrl: json["avatarUrl"],
//       gender: json["gender"],
//       birthDate: json["birthDate"],
//       address: json["address"],
//       age: json["age"],
//     );
//   }
//
//   get patientProfile => null;
// }


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

  ProfileModel({
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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"]?.toString() ?? "",
      firstName: json["firstName"] ?? "",
      fatherName: json["fatherName"] ?? "",
      lastName: json["lastName"] ?? "",
      fullName: json["full_name"] ?? json["fullName"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"],
      // فحص عدة احتمالات لاسم مفتاح الصورة القادم من الـ Backend
      avatarUrl: json["avatarUrl"] ?? json["avatar"] ?? json["image"] ?? json["profile_image"],
      gender: json["gender"] ?? "",
      birthDate: json["birthDate"] ?? "",
      address: json["address"] ?? "",
      age: json["age"] ?? 0,
    );
  }

  get patientProfile => null;
}