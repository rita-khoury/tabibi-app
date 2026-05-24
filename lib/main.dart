/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/profile/binding/profile_binding.dart';
import 'features/profile/view/profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: ProfileBinding(),

      home: ProfileView(),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.profile,

      getPages: AppPages.pages,
    );
  }
}