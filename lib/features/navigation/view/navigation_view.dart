import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/view/appointments_view.dart';
import 'package:tabibi/features/favorites/view/favorites_doctors_view.dart';
import 'package:tabibi/features/home/view/home_view.dart';
import 'package:tabibi/features/navigation/controller/navigation_controller.dart';
import 'package:tabibi/features/profile/view/profile_view.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeView(),
            AppointmentsView(),
            FavoritesDoctorsView(),
            ProfileView(),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
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
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
),
      ),
    );
  }
}