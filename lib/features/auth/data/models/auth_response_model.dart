import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String? role;
  final bool profileCompleted;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.role,
    required this.profileCompleted,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = Map<String, dynamic>.from(
      json['user'] as Map? ?? const <String, dynamic>{},
    );
    final rawRole = userJson['role'] ?? json['role'] ?? json['userRole'];
    return AuthResponseModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(userJson),
      role: rawRole?.toString(),
      profileCompleted: json['profileCompleted'] == true,
    );
  }
}