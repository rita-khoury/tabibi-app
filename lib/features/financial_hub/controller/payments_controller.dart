import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.amount,
    required this.netPaidAmount,
    required this.paymentMethod,
    required this.status,
    required this.humanReadableStatus,
    required this.appointmentType,
    required this.paidAt,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.clinicName,
    required this.appointmentAt,
    required this.appointmentStatus,
    this.refundAmount,
    this.penaltyAmount,
    this.failureReason,
    this.doctorId,
    this.appointmentId,
  });

  final String id;
  final double amount;
  final double? netPaidAmount;
  final double? refundAmount;
  final double? penaltyAmount;
  final String? failureReason;
  final String? doctorId;
  final String? appointmentId;
  final String paymentMethod;
  final String status;
  final String humanReadableStatus;
  final String appointmentType;
  final DateTime? paidAt;
  final String doctorName;
  final String doctorSpecialty;
  final String clinicName;
  final DateTime? appointmentAt;
  final String appointmentStatus;

  double get displayAmount => netPaidAmount ?? amount;

  String get displayStatus {
    if (humanReadableStatus.trim().isNotEmpty) {
      return humanReadableStatus.trim();
    }
    return _humanize(status, fallback: 'Unknown');
  }

  String get displayMethod =>
      _humanize(paymentMethod, fallback: 'Not specified');

  String get displayAppointmentStatus =>
      _humanize(appointmentStatus, fallback: displayStatus);

  bool get hasPenalty => penaltyAmount != null && penaltyAmount! > 0;

  bool get hasFailureReason =>
      failureReason != null && failureReason!.trim().isNotEmpty;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    final appointment = _map(json['appointment']);
    final appointmentDoctor = _map(appointment['doctor']);
    final rootDoctor = _map(json['doctor']);
    final doctor = appointmentDoctor.isNotEmpty
        ? appointmentDoctor
        : rootDoctor;
    final doctorUser = _map(doctor['user']);
    final clinic = _map(appointment['clinic']);

    return PaymentRecord(
      id: json['id']?.toString() ?? '',
      amount: _asDouble(json['amount']) ?? 0,
      netPaidAmount: _asDouble(
        json['net_paid_amount'] ?? json['netPaidAmount'],
      ),
      refundAmount: _asDouble(json['refund_amount'] ?? json['refundAmount']),
      penaltyAmount: _asDouble(json['penalty_amount'] ?? json['penaltyAmount']),
      failureReason: _asOptionalString(
        json['failure_reason'] ?? json['failureReason'] ?? json['reason'],
      ),
      doctorId: _asOptionalString(
        doctor['id'] ?? doctor['_id'] ?? json['doctorId'],
      ),
      appointmentId: _asOptionalString(
        appointment['id'] ?? appointment['_id'] ?? json['appointmentId'],
      ),
      paymentMethod:
          json['paymentMethod']?.toString() ??
          json['payment_method']?.toString() ??
          '',
      status: json['status']?.toString() ?? '',
      humanReadableStatus:
          json['human_readable_status']?.toString() ??
          json['humanReadableStatus']?.toString() ??
          '',
      appointmentType:
          json['appointmentType']?.toString() ??
          json['appointment_type']?.toString() ??
          appointment['type']?.toString() ??
          '',
      paidAt: _asDateTime(
        json['paidAt'] ?? json['created_at'] ?? json['createdAt'],
      ),
      doctorName:
          doctorUser['fullName']?.toString() ??
          doctorUser['full_name']?.toString() ??
          doctor['fullName']?.toString() ??
          doctor['name']?.toString() ??
          '',
      doctorSpecialty:
          doctor['specialization']?.toString() ??
          doctor['specialty']?.toString() ??
          doctor['subSpecialization']?.toString() ??
          '',
      clinicName: clinic['name']?.toString() ?? '',
      appointmentAt: _asDateTime(
        appointment['scheduledAt'] ??
            appointment['appointmentDate'] ??
            appointment['date'] ??
            appointment['requestedDate'] ??
            appointment['startAt'] ??
            json['appointmentDate'],
      ),
      appointmentStatus:
          appointment['status']?.toString() ??
          json['appointmentStatus']?.toString() ??
          '',
    );
  }

  static String _humanize(String value, {required String fallback}) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return fallback;
    }
    return normalized
        .toLowerCase()
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const <String, dynamic>{};
  }

  static double? _asDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static String? _asOptionalString(dynamic value) {
    final result = value?.toString().trim();
    return result == null || result.isEmpty ? null : result;
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}

class PaymentsController extends GetxController {
  PaymentsController({AuthRepository? authRepository})
    : _authRepository = authRepository ?? Get.find<AuthRepository>();

  final AuthRepository _authRepository;
  final payments = <PaymentRecord>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  Dio get _dio => _authRepository.dio;

  @override
  void onReady() {
    super.onReady();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final response = await _dio.get('/payments/my');
      final data = _extractList(response.data);
      payments.assignAll(
        data.whereType<Map>().map(
          (item) => PaymentRecord.fromJson(Map<String, dynamic>.from(item)),
        ),
      );
    } on DioException catch (error) {
      errorMessage.value = _messageFromDio(error);
    } catch (_) {
      errorMessage.value = 'Unable to load payment history. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is List) {
      return body;
    }
    if (body is Map) {
      final data = body['data'] ?? body['payments'];
      if (data is List) {
        return data;
      }
    }
    return const [];
  }

  String _messageFromDio(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map) {
      final message = responseData['message'] ?? responseData['error'];
      if (message is List) {
        final formatted = message.whereType<String>().join('\n').trim();
        if (formatted.isNotEmpty) {
          return formatted;
        }
      }
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }
    return 'Unable to load payment history. Please try again.';
  }
}
