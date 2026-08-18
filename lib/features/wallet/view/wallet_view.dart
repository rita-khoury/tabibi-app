import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/wallet/controller/wallet_controller.dart';
import 'package:tabibi/features/wallet/view/top_up_view.dart';
import 'package:tabibi/features/wallet/widgets/wallet_widgets.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const TopUpView()),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          'Top Up',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          const _WalletHeaderBackground(),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.wallet.value == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                );
              }

              if (controller.wallet.value == null) {
                return _WalletUnavailable(onRetry: controller.fetchWallet);
              }

              final wallet = controller.wallet.value!;
              return RefreshIndicator(
                color: AppColors.primaryBlue,
                onRefresh: controller.fetchWallet,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 108),
                  children: [
                    const SizedBox(height: 74),
                    const _WalletHeaderText(),
                    const SizedBox(height: 24),
                    const TotalBalanceCard(),
                    const SizedBox(height: 18),
                    BalanceStatusCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: AppColors.primaryBlue,
                      iconBgColor: const Color(0xFFE3F2FD),
                      title: 'Available Balance',
                      value: wallet.availableBalance,
                      currency: controller.currency.value,
                    ),
                    const SizedBox(height: 12),
                    BalanceStatusCard(
                      icon: Icons.lock_outline,
                      iconColor: const Color(0xFF7E57C2),
                      iconBgColor: const Color(0xFFEDE7F6),
                      title: 'Frozen Balance',
                      value: wallet.frozenBalance,
                      currency: controller.currency.value,
                    ),
                    const SizedBox(height: 12),
                    const WalletStatusCard(),
                  ],
                ),
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 10),
              child: IconButton(
                tooltip: 'Back',
                onPressed: Get.back,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletHeaderBackground extends StatelessWidget {
  const _WalletHeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 286,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
    );
  }
}

class _WalletHeaderText extends StatelessWidget {
  const _WalletHeaderText();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your wallet overview',
            style: TextStyle(
              color: Color(0xE6FFFFFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletUnavailable extends StatelessWidget {
  const _WalletUnavailable({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(28, 96, 28, 48),
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
            size: 52,
          ),
          const SizedBox(height: 18),
          const Text(
            'Wallet unavailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 14),
          ),
          const SizedBox(height: 22),
          Center(
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                backgroundColor: Colors.white,
                side: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
