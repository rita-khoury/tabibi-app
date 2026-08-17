import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/medical_records/widgets/medical_attachments_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_history_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_profile_tab.dart';

import '../view/medical_profile_editor_view.dart';

class MedicalRecordView extends GetView<MedicalRecordController> {
  const MedicalRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    // التأكد من تسجيل الـ Controller
    final controller = Get.put(MedicalRecordController());

    // متغير تفاعلي لمراقبة التبويب الحالي وتغيير وظيفة وشكل الزر العائم بناءً عليه
    final RxInt currentTabIndex = 0.obs;
    controller.tabController.addListener(() {
      currentTabIndex.value = controller.tabController.index;
    });

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
      // زر عائم ديناميكي متكامل (يغطي الإنشاء لأول مرة + التعديل + رفع المرفقات)
      floatingActionButton: Obx(() {
        // إذا كان المستخدم في تبويب الملف الطبي (Index 0)
        if (currentTabIndex.value == 0) {
          // التحقق مما إذا كان الملف الطبي موجوداً أم لا
          final bool hasProfile = controller.medicalProfile.value != null;

          return FloatingActionButton.extended(
            backgroundColor: hasProfile ? AppColors.primaryBlue : Colors.orange,
            onPressed: () async {
              final saved = await Get.to<bool>(
                () => const MedicalProfileEditorView(),
              );
              if (saved == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medical profile saved successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: Icon(
              hasProfile ? Icons.edit : Icons.add_circle_outline,
              color: AppColors.white,
            ),
            label: Text(
              hasProfile ? "Edit Profile" : "Create Profile",
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (currentTabIndex.value == 2) {
          return FloatingActionButton(
            backgroundColor: AppColors.primaryBlue,
            onPressed: () => controller.uploadAttachment(),
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          );
        }

        // في تبويب الزيارات (Index 1) لا نحتاج زر عائم
        return const SizedBox.shrink();
      }),
    );
  }
}
