import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:tabibi/features/wallet/model/wallet_model.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

class WalletRepositoryException implements Exception {
  final String message;

  WalletRepositoryException(this.message);

  @override
  String toString() => message;
}

class WalletController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  Dio get _dio => _authRepository.dio;

  final wallet = Rxn<WalletModel>();
  final isLoading = false.obs;
  final isTopUpLoading = false.obs;
  final currency = "EGP".obs;
  final isBalanceVisible = true.obs;

  @override
  void onReady() {
    super.onReady();

    fetchWallet();
  }

  Future<void> fetchWallet() async {
    try {
      isLoading.value = true;

      final response = await _dio.get('/wallets/me');

      wallet.value = WalletModel.fromJson(response.data);
      debugPrint("✅ Wallet Data Updated");
    } on DioException catch (e) {
      debugPrint("❌ Wallet Error: ${e.response?.data}");
      Get.snackbar(
        "Error",
        _handleDioError(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> topUpWallet({
    required String cardNumber,
    required String cvv,
    required int amount,
  }) async {
    try {
      isTopUpLoading.value = true;

      final response = await _dio.post(
        '/transactions/top-up',
        data: {"cardNumber": cardNumber, "cvv": cvv, "amount": amount},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Wallet topped up successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchWallet();
        return true;
      }
      return false;
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        _handleDioError(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isTopUpLoading.value = false;
    }
  }

  void toggleBalanceVisibility() =>
      isBalanceVisible.value = !isBalanceVisible.value;

  String _handleDioError(DioException error) {
    if (error.response?.data != null) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return "Connection to server failed";
  }
}
