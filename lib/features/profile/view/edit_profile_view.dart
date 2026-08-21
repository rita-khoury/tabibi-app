import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/routes/app_routes.dart';
import 'package:tabibi/core/widgets/app_network_image.dart';
import 'package:tabibi/features/profile/controller/edit_profile_controller.dart';
import 'package:tabibi/features/profile/widgets/custom_widgets.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (!didPop) await _attemptExit(context);
    },
    child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => _attemptExit(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(
            () => controller.isProfileLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  )
                : IconButton(
                    tooltip: 'Save changes',
                    icon: const Icon(
                      Icons.check_rounded,
                      color: AppColors.primaryBlue,
                    ),
                    onPressed: () async {
                      final saved = await controller.saveChanges();
                      if (saved) Get.back();
                    },
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(
                    () => AppAvatar(
                      imageUrl: controller.currentAvatarUrl.value,
                      localFile: controller.profileImage.value,
                      radius: 60,
                      fallbackIcon: Icons.person,
                      backgroundColor: AppColors.lightGray,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => _showPhotoActions(context),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryBlue,
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomCard(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        label: 'First Name',
                        controller: controller.firstNameController,
                        prefixIcon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomInputField(
                        label: 'Last Name',
                        controller: controller.lastNameController,
                        prefixIcon: Icons.person,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Email (Read Only)',
                  controller: controller.emailController,
                  prefixIcon: Icons.email,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Phone (Read Only)',
                  controller: controller.phoneController,
                  prefixIcon: Icons.phone,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Address',
                  controller: controller.addressController,
                  prefixIcon: Icons.location_on,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCard(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        label: 'Occupation',
                        controller: controller.occupationController,
                        prefixIcon: Icons.work,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _maritalStatusField(context)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        label: 'Emergency Contact Name',
                        controller: controller.emergencyNameController,
                        prefixIcon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomInputField(
                        label: 'Emergency Contact Phone',
                        controller: controller.emergencyPhoneController,
                        prefixIcon: Icons.phone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCard(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.lock_outline,
                    color: AppColors.primaryBlue,
                  ),
                  title: const Text(
                    'Change Password',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Update your account password'),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.gray,
                  ),
                  onTap: () => Get.toNamed(AppRoutes.changePassword),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );

  Widget _maritalStatusField(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Marital Status',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedMaritalStatus.value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            prefixIcon: const Icon(
              Icons.favorite,
              color: AppColors.primaryBlue,
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: const ['Single', 'Married', 'Divorced']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) controller.selectedMaritalStatus.value = value;
          },
        ),
      ),
    ],
  );

  Future<void> _attemptExit(BuildContext context) async {
    if (!controller.isDirty.value) {
      Get.back();
      return;
    }
    final discard = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Discard Changes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (discard == true) Get.back();
  }

  void _showPhotoActions(BuildContext context) => Get.bottomSheet(
    SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Text(
                'Profile Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.primaryBlue,
              ),
              title: const Text('Change Photo'),
              onTap: () {
                Get.back();
                controller.pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                controller.deletePhoto();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}
