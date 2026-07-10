import 'user_model.dart';
import 'ProfileCompletionModel.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final ProfileCompletionModel profileCompletion;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.profileCompletion,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),

      profileCompletion: ProfileCompletionModel.fromJson(
        json['profileCompletion'] ?? {},
      ),
    );
  }
}
