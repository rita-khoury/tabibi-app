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
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  await GetStorage.init();

  final GetStorage box = GetStorage();
  final bool isDark = box.read('isDarkMode') ?? false;

  runApp(MyApp(initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialThemeMode});

  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: AuthBinding(),

      themeMode: initialThemeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.lightGray,
        primaryColor: AppColors.primaryBlue,
        cardColor: AppColors.white,
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121619),
        primaryColor: AppColors.primaryBlue,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2126),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardColor: const Color(0xFF1A2126),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF1A2126),
          surfaceTintColor: Color(0xFF1A2126),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1A2126),
          surfaceTintColor: Color(0xFF1A2126),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white60),
        ),
      ),
    );
  }
}
