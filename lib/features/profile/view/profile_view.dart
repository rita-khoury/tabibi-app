/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),

      body: Column(
        children: [

          // ================= HEADER =================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff2F80ED),
                  Color(0xff4A90E2),
                ],
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://i.pravatar.cc/300',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Obx(
                  () => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Obx(
                  () => Text(
                    controller.email.value,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: controller.editProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xff2F80ED),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= MENU =================

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [

                MenuTile(
                  icon: Icons.calendar_month,
                  title: "My Appointments",
                ),

                MenuTile(
                  icon: Icons.medical_information,
                  title: "Medical Records",
                ),

                MenuTile(
                  icon: Icons.favorite_border,
                  title: "Favorite Doctors",
                ),

                MenuTile(
                  icon: Icons.payment,
                  title: "Payments",
                ),

                MenuTile(
                  icon: Icons.settings,
                  title: "Settings",
                ),

                MenuTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                ),

                MenuTile(
                  icon: Icons.logout,
                  title: "Logout",
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),

      // ================= BOTTOM NAV =================

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(

          currentIndex: controller.selectedIndex.value,

          onTap: controller.changeBottomNav,

          selectedItemColor: const Color(0xff2F80ED),

          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MENU TILE =================

class MenuTile extends StatelessWidget {

  final IconData icon;

  final String title;

  final bool isLogout;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

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

      child: ListTile(

        leading: Icon(
          icon,
          color: isLogout
              ? Colors.red
              : const Color(0xff2F80ED),
        ),

        title: Text(
          title,

          style: TextStyle(
            fontWeight: FontWeight.w600,

            color: isLogout
                ? Colors.red
                : Colors.black87,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),

        onTap: () {},
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/core/routes/app_routes.dart';
import 'package:tabibi/features/settings/view/view_settings.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,

      body: Column(
        children: [

          // ================= HEADER =================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 25),
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.lightBlue,
                ],
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

               Obx(() {
  final img = controller.imageUrl.value;
  final loggedIn = controller.isLoggedIn.value;

  return Container(
    width: 110,
    height: 110,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.white,
        width: 4,
      ),
      color: AppColors.primaryBlue,
      image: (loggedIn && img.isNotEmpty)
          ? DecorationImage(
              image: NetworkImage(img),
              fit: BoxFit.cover,
            )
          : null,
    ),
    child: (!loggedIn || img.isEmpty)
        ? const Center(
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          )
        : null,
  );
}),

                const SizedBox(height: 15),

                Obx(
                  () => Text(
                    controller.userName.value,
                    style:  TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Obx(
                  () => Text(
                    controller.email.value,
                    style:  TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed:  () {
  Get.toNamed(AppRoutes.editProfile);
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 12,
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

          // ================= MENU =================

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [

     MenuTile(
  icon: Icons.calendar_month,
  title: "My Appointments",
  onTap: () {
    Get.toNamed(AppRoutes.appointments);
  },
),

                 MenuTile(
                  icon: Icons.medical_information,
                  title: "Medical Records",
                  onTap: () {
    
 Get.toNamed(AppRoutes.medicalRecords);

    }
                ),

                 MenuTile(
                  icon: Icons.favorite_border,
                  title: "Favorite Doctors",
                 onTap: () {
    
 Get.toNamed(AppRoutes.favorites);

    }
                ),

                const MenuTile(
                  icon: Icons.payment,
                  title: "Payments",
                ),

                MenuTile(
  icon: Icons.settings,
  title: "Settings",
  onTap: () {
    
 Get.toNamed(AppRoutes.settings);

    }
),
               MenuTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                   onTap: () {
    Get.toNamed(AppRoutes.helpSupport);
  },
                ),

                MenuTile(
                  icon: Icons.logout,
                  title: "Logout",
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),

      // ================= BOTTOM NAV =================

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeBottomNav,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.gray,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_day), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }
}/*class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
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
            color: Colors.grey.withOpacity(0.12),
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
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
        onTap: () {
          if (isLogout) {
           // Get.offAllNamed(AppRoutes.login);
          }
        },
      ),
    );
  }
}*/
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
            color: Colors.grey.withOpacity(0.12),
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