// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'core/routes/app_pages.dart';
// import 'core/routes/app_routes.dart';
// import 'features/auth/repository/auth_binding.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.splash,
//       getPages: AppPages.pages,
//
//       initialBinding: AuthBinding(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/repository/auth_binding.dart';
import 'core/constance/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final GetStorage box = GetStorage();
  bool isDark = box.read('isDarkMode') ?? false;

  Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: AuthBinding(),

      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightGray,
        primaryColor: AppColors.primaryBlue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF121619),
        primaryColor: AppColors.primaryBlue,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2126),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardColor: const Color(0xFF1A2126),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }
}
