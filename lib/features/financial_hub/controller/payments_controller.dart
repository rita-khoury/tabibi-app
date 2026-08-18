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
    required this.clinicName,
  });

  final String id;
  final double amount;
  final double? netPaidAmount;
  final String paymentMethod;
  final String status;
  final String humanReadableStatus;
  final String appointmentType;
  final DateTime? paidAt;
  final String doctorName;
  final String clinicName;

  double get displayAmount => netPaidAmount ?? amount;

  String get displayStatus {
    if (humanReadableStatus.trim().isNotEmpty) {
      return humanReadableStatus.trim();
    }
    if (status.trim().isEmpty) {
      return 'Unknown';
    }
    return status
        .toLowerCase()
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String get displayMethod {
    if (paymentMethod.trim().isEmpty) {
      return 'Not specified';
    }
    return paymentMethod
        .toLowerCase()
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    final appointment = _map(json['appointment']);
    final doctor = _map(appointment['doctor']);
    final doctorUser = _map(doctor['user']);
    final clinic = _map(appointment['clinic']);

    return PaymentRecord(
      id: json['id']?.toString() ?? '',
      amount: _asDouble(json['amount']) ?? 0,
      netPaidAmount: _asDouble(
        json.containsKey('net_paid_amount')
            ? json['net_paid_amount']
            : json['netPaidAmount'],
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
          '',
      paidAt: _asDateTime(
        json['paidAt'] ?? json['created_at'] ?? json['createdAt'],
      ),
      doctorName: doctorUser['fullName']?.toString() ?? '',
      clinicName: clinic['name']?.toString() ?? '',
    );
  }

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const {};
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

  Dio get _dio => _authRepository.dio;

  final payments = <PaymentRecord>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

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
        data
            .whereType<Map>()
            .map(
              (item) => PaymentRecord.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList(growable: false),
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
