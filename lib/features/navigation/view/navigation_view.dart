import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/view/appointments_view.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/favorites/view/favorites_doctors_view.dart';
import 'package:tabibi/features/home/view/home_view.dart';
import 'package:tabibi/features/navigation/controller/navigation_controller.dart';
import 'package:tabibi/features/profile/view/profile_view.dart';

import '../../appointments/view/PatientQueueView.dart' show PatientQueueView;

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final isAuthenticated = authController.isLoggedIn;
      final screens = <Widget>[
        HomeView(),
        if (isAuthenticated) const AppointmentsView(),
        if (isAuthenticated) FavoritesDoctorsView(),
        if (isAuthenticated) const PatientQueueView(),
        if (isAuthenticated) const ProfileView(),
      ];

      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: isAuthenticated
            ? BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changeTab,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: AppColors.gray,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month),
                    label: 'Appointments',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_rounded),
                    label: 'Queue',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
            : _GuestHomeBar(onTap: () => controller.changeTab(0)),
      );
    });
  }
}

class _GuestHomeBar extends StatelessWidget {
  final VoidCallback onTap;

  const _GuestHomeBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          child: Center(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: AppColors.primaryBlue, size: 22),
                    SizedBox(height: 0),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
