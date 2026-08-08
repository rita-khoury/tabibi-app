// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import 'package:tabibi/features/profile/controller/edit_profile_controller.dart';
// import 'package:tabibi/features/profile/widgets/custom_widgets.dart';
//
// class EditProfileView extends GetView<EditProfileController> {
//   const EditProfileView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: AppColors.primaryBlue,
//           ),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(
//             color: AppColors.primaryBlue,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Obx(
//                         () => CircleAvatar(
//                           radius: 60,
//                           backgroundColor: AppColors.lightGray,
//                           backgroundImage: controller.profileImage.value != null
//                               ? FileImage(controller.profileImage.value!)
//                               : const NetworkImage(
//                                       'https://via.placeholder.com/150/1E88E5/FFFFFF?text=J.D.',
//                                     )
//                                     as ImageProvider,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 4,
//                         child: CircleAvatar(
//                           radius: 18,
//                           backgroundColor: AppColors.primaryBlue,
//                           child: const Icon(
//                             Icons.camera_alt,
//                             color: AppColors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       OutlinedButton.icon(
//                         onPressed: controller.pickImage,
//                         icon: const Icon(Icons.camera_alt_outlined, size: 18),
//                         label: const Text('Change Photo'),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: AppColors.primaryBlue,
//                           side: const BorderSide(color: AppColors.primaryBlue),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       OutlinedButton.icon(
//                         onPressed: controller.deletePhoto,
//                         icon: const Icon(
//                           Icons.delete_outline,
//                           size: 18,
//                           color: Colors.red,
//                         ),
//                         label: const Text(
//                           'Delete Photo',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.red,
//                           side: const BorderSide(color: Colors.red),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             CustomCard(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomInputField(
//                         label: 'First Name',
//                         controller: controller.firstNameController,
//                         prefixIcon: Icons.person,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: CustomInputField(
//                         label: 'Last Name',
//                         controller: controller.lastNameController,
//                         prefixIcon: Icons.person,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 CustomInputField(
//                   label: 'Email (Read Only)',
//                   controller: controller.emailController,
//                   prefixIcon: Icons.email,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomInputField(
//                   label: 'Phone (Read Only)',
//                   controller: controller.phoneController,
//                   prefixIcon: Icons.phone,
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomInputField(
//                   label: 'Address',
//                   controller: controller.addressController,
//                   prefixIcon: Icons.location_on,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             CustomCard(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomInputField(
//                         label: 'Occupation',
//                         controller: controller.occupationController,
//                         prefixIcon: Icons.work,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Marital Status',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Obx(
//                             () => Container(
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.04),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: DropdownButtonFormField<String>(
//                                 value: controller.selectedMaritalStatus.value,
//                                 dropdownColor: AppColors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 isExpanded: true,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: AppColors.lightGray,
//                                   prefixIcon: const Icon(
//                                     Icons.favorite,
//                                     color: AppColors.primaryBlue,
//                                     size: 18,
//                                   ),
//                                   prefixIconConstraints: const BoxConstraints(
//                                     minWidth: 36,
//                                   ),
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.primaryBlue,
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                                 items: ['Single', 'Married', 'Divorced']
//                                     .map(
//                                       (status) => DropdownMenuItem(
//                                         value: status,
//                                         child: Text(
//                                           status,
//                                           style: const TextStyle(fontSize: 13),
//                                         ),
//                                       ),
//                                     )
//                                     .toList(),
//                                 onChanged: (val) =>
//                                     controller.selectedMaritalStatus.value =
//                                         val!,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomInputField(
//                         label: 'Emergency Contact Name',
//                         controller: controller.emergencyNameController,
//                         prefixIcon: Icons.person,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: CustomInputField(
//                         label: 'Emergency Contact Phone',
//                         controller: controller.emergencyPhoneController,
//                         prefixIcon: Icons.phone,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             CustomCard(
//               children: [
//                 Obx(
//                   () => CustomInputField(
//                     label: 'Current Password',
//                     hintText: 'Enter current password',
//                     controller: controller.currentPasswordController,
//                     prefixIcon: Icons.lock,
//                     obscureText: controller.isCurrentPasswordObscure.value,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         controller.isCurrentPasswordObscure.value
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () =>
//                           controller.isCurrentPasswordObscure.toggle(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Obx(
//                   () => CustomInputField(
//                     label: 'New Password',
//                     hintText: 'Enter new password',
//                     controller: controller.newPasswordController,
//                     prefixIcon: Icons.lock,
//                     obscureText: controller.isNewPasswordObscure.value,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         controller.isNewPasswordObscure.value
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () => controller.isNewPasswordObscure.toggle(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Obx(
//                   () => CustomInputField(
//                     label: 'Confirm Password',
//                     hintText: 'Confirm new password',
//                     controller: controller.confirmPasswordController,
//                     prefixIcon: Icons.lock,
//                     obscureText: controller.isConfirmPasswordObscure.value,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         controller.isConfirmPasswordObscure.value
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () =>
//                           controller.isConfirmPasswordObscure.toggle(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: controller.changePassword,
//                     icon: const Icon(Icons.lock_open, color: AppColors.white),
//                     label: const Text(
//                       'Change Password',
//                       style: TextStyle(color: AppColors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryBlue,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: controller.saveChanges,
//                 icon: const Icon(Icons.save, color: AppColors.white),
//                 label: const Text(
//                   'Save Changes',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryBlue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/profile/controller/edit_profile_controller.dart';
import 'package:tabibi/features/profile/widgets/custom_widgets.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Obx(() {
                        final localFile = controller.profileImage.value;
                        final remoteUrl = controller.currentAvatarUrl.value;

                        ImageProvider? imageProvider;
                        if (localFile != null) {
                          imageProvider = FileImage(localFile);
                        } else if (remoteUrl.isNotEmpty) {
                          imageProvider = NetworkImage(remoteUrl);
                        }

                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.lightGray,
                          backgroundImage: imageProvider,
                          child: imageProvider == null
                              ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primaryBlue,
                          )
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryBlue,
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: controller.pickImage,
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text('Change Photo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                          side: const BorderSide(color: AppColors.primaryBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: controller.deletePhoto,
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Delete Photo',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Marital Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedMaritalStatus.value,
                                dropdownColor: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.lightGray,
                                  prefixIcon: const Icon(
                                    Icons.favorite,
                                    color: AppColors.primaryBlue,
                                    size: 18,
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 36,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryBlue,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                items: ['Single', 'Married', 'Divorced']
                                    .map(
                                      (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(
                                      status,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (val) =>
                                controller.selectedMaritalStatus.value =
                                val!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                Obx(
                      () => CustomInputField(
                    label: 'Current Password',
                    hintText: 'Enter current password',
                    controller: controller.currentPasswordController,
                    prefixIcon: Icons.lock,
                    obscureText: controller.isCurrentPasswordObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isCurrentPasswordObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          controller.isCurrentPasswordObscure.toggle(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                      () => CustomInputField(
                    label: 'New Password',
                    hintText: 'Enter new password',
                    controller: controller.newPasswordController,
                    prefixIcon: Icons.lock,
                    obscureText: controller.isNewPasswordObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => controller.isNewPasswordObscure.toggle(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                      () => CustomInputField(
                    label: 'Confirm Password',
                    hintText: 'Confirm new password',
                    controller: controller.confirmPasswordController,
                    prefixIcon: Icons.lock,
                    obscureText: controller.isConfirmPasswordObscure.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          controller.isConfirmPasswordObscure.toggle(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.changePassword,
                    icon: const Icon(Icons.lock_open, color: AppColors.white),
                    label: const Text(
                      'Change Password',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.saveChanges,
                icon: const Icon(Icons.save, color: AppColors.white),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}