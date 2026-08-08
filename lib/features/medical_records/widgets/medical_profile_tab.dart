import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';

class MedicalProfileTab extends StatelessWidget {
  final MedicalRecordController controller = Get.find();

  MedicalProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isProfileLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Medical Profile Completion",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray,
                        ),
                      ),
                      Text(
                        "${(controller.completionRate.value * 100).toInt()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: controller.completionRate.value,
                    backgroundColor: AppColors.lightBlue.withOpacity(0.3),
                    color: AppColors.primaryBlue,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileTile(
                    Icons.bloodtype,
                    "Blood Type",
                    controller.bloodType.value,
                  ),
                  const Divider(height: 1, color: AppColors.lightGray),
                  _buildProfileTile(
                    Icons.healing,
                    "Chronic Diseases",
                    controller.chronicDiseases.value,
                  ),
                  const Divider(height: 1, color: AppColors.lightGray),
                  _buildProfileTile(
                    Icons.warning_amber_rounded,
                    "Allergies",
                    controller.allergies.value,
                  ),
                  const Divider(height: 1, color: AppColors.lightGray),
                  _buildProfileTile(
                    Icons.biotech,
                    "Surgeries",
                    controller.surgeries.value,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: AppColors.gray),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
