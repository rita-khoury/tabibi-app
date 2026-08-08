import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';

import '../card/rating_card.dart';
import '../controller/doctor_ratings_controller.dart';

class DoctorRatingsView extends GetView<DoctorRatingsController> {
  const DoctorRatingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Doctor Ratings",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.ratingsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.ratingsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border_rounded,
                  size: 64,
                  color: AppColors.gray.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No ratings for this doctor yet.",
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.ratingsList.length + (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.ratingsList.length) {
                if (!controller.isMoreLoading.value) {
                  controller.fetchDoctorRatings();
                }
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                );
              }

              final rating = controller.ratingsList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: RatingCard(
                  rating: rating,
                  onReportPressed: () => _showReportDialog(context, rating.id),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showReportDialog(BuildContext context, int ratingId) {
    String selectedReason = 'spam';
    final explanationController = TextEditingController();

    Get.defaultDialog(
      title: "Report Rating",
      titleStyle: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      backgroundColor: Colors.white,
      radius: 16,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedReason,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 8,
              decoration: InputDecoration(
                labelText: 'Reason',
                labelStyle: const TextStyle(color: AppColors.gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'spam', child: Text('Spam')),
                DropdownMenuItem(
                  value: 'inappropriate',
                  child: Text('Inappropriate'),
                ),
                DropdownMenuItem(value: 'abusive', child: Text('Abusive')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (val) {
                if (val != null) selectedReason = val;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: explanationController,
              decoration: InputDecoration(
                labelText: 'Details (Optional)',
                labelStyle: const TextStyle(color: AppColors.gray),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      textConfirm: "Submit Report",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryBlue,
      onConfirm: () {
        Get.back();
        controller.reportRating(
          ratingId,
          selectedReason,
          explanationController.text,
        );
      },
      textCancel: "Cancel",
      cancelTextColor: AppColors.gray,
    );
  }
}
