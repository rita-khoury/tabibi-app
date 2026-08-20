import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/doctor_profile/card/rating_card.dart';
import 'package:tabibi/features/doctor_profile/controller/doctor_ratings_controller.dart';

class DoctorRatingsView extends GetView<DoctorRatingsController> {
  const DoctorRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text(
          'Doctor Ratings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: Obx(() {
        final currentUserId =
            int.tryParse(
              authController?.currentUser.value?.id.toString() ?? '',
            ) ??
            0;
        if (controller.isLoading.value && controller.ratingsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.ratingsList.isEmpty) {
          return RefreshIndicator(
            color: AppColors.primaryBlue,
            onRefresh: () => controller.fetchDoctorRatings(isRefresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 360,
                  child: Center(
                    child: Text(
                      'No ratings yet',
                      style: TextStyle(color: AppColors.gray, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: () => controller.fetchDoctorRatings(isRefresh: true),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.ratingsList.length + (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.ratingsList.length) {
                if (!controller.isMoreLoading.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.fetchDoctorRatings();
                  });
                }
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final rating = controller.ratingsList[index];
              final isOwner =
                  currentUserId > 0 && rating.authorUserId == currentUserId;
              final isReportedByMe =
                  rating.isReportedByMe ||
                  controller.isRatingReported(rating.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: RatingCard(
                  rating: rating,
                  onDeletePressed: isOwner
                      ? () => _confirmDelete(rating.id)
                      : null,
                  showReportAction: !isOwner,
                  isReportDisabled: !isOwner && isReportedByMe,
                  onReportPressed: !isOwner && !isReportedByMe
                      ? () => _showReportDialog(context, rating.id)
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmDelete(int ratingId) {
    Get.defaultDialog(
      title: 'Delete Rating',
      titleStyle: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w800,
      ),
      middleText: 'Are you sure you want to delete this rating?',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteRating(ratingId);
      },
      textCancel: 'Cancel',
      cancelTextColor: AppColors.gray,
    );
  }

  void _showReportDialog(BuildContext context, int ratingId) {
    final explanationController = TextEditingController();
    const reasonValues = <String, String>{
      'Spam': 'spam',
      'Abusive content': 'abusive',
      'Inappropriate content': 'inappropriate',
      'Other': 'other',
    };
    String selectedReasonLabel = 'Spam';

    Get.defaultDialog(
      title: 'Report Rating',
      titleStyle: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w800,
      ),
      content: StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedReasonLabel,
                decoration: const InputDecoration(labelText: 'Reason'),
                items: reasonValues.keys
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedReasonLabel = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: explanationController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Details (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      textConfirm: 'Report',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryBlue,
      onConfirm: () {
        final explanation = explanationController.text.trim();
        _showReportConfirmation(
          ratingId: ratingId,
          reason: reasonValues[selectedReasonLabel]!,
          explanation: explanation.isEmpty ? null : explanation,
        );
      },
      textCancel: 'Cancel',
      cancelTextColor: AppColors.gray,
    );
  }

  void _showReportConfirmation({
    required int ratingId,
    required String reason,
    required String? explanation,
  }) {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Confirm Report'),
        content: const Text('Are you sure you want to report this rating?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final result = await controller.reportRating(
                ratingId,
                reason,
                explanation,
              );
              Get.back();
              Get.back();
              switch (result) {
                case ReportRatingResult.success:
                  Get.snackbar(
                    'Thank you!',
                    'Thank you for helping us improve our platform experience!',
                    backgroundColor: AppColors.primaryBlue,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  break;
                case ReportRatingResult.duplicate:
                  Get.snackbar(
                    'Report unavailable',
                    'You have already reported this rating, or it has already been reviewed by the admin.',
                    backgroundColor: const Color(0xFF17A2B8),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  break;
                case ReportRatingResult.failure:
                  Get.snackbar(
                    'Unable to report rating',
                    'Unable to submit this report right now. Please try again later.',
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  break;
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
