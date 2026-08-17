import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/medicines/view/medicines_view.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/medical_records/view/medical_profile_editor_view.dart';
import 'package:tabibi/features/medical_records/widgets/medical_attachments_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_history_tab.dart';
import 'package:tabibi/features/medical_records/widgets/medical_profile_tab.dart';

class MedicalRecordView extends StatelessWidget {
  const MedicalRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Medical Record'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          const Text(
            'Your medical record',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Choose a section to view or manage your information.',
            style: TextStyle(color: AppColors.gray, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _MedicalRecordSectionCard(
            section: _MedicalRecordSection.profile,
            icon: Icons.health_and_safety_outlined,
            title: 'Medical Profile',
            subtitle: 'Your personal medical information',
          ),
          _MedicalRecordSectionCard(
            section: _MedicalRecordSection.visits,
            icon: Icons.history_rounded,
            title: 'Visits',
            subtitle: 'Your previous medical visits',
          ),
          _MedicalRecordSectionCard(
            section: _MedicalRecordSection.attachments,
            icon: Icons.attach_file_rounded,
            title: 'Attachments',
            subtitle: 'Your medical documents',
          ),
          _MedicalRecordSectionCard(
            section: _MedicalRecordSection.medicines,
            icon: Icons.medication_outlined,
            title: 'Medicines',
            subtitle: 'Your prescribed medicines',
          ),
          _MedicalRecordSectionCard(
            section: _MedicalRecordSection.profileUpdates,
            icon: Icons.article_outlined,
            title: 'Profile Updates',
            subtitle: 'Changes to your medical profile',
          ),
        ],
      ),
    );
  }
}

enum _MedicalRecordSection {
  profile,
  visits,
  attachments,
  medicines,
  profileUpdates,
}

class _MedicalRecordSectionCard extends StatelessWidget {
  final _MedicalRecordSection section;
  final IconData icon;
  final String title;
  final String subtitle;

  const _MedicalRecordSectionCard({
    required this.section,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to<void>(
            () => _MedicalRecordDestinationPage(section: section),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: AppColors.primaryBlue, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.gray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicalRecordDestinationPage extends StatelessWidget {
  final _MedicalRecordSection section;

  const _MedicalRecordDestinationPage({required this.section});

  @override
  Widget build(BuildContext context) {
    if (section == _MedicalRecordSection.medicines) {
      return const MedicinesView();
    }
    if (section == _MedicalRecordSection.profileUpdates) {
      return const _MedicalRecordPlaceholderPage(
        title: 'Profile Updates',
        icon: Icons.article_outlined,
        message: 'Changes to your medical profile will be available here.',
      );
    }

    final controller = Get.isRegistered<MedicalRecordController>()
        ? Get.find<MedicalRecordController>()
        : Get.put(MedicalRecordController());

    switch (section) {
      case _MedicalRecordSection.profile:
        return _MedicalRecordSectionPage(
          title: 'Medical Profile',
          controller: controller,
          body: const MedicalProfileTab(),
          floatingActionButton: _ProfileActionButton(controller: controller),
        );
      case _MedicalRecordSection.visits:
        return _MedicalRecordSectionPage(
          title: 'Visits',
          controller: controller,
          body: MedicalHistoryTab(),
        );
      case _MedicalRecordSection.attachments:
        return _MedicalRecordSectionPage(
          title: 'Attachments',
          controller: controller,
          body: MedicalAttachmentsTab(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryBlue,
            onPressed: controller.uploadAttachment,
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          ),
        );
      case _MedicalRecordSection.medicines:
      case _MedicalRecordSection.profileUpdates:
        throw StateError(
          'Placeholder sections return before controller creation.',
        );
    }
  }
}

class _MedicalRecordSectionPage extends StatelessWidget {
  final String title;
  final MedicalRecordController controller;
  final Widget body;
  final Widget? floatingActionButton;

  const _MedicalRecordSectionPage({
    required this.title,
    required this.controller,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  final MedicalRecordController controller;

  const _ProfileActionButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasProfile = controller.medicalProfile.value != null;
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
        icon: Icon(hasProfile ? Icons.edit : Icons.add, color: AppColors.white),
        label: Text(
          hasProfile ? 'Edit Profile' : 'Complete Profile',
          style: const TextStyle(color: AppColors.white),
        ),
      );
    });
  }
}

class _MedicalRecordPlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _MedicalRecordPlaceholderPage({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 42),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.gray, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
