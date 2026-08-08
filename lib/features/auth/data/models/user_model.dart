// class UserModel {
//   final String id;
//   final String? email;
//   final String? phone;
//   final String firstName;
//   final String lastName;
//   final String fullName;
//
//   UserModel({
//     required this.id,
//     this.email,
//     this.phone,
//     required this.firstName,
//     required this.lastName,
//     required this.fullName,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     final first = json['firstName']?.toString() ?? '';
//     final last = json['lastName']?.toString() ?? '';
//
//     return UserModel(
//       id: json['id']?.toString() ?? "",
//       email: json['email']?.toString(),
//       phone: json['phone']?.toString(),
//       firstName: first,
//       lastName: last,
//       fullName: "$first $last".trim(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "email": email,
//       "phone": phone,
//       "firstName": firstName,
//       "lastName": lastName,
//     };
//   }
// }

class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? avatarUrl; // أضفناها هنا لتتطابق مع الـ Backend

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final first = json['firstName']?.toString() ?? '';
    final last = json['lastName']?.toString() ?? '';

    return UserModel(
      id: json['id']?.toString() ?? "",
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      firstName: first,
      lastName: last,
      fullName: "$first $last".trim(),
      avatarUrl: json['avatarUrl']?.toString(), // قراءتها من الـ JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "phone": phone,
      "firstName": firstName,
      "lastName": lastName,
      "avatarUrl": avatarUrl,
    };
  }

  // 1. إضافة copyWith لتحديث البيانات بسهولة
  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) {
    final newFirst = firstName ?? this.firstName;
    final newLast = lastName ?? this.lastName;

    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: newFirst,
      lastName: newLast,
      fullName: "$newFirst $newLast".trim(), // يتم تحديث الـ fullName تلقائياً
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // 2. إضافة المقارنة (equality)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.phone == phone &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    email.hashCode ^
    phone.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    fullName.hashCode ^
    avatarUrl.hashCode;
  }
}