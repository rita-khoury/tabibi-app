import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';

import '../controller/doctor_reminders_controller.dart';
import '../model/referral_model.dart';

class DoctorRemindersView extends GetView<DoctorRemindersController> {
  const DoctorRemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text(
          'Referrals and Reminders',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryBlue),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.remindersList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        if (controller.remindersList.isEmpty) {
          return const _EmptyReferralsState();
        }
        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: controller.fetchReferrals,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.remindersList.length,
            itemBuilder: (context, index) {
              final referral = controller.remindersList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReferralCard(
                  referral: referral,
                  onTap: () => controller.openReferral(referral),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _ReferralCard extends StatelessWidget {
  const _ReferralCard({required this.referral, required this.onTap});

  final ReferralModel referral;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final actionable = referral.isActionable;
    final statusColor = referral.isExpired
        ? Colors.red
        : referral.status == 'COMPLETED'
            ? Colors.green
            : Colors.orange;

    return Opacity(
      opacity: actionable ? 1 : 0.58,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: actionable ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          splashColor: actionable
              ? AppColors.primaryBlue.withValues(alpha: 0.08)
              : Colors.transparent,
          highlightColor: actionable
              ? AppColors.primaryBlue.withValues(alpha: 0.04)
              : Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: actionable
                    ? AppColors.primaryBlue.withValues(alpha: 0.16)
                    : Colors.grey.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: AppColors.primaryBlue,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              referral.destinationName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusBadge(
                            label: referral.displayStatus,
                            color: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        referral.type == 'FOLLOW_UP'
                            ? 'Follow-up referral'
                            : 'External referral',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_rounded,
                              size: 16, color: AppColors.gray),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Reason: ${referral.reason}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (actionable) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Text(
                              'Book with this referral',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 15, color: AppColors.primaryBlue),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyReferralsState extends StatelessWidget {
  const _EmptyReferralsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_rounded,
              size: 45,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No referrals or reminders found.',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
