import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/wallet/controller/wallet_controller.dart';

class TotalBalanceCard extends GetView<WalletController> {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final wallet = controller.wallet.value;
      final isVisible = controller.isBalanceVisible.value;
      final total = wallet?.totalBalance ?? 0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x401E88E5),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Material(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: isVisible ? 'Hide balance' : 'Show balance',
                    onPressed: controller.toggleBalanceVisibility,
                    icon: Icon(
                      isVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              isVisible ? total.toStringAsFixed(2) : '••••••',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'EGP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class BalanceStatusCard extends StatelessWidget {
  const BalanceStatusCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.currency,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final double value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return _WalletSurfaceCard(
      child: Row(
        children: [
          _LeadingIcon(
            icon: icon,
            iconColor: iconColor,
            backgroundColor: iconBgColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${value.toStringAsFixed(2)} $currency',
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletStatusCard extends GetView<WalletController> {
  const WalletStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.wallet.value?.status.trim().isEmpty ?? true
          ? 'ACTIVE'
          : controller.wallet.value!.status;
      final appearance = _StatusAppearance.fromStatus(status);

      return _WalletSurfaceCard(
        child: Row(
          children: [
            _LeadingIcon(
              icon: Icons.shield_outlined,
              iconColor: appearance.foreground,
              backgroundColor: appearance.background,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Wallet Status',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: appearance.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _displayStatus(status),
                style: TextStyle(
                  color: appearance.foreground,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  static String _displayStatus(String value) {
    return value
        .toLowerCase()
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

class _WalletSurfaceCard extends StatelessWidget {
  const _WalletSurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EDF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 23),
    );
  }
}

class _StatusAppearance {
  const _StatusAppearance({required this.background, required this.foreground});

  final Color background;
  final Color foreground;

  factory _StatusAppearance.fromStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
      case 'VERIFIED':
        return const _StatusAppearance(
          background: Color(0xFFE8F5E9),
          foreground: Color(0xFF2E7D32),
        );
      case 'FROZEN':
      case 'SUSPENDED':
        return const _StatusAppearance(
          background: Color(0xFFFFEBEE),
          foreground: Color(0xFFC62828),
        );
      default:
        return const _StatusAppearance(
          background: Color(0xFFFFF8E1),
          foreground: Color(0xFFF57F17),
        );
    }
  }
}
