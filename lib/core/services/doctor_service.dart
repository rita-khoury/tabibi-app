import 'package:dio/dio.dart';

import '../constance/api_constants.dart';

class DoctorService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<dynamic>> getAll({
    String? search,
    String? specialization,
    String? language,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (specialization != null && specialization.isNotEmpty) {
        queryParameters['specialization'] = specialization;
      }
      if (language != null && language.isNotEmpty) {
        queryParameters['language'] = language;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParameters['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParameters['sortOrder'] = sortOrder;
      }

      final response = await _dio.get(
        '/doctors',
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  Future<Map<String, dynamic>> getDoctorById(int doctorId) async {
    try {
      final response = await _dio.get('/doctor-profiles/$doctorId');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load doctor details');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> search(String query) {
    return getAll(search: query);
  }
}
