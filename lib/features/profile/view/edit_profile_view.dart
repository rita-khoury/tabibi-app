import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ================= BACK BUTTON =================
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.primaryBlue,
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= IMAGE =================
           Obx(() {
  return Stack(
    children: [

      // ================= PROFILE IMAGE =================
      GestureDetector(
        onTap: controller.pickImage,
        child: CircleAvatar(
          radius: 55,
          backgroundColor: AppColors.primaryBlue,

          backgroundImage: controller.imageFile.value != null
              ? FileImage(controller.imageFile.value!)
              : controller.imageUrl.value.isNotEmpty
                  ? NetworkImage(controller.imageUrl.value)
                      as ImageProvider
                  : null,

          child: controller.imageFile.value == null &&
                  controller.imageUrl.value.isEmpty
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
              : null,
        ),
      ),

      // ================= EDIT ICON =================
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}),

            const SizedBox(height: 25),

            // ================= NAME =================
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter your full name",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= EMAIL =================
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= OLD PASSWORD =================
            TextField(
              controller: controller.oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Old Password",
                hintText: "Enter current password",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= NEW PASSWORD =================
            TextField(
              controller: controller.newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                hintText: "Enter new password",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ================= SAVE BUTTON =================
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}