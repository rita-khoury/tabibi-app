import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tabibi/core/routes/app_routes.dart';

class ProfileMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();

    if (route == '/login' || route == AppRoutes.home) {
      return null;
    }

    if (box.read('profileCompleted') == true) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null;
  }
}
