// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import 'package:tabibi/features/appointments/view/appointments_view.dart';
// import 'package:tabibi/features/favorites/view/favorites_doctors_view.dart';
// import 'package:tabibi/features/home/view/home_view.dart';
// import 'package:tabibi/features/navigation/controller/navigation_controller.dart';
// import 'package:tabibi/features/profile/view/profile_view.dart';
//
// class NavigationView extends GetView<NavigationController> {
//   const NavigationView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final GetStorage box = GetStorage();
//
//     return Obx(() {
//       // التحقق هل المستخدم مسجل دخول أم لا مباشرة من المخزن
//       final bool isLoggedIn = box.read('isLoggedIn') == true;
//
//       // قائمة الشاشات الديناميكية (البروفايل يضاف فقط إذا كان مسجلاً دخول)
//       final List<Widget> screens = [
//          HomeView(),
//         const AppointmentsView(),
//         const FavoritesDoctorsView(),
//         if (isLoggedIn) const ProfileView(),
//       ];
//
//       // التأكد من أن الـ Index الحالي لا يتجاوز عدد الشاشات المتاح لمنع أي خطأ
//       if (controller.selectedIndex.value >= screens.length) {
//         controller.selectedIndex.value = 0;
//       }
//
//       return Scaffold(
//         body: IndexedStack(
//           index: controller.selectedIndex.value,
//           children: screens,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: controller.selectedIndex.value,
//           onTap: controller.changeTab,
//           selectedItemColor: AppColors.primaryBlue,
//           unselectedItemColor: AppColors.gray,
//           type: BottomNavigationBarType.fixed,
//           items: [
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_month),
//               label: 'Appointments',
//             ),
//             const BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Favorites',
//             ),
//
//             if (isLoggedIn)
//               const BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: 'Profile',
//               ),
//           ],
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/view/appointments_view.dart';
import 'package:tabibi/features/favorites/view/favorites_doctors_view.dart';
import 'package:tabibi/features/home/view/home_view.dart';
import 'package:tabibi/features/navigation/controller/navigation_controller.dart';
import 'package:tabibi/features/profile/view/profile_view.dart';


import '../../appointments/view/PatientQueueView.dart' show PatientQueueView;

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage();

    return Obx(() {

      final bool isLoggedIn = box.read('isLoggedIn') == true;


      final List<Widget> screens = [
         HomeView(),
        const AppointmentsView(),
         FavoritesDoctorsView(),
        if (isLoggedIn) const PatientQueueView(),
        if (isLoggedIn) const ProfileView(),
      ];


      if (controller.selectedIndex.value >= screens.length) {
        controller.selectedIndex.value = 0;
      }

      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.gray,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Appointments',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            if (isLoggedIn)
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              label: 'Queue',
            ),
            if (isLoggedIn)
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
          ],
        ),
      );
    });
  }
}
