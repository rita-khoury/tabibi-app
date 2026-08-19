import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/profile/controller/edit_profile_controller.dart';
import 'package:tabibi/features/profile/widgets/custom_widgets.dart';

class ChangePasswordView extends GetView<EditProfileController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.lightGray,
    appBar: AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryBlue), onPressed: Get.back),
      title: const Text('Change Password', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w700)),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomCard(children: [
        const Text('Set a new password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Obx(() => CustomInputField(label: 'Current Password', controller: controller.currentPasswordController, prefixIcon: Icons.lock_outline, obscureText: controller.isCurrentPasswordObscure.value, suffixIcon: IconButton(icon: Icon(controller.isCurrentPasswordObscure.value ? Icons.visibility_off : Icons.visibility), onPressed: controller.isCurrentPasswordObscure.toggle))),
        const SizedBox(height: 16),
        Obx(() => CustomInputField(label: 'New Password', controller: controller.newPasswordController, prefixIcon: Icons.lock_outline, obscureText: controller.isNewPasswordObscure.value, suffixIcon: IconButton(icon: Icon(controller.isNewPasswordObscure.value ? Icons.visibility_off : Icons.visibility), onPressed: controller.isNewPasswordObscure.toggle))),
        const SizedBox(height: 16),
        Obx(() => CustomInputField(label: 'Confirm Password', controller: controller.confirmPasswordController, prefixIcon: Icons.lock_outline, obscureText: controller.isConfirmPasswordObscure.value, suffixIcon: IconButton(icon: Icon(controller.isConfirmPasswordObscure.value ? Icons.visibility_off : Icons.visibility), onPressed: controller.isConfirmPasswordObscure.toggle))),
        const SizedBox(height: 22),
        Obx(() => SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: controller.isPasswordLoading.value ? null : controller.changePassword, icon: controller.isPasswordLoading.value ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.lock_reset), label: const Text('Update Password'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue)))),
      ]),
    ),
  );
}
