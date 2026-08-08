import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/medical_records/widgets/medical_attachments_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_history_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_profile_tab.dart';

class MedicalRecordView extends GetView<MedicalRecordController> {
  const MedicalRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicalRecordController());

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Medical Record",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.gray,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Medical Profile"),
            Tab(text: "Visits"),
            Tab(text: "Attachments"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          MedicalProfileTab(),
          MedicalHistoryTab(),
          MedicalAttachmentsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => controller.uploadAttachment(),
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }
}
