/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';


class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final RxBool darkMode = false.obs;
  final RxBool notifications = true.obs;
  final RxString language = "English".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(
    color: AppColors.white,
  ),


        title: const Text("Settings",style: TextStyle(color: AppColors.lightGray),),
      
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ================= DARK MODE =================

          Obx(
            () => SwitchListTile(
              value: darkMode.value,
              onChanged: (value) => darkMode.value = value,

              title: const Text(
                "Dark Mode",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              secondary: Icon(
                Icons.dark_mode,
                color: AppColors.primaryBlue,
              ),

              activeColor: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 10),

          // ================= NOTIFICATIONS =================

          Obx(
            () => SwitchListTile(
              value: notifications.value,
              onChanged: (value) => notifications.value = value,

              title: const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              secondary: Icon(
                Icons.notifications,
                color: AppColors.primaryBlue,
              ),

              activeColor: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 20),

          // ================= LANGUAGE =================

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButton<String>(
                    value: language.value,

                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(
                        value: "English",
                        child: Text("English"),
                      ),
                      DropdownMenuItem(
                        value: "Arabic",
                        child: Text("Arabic"),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        language.value = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ================= SAVE BUTTON =================

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
              style: TextStyle(color:AppColors.white,fontWeight:  FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/settings/controller/controller_settings.dart';



class SettingsView extends GetView<SettingsController> {

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.lightGray,

      appBar: AppBar(

        backgroundColor: AppColors.primaryBlue,

        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),

        title: const Text(
          "Settings",
          style: TextStyle(
            color: AppColors.lightGray,
          ),
        ),

        centerTitle: true,
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          // ================= DARK MODE =================

          Obx(
            () => SwitchListTile(

              value: controller.darkMode.value,

              onChanged: controller.changeDarkMode,

              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              secondary: Icon(
                Icons.dark_mode,
                color: AppColors.primaryBlue,
              ),

              activeColor: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 10),

          // ================= NOTIFICATIONS =================

          Obx(
            () => SwitchListTile(

              value: controller.notifications.value,

              onChanged: controller.changeNotifications,

              title: const Text(
                "Notifications",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              secondary: Icon(
                Icons.notifications,
                color: AppColors.primaryBlue,
              ),

              activeColor: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 20),

          // ================= LANGUAGE =================

          Container(

            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(18),

              boxShadow: [

                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

                      DropdownMenuItem(
                        value: "Arabic",
                        child: Text("Arabic"),
                      ),
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

          // ================= SAVE BUTTON =================

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

              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),

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