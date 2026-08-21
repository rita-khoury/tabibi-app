import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/settings/controller/controller_settings.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: AppColors.lightBlue),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Obx(
            () => SwitchListTile(
              value: controller.darkMode.value,
              onChanged: controller.changeDarkMode,
              title: const Text(
                "Dark Mode",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              secondary: const Icon(
                Icons.dark_mode,
                color: AppColors.primaryBlue,
              ),
              activeThumbColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => SwitchListTile(
              value: controller.notifications.value,
              onChanged: controller.changeNotifications,
              title: const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              secondary: const Icon(
                Icons.notifications,
                color: AppColors.primaryBlue,
              ),
              activeThumbColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Language",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: controller.language.value,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "English",
                        child: Text("English"),
                      ),
                      DropdownMenuItem(value: "Arabic", child: Text("Arabic")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeLanguage(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Get.snackbar(
                "Settings",
                "Saved successfully",
                backgroundColor: AppColors.primaryBlue,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Save Settings",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
