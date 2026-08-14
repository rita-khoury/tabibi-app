import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';

import '../card/rating_card.dart';
import '../controller/doctor_ratings_controller.dart';

class DoctorRatingsView extends GetView<DoctorRatingsController> {
  final int? appointmentId;

  const DoctorRatingsView({Key? key, this.appointmentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان هناك معرف موعد صالح (إما من الـ constructor أو Get.arguments)
    final int? currentAppointmentId = appointmentId ??
        (Get.arguments is int ? Get.arguments : null);

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
                  color: AppColors.gray.withValues(alpha: 0.5),
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
      // يظهر زر إضافة التقييم حصرياً إذا كان هناك موعد مكتمل مرتبط (appointmentId)
      floatingActionButton: currentAppointmentId != null
          ? FloatingActionButton.extended(
        onPressed: () => _showAddRatingDialog(context, currentAppointmentId),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.rate_review_rounded, color: Colors.white),
        label: const Text(
          "Add Rating",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      )
          : null,
    );
  }

  void _showAddRatingDialog(BuildContext context, int validAppointmentId) {
    controller.scoreController.value = 5.0;
    controller.commentController.clear();

    Get.defaultDialog(
      title: "Add Your Rating",
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
            const Text(
              "How was your experience with the doctor?",
              style: TextStyle(color: AppColors.gray, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      controller.scoreController.value = (index + 1).toDouble();
                    },
                    icon: Icon(
                      index < controller.scoreController.value
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.commentController,
              decoration: InputDecoration(
                labelText: 'Write your comment...',
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
              maxLines: 3,
            ),
          ],
        ),
      ),
      textConfirm: "Submit",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryBlue,
      onConfirm: () async {
        Get.back();
        await controller.createRating(validAppointmentId);
      },
      textCancel: "Cancel",
      cancelTextColor: AppColors.gray,
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