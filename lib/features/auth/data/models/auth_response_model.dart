import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final bool profileCompleted;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.profileCompleted,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      profileCompleted: json['profileCompleted'] == true,
    );
  }
}
