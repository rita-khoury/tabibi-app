import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/financial_hub/controller/transactions_controller.dart';

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.transactions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.errorMessage.value != null &&
            controller.transactions.isEmpty) {
          return _TransactionStateView(
            icon: Icons.cloud_off_outlined,
            title: 'Unable to load transactions',
            message: controller.errorMessage.value!,
            actionLabel: 'Try again',
            onAction: () => controller.fetchTransactions(isRefresh: true),
          );
        }

        if (controller.transactions.isEmpty) {
          return _TransactionStateView(
            icon: Icons.receipt_long_outlined,
            title: 'No transactions yet',
            message: 'Your wallet deposits and top-up logs will appear here.',
            actionLabel: 'Refresh',
            onAction: () => controller.fetchTransactions(isRefresh: true),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: () => controller.fetchTransactions(isRefresh: true),
          child: ListView.separated(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            itemCount: controller.transactions.length + 2,
            separatorBuilder: (_, index) =>
                SizedBox(height: index == 0 ? 18 : 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _PageHeader();
              }
              if (index == controller.transactions.length + 1) {
                return _PaginationFooter(controller: controller);
              }
              return _TransactionCard(
                transaction: controller.transactions[index - 1],
              );
            },
          ),
        );
      }),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'View your wallet deposits and top-up logs',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Pull down to refresh your transaction history.',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final TransactionRecord transaction;

  @override
  Widget build(BuildContext context) {
    final appearance = _StatusAppearance.fromStatus(transaction.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: appearance.iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: appearance.foreground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.displayPaymentDetails,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(
                      label: transaction.displayStatus,
                      appearance: appearance,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  'EGP ${transaction.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 17,
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

  String _formatDate(DateTime? value) {
    if (value == null) {
      return 'Date not available';
    }
    return DateFormat('dd MMM yyyy • h:mm a').format(value);
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.controller});

  final TransactionsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoadingMore.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      );
    }

    if (controller.loadMoreError.value != null) {
      return Center(
        child: TextButton.icon(
          onPressed: controller.fetchTransactions,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry loading more'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
        ),
      );
    }

    if (!controller.hasMore.value) {
      return const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Center(
          child: Text(
            'You are up to date',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ),
      );
    }

    return const SizedBox(height: 12);
  }
}

class _TransactionStateView extends StatelessWidget {
  const _TransactionStateView({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final Future<void> Function() onAction;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlue,
      onRefresh: onAction,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
          Icon(icon, size: 58, color: AppColors.primaryBlue),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: OutlinedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.appearance});

  final String label;
  final _StatusAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: appearance.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: appearance.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusAppearance {
  const _StatusAppearance({
    required this.background,
    required this.foreground,
    required this.iconBackground,
  });

  final Color background;
  final Color foreground;
  final Color iconBackground;

  factory _StatusAppearance.fromStatus(String status) {
    switch (status.trim().toUpperCase()) {
      case 'SUCCESS':
      case 'COMPLETED':
      case 'PAID':
        return const _StatusAppearance(
          background: Color(0xFFE8F5E9),
          foreground: Color(0xFF2E7D32),
          iconBackground: Color(0xFFE8F5E9),
        );
      case 'PENDING':
      case 'HELD':
      case 'PROCESSING':
        return const _StatusAppearance(
          background: Color(0xFFFFF8E1),
          foreground: Color(0xFFF57F17),
          iconBackground: Color(0xFFFFF8E1),
        );
      case 'FAILED':
      case 'CANCELLED':
      case 'REJECTED':
        return const _StatusAppearance(
          background: Color(0xFFFFEBEE),
          foreground: Color(0xFFC62828),
          iconBackground: Color(0xFFFFEBEE),
        );
      default:
        return const _StatusAppearance(
          background: Color(0xFFE3F2FD),
          foreground: Color(0xFF1565C0),
          iconBackground: Color(0xFFE3F2FD),
        );
    }
  }
}
