import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.cardLast4,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final String status;
  final String paymentMethod;
  final String cardLast4;
  final DateTime? createdAt;

  String get displayStatus {
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

  String get displayPaymentDetails {
    final method = paymentMethod.trim().isEmpty
        ? (cardLast4.trim().isEmpty ? 'Not specified' : 'Card')
        : paymentMethod
              .toLowerCase()
              .split(RegExp(r'[_\s-]+'))
              .where((part) => part.isNotEmpty)
              .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
              .join(' ');
    if (cardLast4.trim().isEmpty) {
      return method;
    }
    return '$method • **** $cardLast4';
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json['id']?.toString() ?? '',
      amount: _asDouble(json['amount']) ?? 0,
      status: json['status']?.toString() ?? '',
      paymentMethod:
          json['paymentMethod']?.toString() ??
          json['payment_method']?.toString() ??
          '',
      cardLast4:
          json['cardLast4']?.toString() ?? json['card_last4']?.toString() ?? '',
      createdAt: _asDateTime(json['created_at'] ?? json['createdAt']),
    );
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

class TransactionsController extends GetxController {
  TransactionsController({AuthRepository? authRepository})
    : _authRepository = authRepository ?? Get.find<AuthRepository>();

  static const int pageLimit = 10;

  final AuthRepository _authRepository;
  final transactions = <TransactionRecord>[].obs;
  final page = 1.obs;
  final limit = pageLimit.obs;
  final hasMore = true.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final loadMoreError = RxnString();
  final scrollController = ScrollController();

  Dio get _dio => _authRepository.dio;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    fetchTransactions(isRefresh: true);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.onClose();
  }

  Future<void> fetchTransactions({bool isRefresh = false}) async {
    if (isLoading.value || isLoadingMore.value) {
      return;
    }

    final isFirstPage = isRefresh || transactions.isEmpty;
    final requestedPage = isFirstPage ? 1 : page.value + 1;
    if (!isFirstPage && !hasMore.value) {
      return;
    }

    if (isFirstPage) {
      isLoading.value = true;
      errorMessage.value = null;
    } else {
      isLoadingMore.value = true;
      loadMoreError.value = null;
    }

    try {
      final response = await _dio.get(
        '/transactions/me',
        queryParameters: {'page': requestedPage, 'limit': limit.value},
      );
      final envelope = _TransactionEnvelope.fromJson(
        response.data,
        fallbackPage: requestedPage,
        fallbackLimit: limit.value,
      );

      if (isFirstPage) {
        transactions.assignAll(envelope.items);
      } else {
        transactions.addAll(envelope.items);
      }

      page.value = envelope.page;
      limit.value = envelope.limit;
      hasMore.value = envelope.hasMore(loadedCount: transactions.length);
    } on DioException catch (error) {
      if (isFirstPage) {
        errorMessage.value = _messageFromDio(error);
      } else {
        loadMoreError.value = _messageFromDio(error);
      }
    } catch (_) {
      const message = 'Unable to load transactions. Please try again.';
      if (isFirstPage) {
        errorMessage.value = message;
      } else {
        loadMoreError.value = message;
      }
    } finally {
      if (isFirstPage) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || !hasMore.value) {
      return;
    }
    if (scrollController.position.extentAfter < 240) {
      fetchTransactions();
    }
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
    return 'Unable to load transactions. Please try again.';
  }
}

class _TransactionEnvelope {
  const _TransactionEnvelope({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.lastPage,
  });

  final List<TransactionRecord> items;
  final int? total;
  final int page;
  final int limit;
  final int? lastPage;

  bool hasMore({required int loadedCount}) {
    if (lastPage != null) {
      return page < lastPage!;
    }
    if (total != null) {
      return loadedCount < total!;
    }
    return items.length >= limit;
  }

  factory _TransactionEnvelope.fromJson(
    dynamic body, {
    required int fallbackPage,
    required int fallbackLimit,
  }) {
    final map = body is Map
        ? Map<String, dynamic>.from(body)
        : const <String, dynamic>{};
    final rawItems = body is List ? body : map['data'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) =>
                    TransactionRecord.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(growable: false)
        : const <TransactionRecord>[];

    return _TransactionEnvelope(
      items: items,
      total: _asInt(map['total']),
      page: _asInt(map['page']) ?? fallbackPage,
      limit: _asInt(map['limit']) ?? fallbackLimit,
      lastPage: _asInt(map['lastPage'] ?? map['last_page']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }
}
