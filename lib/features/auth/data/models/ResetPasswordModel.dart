class ResetPasswordModel {
  final String? email;
  final String? phone;
  final String code;
  final String newPassword;

  ResetPasswordModel({
    this.email,
    this.phone,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (phone != null && phone!.isNotEmpty) data['phone'] = phone;

    data['code'] = code;
    data['newPassword'] = newPassword;

    return data;
  }
}
