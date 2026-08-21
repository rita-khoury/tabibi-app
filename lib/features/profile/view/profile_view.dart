import '../../../core/widgets/app_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/core/constance/app_colors.dart';
// import '/core/routes/app_routes.dart';
// import '../controller/profile_controller.dart';
//
// class ProfileView extends GetView<ProfileController> {
//   const ProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGray,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(top: 80, bottom: 40),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [AppColors.primaryBlue, AppColors.lightBlue],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Profile",
//                       style: TextStyle(
//                         color: AppColors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     Obx(
//                       () => Text(
//                         controller.userName,
//                         style: const TextStyle(
//                           color: AppColors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//
//                     Obx(
//                       () => Text(
//                         controller.email,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//
//                     ElevatedButton(
//                       onPressed: () => Get.toNamed(AppRoutes.editProfile),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.white,
//                         foregroundColor: AppColors.primaryBlue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 12,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         "Edit Profile",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   children: [
//                     MenuTile(
//                       icon: Icons.medical_information,
//                       title: "Medical Records",
//                       onTap: () => Get.toNamed(AppRoutes.medicalRecords),
//                     ),
//                     MenuTile(
//                       icon: Icons.payment,
//                       title: "Payments",
//                       onTap: () => Get.toNamed(AppRoutes.wallet),
//                     ),
//                     MenuTile(
//                       icon: Icons.settings,
//                       title: "Settings",
//                       onTap: () => Get.toNamed(AppRoutes.settings),
//                     ),
//                     MenuTile(
//                       icon: Icons.help_outline,
//                       title: "Help & Support",
//                       onTap: () => Get.toNamed(AppRoutes.helpSupport),
//                     ),
//                     MenuTile(
//                       icon: Icons.logout,
//                       title: "Logout",
//                       isLogout: true,
//                       onTap: () => controller.logout(),
//                     ),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: Obx(
//               () => controller.violationsCount.value > 0
//                   ? FloatingActionButton(
//                       onPressed: () {
//                         Get.toNamed(AppRoutes.violationsView);
//                       },
//                       backgroundColor: Colors.red,
//                       elevation: 8,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           const Icon(
//                             Icons.warning_amber_rounded,
//                             color: Colors.white,
//                             size: 32,
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 4,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Text(
//                                 "${controller.violationsCount.value}",
//                                 style: const TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MenuTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final bool isLogout;
//   final VoidCallback? onTap;
//
//   const MenuTile({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.isLogout = false,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.12),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isLogout ? Colors.red : AppColors.primaryBlue,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: isLogout ? Colors.red : AppColors.gray,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//         onTap: onTap,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/constance/app_colors.dart';
import '/core/routes/app_routes.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.lightBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- جزء عرض الصورة الشخصية (Profile Avatar) ---
                    Obx(
                      () => AppAvatar(
                        imageUrl: controller.profileAvatarUrl.value,
                        radius: 45,
                        fallbackIcon: Icons.person,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ----------------------------------------------
                    Obx(
                      () => Text(
                        controller.userName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Obx(
                      () => Text(
                        controller.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.editProfile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    MenuTile(
                      icon: Icons.medical_information,
                      title: "Medical Records",
                      onTap: () => Get.toNamed(AppRoutes.medicalRecords),
                    ),
                    MenuTile(
                      icon: Icons.payment,
                      title: "Financial Hub",
                      onTap: () => Get.toNamed(AppRoutes.financialHub),
                    ),
                    MenuTile(
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                    MenuTile(
                      icon: Icons.person_off_outlined,
                      title: "Deactivate Account",
                      accentColor: Colors.orange.shade800,
                      onTap: () => _showDeactivateWarning(context),
                    ),
                    MenuTile(
                      icon: Icons.logout,

                      title: "Logout",
                      isLogout: true,
                      onTap: () => controller.logout(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: Obx(
              () => controller.violationsCount.value > 0
                  ? FloatingActionButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.violationsView);
                      },
                      backgroundColor: Colors.red,
                      elevation: 8,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${controller.violationsCount.value}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeactivateWarning(BuildContext context) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.person_off_outlined, color: Colors.orange.shade800),
            const SizedBox(width: 10),
            const Expanded(child: Text('Deactivate Account?')),
          ],
        ),
        content: const Text(
          'Deactivating your account will disable it and sign you out after successful deactivation. You can continue to confirm your decision with your current password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (shouldContinue == true && context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => const _DeactivatePasswordDialog(),
      );
    }
  }
}

class _DeactivatePasswordDialog extends StatefulWidget {
  const _DeactivatePasswordDialog();

  @override
  State<_DeactivatePasswordDialog> createState() =>
      _DeactivatePasswordDialogState();
}

class _DeactivatePasswordDialogState extends State<_DeactivatePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      final isDeactivating = profileController.isDeactivating.value;
      return PopScope(
        canPop: !isDeactivating,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.person_off_outlined, color: Colors.orange.shade800),
              const SizedBox(width: 10),
              const Expanded(child: Text('Confirm Deactivation')),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your current password to confirm account deactivation.',
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    autofocus: true,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _confirm(),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your current password.'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isDeactivating
                  ? null
                  : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isDeactivating ? null : _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: isDeactivating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Confirm Deactivation'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _confirm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final profileController = Get.find<ProfileController>();
    if (profileController.isDeactivating.value) {
      return;
    }

    await profileController.deactivateAccount();
  }
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final Color? accentColor;
  final VoidCallback? onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : accentColor ?? AppColors.primaryBlue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLogout
                ? Colors.red
                : accentColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
