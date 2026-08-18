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
      backgroundColor: AppColors.lightGray,
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
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () => Get.toNamed(AppRoutes.helpSupport),
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
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final VoidCallback? onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.primaryBlue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : AppColors.gray,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
