import 'package:dio/dio.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';

enum PatientQueueFailureKind {
  unauthorized,
  forbidden,
  network,
  server,
  invalidResponse,
  unknown,
}

class PatientQueueRepositoryException implements Exception {
  const PatientQueueRepositoryException({required this.kind, this.statusCode});

  final PatientQueueFailureKind kind;
  final int? statusCode;

  factory PatientQueueRepositoryException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return const PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.unauthorized,
        statusCode: 401,
      );
    }
    if (statusCode == 403) {
      return const PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.forbidden,
        statusCode: 403,
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.server,
        statusCode: statusCode,
      );
    }
    if (_isNetworkError(error.type)) {
      return const PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.network,
      );
    }
    return PatientQueueRepositoryException(
      kind: PatientQueueFailureKind.unknown,
      statusCode: statusCode,
    );
  }

  static bool _isNetworkError(DioExceptionType type) {
    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };
  }
}

class PatientQueueRepository {
  PatientQueueRepository(AuthRepository authRepository, {Dio? client})
    : _client = client ?? authRepository.dio;

  final Dio _client;

  Future<PatientQueueModel?> getPatientActiveQueue() async {
    try {
      final response = await _client.get('/queues/patient/my-active-queue');
      return _parseQueueResponse(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw PatientQueueRepositoryException.fromDio(error);
    }
  }

  Future<PatientQueueModel?> getPatientLiveStatus(int appointmentId) async {
    try {
      final response = await _client.get(
        '/queues/patient/live-status/$appointmentId',
      );
      return _parseQueueResponse(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw PatientQueueRepositoryException.fromDio(error);
    }
  }

  PatientQueueModel _parseQueueResponse(dynamic data) {
    if (data is! Map) {
      throw const PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.invalidResponse,
      );
    }
    try {
      return PatientQueueModel.fromJson(Map<String, dynamic>.from(data));
    } on FormatException {
      throw const PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.invalidResponse,
      );
    }
  }
}
