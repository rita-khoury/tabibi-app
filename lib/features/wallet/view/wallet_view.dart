import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/wallet/controller/wallet_controller.dart';
import 'package:tabibi/features/wallet/view/top_up_view.dart';
import 'package:tabibi/features/wallet/widgets/wallet_widgets.dart';
import 'package:tabibi/features/notifications/view/notification_view.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const TopUpView()),
        label: const Text(
          "Top Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.wallet.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.wallet.value == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 70,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "No wallet data available",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1565C0),
                        ),
                        onPressed: () => controller.fetchWallet(),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry Connection"),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => await controller.fetchWallet(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Wallet",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Your wallet overview",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () =>
                                Get.to(() => const NotificationView()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const TotalBalanceCard(),
                      const SizedBox(height: 20),
                      BalanceStatusCard(
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xFF1E88E5),
                        iconBgColor: const Color(0xFFE3F2FD),
                        title: "Available Balance",
                        value: controller.wallet.value!.availableBalance,
                        currency: controller.currency.value,
                      ),
                      const SizedBox(height: 16),
                      BalanceStatusCard(
                        icon: Icons.lock_outline,
                        iconColor: const Color(0xFF673AB7),
                        iconBgColor: const Color(0xFFEDE7F6),
                        title: "Frozen Balance",
                        value: controller.wallet.value!.frozenBalance,
                        currency: controller.currency.value,
                      ),
                      const SizedBox(height: 16),
                      const WalletStatusCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 55,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Get.back(),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
