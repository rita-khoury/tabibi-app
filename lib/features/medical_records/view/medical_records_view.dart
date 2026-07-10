import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/medical_records_controller.dart';

class MedicalRecordsView extends GetView<MedicalRecordsController> {
  const MedicalRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.lightBlue],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.white,
                      ),
                    ),

                    const Expanded(
                      child: Text(
                        "Medical Records",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: controller.uploadRecord,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  icon: const Icon(Icons.upload_file),

                  label: const Text(
                    "Upload File",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(
              () => controller.records.isEmpty
                  ? const Center(
                      child: Text(
                        "No medical records found",
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.records.length,

                      itemBuilder: (context, index) {
                        final record = controller.records[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),

                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),

                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),

                            leading: Container(
                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: AppColors.lightBlue.withValues(
                                  alpha: 0.12,
                                ),

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: const Icon(
                                Icons.picture_as_pdf,
                                color: AppColors.primaryBlue,
                              ),
                            ),

                            title: Text(
                              record.fileName,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),

                              child: Text(
                                record.date,

                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            trailing: IconButton(
                              onPressed: () {
                                controller.openRecord(record);
                              },

                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
