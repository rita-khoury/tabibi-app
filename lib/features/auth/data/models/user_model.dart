class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String fullName;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.fullName,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "phone": phone,
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
