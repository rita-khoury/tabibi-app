import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/CreateAppointmentModel.dart';
import '../data/models/ProfileCompletionModel.dart';
import '../data/models/ResetPasswordModel.dart';
import '../data/models/auth_response_model.dart';
import '../data/models/user_model.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Dio get dio => _dio;
  Future<String?>? _refreshFuture;

  AuthRepository() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onError: (error, handler) async {
          final request = error.requestOptions;

          if (request.path == '/auth/refresh' ||
              error.type == DioExceptionType.connectionError) {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401) {
            try {
              final newToken = await _refreshWithLock();
              if (newToken != null) {
                request.headers['Authorization'] = 'Bearer $newToken';
                final retry = await _dio.fetch(request);
                return handler.resolve(retry);
              }
            } catch (e) {
              debugPrint("❌ فشل تجديد التوكن، يجب تسجيل الخروج: $e");

              await _clearTokens();

              Get.offAllNamed('/login');

              return handler.reject(
                DioException(
                  requestOptions: request,
                  error: "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً",
                ),
              );
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshWithLock() {
    _refreshFuture ??= refreshToken().whenComplete(() => _refreshFuture = null);
    return _refreshFuture!;
  }

  Future<String?> refreshToken() async {
    debugPrint("🔄 [Interceptor]: جاري محاولة تجديد التوكن...");
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token');
    if (refresh == null) return null;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refresh},
        options: Options(headers: {'Authorization': null}),
      );

      final newAccess = response.data['accessToken'];
      final newRefresh = response.data['refreshToken'];

      if (newAccess == null) throw Exception('No access token returned');

      await prefs.setString('auth_token', newAccess);
      if (newRefresh != null)
        await prefs.setString('refresh_token', newRefresh);
      return newAccess;
    } catch (e) {
      await _clearTokens();
      rethrow;
    }
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
  }

  Future<AuthResponseModel> login(String identifier, String password) async {
    final isEmail = identifier.contains('@');
    final data = {
      'password': password,
      isEmail ? 'email' : 'phone': identifier,
    };
    try {
      final response = await _dio.post('/auth/login', data: data);
      final auth = AuthResponseModel.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();
      if (auth.accessToken != null)
        await prefs.setString('auth_token', auth.accessToken!);
      if (auth.refreshToken != null)
        await prefs.setString('refresh_token', auth.refreshToken!);
      return auth;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<UserModel> registerUser(Map<String, dynamic> data) async {
    if (data.containsKey('phone') && data['phone'] is String) {
      data['phone'] = (data['phone'] as String).replaceAll(
        RegExp(r'[+\s]'),
        '',
      );
    }
    try {
      final response = await _dio.post('/auth/register', data: data);
      final userJson =
          response.data['user'] ?? response.data['data'] ?? response.data;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/auth/verify-account', data: data);
      return response.data is String
          ? {"message": response.data}
          : response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> requestOtp(String identifier, String purpose) async {
    final isEmail = identifier.contains('@');
    try {
      await _dio.post(
        '/auth/forgot-password',
        data: {isEmail ? 'email' : 'phone': identifier},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> resetPassword(ResetPasswordModel model) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: model.toJson(),
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
    } on DioException catch (e) {
      debugPrint("الخطأ الحقيقي من السيرفر: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "خطأ غير معروف");
    }
  }

  Future<List<dynamic>> getMyAppointments() async {
    try {
      final response = await _dio.get('/appointments/my');
      return List<dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> cancelAppointment(int appointmentId, String reason) async {
    try {
      await _dio.patch(
        '/appointments/$appointmentId/cancel',
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> completeAppointment(int id) async {
    try {
      await _dio.patch('/appointments/$id/complete');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<bool> createAppointment(CreateAppointmentModel appointmentData) async {
    final Map<String, dynamic> body = appointmentData.toJson();

    debugPrint("🚀 APPOINTMENT REQUEST:");
    debugPrint(body.toString());

    try {
      final response = await _dio.post('/appointments', data: body);

      return response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint("❌ SERVER ERROR:");
      debugPrint(e.response?.data.toString());

      rethrow;
    }
  }

  Future<void> createPatientProfile(Map<String, dynamic> data) async {
    try {
      await _dio.post('/patients/profile', data: data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createMedicalProfile(dynamic profile) async {
    try {
      await _dio.post('/medical-profiles', data: profile.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<ProfileCompletionModel> getCompletionStatus() async {
    try {
      final response = await _dio.get('/medical-profiles/completion');
      return ProfileCompletionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateMedicalProfile(dynamic profile) async {
    try {
      await _dio.patch('/medical-profiles/me', data: profile.toJson());
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CompleteProfileRequest?> getMedicalProfile() async {
    try {
      final response = await _dio.get('/medical-profiles/me');
      return CompleteProfileRequest.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMyFavorites() async {
    try {
      final response = await _dio.get('/favorite-doctors');
      print("الاستجابة من السيرفر: ${response.statusCode}");
      return response.data;
    } on DioException catch (e) {
      print("خطأ DIO في addFavorite: ${e.message}");
      print("تفاصيل الخطأ: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> addFavorite(int doctorId) async {
    try {
      await _dio.post('/favorite-doctors/$doctorId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> removeFavorite(int doctorId) async {
    try {
      await _dio.delete('/favorite-doctors/$doctorId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      await _clearTokens();
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] is List
            ? (data['message'] as List).join('\n')
            : data['message'].toString();
      }
    }
    return 'تعذر الاتصال بالسيرفر';
  }
}
