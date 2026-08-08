// import 'package:dio/dio.dart';
//
// class DoctorService {
//   final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
//
//
//   Future<List<dynamic>> getAll() async {
//     try {
//       final response = await _dio.get('/doctors');
//       return response.data;
//     } catch (e) {
//       throw Exception('Failed to load doctors: $e');
//     }
//   }
//
//
//   Future<List<dynamic>> search(String query) async {
//     final response = await _dio.get('/doctor-profiles/search', queryParameters: {'q': query});
//     return response.data;
//   }
// }

import 'package:dio/dio.dart';

class DoctorService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<dynamic>> getAll() async {
    try {
      final response = await _dio.get('/doctors');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  Future<List<dynamic>> getSpecialities() async {
    try {
      final response = await _dio.get('/specialities');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load specialities');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getDoctorById(int doctorId) async {
    try {
      final response = await _dio.get('/doctor-profiles/$doctorId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load doctor details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> search(String query) async {
    final response = await _dio.get(
      '/doctor-profiles/search',
      queryParameters: {'q': query},
    );
    return response.data;
  }
}
