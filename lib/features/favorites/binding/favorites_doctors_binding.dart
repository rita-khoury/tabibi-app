import 'package:get/get.dart';
import '../../auth/repository/auth_repository.dart';
import '../controller/favorites_doctors_controller.dart';

class FavoritesDoctorsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut(() => AuthRepository());
    }

    Get.lazyPut(() => FavoritesDoctorsController(Get.find<AuthRepository>()));
  }
}
