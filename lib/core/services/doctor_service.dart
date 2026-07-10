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


  Future<List<dynamic>> search(String query) async {
    final response = await _dio.get('/doctor-profiles/search', queryParameters: {'q': query});
    return response.data;
  }
}