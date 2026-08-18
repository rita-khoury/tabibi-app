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
    String selectedReason = 'spam';

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
                initialValue: selectedReason,
                decoration: const InputDecoration(labelText: 'Reason'),
                items: const [
                  DropdownMenuItem(value: 'spam', child: Text('Spam')),
                  DropdownMenuItem(
                    value: 'abuse',
                    child: Text('Abusive content'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedReason = value);
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
        Get.back();
        controller.reportRating(
          ratingId,
          selectedReason,
          explanation.isEmpty ? null : explanation,
        );
      },
      textCancel: 'Cancel',
      cancelTextColor: AppColors.gray,
    );
  }
}
