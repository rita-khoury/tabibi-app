// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../appointments/model/appointment_model.dart';
// import '../data/models/CreateAppointmentModel.dart';
// import '../data/models/DoctorModel.dart';
// import '../data/models/ProfileCompletionModel.dart';
// import '../data/models/ResetPasswordModel.dart';
// import '../data/models/auth_response_model.dart';
//
// import '../data/models/notifications_model.dart';
// import '../data/models/user_model.dart';
//
// class RegistrationConflictException implements Exception {

//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: ApiConfig.baseUrl,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//     ),
//   );
//
//   Dio get dio => _dio;
//   Future<String?>? _refreshFuture;
//
//   AuthRepository() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final prefs = await SharedPreferences.getInstance();
//           final token = prefs.getString('auth_token');
//           if (token != null) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           handler.next(options);
//         },
//
//         onError: (error, handler) async {
//           final request = error.requestOptions;
//
//           if (request.path == '/auth/refresh' ||
//               error.type == DioExceptionType.connectionError) {
//             return handler.next(error);
//           }
//
//           if (error.response?.statusCode == 401) {
//             try {
//               final newToken = await _refreshWithLock();
//               if (newToken != null) {
//                 request.headers['Authorization'] = 'Bearer $newToken';
//                 final retry = await _dio.fetch(request);
//                 return handler.resolve(retry);
//               }
//             } catch (e) {
//               debugPrint("❌ فشل تجديد التوكن، يجب تسجيل الخروج: $e");
//
//               await _clearTokens();
//
//               Get.offAllNamed('/login');
//
//               return handler.reject(
//                 DioException(
//                   requestOptions: request,
//                   error: "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً",
//                 ),
//               );
//             }
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }
//
//   Future<String?> _refreshWithLock() {
//     _refreshFuture ??= refreshToken().whenComplete(() => _refreshFuture = null);
//     return _refreshFuture!;
//   }
//
//   Future<String?> refreshToken() async {
//     debugPrint("🔄 [Interceptor]: جاري محاولة تجديد التوكن...");
//     final prefs = await SharedPreferences.getInstance();
//     final refresh = prefs.getString('refresh_token');
//     if (refresh == null) return null;
//
//     try {
//       final response = await _dio.post(
//         '/auth/refresh',
//         data: {'refreshToken': refresh},
//         options: Options(headers: {'Authorization': null}),
//       );
//
//       final newAccess = response.data['accessToken'];
//       final newRefresh = response.data['refreshToken'];
//
//       if (newAccess == null) throw Exception('No access token returned');
//
//       await prefs.setString('auth_token', newAccess);
//       if (newRefresh != null)
//         await prefs.setString('refresh_token', newRefresh);
//       return newAccess;
//     } catch (e) {
//       await _clearTokens();
//       rethrow;
//     }
//   }
//
//   Future<void> _clearTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('refresh_token');
//   }
//
//   Future<List<dynamic>> getLookups(String type) async {
//     final response = await _dio.get(
//       '/lookups',
//       queryParameters: {'type': type},
//     );
//     return response.data;
//   }
//   Future<bool> checkInPatient(int appointmentId) async {
//     try {
//       final response = await _dio.patch('/queues/check-in/$appointmentId');
//       return response.statusCode == 200 || response.statusCode == 201;
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في الـ Check-in: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//   Future<List<Map<String, dynamic>>> getLookupsByCategory(
//     String category,
//   ) async {
//     try {
//       final response = await _dio.get(
//         '/lookups',
//         queryParameters: {'category': category},
//       );
//
//       return List<Map<String, dynamic>>.from(response.data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getDoctorScheduleForPatient(
//     int doctorId,
//     int clinicId,
//   ) async {
//     try {
//       final response = await _dio.get(
//         '/doctor-schedules/patient/doctor/$doctorId/clinic/$clinicId',
//       );
//
//       return List<Map<String, dynamic>>.from(response.data);
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في جلب جدول الطبيب: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<ClinicModel>> getClinicsForDoctor(int doctorId) async {
//     try {
//       final response = await _dio.get(
//         '/doctor-clinics/doctors/$doctorId/clinics',
//       );
//
//       debugPrint("🔍 العيادات المستلمة: ${response.data}");
//
//       return (response.data as List)
//           .map((e) => ClinicModel.fromJson(e))
//           .toList();
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<AuthResponseModel> login(String identifier, String password) async {
//     final isEmail = identifier.contains('@');
//     final data = {
//       'password': password,
//       isEmail ? 'email' : 'phone': identifier,
//     };
//     try {
//       final response = await _dio.post('/auth/login', data: data);
//       final auth = AuthResponseModel.fromJson(response.data);
//       final prefs = await SharedPreferences.getInstance();
//       if (auth.accessToken != null)
//         await prefs.setString('auth_token', auth.accessToken!);
//       if (auth.refreshToken != null)
//         await prefs.setString('refresh_token', auth.refreshToken!);
//       return auth;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<UserModel> registerUser(Map<String, dynamic> data) async {
//     if (data.containsKey('phone') && data['phone'] is String) {
//       data['phone'] = (data['phone'] as String).replaceAll(
//         RegExp(r'[+\s]'),
//         '',
//       );
//     }
//     try {
//       final response = await _dio.post('/auth/register', data: data);
//       final userJson =
//           response.data['user'] ?? response.data['data'] ?? response.data;
//       return UserModel.fromJson(userJson);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
//     try {
//       final response = await _dio.post('/auth/verify-account', data: data);
//       return response.data is String
//           ? {"message": response.data}
//           : response.data as Map<String, dynamic>;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> requestOtp(String identifier, String purpose) async {
//     final isEmail = identifier.contains('@');
//     try {
//       await _dio.post(
//         '/auth/forgot-password',
//         data: {isEmail ? 'email' : 'phone': identifier},
//       );
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> resetPassword(ResetPasswordModel model) async {
//     try {
//       await _dio.post(
//         '/auth/reset-password',
//         data: model.toJson(),
//         options: Options(
//           validateStatus: (status) {
//             return status! < 500;
//           },
//         ),
//       );
//     } on DioException catch (e) {
//       debugPrint("الخطأ الحقيقي من السيرفر: ${e.response?.data}");
//       throw Exception(e.response?.data['message'] ?? "خطأ غير معروف");
//     }
//   }
//
//   Future<List<AppointmentModel>> getMyAppointments() async {
//     try {
//       final response = await _dio.get('/appointments/my');
//
//       if (kDebugMode) {
//         print("🔍 استجابة المواعيد الخام: ${response.data}");
//       }
//
//       final List<dynamic> data = response.data;
//       return data.map((json) => AppointmentModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ API المواعيد: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> cancelAppointment(int appointmentId, String reason) async {
//     try {
//       await _dio.patch(
//         '/appointments/$appointmentId/cancel',
//         data: {'cancellationReason': reason},
//       );
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> completeAppointment(int id) async {
//     try {
//       await _dio.patch('/appointments/$id/complete');
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<bool> createAppointment(CreateAppointmentModel appointmentData) async {
//     final Map<String, dynamic> body = appointmentData.toJson();
//
//     debugPrint("🚀 APPOINTMENT REQUEST:");
//     debugPrint(body.toString());
//
//     try {
//       final response = await _dio.post('/appointments', data: body);
//
//       return response.statusCode == 201;
//     } on DioException catch (e) {
//       debugPrint("❌ SERVER ERROR:");
//       debugPrint(e.response?.data.toString());
//
//       rethrow;
//     }
//   }
//
//   Future<void> createPatientProfile(Map<String, dynamic> data) async {
//     try {
//       await _dio.post('/patients/profile', data: data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> createMedicalProfile(dynamic profile) async {
//     try {
//       await _dio.post('/medical-profiles', data: profile.toJson());
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<ProfileCompletionModel> getCompletionStatus() async {
//     try {
//       final response = await _dio.get('/medical-profiles/completion');
//       return ProfileCompletionModel.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> updateMedicalProfile(dynamic profile) async {
//     try {
//       await _dio.patch('/medical-profiles/me', data: profile.toJson());
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<CompleteProfileRequest?> getMedicalProfile() async {
//     try {
//       final response = await _dio.get('/medical-profiles/me');
//       return CompleteProfileRequest.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return null;
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<dynamic>> getMyFavorites() async {
//     try {
//       final response = await _dio.get('/favorite-doctors');
//       print("الاستجابة من السيرفر: ${response.statusCode}");
//       return response.data;
//     } on DioException catch (e) {
//       print("خطأ DIO في addFavorite: ${e.message}");
//       print("تفاصيل الخطأ: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getDoctorAvailableDays(
//     int doctorId,
//     int clinicId,
//     String month,
//   ) async {
//     try {
//       final response = await _dio.get(
//         '/doctors/$doctorId/availability',
//         queryParameters: {'clinicId': clinicId, 'month': month},
//       );
//       return List<Map<String, dynamic>>.from(response.data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<String>> getDoctorLeaves(int doctorId, String month) async {
//     try {
//       final response = await _dio.get(
//         '/doctor-leaves/by-month',
//         queryParameters: {'doctorId': doctorId, 'month': month},
//       );
//       return List<String>.from(response.data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
// // 1. تعديل دالة الانضمام (Join Waitlist) لتتطابق مع المسار الصحيح
//   Future<bool> joinWaitlist({
//     required int doctorId,
//     required int clinicId,
//     required String requestedDate,
//   }) async {
//     try {
//       final response = await _dio.post(
//         '/waitlists/join', // المسار الصحيح في الكنترولر
//         data: {
//           'doctorId': doctorId,
//           'clinicId': clinicId,
//           'requestedDate': requestedDate,
//         },
//       );
//
//       return response.statusCode == 201 || response.statusCode == 200;
//     } on DioException catch (e) {
//       debugPrint("❌ Error joining waitlist: ${e.response?.data}");
//       throw Exception(_handleDioError(e)); // تم إضافة معالجة الأخطاء لتظهر رسالة السيرفر الواضحة
//     }
//   }
//
//   // 2. تعديل دالة المغادرة (Leave Waitlist) لتتطابق مع المسار الصحيح DELETE
//   Future<bool> leaveWaitlist({
//     required int doctorId,
//     required int clinicId,
//     required String requestedDate,
//   }) async {
//     try {
//       final response = await _dio.delete(
//         '/waitlists/leave', // المسار الصحيح في الكنترولر
//         data: {
//           'doctorId': doctorId,
//           'clinicId': clinicId,
//           'requestedDate': requestedDate,
//         },
//       );
//       return response.statusCode == 200;
//     } on DioException catch (e) {
//       debugPrint("❌ Error leaving waitlist: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   // جلب قائمة الانتظار الخاصة بالمريض باستخدام المسار الصحيح /waitlists/my
//   Future<List<dynamic>> getMyWaitlists() async {
//     try {
//       final response = await _dio.get('/waitlists/my');
//
//       debugPrint("🔍 استجابة قائمة الانتظار الخام: ${response.data}");
//
//       if (response.statusCode == 200) {
//         return List<dynamic>.from(response.data);
//       }
//       return [];
//     } on DioException catch (e) {
//       debugPrint("❌ Error fetching my waitlists: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//   // Future<void> addToWaitlist(int doctorId, int clinicId, String date) async {
//   //   try {
//   //     await _dio.post(
//   //       '/waitlists',
//   //       data: {
//   //         'doctorId': doctorId,
//   //         'clinicId': clinicId,
//   //         'requestedDate': date,
//   //       },
//   //     );
//   //   } on DioException catch (e) {
//   //     throw Exception(_handleDioError(e));
//   //   }
//   // }
//
//   Future<List<dynamic>> getMyActiveReferrals() async {
//     try {
//       final response = await _dio.get('/referrals/my-active');
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<bool> checkSlotAvailability(
//     int doctorId,
//     int clinicId,
//     String startTime,
//     String endTime,
//   ) async {
//     try {
//       final response = await _dio.post(
//         '/appointments/check-availability',
//         data: {
//           'doctorId': doctorId,
//           'clinicId': clinicId,
//           'startTime': startTime,
//           'endTime': endTime,
//         },
//       );
//       return response.data['isAvailable'] == true;
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في التحقق من التوفر: ${e.response?.data}");
//       return false;
//     }
//   }
//
//   Future<void> updateAppointmentStatus(int appointmentId, String status) async {
//     try {
//       await _dio.patch(
//         '/appointments/$appointmentId/status',
//         data: {'status': status},
//       );
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getNextAvailableTime(
//     int doctorId,
//     int clinicId,
//     int scheduleId,
//     String date,
//     String type,
//   ) async {
//     try {
//       final response = await _dio.post(
//         '/appointments/next-time',
//         data: {
//           'doctorId': doctorId,
//           'clinicId': clinicId,
//           'scheduleId': scheduleId,
//           'requestedDate': date,
//           'type': type,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<dynamic>> getAvailableDays(
//     int doctorId,
//     int clinicId,
//     int scheduleId,
//     String month,
//   ) async {
//     try {
//       final response = await _dio.post(
//         '/appointments/available-days',
//         data: {
//           'doctorId': doctorId,
//           'clinicId': clinicId,
//           'scheduleId': scheduleId,
//           'month': month,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   // Future<bool> joinWaitlist({
//   //   required int doctorId,
//   //   required int clinicId,
//   //   required String requestedDate,
//   // }) async {
//   //   try {
//   //     final response = await _dio.post(
//   //       '/waitlists/join',
//   //       data: {
//   //         'doctorId': doctorId,
//   //         'clinicId': clinicId,
//   //         'requestedDate': requestedDate,
//   //       },
//   //     );
//   //
//   //     return response.statusCode == 201 || response.statusCode == 200;
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ Error joining waitlist: ${e.response?.data}");
//   //
//   //     rethrow;
//   //   }
//   // }
//   //
//   // Future<bool> leaveWaitlist({
//   //   required int doctorId,
//   //   required int clinicId,
//   //   required String requestedDate,
//   // }) async {
//   //   try {
//   //     final response = await _dio.delete(
//   //       '/waitlists/leave',
//   //       data: {
//   //         'doctorId': doctorId,
//   //         'clinicId': clinicId,
//   //         'requestedDate': requestedDate,
//   //       },
//   //     );
//   //     return response.statusCode == 200;
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ Error leaving waitlist: ${e.response?.data}");
//   //     throw Exception(_handleDioError(e));
//   //   }
//   // }
//
//   Future<List<NotificationsModel>> getMyNotifications({
//     String lang = 'en',
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/notifications/me',
//         options: Options(headers: {'accept-language': lang}),
//       );
//
//       final List<dynamic> data = response.data;
//       return data.map((json) => NotificationsModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في جلب الإشعارات: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> markNotificationAsRead(int notificationId) async {
//     try {
//       await _dio.patch('/notifications/$notificationId/read');
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في تحديث حالة الإشعار: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<int> markAllNotificationsAsRead() async {
//     try {
//       final response = await _dio.patch('/notifications/read-all');
//       return response.data['updatedCount'] ?? 0;
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في تحديث جميع الإشعارات: ${e.response?.data}");
//       throw Exception(_handleDioError(e));
//     }
//   }
//   //
//   // Future<List<dynamic>> getWaitlist() async {
//   //   try {
//   //     final response = await _dio.get('/waitlists/patient');
//   //
//   //     debugPrint("🔍 استجابة الويت ليست الخام: ${response.data}");
//   //
//   //     if (response.statusCode == 200) {
//   //       return List<dynamic>.from(response.data);
//   //     }
//   //     return [];
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ Error fetching waitlist: ${e.response?.data}");
//   //     throw Exception(_handleDioError(e));
//   //   }
//   // }
//
//   Future<DoctorModel?> getDoctorById(int doctorId) async {
//     final response = await _dio.get('/doctors/$doctorId');
//     debugPrint("🔍 البيانات الخام للطبيب: ${response.data}");
//     return DoctorModel.fromJson(response.data);
//   }
//
//   Future<Map<String, dynamic>> getSentReferrals({
//     int page = 1,
//     int limit = 10,
//     String? status,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/referrals/doctor/sent',
//         queryParameters: {
//           'page': page,
//           'limit': limit,
//           if (status != null) 'status': status,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getReceivedReferrals({
//     int page = 1,
//     int limit = 10,
//     String? status,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/referrals/doctor/received',
//         queryParameters: {
//           'page': page,
//           'limit': limit,
//           if (status != null) 'status': status,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getReferralDetails(int referralId) async {
//     try {
//       final response = await _dio.get('/referrals/$referralId');
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getPatientLiveQueueStatus(int appointmentId) async {
//     try {
//       final response = await _dio.get(
//         '/queues/patient/live-status/$appointmentId',
//         options: Options(validateStatus: (status) => status! < 500),
//       );
//       return response.data is Map<String, dynamic> ? response.data : {};
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//   Future<Map<String, dynamic>?> getActiveCheckedInAppointment() async {
//     try {
//       final response = await _dio.get(
//         '/queues/patient/active-checked-in',
//         options: Options(validateStatus: (status) => status! < 500),
//       );
//
//       if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
//         return response.data;
//       }
//       return null;
//     } on DioException catch (e) {
//       debugPrint("❌ خطأ في جلب الموعد النشط: ${e.response?.data}");
//       return null;
//     }
//   }
//
//   Future<List<dynamic>> getMyViolations() async {
//     try {
//       final response = await _dio.get('/patient-violations/me');
//       if (response.statusCode == 200) {
//         return response.data is List
//             ? response.data
//             : (response.data['data'] ?? []);
//       }
//       return [];
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب المخالفات: $e");
//       return [];
//     }
//   }
//
//   // Future<Map<String, dynamic>> getPatientLiveQueueStatus(int appointmentId) async {
//   //   try {
//   //     final response = await _dio.get(
//   //       '/queues/patient/live-status/$appointmentId',
//   //       options: Options(
//   //         validateStatus: (status) => status! < 500,
//   //       ),
//   //     );
//   //
//   //     debugPrint("🔍 استجابة حالة الطابور: ${response.data}");
//   //
//   //     if (response.data is Map<String, dynamic>) {
//   //       return response.data;
//   //     }
//   //     return {};
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ خطأ في جلب حالة الطابور الحي: ${e.response?.data}");
//   //     throw Exception(_handleDioError(e));
//   //   }
//   // }
//   //
//   // Future<Map<String, dynamic>?> getActiveCheckedInAppointment() async {
//   //   try {
//   //     final response = await _dio.get(
//   //       '/queues/patient/active-checked-in',
//   //       options: Options(
//   //         validateStatus: (status) => status! < 500,
//   //       ),
//   //     );
//   //
//   //     if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
//   //       return response.data;
//   //     }
//   //     return null;
//   //   } on DioException catch (e) {
//   //     debugPrint("❌ خطأ في جلب الموعد النشط: ${e.response?.data}");
//   //     return null;
//   //   }
//   // }
//   //
//
//   Future<Map<String, dynamic>> createRating(Map<String, dynamic> data) async {
//     try {
//       final response = await _dio.post('/ratings', data: data);
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> updateRating(
//     int ratingId,
//     Map<String, dynamic> data,
//   ) async {
//     try {
//       final response = await _dio.patch('/ratings/$ratingId', data: data);
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> deleteRating(int ratingId) async {
//     try {
//       await _dio.delete('/ratings/$ratingId');
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> reportRating(
//     int ratingId,
//     Map<String, dynamic> data,
//   ) async {
//     try {
//       final response = await _dio.post('/ratings/$ratingId/report', data: data);
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getDoctorRatings(
//     int doctorId, {
//     int page = 1,
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/ratings/doctor/$doctorId',
//         queryParameters: {'page': page, 'limit': limit},
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> getPatientOwnRatings({
//     int page = 1,
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/ratings/my-reviews',
//         queryParameters: {'page': page, 'limit': limit},
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> adminGetAllRatings({
//     String? status,
//     int? score,
//     int? doctorId,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/ratings/admin/all',
//         queryParameters: {
//           if (status != null) 'status': status,
//           if (score != null) 'score': score,
//           if (doctorId != null) 'doctorId': doctorId,
//           'page': page,
//           'limit': limit,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> adminUpdateRatingStatus(
//     int ratingId,
//     String status,
//   ) async {
//     try {
//       final response = await _dio.patch(
//         '/ratings/admin/$ratingId/status',
//         data: {'status': status},
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> adminGetAllReports({
//     String? status,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/ratings/admin/reports',
//         queryParameters: {
//           if (status != null) 'status': status,
//           'page': page,
//           'limit': limit,
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>?> getMedicalProfileDetails() async {
//     try {
//       final response = await _dio.get('/medical-profiles/me');
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return null;
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<double> getProfileCompletionPercentage() async {
//     try {
//       final response = await _dio.get('/medical-profiles/completion');
//       if (response.data != null &&
//           response.data['completionPercentage'] != null) {
//         double percentage = (response.data['completionPercentage'] as num)
//             .toDouble();
//         return percentage > 1.0 ? percentage / 100.0 : percentage;
//       }
//       return 0.0;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<dynamic>> getMedicalHistories({
//     int page = 1,
//     int limit = 20,
//   }) async {
//     try {
//       final response = await _dio.get(
//         '/medical-histories/me',
//         queryParameters: {'page': page, 'limit': limit},
//       );
//
//       if (response.data != null) {
//         return response.data is List
//             ? response.data
//             : response.data['data'] ?? [];
//       }
//       return [];
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<dynamic> getMedicalAttachments() async {
//     try {
//       final response = await _dio.get('/medical-attachments/me');
//       return response.data;
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> deleteMedicalAttachment(int id) async {
//     try {
//       await _dio.delete('/medical-attachments/$id');
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> uploadMedicalAttachment(String filePath, String fileName) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "files": [await MultipartFile.fromFile(filePath, filename: fileName)],
//       });
//
//       await _dio.post('/medical-attachments/profile/me', data: formData);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<dynamic>> getMyMedicines() async {
//     try {
//       final response = await _dio.get('/prescribed-medicines/me');
//       return response.data is List
//           ? response.data
//           : (response.data['data'] ?? []);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> createMyProfileMedicine(Map<String, dynamic> data) async {
//     try {
//       await _dio.post('/prescribed-medicines/my-profile', data: data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> updateMedicineStatus(int medicineId, String status) async {
//     try {
//       await _dio.patch(
//         '/prescribed-medicines/$medicineId/status',
//         data: {'status': status},
//       );
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> updateMedicalProfileMe(Map<String, dynamic> data) async {
//     try {
//       await _dio.patch('/medical-profiles/me', data: data);
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<List<dynamic>> getMedicalProfileLogs() async {
//     try {
//       final response = await _dio.get('/medical-profiles/logs/me');
//       return response.data is List
//           ? response.data
//           : (response.data['data'] ?? []);
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) return [];
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<Map<String, dynamic>> adminResolveReport(
//     int reportId,
//     String action,
//   ) async {
//     try {
//       final response = await _dio.patch(
//         '/ratings/admin/reports/$reportId/resolve',
//         data: {'action': action},
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> addFavorite(int doctorId) async {
//     try {
//       await _dio.post('/favorite-doctors/$doctorId');
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> removeFavorite(int doctorId) async {
//     try {
//       await _dio.delete('/favorite-doctors/$doctorId');
//     } on DioException catch (e) {
//       throw Exception(_handleDioError(e));
//     }
//   }
//
//   Future<void> logout() async {
//     try {
//       await _dio.post('/auth/logout');
//     } catch (e) {
//       debugPrint("Logout error: $e");
//     } finally {
//       await _clearTokens();
//     }
//   }
//
// //   String _handleDioError(DioException e) {
// //     if (e.response?.data != null) {
// //       final data = e.response?.data;
// //       if (data is Map && data['message'] != null) {
// //         return data['message'] is List
// //             ? (data['message'] as List).join('\n')
// //             : data['message'].toString();
// //       }
// //     }
// //     return 'تعذر الاتصال بالسيرفر';
// //   }
// // }
//
//
//   String _handleDioError(DioException e) {
//     if (e.response?.data != null) {
//       final data = e.response?.data;
//
//       if (data is Map) {
//         // إذا كان الخطأ موجوداً في حقل message
//         if (data['message'] != null) {
//           final msg = data['message'];
//           if (msg is List) return msg.join('\n');
//           return msg.toString();
//         }
//         // إذا كان السيرفر يرسل الخطأ في حقل error
//         if (data['error'] != null) {
//           return data['error'].toString();
//         }
//         // إذا كانت البيانات عبارة عن خريطة كاملة يمكن تحويلها لنص
//         return data.toString();
//       } else if (data is String) {
//         return data;
//       }
//     }
//
//     // في حال لم تكن هناك استجابة واضحة نأخذ رسالة الـ Dio الأصلية
//     return e.message ?? 'تعذر الاتصال بالسيرفر';
//   }}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constance/api_constants.dart';

import '../../appointments/model/appointment_model.dart';
import '../data/models/CreateAppointmentModel.dart';
import '../data/models/DoctorModel.dart';
import '../data/models/ProfileCompletionModel.dart';
import '../data/models/ResetPasswordModel.dart';
import '../data/models/auth_response_model.dart';

import '../data/models/notifications_model.dart';
import '../data/models/user_model.dart';

class RegistrationConflictException implements Exception {
  const RegistrationConflictException();
}

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
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
          if (token != null && options.path != '/auth/refresh') {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onError: (error, handler) async {
          final request = error.requestOptions;

          if (request.extra['retriedAfterRefresh'] == true ||
              request.path.startsWith('/auth/') ||
              error.type == DioExceptionType.connectionError) {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401) {
            try {
              final newToken = await _refreshWithLock();
              if (newToken != null) {
                request.extra['retriedAfterRefresh'] = true;
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

  Future<void> rateDoctor({
    required int appointmentId,
    required double rating,
    String? comment,
  }) async {
    try {
      await _dio.post(
        '/ratings',
        data: {
          'appointmentId': appointmentId,
          'score': rating.toInt(),
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
      );
    } on DioException catch (e) {
      debugPrint("خطأ في إرسال التقييم: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
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

  Future<List<dynamic>> getLookups(String type) async {
    final response = await _dio.get(
      '/lookups',
      queryParameters: {'type': type},
    );
    return response.data;
  }

  Future<bool> checkInPatient(int appointmentId) async {
    try {
      final response = await _dio.patch('/queues/check-in/$appointmentId');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint("❌ خطأ في الـ Check-in: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<Map<String, dynamic>>> getLookupsByCategory(
    String category,
  ) async {
    try {
      final response = await _dio.get(
        '/lookups',
        queryParameters: {'category': category},
      );

      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<Map<String, dynamic>>> getDoctorScheduleForPatient(
    int doctorId,
    int clinicId,
  ) async {
    try {
      final response = await _dio.get(
        '/doctor-schedules/patient/doctor/$doctorId/clinic/$clinicId',
      );

      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      debugPrint("❌ خطأ في جلب جدول الطبيب: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<ClinicModel>> getClinicsForDoctor(int doctorId) async {
    try {
      final response = await _dio.get(
        '/doctor-clinics/doctors/$doctorId/clinics',
      );

      debugPrint("🔍 العيادات المستلمة: ${response.data}");

      return (response.data as List)
          .map((e) => ClinicModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<AuthResponseModel> login(String identifier, String password) async {
    final isEmail = identifier.contains('@');
    final data = {
      'password': password,
      isEmail ? 'email' : 'phone': identifier,
    };
    try {
      final response = await _dio.post('/auth/login', data: data);
      return AuthResponseModel.fromJson(response.data);
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
      if (e.response?.statusCode == 409) {
        throw const RegistrationConflictException();
      }
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

  Future<void> resendVerification(String identifier) async {
    final isEmail = identifier.contains('@');
    try {
      await _dio.post(
        '/auth/resend-verification', // تأكدي أن هذا المسار يطابق الـ Endpoint في الـ Backend لديك
        data: {isEmail ? 'email' : 'phone': identifier},
      );
    } on DioException catch (e) {
      debugPrint("❌ خطأ في إعادة الإرسال: ${e.response?.data}");
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

  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _dio.get('/appointments/my');
      final raw = response.data;
      final List<dynamic> items;
      if (raw is List) {
        items = raw;
      } else if (raw is Map) {
        final candidates = <dynamic>[
          raw['data'],
          raw['appointments'],
          raw['items'],
        ];
        final list = candidates.firstWhere(
          (value) => value is List,
          orElse: () => const <dynamic>[],
        );
        items = List<dynamic>.from(list as List);
      } else {
        items = const <dynamic>[];
      }
      return items
          .whereType<Map>()
          .map(
            (json) =>
                AppointmentModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return <AppointmentModel>[];
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> cancelAppointment(int appointmentId, String reason) async {
    try {
      await _dio.patch(
        '/appointments/$appointmentId/cancel',
        data: {'cancellationReason': reason},
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
    try {
      final response = await _dio.post(
        '/appointments',
        data: appointmentData.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
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

  Future<List<Map<String, dynamic>>> getDoctorAvailableDays(
    int doctorId,
    int clinicId,
  ) {
    return getAvailableDays(doctorId, clinicId);
  }

  Future<List<String>> getDoctorLeaves(int doctorId, String month) async {
    try {
      final response = await _dio.get(
        '/doctor-leaves/by-month',
        queryParameters: {'doctorId': doctorId, 'month': month},
      );
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<bool> joinWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      final response = await _dio.post(
        '/waitlists/join',
        data: {
          'doctorId': doctorId,
          'clinicId': clinicId,
          'requestedDate': requestedDate,
        },
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("❌ Error joining waitlist: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<bool> leaveWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      final response = await _dio.delete(
        '/waitlists/leave',
        data: {
          'doctorId': doctorId,
          'clinicId': clinicId,
          'requestedDate': requestedDate,
        },
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("❌ Error leaving waitlist: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMyWaitlists() async {
    try {
      final response = await _dio.get('/waitlists/my');

      debugPrint("🔍 استجابة قائمة الانتظار الخام: ${response.data}");

      if (response.statusCode == 200) {
        return List<dynamic>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      debugPrint("❌ Error fetching my waitlists: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMyReferrals({int limit = 50}) async {
    try {
      final response = await _dio.get(
        '/referrals/my-referrals',
        queryParameters: {'page': 1, 'limit': limit},
      );
      final payload = response.data;
      if (payload is List) return List<dynamic>.from(payload);
      if (payload is Map) {
        final data = payload['data'];
        if (data is List) return List<dynamic>.from(data);
      }
      return <dynamic>[];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<Map<String, dynamic>>> getDoctorsInClinic(int clinicId) async {
    try {
      final response = await _dio.get(
        '/doctor-clinics/clinics/$clinicId/doctors',
      );
      final payload = response.data;
      if (payload is! List) return <Map<String, dynamic>>[];
      return payload
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMyActiveReferrals() async {
    try {
      final response = await _dio.get('/referrals/my-active');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<bool> checkSlotAvailability(
    int doctorId,
    int clinicId,
    String startTime,
    String endTime,
  ) async {
    try {
      final response = await _dio.post(
        '/appointments/check-availability',
        data: {
          'doctorId': doctorId,
          'clinicId': clinicId,
          'startTime': startTime,
          'endTime': endTime,
        },
      );
      return response.data['isAvailable'] == true;
    } on DioException catch (e) {
      debugPrint("❌ خطأ في التحقق من التوفر: ${e.response?.data}");
      return false;
    }
  }

  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      await _dio.patch(
        '/appointments/$appointmentId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getNextAvailableTime(
    int doctorId,
    int clinicId,
    int scheduleId,
    String date,
    String type,
  ) async {
    try {
      final response = await _dio.post(
        '/appointments/next-time',
        data: {
          'doctorId': doctorId,
          'clinicId': clinicId,
          'scheduleId': scheduleId,
          'requestedDate': date,
          'type': type,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDays(
    int doctorId,
    int clinicId,
  ) async {
    try {
      final response = await _dio.post(
        '/appointments/available-days',
        data: {'doctorId': doctorId, 'clinicId': clinicId},
      );
      return List<Map<String, dynamic>>.from(response.data as List);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> getAppointmentDayStatus({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      final response = await _dio.get(
        '/appointments/day-status',
        queryParameters: {
          'doctorId': doctorId,
          'clinicId': clinicId,
          'requestedDate': requestedDate,
        },
      );
      final data = response.data;
      if (data is Map && data['status'] != null) {
        return data['status'].toString();
      }
      throw const FormatException('Invalid appointment day-status response.');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<NotificationsModel>> getMyNotifications({
    String lang = 'en',
  }) async {
    try {
      final response = await _dio.get(
        '/notifications/me',
        options: Options(headers: {'accept-language': lang}),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => NotificationsModel.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint("❌ خطأ في جلب الإشعارات: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await _dio.patch('/notifications/$notificationId/read');
    } on DioException catch (e) {
      debugPrint("❌ خطأ في تحديث حالة الإشعار: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<int> markAllNotificationsAsRead() async {
    try {
      final response = await _dio.patch('/notifications/read-all');
      return response.data['updatedCount'] ?? 0;
    } on DioException catch (e) {
      debugPrint("❌ خطأ في تحديث جميع الإشعارات: ${e.response?.data}");
      throw Exception(_handleDioError(e));
    }
  }

  Future<DoctorModel?> getDoctorById(int doctorId) async {
    final response = await _dio.get('/doctors/$doctorId');
    debugPrint("🔍 البيانات الخام للطبيب: ${response.data}");
    return DoctorModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getSentReferrals({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        '/referrals/doctor/sent',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getReceivedReferrals({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        '/referrals/doctor/received',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getReferralDetails(int referralId) async {
    try {
      final response = await _dio.get('/referrals/$referralId');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getPatientLiveQueueStatus(
    int appointmentId,
  ) async {
    try {
      final response = await _dio.get(
        '/queues/patient/live-status/$appointmentId',
        options: Options(validateStatus: (status) => status! < 500),
      );
      return response.data is Map<String, dynamic> ? response.data : {};
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>?> getActiveCheckedInAppointment() async {
    try {
      final response = await _dio.get(
        '/queues/patient/active-checked-in',
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ خطأ في جلب الموعد النشط: ${e.response?.data}");
      return null;
    }
  }

  // INSERT INTO queues (appointment_id, clinic_id, doctor_id, position, status, checkin_time, created_at, updated_at)
  // SELECT
  // id AS appointment_id,
  //     clinic_id,
  //     doctor_id,
  // (SELECT COALESCE(MAX(position), 0) + 1 FROM queues WHERE doctor_id = appointments.doctor_id AND CAST(created_at AS DATE) = CURRENT_DATE) AS position,
  // 'in_progress' AS status, -- أو in_progress حسب الحاجة
  // NOW() AS checkin_time,
  // NOW() AS created_at,
  // NOW() AS updated_at
  // FROM appointments
  // WHERE id = 394;
  // INSERT INTO appointments (
  //     patient_id,
  //     doctor_id,
  //     clinic_id,
  //     type,
  //     priority,
  //     status,
  //     requested_date,
  //     start_time,
  //     end_time,
  //     created_at,
  //     updated_at
  //     )
  // VALUES (
  // 2,
  // 129,
  // 10,
  // 'consultation',
  // '1',
  // 'confirmed',
  // CURRENT_DATE,
  // CURRENT_TIME,
  // CURRENT_TIME + INTERVAL '30 minutes',
  // NOW(),
  // NOW()
  // );

  Future<List<dynamic>> getMyViolations() async {
    try {
      final response = await _dio.get('/patient-violations/me');
      if (response.statusCode == 200) {
        return response.data is List
            ? response.data
            : (response.data['data'] ?? []);
      }
      return [];
    } catch (e) {
      debugPrint("❌ خطأ في جلب المخالفات: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> createRating(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/ratings', data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> updateRating(
    int ratingId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/ratings/$ratingId', data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteRating(int ratingId) async {
    try {
      await _dio.delete('/ratings/$ratingId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> reportRating(
    int ratingId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post('/ratings/$ratingId/report', data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getDoctorRatings(
    int doctorId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/ratings/doctor/$doctorId',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getPatientOwnRatings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/ratings/my-reviews',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> adminGetAllRatings({
    String? status,
    int? score,
    int? doctorId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/ratings/admin/all',
        queryParameters: {
          if (status != null) 'status': status,
          if (score != null) 'score': score,
          if (doctorId != null) 'doctorId': doctorId,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> adminUpdateRatingStatus(
    int ratingId,
    String status,
  ) async {
    try {
      final response = await _dio.patch(
        '/ratings/admin/$ratingId/status',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> adminGetAllReports({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/ratings/admin/reports',
        queryParameters: {
          if (status != null) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>?> getMedicalProfileDetails() async {
    try {
      final response = await _dio.get('/medical-profiles/me');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> getMedicalProfileCompletionStatus() async {
    try {
      final response = await _dio.get('/medical-profiles/completion');
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<double> getProfileCompletionPercentage() async {
    try {
      final response = await _dio.get('/medical-profiles/completion');
      if (response.data != null &&
          response.data['completionPercentage'] != null) {
        double percentage = (response.data['completionPercentage'] as num)
            .toDouble();
        return percentage > 1.0 ? percentage / 100.0 : percentage;
      }
      return 0.0;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMedicalHistories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/medical-histories/me',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.data != null) {
        return response.data is List
            ? response.data
            : response.data['data'] ?? [];
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(_handleDioError(e));
    }
  }

  Future<dynamic> getMedicalAttachments() async {
    try {
      final response = await _dio.get('/medical-attachments/me');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<int>> getMyAttachmentFile(int attachmentId) async {
    try {
      final response = await _dio.get<List<int>>(
        '/medical-attachments/me/$attachmentId',
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Attachment could not be loaded.');
      }
      return bytes;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deleteMedicalAttachment(int id) async {
    try {
      await _dio.delete('/medical-attachments/$id');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> uploadMedicalAttachment(String filePath, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "files": [await MultipartFile.fromFile(filePath, filename: fileName)],
      });

      await _dio.post('/medical-attachments/profile/me', data: formData);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMyMedicines() async {
    try {
      final response = await _dio.get('/prescribed-medicines/me');
      return response.data is List
          ? response.data
          : (response.data['data'] ?? []);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createMyProfileMedicine(Map<String, dynamic> data) async {
    try {
      await _dio.post('/prescribed-medicines/my-profile', data: data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateMedicineStatus(int medicineId, String status) async {
    try {
      await _dio.patch(
        '/prescribed-medicines/$medicineId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> createMedicalProfileMe(Map<String, dynamic> data) async {
    try {
      await _dio.post('/medical-profiles', data: data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> updateMedicalProfileMe(Map<String, dynamic> data) async {
    try {
      await _dio.patch('/medical-profiles/me', data: data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> getMedicalProfileLogs() async {
    try {
      final response = await _dio.get('/medical-profiles/logs/me');
      return response.data is List
          ? response.data
          : (response.data['data'] ?? []);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception(_handleDioError(e));
    }
  }

  Future<Map<String, dynamic>> adminResolveReport(
    int reportId,
    String action,
  ) async {
    try {
      final response = await _dio.patch(
        '/ratings/admin/reports/$reportId/resolve',
        data: {'action': action},
      );
      return response.data;
    } on DioException catch (e) {
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

  Future<String?> uploadAvatar(String filePath) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.patch('/users/me/avatar', data: formData);

      // إرجاع رابط الصورة القادم من السيرفر
      if (response.data is Map) {
        return response.data['avatarUrl'] ?? response.data['avatar'];
      }
      return null;
    } on DioException catch (e) {
      debugPrint("❌ خطأ في رفع الصورة الشخصية: ${e.response?.data}");
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
    final data = e.response?.data;
    if (data is Map) {
      for (final key in <String>['message', 'error']) {
        final value = data[key];
        if (value is List) {
          final message = value.whereType<Object>().map((item) => item.toString()).where((item) => item.trim().isNotEmpty).join('\n');
          if (message.isNotEmpty) return message;
        } else if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return e.message ?? 'تعذر الاتصال بالسيرفر';
  }
}
