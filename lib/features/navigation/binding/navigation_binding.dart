import 'package:get/get.dart';
import 'package:tabibi/features/appointments/controller/appointments_controller.dart';
import 'package:tabibi/features/favorites/controller/favorites_doctors_controller.dart';

import '../../auth/repository/auth_repository.dart';
import '../controller/navigation_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../home/controller/home_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());

    Get.lazyPut(() => HomeController());

    Get.lazyPut(() => ProfileController());Get.lazyPut(() => FavoritesDoctorsController(Get.find<AuthRepository>()));
    Get.lazyPut(() => AppointmentsController());
  }
}
