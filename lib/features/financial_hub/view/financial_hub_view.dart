import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/routes/app_routes.dart';

class FinancialHubView extends StatelessWidget {
  const FinancialHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text(
          'Financial Hub',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          const Text(
            'Manage your payments, wallet balance, and transactions',
            style: TextStyle(color: AppColors.gray, fontSize: 14, height: 1.45),
          ),
          const SizedBox(height: 22),
          _FinancialHubCard(
            icon: Icons.payments_outlined,
            iconColor: const Color(0xFF1565C0),
            iconBackground: const Color(0xFFE3F2FD),
            title: 'Payments',
            subtitle: 'View your appointment & operation payment history',
            onTap: () => Get.toNamed(AppRoutes.payments),
          ),
          const SizedBox(height: 14),
          _FinancialHubCard(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF2E7D32),
            iconBackground: const Color(0xFFE8F5E9),
            title: 'Wallet',
            subtitle: 'Manage your balance, top-ups, and wallet status',
            onTap: () => Get.toNamed(AppRoutes.wallet),
          ),
          const SizedBox(height: 14),
          _FinancialHubCard(
            icon: Icons.receipt_long_outlined,
            iconColor: const Color(0xFF6A1B9A),
            iconBackground: const Color(0xFFF3E5F5),
            title: 'Transactions',
            subtitle: 'View your wallet deposits and top-up logs',
            onTap: () => Get.toNamed(AppRoutes.transactions),
          ),
        ],
      ),
    );
  }
}

class _FinancialHubCard extends StatelessWidget {
  const _FinancialHubCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D0F172A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.gray,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.gray,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
